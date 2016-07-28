## install packages
##---------------------------------------------------------

library(yaml)
yml <- yaml.load_file("_config.yml")

strings <- sapply(yml$widgets, function(x)
  paste0(x$ghuser, "/", x$ghrepo))

# urls <- paste0("https://github.com/", strings)
# system2("open", urls)

for(strng in strings) {
  message(strng)
  suppressMessages(devtools::install_github(strng))
}


## make an example for each package
##---------------------------------------------------------

pkgstrings <- sapply(yml$widgets, function(x) x$name)
# cat(paste0("library(", pkgstrings, ")", collapse = "\n"))

thumbs <- sapply(yml$widgets, function(x)
  paste0("images/", x$ghuser, "-", x$ghrepo, ".png"))
names(thumbs) <- pkgstrings

ww <- 350*2
hh <- 300*2

help.start()

library(trelliscope)

widgetThumbnail2 <- function(wgt,filename){
  library(htmltools)
  library(webshot)
  library(magrittr)

  tagList(
    wgt
  ) %>%
    html_print %>%
    # get forward slash on windows
    normalizePath(.,winslash="/") %>%
    # replace drive:/ with drive:// so C:/ becomes C://
    gsub(x=.,pattern = ":/",replacement="://") %>%
    # appends file:/// to make valid uri
    paste0("file:///",.) %>%
    # screenshot it for lots of good reasons
    webshot( file = filename, delay = 3, cliprect = c(0,0,ww,hh) )
}

library(datamaps)
p <- datamaps(width = ww, height = hh)
widgetThumbnail(p, thumbs["datamaps"])

library(rChartsCalmap)
dat <- read.csv('http://t.co/mN2RgcyQFc')[,c('date', 'pts')]
p <- calheatmap(x = 'date', y = 'pts',
  data = dat,
  domain = 'month',
  start = "2012-10-27",
  legend = seq(10, 50, 10),
  itemName = 'point',
  range = 7,
  width = ww, height = hh
)
# widgetThumbnail(p, thumbs["rChartsCalmap"])
# do this one manually...
p

library(leaflet)
content <- paste(sep = "<br/>",
  "<b><a href='http://www.samurainoodle.com'>Samurai Noodle</a></b>",
  "606 5th Ave. S",
  "Seattle, WA 98138"
)
p <- leaflet(width = ww, height = hh) %>% addTiles() %>%
  addPopups(-122.327298, 47.597131, content,
    options = popupOptions(closeButton = FALSE)
)
widgetThumbnail(p, thumbs["leaflet"])

library(DT)
p <- datatable(iris, width = ww)
widgetThumbnail(p, thumbs["DT"])

library(dygraphs)
p <- dygraph(nhtemp, main = "New Haven Temperatures", width = ww, height = hh) %>%
  dyAxis("y", label = "Temp (F)", valueRange = c(40, 60)) %>%
  dyOptions(fillGraph = TRUE, drawGrid = FALSE) %>%
  dyRangeSelector()
widgetThumbnail(p, thumbs["dygraphs"])

library(metricsgraphics)
library(RColorBrewer)
p <- mjs_plot(movies$rating, width = ww, height = hh) %>% mjs_histogram(bins=30)
widgetThumbnail(p, thumbs["metricsgraphics"])

library(streamgraph)
library(dplyr)
ggplot2::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) -> dat
p <- streamgraph(dat, "genre", "n", "year", interactive=TRUE, width = ww, height = hh) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_fill_brewer("PuOr")
widgetThumbnail(p, thumbs["streamgraph"])

library(networkD3)
# data(MisLinks)
# data(MisNodes)
# forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
#   Target = "target", Value = "value", NodeID = "name",
#   Group = "group", opacity = 0.4,
#   colourScale = "d3.scale.category20b()")
library(RCurl)
URL <- "https://raw.githubusercontent.com/christophergandrud/networkD3/master/JSONdata/energy.json"
Energy <- getURL(URL, ssl.verifypeer = FALSE)
EngLinks <- JSONtoDF(jsonStr = Energy, array = "links")
EngNodes <- JSONtoDF(jsonStr = Energy, array = "nodes")
p <- sankeyNetwork(Links = EngLinks, Nodes = EngNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  fontSize = 12, nodeWidth = 30, width = ww, height = hh)
widgetThumbnail(p, thumbs["networkD3"])

library(threejs)
N     = 20000
theta = runif(N)*2*pi
phi   = runif(N)*2*pi
R     = 1.5
r     = 1.0
x = (R + r*cos(theta))*cos(phi)
y = (R + r*cos(theta))*sin(phi)
z = r*sin(theta)
d = 6
h = 6
t = 2*runif(N) - 1
w = t^2*sqrt(1-t^2)
x1 = d*cos(theta)*sin(phi)*w
y1 = d*sin(theta)*sin(phi)*w
i = order(phi)
j = order(t)
col = c( rainbow(length(phi))[order(i)],
         rainbow(length(t),start=0, end=2/6)[order(j)])
M = cbind(x=c(x,x1),y=c(y,y1),z=c(z,h*t))
p <- scatterplot3js(M,size=0.25,color=col,bg="black", width = ww, height = hh)
# widgetThumbnail(p, thumbs["threejs"])
# unsuccessfull... do it manually
p

library(DiagrammeR)
p <- grViz("
digraph neato {

node [shape = circle,
      style = filled,
      color = grey,
      label = '']

node [fillcolor = red]
a

node [fillcolor = green]
b c d

node [fillcolor = orange]

edge [color = grey]
a -> {b c d}
b -> {e f g h i j}
c -> {k l m n o p}
d -> {q r s t u v}
}",
engine = "neato", width = ww, height = hh)
widgetThumbnail(p, thumbs["DiagrammeR"])

library(sigmaGraph)
# no examples found...

library(bubbleCloud)
# no examples found

library(d3plus)
# edges <- read.csv(system.file("data/edges.csv", package = "d3plus"))
# nodes <- read.csv(system.file("data/nodes.csv", package = "d3plus"))
# p <- d3plus("rings",edges, width = ww, height = hh)
# d3plus("rings", edges, focusDropdown = TRUE)
# d3plus("rings", edges, nodes = nodes,focusDropdown = TRUE)
# d3plus("network", edges)
# d3plus("network",edges,nodes = nodes)
p <- d3plus("tree", countries, width = ww, height = hh)
widgetThumbnail(p, thumbs["d3plus"], timeout = 2000)

library(isotope)
d <- read.csv(system.file("data/candidatos.csv",package="isotope"), stringsAsFactors = FALSE)
filterCols <- c("genero","profesiones", "niveldeestudios","talante", "pragmaticoideologico","visionpais")
sortCols <- c("nombre","apoyosenadores","apoyorepresentantes")
tpl <- '
<div style="border: 1px solid grey; margin:5px; padding:5px">
  <div class="container">
    <h3 class="nombre">{{nombre}}</h3>
    <div style="width:125px; height: 125px; margin:auto">
      <img src={{foto}} class="circle" width="100px"/>
    </div>
    <p>Profesión: {{profesiones}}, Género: {{genero}},Nivel de estudios: {{niveldeestudios}}</p>
    <div class="apoyosenadores"><em>Apoyo Senadores:</em> {{apoyosenadores}}</div>
    <div class="apoyorepresentantes"><em>Apoyo Representantes:</em> {{apoyorepresentantes}}</div>
  </div>
</div>
'
isotope(d, filterCols = filterCols, sortCols = sortCols, lang = 'es', elemTpl = tpl, ncols=3)
# save it manually...

library(D3TableFilter)
p <- d3tf(mtcars[,1:5], showRowNames = TRUE, initialFilters = list(col_1 = ">18"), width = ww, height = hh)
widgetThumbnail(p, thumbs["D3TableFilter"])

library(rhandsontable)
DF = data.frame(val = 1:10, bool = TRUE, big = LETTERS[1:10],
                small = letters[1:10],
                dt = seq(from = Sys.Date(), by = "days", length.out = 10),
                stringsAsFactors = F)
rhandsontable(DF, rowHeaders = NULL, width = ww, height = hh)
# save it manually...

library(rcdimple)
ex_data <- read.delim("http://pmsi-alignalytics.github.io/dimple/data/example_data.tsv")
colnames(ex_data) <- gsub("[.]","", colnames(ex_data))
p <- ex_data %>%
  dimple(x ="Month", y = "UnitSales", groups = 'Channel',
    type = "bar", width = 590, height = 400
  ) %>%
  set_bounds( x = 60, y = 30, width = 510, height = 290 ) %>%
  xAxis(orderRule = "Date") %>%
  add_legend(  ) %>%
  add_title( text = "Unit Sales each Month by Channel", width = ww, height = hh)
# doesn't seem to obey sizing...
widgetThumbnail(p, thumbs["rcdimple"])

library(sortableR)
# save manually

library(parcoords)
data(mtcars)
p <- parcoords(
  mtcars,
  reorderable = T,
  brushMode = "2d-strums",
  width = hh + 60, height = hh
)
# make a bid wider and manually crop
widgetThumbnail(p, thumbs["parcoords"])

library(listviewer)
p <- jsonedit(mtcars, width = ww, height = hh)
widgetThumbnail(p, thumbs["listviewer"])

library(svgPanZoom)
library(SVGAnnotation)
# svgPanZoom(
#   svgPlot(
#     plot(1:10)
#   )
# )
# rrg... x11... skip this one

library(exportwidget)
# not plottable

library(trailr)
# not plottable

library(imageR)
tf <- tempfile()
png( file = tf, height = 600, width = 600 )
plot(1:50)
dev.off()
intense(
  tags$img(
    style = "height:50%;"
    ,"data-title" = "sample intense plot"
    ,"data-caption" = "imageR at work"
    ,src = paste0("data:image/png;base64,",base64enc::base64encode(tf))
  ),
  width = ww, height = hh
)

library(plottableR)
# can't find examples...

library(chartist)
set.seed(324)
data <- data.frame(
  day = paste0("day", 1:10),
  A   = runif(10, 0, 10),
  B   = runif(10, 0, 10),
  C   = runif(10, 0, 10)
)
chartist(data, day) #, width = ww, height = hh)
# doesn't like sizing - do it manually...

library(phylowidget)
nwk <- "(((EELA:0.150276,CONGERA:0.213019):0.230956,(EELB:0.263487,CONGERB:0.202633):0.246917):0.094785,((CAVEFISH:0.451027,(GOLDFISH:0.340495,ZEBRAFISH:0.390163):0.220565):0.067778,((((((NSAM:0.008113,NARG:0.014065):0.052991,SPUN:0.061003,(SMIC:0.027806,SDIA:0.015298,SXAN:0.046873):0.046977):0.009822,(NAUR:0.081298,(SSPI:0.023876,STIE:0.013652):0.058179):0.091775):0.073346,(MVIO:0.012271,MBER:0.039798):0.178835):0.147992,((BFNKILLIFISH:0.317455,(ONIL:0.029217,XCAU:0.084388):0.201166):0.055908,THORNYHEAD:0.252481):0.061905):0.157214,LAMPFISH:0.717196,((SCABBARDA:0.189684,SCABBARDB:0.362015):0.282263,((VIPERFISH:0.318217,BLACKDRAGON:0.109912):0.123642,LOOSEJAW:0.397100):0.287152):0.140663):0.206729):0.222485,(COELACANTH:0.558103,((CLAWEDFROG:0.441842,SALAMANDER:0.299607):0.135307,((CHAMELEON:0.771665,((PIGEON:0.150909,CHICKEN:0.172733):0.082163,ZEBRAFINCH:0.099172):0.272338):0.014055,((BOVINE:0.167569,DOLPHIN:0.157450):0.104783,ELEPHANT:0.166557):0.367205):0.050892):0.114731):0.295021)"
p <- phylowidget(nwk, width = ww, height = hh)
widgetThumbnail(p, thumbs["phylowidget"])

library(sweep)
# can't find anything...

library(testjs)
x <- rnorm(100)
grp <- sample(1:3, 100, replace=TRUE)
y <- x*grp + rnorm(100)
p <- iplot(x, y, grp)
# won't accept dimensions
widgetThumbnail(p, thumbs["testjs"])

library(highchartR)
data = mtcars
x = 'wt'
y = 'mpg'
group = 'cyl'
highcharts(
    data = data,
    x = x,
    y = y,
    group = group,
    type = 'scatter'
)
# doesn't work

library(greatCircles)
p <- greatCircles(data.frame(
  longitude.start=c(-0.1015987,9.9278215,2.3470599,12.5359979,-42.9232368,114.1537584, 139.7103880,-118.4117325,-73.9796810,4.8986142,7.4259704,-1.7735460),
  latitude.start = c(51.52864,53.55857,48.85886,41.91007,-22.06645,22.36984,35.67334, 34.02050,40.70331,52.37472,43.74105,52.49033),
  longitude.finish = c(9.9278215,2.3470599,12.5359979,-42.9232368,114.1537584,139.7103880, -118.4117325,-73.9796810,4.8986142,7.4259704,-1.7735460,-0.1015987),
  latitude.finish = c(53.55857,48.85886,41.91007,-22.06645,22.36984,35.67334,34.02050, 40.70331,52.37472,43.74105,52.49033,51.52864)
), width = ww, height = hh)
widgetThumbnail(p, thumbs["great-circles"])

library(sparkline)
x = rnorm(20)
sparkline(x)
sparkline(x, type = 'bar')
sparkline(x, type = 'box')
# manually save...

library(rWordCloud)
# manaul...

library(c3r)
data(cars)
p <- c3_plot(cars, "speed", "dist", width = ww, height = hh)
widgetThumbnail(p, thumbs["c3r"])

library(dcStockR)
library(httr)
library(lubridate)
res <- GET("https://github.com/dc-js/dc.js/raw/master/web/ndx.csv")
ndx <- content(res, type = "text/csv")
ndx$date <- as.character(mdy(ndx$date))
# dc(ndx, "yearlyBubbleChart", title = "Yearly Performance (radius: fluctuation/index ratio, color: gain/loss)")
# dc(ndx, "gainOrLossChart", title = "Days by Gain/Loss", height = 300)
# dc(ndx, "quarterChart", title = "Quarters", height = 300)
# dc(ndx, "dayOfWeekChart", title = "Day of Week", height = 300)
# dc(ndx, "fluctuationChart", title = "Days by Fluctuation(%)", height = 300)
p <- dc(ndx, "moveChart", title = "Monthly Index Abs Move & Volume/500,000 Chart", width = ww, height = hh)
# dc(ndx, "dataCount")
# dc(ndx, "dataTable")
widgetThumbnail(p, thumbs["dcStockR"])

library(scatterMatrixD3)
scatterMatrix(data = iris, width = ww, height = hh)

library(d3heatmap)
p <- d3heatmap(mtcars, scale = "column", colors = "Spectral", width = ww, height = hh)
widgetThumbnail(p, "rstudio-d3heatmap.png")

library(rpivotTable)
data(mtcars)
p <- rpivotTable(
  Titanic
  , rows = c("Class","Sex","Age")
  , cols = "Survived"
  , aggregatorName = "Sum as Fraction of Rows"
  , vals = "Freq"
  , rendererName = "Heatmap"
)
widgetThumbnail2(p,thumbs["rpivotTable"])


library(qtlcharts)
# simulate some data
n.ind <- 500
n.gene <- 10000
expr <- matrix(rnorm(n.ind * n.gene, (1:n.ind)/n.ind*3), ncol=n.gene)
dimnames(expr) <- list(paste0("ind", 1:n.ind),
                       paste0("gene", 1:n.gene))
# generate the plot
p <- iboxplot(expr, chartOpts= list(height = hh, width =ww))
widgetThumbnail2(p,thumbs["qtlcharts"])


library(formattable)

df <- data.frame(
  id = 1:10,
  name = c("Bob", "Ashley", "James", "David", "Jenny",
           "Hans", "Leo", "John", "Emily", "Lee"),
  age = c(28, 27, 30, 28, 29, 29, 27, 27, 31, 30),
  grade = c("C", "A", "A", "C", "B", "B", "B", "A", "C", "C"),
  test1_score = c(8.9, 9.5, 9.6, 8.9, 9.1, 9.3, 9.3, 9.9, 8.5, 8.6),
  test2_score = c(9.1, 9.1, 9.2, 9.1, 8.9, 8.5, 9.2, 9.3, 9.1, 8.8),
  final_score = c(9, 9.3, 9.4, 9, 9, 8.9, 9.25, 9.6, 8.8, 8.7),
  registered = c(TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
  stringsAsFactors = FALSE)

p<-formattable(df, list(
  age = color_tile("white", "orange"),
  grade = formatter("span",
                    style = x ~ ifelse(x == "A", style(color = "green", font.weight = "bold"), NA)),
  test1_score = color_bar("pink", 0.2),
  test2_score = color_bar("pink", 0.2),
  final_score = formatter("span",
                          style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
                          x ~ sprintf("%.2f (rank: %02d)", x, rank(-x))),
  registered = formatter("span",
                         style = x ~ style(color = ifelse(x, "green", "red")),
                         x ~ icontext(ifelse(x, "ok", "remove"), ifelse(x, "Yes", "No")))
))

widgetThumbnail2(as.htmlwidget(p),thumbs["formattable"])


library(bubbles)

p<-bubbles(value = runif(26), label = LETTERS,
        color = rainbow(26, alpha=NULL)[sample(26)]
)
widgetThumbnail2(p,thumbs["bubbles"])


data(iris)
require(pairsD3)
p<-pairsD3(iris[,1:4],group=iris[,5])
widgetThumbnail2(p,thumbs["pairsD3"])

library(edgebundleR)
require(igraph)
ws_graph <- watts.strogatz.game(1, 50, 4, 0.05)
p<-edgebundle(ws_graph,tension = 0.1,fontsize = 18,padding=40)
widgetThumbnail2(p,thumbs["edgebundleR"])



library(katexR)
library(htmltools)

p <- katex( "\\frac{1}{n} \\sum_{i=i}^{n} x_{i}", tag="p", style = "font-size:300%;" )
widgetThumbnail2(p,thumbs["katexR"])


library(htmltools)
library(navr)

# build a simple nav
n1 <- navr(
  selector = "#icon-toolbar"
  ,taglist = tagList(
    tags$ul(style="line-height:120px; text-align:center; vertical-align:middle;"
            ,tags$li(
              style="border: solid 0.1em white;border-radius:100%;line-height:inherit;width:130px;height:130px;"
              , class="fa fa-beer fa-4x"
            )
            ,tags$li(
              style="border: solid 0.1em white;border-radius:100%;line-height:inherit;width:130px;height:130px;"
              , class="fa fa-bell fa-4x"
            )
    )
  )
)

p<-tagList(
  tags$div(
    id = "icon-toolbar"
    ,style="width:300px;height:300px;border: dashed 0.2em lightgray; float:left;"
    ,tags$h3("Icon with Hover Effects")
    ,"Hover effects are even nicer when they work with icons, especially our easy
    to add Font-Awesome icons."
  )
  ,add_hover(add_font_awesome(n1),"fade")
)
widgetThumbnail2(p,thumbs["navr"])


library(gamer)
p<-entangler()
widgetThumbnail2(p,thumbs["gamer"])




library(htmltools)
library(materializeR)

p<-tagList(
  materialize() # can be anywhere; I like to put first so I don't forget
  ,HTML('
     <div class="row">
        <div class="col s12">
          <ul class="tabs">
            <li class="tab col s3"><a href="#test1">Base Graphics</a></li>
            <li class="tab col s3"><a class="active" href="#test2">lattice</a></li>
            <li class="tab col s3"><a href="#test3">ggplot2</a></li>
          </ul>
        </div>
        <div id="test1" class="col s12">even base R graphics are powerful.</div>
        <div id="test2" class="col s12">lattice does amazing plots with little code.</div>
        <div id="test3" class="col s12">ggplot2 makes non-R envious.</div>
      </div>
  ')
)
widgetThumbnail2(p,thumbs["materializeR"])


library(comicR)
library(lattice)
library(gridSVG)
library(XML)
library(pipeR)

dev.new( height = 10, width = 10, noRStudioGD = T )
dev.set(which = tail(dev.list(),1))

dotplot(variety ~ yield | year * site, data=barley)
dot_svg <- grid.export(name="")$svg
dev.off()
p<-tagList(
  tags$div(
    id = "lattice-comic"
    ,tags$h3("lattice plot with comicR and Google font")
    ,HTML(saveXML(addCSS(
      dot_svg
      , I("svg text { font-family : Architects Daughter; }")
    )))
  )
  ,comicR( "#lattice-comic", ff = 5 )
)
widgetThumbnail2(p,thumbs["comicR"])



library(loryR)
contour( volcano )
dotchart(VADeaths, main = "Death Rates in Virginia - 1940")
coplot(lat ~ long | depth, data = quakes)
sunflowerplot(iris[, 3:4])
p<-loryR(
  rstudio_gallery()
  , images_per_page = 2
  , options = list( rewind = TRUE )
  , height = 500
  , width = 500
)

widgetThumbnail2(p,thumbs["loryR"])


library(d3vennR)
venn_tooltip <- function( venn ){
  venn$x$tasks[length(venn$x$tasks)+1] <- list(
    htmlwidgets::JS('
                    function(){
                    var div = d3.select(this);

                    // add a tooltip
                    var tooltip = d3.select("body").append("div")
                    .attr("class", "venntooltip")
                    .style("position", "absolute")
                    .style("text-align", "center")
                    .style("width", 128)
                    .style("height", 16)
                    .style("background", "#333")
                    .style("color","#ddd")
                    .style("padding","2px")
                    .style("border","0px")
                    .style("border-radius","8px")
                    .style("opacity",0);

                    div.selectAll("path")
                    .style("stroke-opacity", 0)
                    .style("stroke", "#fff")
                    .style("stroke-width", 0)

                    // add listeners to all the groups to display tooltip on mousover
                    div.selectAll("g")
                    .on("mouseover", function(d, i) {

                    // sort all the areas relative to the current item
                    venn.sortAreas(div, d);

                    // Display a tooltip with the current size
                    tooltip.transition().duration(400).style("opacity", .9);
                    tooltip.text(d.size);

                    // highlight the current path
                    var selection = d3.select(this).transition("tooltip").duration(400);
                    selection.select("path")
                    .style("stroke-width", 3)
                    .style("fill-opacity", d.sets.length == 1 ? .4 : .1)
                    .style("stroke-opacity", 1);
                    })

                    .on("mousemove", function() {
                    tooltip.style("left", (d3.event.pageX) + "px")
                    .style("top", (d3.event.pageY - 28) + "px");
                    })

                    .on("mouseout", function(d, i) {
                    tooltip.transition().duration(400).style("opacity", 0);
                    var selection = d3.select(this).transition("tooltip").duration(400);
                    selection.select("path")
                    .style("stroke-width", 0)
                    .style("fill-opacity", d.sets.length == 1 ? .25 : .0)
                    .style("stroke-opacity", 0);
                    });
                    }
                    ')
    )
  venn
  }
p<-venn_tooltip(d3vennR(
  # data from venn.js examples
  #   https://github.com/benfred/venn.js/blob/master/examples/lastfm.jsonp
  data = list(
    list("sets"= list(0), "label"= "Radiohead", "size"= 77348),
    list("sets"= list(1), "label"= "Thom Yorke", "size"= 5621),
    list("sets"= list(2), "label"= "John Lennon", "size"= 7773),
    list("sets"= list(3), "label"= "Kanye West", "size"= 27053),
    list("sets"= list(4), "label"= "Eminem", "size"= 19056),
    list("sets"= list(5), "label"= "Elvis Presley", "size"= 15839),
    list("sets"= list(6), "label"= "Explosions in the Sky", "size"= 10813),
    list("sets"= list(7), "label"= "Bach", "size"= 9264),
    list("sets"= list(8), "label"= "Mozart", "size"= 3959),
    list("sets"= list(9), "label"= "Philip Glass", "size"= 4793),
    list("sets"= list(10), "label"= "St. Germain", "size"= 4136),
    list("sets"= list(11), "label"= "Morrissey", "size"= 10945),
    list("sets"= list(12), "label"= "Outkast", "size"= 8444),
    list("sets"= list(0, 1), "size"= 4832),
    list("sets"= list(0, 2), "size"= 2602),
    list("sets"= list(0, 3), "size"= 6141),
    list("sets"= list(0, 4), "size"= 2723),
    list("sets"= list(0, 5), "size"= 3177),
    list("sets"= list(0, 6), "size"= 5384),
    list("sets"= list(0, 7), "size"= 2252),
    list("sets"= list(0, 8), "size"= 877),
    list("sets"= list(0, 9), "size"= 1663),
    list("sets"= list(0, 10), "size"= 899),
    list("sets"= list(0, 11), "size"= 4557),
    list("sets"= list(0, 12), "size"= 2332),
    list("sets"= list(1, 2), "size"= 162),
    list("sets"= list(1, 3), "size"= 396),
    list("sets"= list(1, 4), "size"= 133),
    list("sets"= list(1, 5), "size"= 135),
    list("sets"= list(1, 6), "size"= 511),
    list("sets"= list(1, 7), "size"= 159),
    list("sets"= list(1, 8), "size"= 47),
    list("sets"= list(1, 9), "size"= 168),
    list("sets"= list(1, 10), "size"= 68),
    list("sets"= list(1, 11), "size"= 336),
    list("sets"= list(1, 12), "size"= 172),
    list("sets"= list(2, 3), "size"= 406),
    list("sets"= list(2, 4), "size"= 350),
    list("sets"= list(2, 5), "size"= 1335),
    list("sets"= list(2, 6), "size"= 145),
    list("sets"= list(2, 7), "size"= 347),
    list("sets"= list(2, 8), "size"= 176),
    list("sets"= list(2, 9), "size"= 119),
    list("sets"= list(2, 10), "size"= 46),
    list("sets"= list(2, 11), "size"= 418),
    list("sets"= list(2, 12), "size"= 146),
    list("sets"= list(3, 4), "size"= 5465),
    list("sets"= list(3, 5), "size"= 849),
    list("sets"= list(3, 6), "size"= 724),
    list("sets"= list(3, 7), "size"= 273),
    list("sets"= list(3, 8), "size"= 143),
    list("sets"= list(3, 9), "size"= 180),
    list("sets"= list(3, 10), "size"= 218),
    list("sets"= list(3, 11), "size"= 599),
    list("sets"= list(3, 12), "size"= 3453),
    list("sets"= list(4, 5), "size"= 977),
    list("sets"= list(4, 6), "size"= 232),
    list("sets"= list(4, 7), "size"= 250),
    list("sets"= list(4, 8), "size"= 166),
    list("sets"= list(4, 9), "size"= 97),
    list("sets"= list(4, 10), "size"= 106),
    list("sets"= list(4, 11), "size"= 225),
    list("sets"= list(4, 12), "size"= 1807),
    list("sets"= list(5, 6), "size"= 196),
    list("sets"= list(5, 7), "size"= 642),
    list("sets"= list(5, 8), "size"= 336),
    list("sets"= list(5, 9), "size"= 165),
    list("sets"= list(5, 10), "size"= 143),
    list("sets"= list(5, 11), "size"= 782),
    list("sets"= list(5, 12), "size"= 332),
    list("sets"= list(6, 7), "size"= 262),
    list("sets"= list(6, 8), "size"= 85),
    list("sets"= list(6, 9), "size"= 284),
    list("sets"= list(6, 10), "size"= 68),
    list("sets"= list(6, 11), "size"= 363),
    list("sets"= list(6, 12), "size"= 218),
    list("sets"= list(7, 8), "size"= 1581),
    list("sets"= list(7, 9), "size"= 716),
    list("sets"= list(7, 10), "size"= 133),
    list("sets"= list(7, 11), "size"= 254),
    list("sets"= list(7, 12), "size"= 132),
    list("sets"= list(8, 9), "size"= 280),
    list("sets"= list(8, 10), "size"= 53),
    list("sets"= list(8, 11), "size"= 117),
    list("sets"= list(8, 12), "size"= 67),
    list("sets"= list(9, 10), "size"= 57),
    list("sets"= list(9, 11), "size"= 184),
    list("sets"= list(9, 12), "size"= 89),
    list("sets"= list(10, 11), "size"= 51),
    list("sets"= list(10, 12), "size"= 115),
    list("sets"= list(11, 12), "size"= 162),
    list("sets"= list(0, 1, 6), "size"= 480),
    list("sets"= list(0, 1, 9), "size"= 152),
    list("sets"= list(0, 2, 7), "size"= 112),
    list("sets"= list(0, 3, 4), "size"= 715),
    list("sets"= list(0, 3, 12), "size"= 822),
    list("sets"= list(0, 4, 5), "size"= 160),
    list("sets"= list(0, 5, 11), "size"= 292),
    list("sets"= list(0, 6, 12), "size"= 122),
    list("sets"= list(0, 7, 11), "size"= 118),
    list("sets"= list(0, 9, 10), "size" =13),
    list("sets"= list(2, 7, 8), "size"= 72)
  )
))
widgetThumbnail2(p,thumbs["d3vennR"])



# using about.html from R help
library("flowtypeR")
library("htmltools")
library("shiny")

# read about.html from the R system help directory
about_html <- readLines(file.path(R.home("doc/html"),"about.html"))
p<-  tagList(
    bootstrapPage(
      tags$div(class="row"
               ,tags$div(class="col-xs-6"
                         ,tags$h1("with flowtype")
                         ,tags$div(
                           id="flowtype-resize"
                           ,style="padding:0em 1em 0em 1em; border: 2px solid gray;"
                           ,HTML(
                             about_html[do.call(seq,as.list(grep(x=about_html,pattern="<h2>")+c(0,-1)))]
                           )
                         )
               )
               ,tags$div(class="col-xs-6"
                         ,tags$h1("without flowtype")
                         ,tags$div(id="flowtype-resize"
                                   ,style="padding:0em 1em 0em 1em; border: 2px dashed gray;"
                                   ,HTML(
                                     about_html[do.call(seq,as.list(grep(x=about_html,pattern="<h2>")+c(0,-1)))]
                                   )
                         )
               )
      )
    )
    ,flowtype(
      '#flowtype-resize'
      ,minFont = 12
      ,fontRatio = 20
    )
  )

widgetThumbnail2(p,thumbs["flowtypeR"])


library(sweetalertR)
#manual


library(calheatmapR)
data(pletcher)
widgetThumbnail2(
  calheatmapR(data = pletcher, height = "100%") %>%
    chDomain(domain = "month",
             subDomain = "day",
             start = "2012-11-01",
             range = 5)
  ,thumbs["calheatmapR"]
)


## manually make taucharts