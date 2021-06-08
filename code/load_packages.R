#====================================================
# load options, packages, and functions for project
#====================================================

#--------------
# base options
#--------------
options(digits = 15)

#------------------------
# install/load packages
#------------------------
# # arrow
# # if you're on linux and want to open parquet files from GTEx, you'll need to run the following when installing arrow
# if (arrow == TRUE) {
#   if (!(require("arrow"))) {
#     Sys.setenv(ARROW_S3="ON")
#     Sys.setenv(NOT_CRAN="true")	
#     install.packages("arrow", repos = "https://arrow-r-nightly.s3.amazonaws.com")
#     library("arrow")
#   }
# }
#   
# # coloc
# if (coloc == TRUE) {
#   if (!require("coloc")) {
#     remotes::install_github("chr1swallace/coloc",build_vignettes=TRUE)
#     library("coloc")
#   }
# }

# cran_packages <- c("data.table", "magrittr", "ggplot2", "stringi", "readxl", "flextable", "devtools", "ggrepel", "knitr", "rentrez",
#                    "miceadds", "MASS", "dplyr", "GMMAT", "pacman", "remotes", "mediation")
# ignore_deps <- c("SeqArray", "tinytex")
# github_packages <- c("coloc")
# bioc_packages <- c("rtracklayer", "GEOquery", "GENESIS", "GWASTools", "qusage", "SeqArray", "SNPRelate") 
