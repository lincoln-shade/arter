#===========================================
# Create Table 5: Gene-Set Analysis Results
#===========================================

source("code/00_load_options_packages_functions.R")

magma_gsa <- fread("output/magma/nacc_adgc_rosmap_adni_unrelated.gsa.out",
                   skip = 4)
table_5_data <- magma_gsa %>%
  setorder(P) %>%
  .[, FULL_NAME := stri_replace_first_regex(FULL_NAME, "%.*", "")] %>%
  .[, .(FULL_NAME, NGENES, P)] %>% 
  .[, P := format(signif(P, 2), scientific=TRUE)] %>% 
  head(7)
