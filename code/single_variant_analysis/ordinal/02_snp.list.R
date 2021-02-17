##---------------------------------------------------------------------
## make lists of snps of length 30K for analysis blocks 
##---------------------------------------------------------------------


library(pacman)
p_load(data.table, magrittr)

# load snps from .bim file
bim <- fread("02_analysis/ordinal/plink/plink.bim", header = F) %>% 
  .[, .(V1, V2)] %>% 
  setnames(., c("V1", "V2"), c("chr", "snp")) %>% 
  .[, chr := factor(chr)]

raw.length <- 30000 # desired approximate number of variants for each .raw file
n.lists <- nrow(bim) %/% raw.length
bim[, list.n := rep(1:n.lists, length.out=nrow(bim))]

for (i in 1:n.lists) {
  write.table(bim[list.n == i, snp], file = paste0("02_analysis/ordinal/snp.lists/list", i), 
              row.names = F, col.names = F, quote = F)
}

rm(list = ls())
p_unload(all)