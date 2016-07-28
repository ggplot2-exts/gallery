# install.packages(c("yaml", "jsonlite", "devtools"))
# devtools::install_github("cscheid/rgithub")
# set environment variable GITHUB_TOKEN

suppressMessages(library(yaml))
suppressMessages(library(jsonlite))
suppressMessages(library(github))

message("* setting up context")
ctx <- create.github.context(personal_token = Sys.getenv("GITHUB_TOKEN"))

message("* loading yaml")
yml <- yaml.load_file("_config.yml")

meta <- lapply(yml$widgets, function(wdgt) {
  message("*** getting meta data for: ", wdgt$ghuser, " ", wdgt$ghrepo)
  a <- try(get.repository(wdgt$ghuser, wdgt$ghrepo))
  if(inherits(a, "try-error"))
    return(list(stargazers_count = 0))
  a$content[c("stargazers_count", "open_issues_count", "forks_count", "watchers_count")]
})

names(meta) <- sapply(yml$widgets, function(x) paste(x$ghuser, x$ghrepo, sep = "_"))

all_good <- sapply(meta, function(x) is.numeric(x$stargazers_count))

if(all(all_good) && length(yml$widgets) == length(meta)) {
  message("* saving results")
  cat(toJSON(meta, auto_unbox = TRUE), file = "github_meta.json")
} else {
  cat("ERROR - NOT UPDATING REPO")
}

