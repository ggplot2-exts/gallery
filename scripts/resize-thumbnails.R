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
  if (info$width <= 350 && info$height <= 300) {
    message("skip")
    return(invisible(FALSE))
  }
  
  # backup the original image
  file.copy(thumbnail, file.path(ORIGINAL_DIR, basename(thumbnail)))
  
  # resize and save the image
  x <- image_resize(x, "350x300")
  image_write(x, thumbnail)

  message("done")
  invisible(TRUE)
}

lapply(thumbnails, resize_thumbnail)
