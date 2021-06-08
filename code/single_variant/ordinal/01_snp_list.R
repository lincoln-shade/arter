##---------------------------------------------------------------------
## make lists of snps of length 30K for analysis blocks 
##---------------------------------------------------------------------

library(pacman)
p_load(data.table, magrittr)
cargs <- commandArgs(trailingOnly = TRUE)
bim_file <- "data/nacc/nacc.bim" # cargs[1]
# load snps from .bim file
bim <- fread(bim_file, header = F) %>% 
  .[, .(V1, V2)] %>% 
  setnames(., c("V1", "V2"), c("chr", "snp")) %>% 
  .[, chr := factor(chr)]

raw_length <- 30000 # desired approximate number of variants for each .raw file
n_lists <- nrow(bim) %/% raw_length
bim[, list_n := rep(1:n_lists, length.out=nrow(bim))]

for (i in seq_along(n_lists)) {# for (i in 1:n_lists) {
  fwrite(bim[list_n == i, .(snp)], file = paste0("data/tmp/ordinal_snp_list_", i), 
              row.names = F, col.names = F, quote = F, sep = " ")
}

list_index <- data.table(1:n_lists)
fwrite(list_index, file = "data/tmp/snp_list_index.tmp", row.names = F, col.names = F, quote = F, sep = " ")
