##---------------------------------------
## Tables of top SNPs from meta-analysis
##---------------------------------------

library(pacman)
p_load(data.table, magrittr, stringi, knitr, kableExtra)

StripAlleles <- function(dt, v) {
  dt[, paste0(v) := stri_replace_last_regex(get(v), ":[:alpha:]*:[:alpha:]*", "")]
  dt[]
}

snps <- fread("../NACC.ROSMAP.meta/02_analysis/logistic.top.indep.snps.txt", header = F) %>% 
  .[, V1]

results <- fread("../NACC.ROSMAP.meta/02_analysis/logistic.meta") %>% 
  .[SNP %in% snps]

results[, OR := round(OR, 2)]
results[, SE := signif(SE, 2)]
results[, P := signif(P, 2)]

results[, .(CHR, SNP, BP, A1, OR, P)] %>% 
  kable(format = "html") %>% 
  kable_styling(bootstrap_options = c("striped", "condensed", "responsive")) %>% 
  add_header_above(c("Table 6: Top SNPs from NACC/ADGC & ROSMAP logistic meta-analysis" = 6))

##--------------------
# ordinal dataset
#---------------------

snps <- fread("../NACC.ROSMAP.meta/02_analysis/ordinal.top.indep.snps.txt", header = F) %>% 
  .[, V1]
res.val <- fread("../NACC.ROSMAP.meta/02_analysis/ordinal.meta") %>% 
  StripAlleles(., "SNP") %>% 
  .[SNP %in% snps]

res.val[, OR := round(OR, 2)]
res.val[, SE := signif(SE, 2)]
res.val[, P := signif(P, 2)]

res.val[, .(CHR, SNP, BP, A1, OR, P)] %>% 
  kable(format = "html") %>% 
  kable_styling(bootstrap_options = c("striped", "condensed", "responsive")) %>% 
  add_header_above(c("Table 7: Top SNPs from NACC/ADGC & ROSMAP ordinal meta-analysis" = 6))

rm(list=ls())
p_unload(all)