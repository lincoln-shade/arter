##---------------------------------------
## Table of top SNPs from NACC Ordinal
##---------------------------------------

library(pacman)
p_load(data.table, magrittr, stringi, knitr, kableExtra)

StripAlleles <- function(dt, v) {
  dt[, paste0(v) := stri_replace_last_regex(get(v), ":[:alpha:]*:[:alpha:]*", "")]
  dt[]
}

snps <- fread("../ADGC.HRC/80+/02_analysis/ordinal/indep.top.snps.txt", header = F) %>% 
  StripAlleles(., "V1") %>% 
  .[, V1]

results <- fread("../ADGC.HRC/80+/02_analysis/ordinal/nacc.results.csv") %>% 
  StripAlleles(., "SNP") %>% 
  .[SNP %in% snps]
setkey(results, CHR, BP)
results[, OR := round(OR.Ord, 2)]
results[, SE := signif(SE.Ord, 2)]
results[, P := signif(P.Ord, 2)]

results[, .(CHR, SNP, BP, A1, OR, SE, P)] %>% 
  kable(format = "html") %>% 
  kable_styling(bootstrap_options = c("striped", "condensed", "responsive")) %>% 
  add_header_above(c("Table 4: Top SNPs from NACC ordinal regression" = 7))

##--------------------
# validation dataset
#---------------------

res.val <- fread("../ROSMAP/02_analysis/ordinal/rosmap.results.csv") %>% 
  StripAlleles(., "SNP") %>% 
  .[SNP %in% snps]
setkey(res.val, CHR, BP)
res.val[, OR := round(OR.Ord, 2)]
res.val[, SE := signif(SE.Ord, 2)]
res.val[, P := signif(P.Ord, 2)]

res.val[, .(CHR, SNP, BP, A1, OR, SE, P)] %>% 
  kable(format = "html") %>% 
  kable_styling(bootstrap_options = c("striped", "condensed", "responsive")) %>% 
  add_header_above(c("Table 5: ROSMAP validation of top SNPs from NACC/ADGC ordinal regression" = 7))
