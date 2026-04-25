# Simple image filter functions for the group exam
# The functions are intentionally written in a basic way so the steps are easy to follow.

# Turn one RGB pixel into greyscale
make_grey_pixel <- function(pixel) {
  # pixel is a raw vector with red, green and blue values
  red_value <- as.numeric(pixel[1])
  green_value <- as.numeric(pixel[2])
  blue_value <- as.numeric(pixel[3])

  grey_value <- round(red_value * 0.299 + green_value * 0.587 + blue_value * 0.114)

  new_pixel <- as.raw(c(grey_value, grey_value, grey_value))
  return(new_pixel)
}

# Keep only the red part of one pixel
make_red_pixel <- function(pixel) {
  red_value <- as.numeric(pixel[1])
  new_pixel <- as.raw(c(red_value, 0, 0))
  return(new_pixel)
}

# Keep only the green part of one pixel
make_green_pixel <- function(pixel) {
  green_value <- as.numeric(pixel[2])
  new_pixel <- as.raw(c(0, green_value, 0))
  return(new_pixel)
}

# Keep only the blue part of one pixel
make_blue_pixel <- function(pixel) {
  blue_value <- as.numeric(pixel[3])
  new_pixel <- as.raw(c(0, 0, blue_value))
  return(new_pixel)
}

# Turn a hex colour, for example "#FF00FF", into a raw RGB vector
hex_to_raw_rgb <- function(hex_colour) {
  hex_colour <- gsub("#", "", hex_colour)

  red_value <- strtoi(substr(hex_colour, 1, 2), base = 16)
  green_value <- strtoi(substr(hex_colour, 3, 4), base = 16)
  blue_value <- strtoi(substr(hex_colour, 5, 6), base = 16)

  new_pixel <- as.raw(c(red_value, green_value, blue_value))
  return(new_pixel)
}

# Make a black/pink cutoff pixel based on the greyscale value
make_cutoff_pixel <- function(pixel, cutoff = 127, low_colour = "#000000", high_colour = "#FF00FF") {
  red_value <- as.numeric(pixel[1])
  green_value <- as.numeric(pixel[2])
  blue_value <- as.numeric(pixel[3])

  grey_value <- round(red_value * 0.299 + green_value * 0.587 + blue_value * 0.114)

  if (grey_value < cutoff) {
    new_pixel <- hex_to_raw_rgb(low_colour)
  } else {
    new_pixel <- hex_to_raw_rgb(high_colour)
  }

  return(new_pixel)
}

# Go through the bitmap and apply a pixel function to every pixel
change_bitmap <- function(bitmap, pixel_function, ...) {
  new_bitmap <- bitmap

  image_width <- dim(bitmap)[2]
  image_height <- dim(bitmap)[3]

  for (x in 1:image_width) {
    for (y in 1:image_height) {
      old_pixel <- bitmap[, x, y]
      new_pixel <- pixel_function(old_pixel, ...)
      new_bitmap[, x, y] <- new_pixel
    }
  }

  return(new_bitmap)
}

# Read an image, convert the bitmap, and return the filtered image
filter_image <- function(image_path, pixel_function, ...) {
  image_object <- magick::image_read(image_path)
  bitmap <- image_object[[1]]

  filtered_bitmap <- change_bitmap(bitmap, pixel_function, ...)
  filtered_image <- magick::image_read(filtered_bitmap)

  return(filtered_image)
}

# Save a filtered image to a file
save_filter_image <- function(image_path, output_path, pixel_function, ...) {
  filtered_image <- filter_image(image_path, pixel_function, ...)
  magick::image_write(filtered_image, path = output_path)
  return(filtered_image)
}
