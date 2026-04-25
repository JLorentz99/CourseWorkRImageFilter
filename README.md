# Simple Image Filter Package

This is a small R package made for an intermediate R course group exam.

The package applies simple image filters to images by changing RGB pixel values.

## Main functions

- `make_grey_pixel()`
- `make_red_pixel()`
- `make_green_pixel()`
- `make_blue_pixel()`
- `make_cutoff_pixel()`
- `change_bitmap()`
- `filter_image()`
- `save_filter_image()`

## How to use

Open `GroupExam.Rproj` in RStudio.

Then run:

```r
install.packages("magick")
install.packages("devtools")

library(devtools)
load_all(".")
```

Put an image named `image.png` in the project folder.

Then run the R Markdown file `image_filter_exam.Rmd`.
