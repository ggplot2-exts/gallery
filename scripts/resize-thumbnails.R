library(yaml)
library(magick)

ORIGINAL_DIR <- "images/original"
dir.create(ORIGINAL_DIR, showWarnings = FALSE)

yml <- yaml.load_file("_config.yml")
thumbnails <- vapply(yml$widgets, function(x) x$thumbnail, FUN.VALUE = character(1L))

resize_thumbnail <- function(thumbnail) {
  message("resizing ", thumbnail, "...", appendLF = FALSE)
  x <- image_read(thumbnail)
  info <- image_info(x)[1, ]
  if (info$width <= 700 && info$height <= 600) {
    message("skip")
    return(FALSE)
  }
  
  # backup the original image
  file.copy(thumbnail, file.path(ORIGINAL_DIR, basename(thumbnail)), overwrite = TRUE)
  
  # resize and save the image
  x <- image_resize(x, "700x600")
  image_write(x, thumbnail)

  message("done")
  return(TRUE)
}

vapply(thumbnails, resize_thumbnail, FUN.VALUE = logical(1L))
