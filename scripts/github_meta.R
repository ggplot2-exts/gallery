# install.packages(c("yaml", "jsonlite", "rlang", "gh"))
# set environment variable GITHUB_PAT

suppressMessages(library(yaml))
suppressMessages(library(jsonlite))
suppressMessages(library(gh))

`%||%` <- rlang::`%||%`

message("* setting up context")

message("* loading yaml")
yml <- yaml.load_file("_config.yml")
widgets <- yml$widgets

# use only packages on GitHub
idx <- vapply(widgets, function(x) !is.null(x$ghuser), FUN.VALUE = logical(1))
widgets <- widgets[idx]

available_pkgs <- available.packages()[, "Package"]

meta <- lapply(widgets, function(wdgt) {
  # if it's not hosted on GitHub, return 0
  if (is.null(wdgt$ghuser))
    return(list(stargazers_count = 0)) 
  
  message("*** getting meta data for: ", wdgt$ghuser, " ", wdgt$ghrepo)
  
  res <- try(gh("GET /repos/:owner/:repo", owner = wdgt$ghuser, repo = wdgt$ghrepo))

  if(inherits(res, "try-error"))
    return(list(stargazers_count = 0))
  
  Sys.sleep(1)
  
  # check if the package is on CRAN
  res$cran <- wdgt$name %in% available_pkgs

  res[c("cran", "stargazers_count", "open_issues_count", "forks_count", "watchers_count")]
})

nm <- vapply(widgets, function(x) x$name, FUN.VALUE = character(1))
names(meta) <- paste0(nm, "_stars")

all_good <- vapply(meta, function(x) is.numeric(x$stargazers_count), FUN.VALUE = logical(1))

if(all(all_good) && length(widgets) == length(meta)) {
  message("* saving results")
  cat(toJSON(meta, auto_unbox = TRUE, pretty = TRUE), file = "github_meta.json")
} else {
  cat("ERROR - NOT UPDATING REPO")
}

