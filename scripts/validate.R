# TODO: ideally, `cran` should be determined by github_meta.json, but it's not
# possible. This is a temporary workaround.

library(yaml)
library(magick)
library(dplyr)

yml <- yaml.load_file("_config.yml")
pkg_names <- vapply(yml$widgets, function(x) x$name, FUN.VALUE = character(1L))
cran <- vapply(yml$widgets, function(x) x$cran, FUN.VALUE = logical(1L))

d <- tibble(
  pkg_names,
  cran
)

cran_pkgs <- available.packages()[, "Package", drop = TRUE]

# says CRAN: true, but not on CRAN
d |> 
  filter(cran, !pkg_names %in% {{ cran_pkgs }})

# says CRAN: false, but on CRAN
d |> 
  filter(!cran, pkg_names %in% {{ cran_pkgs }})
