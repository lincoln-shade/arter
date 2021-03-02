#====================================================
# load options, packages, and functions for project
#====================================================
options(digits = 15)

library(pacman)
p_load(data.table, magrittr, ggplot2, stringi, readxl, flextable, devtools, qusage)
# options(kableExtra.auto_format = FALSE)

strip_alleles <- function(x) {
  x <- stri_replace_last_regex(x, ":[ACTG]*:[ACTG]*", "")
}

source_url("https://raw.githubusercontent.com/lincoln-shade/r.functions/master/make_table_one.R", 
           sha1 = "618b76ddf7b93f365d7cd45fdf00910011dabb0c")
