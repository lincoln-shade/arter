#====================================================
# load options, packages, and functions for project
#====================================================
options(digits = 15)

library(pacman)
p_load(data.table, magrittr, ggplot2, stringi, readxl)

StripAlleles <- function(x) {
  x <- stri_replace_last_regex(x, ":[ACTG]*:[ACTG]*", "")
}