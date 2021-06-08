#==========================================
# strips A1:A2 suffix from variant IDs
#==========================================

source("code/load_packages.R")
library(stringi)
strip_alleles <- function(x) {
  x <- stringi::stri_replace_last_regex(x, ":[ACTG]*:[ACTG]*", "")
}