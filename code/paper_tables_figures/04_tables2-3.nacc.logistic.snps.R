##---------------------------------------
## Table of top SNPs from NACC
##---------------------------------------

library(pacman)
p_load(data.table, magrittr, stringi, knitr, kableExtra)

main <- "NACC"
validation <- "ROSMAP"

StripAlleles <- function(dt, v) {
  dt[, paste0(v) := stri_replace_last_regex(get(v), ":[:alpha:]*:[:alpha:]*", "")]
  dt[]
}

snps <- fread("../ADGC.HRC/80+/02_analysis/logistic/nacc.indep.top.snps.txt", header = F) %>% 
  .[-c(9:11)] %>% # these are variants that are really close to variant in row 8
  StripAlleles(., "V1") %>% 
  .[, V1]

results <- fread("../ADGC.HRC/80+/02_analysis/logistic/regression.assoc.logistic") %>% 
  StripAlleles(., "SNP") %>% 
  .[SNP %in% snps]

results[, OR := round(OR, 2)]
results[, SE := signif(SE, 2)]
results[, P := signif(P, 2)]

results[, .(CHR, SNP, BP, A1, OR, SE, P)] %>% 
  kable(format = "html") %>% 
  kable_styling(bootstrap_options = c("striped", "condensed", "responsive")) %>% 
  add_header_above(c("Table 2: Top SNPs from NACC logistic regression" = 7))

#---------------------
# validation dataset
#---------------------

res.val <- fread("../ROSMAP/02_analysis/logistic/regression.assoc.logistic") %>% 
  StripAlleles(., "SNP") %>% 
  .[SNP %in% snps]

res.val[, OR := round(OR, 2)]
res.val[, SE := signif(SE, 2)]
res.val[, P := signif(P, 2)]

res.val[, .(CHR, SNP, BP, A1, OR, SE, P)] %>% 
  kable(format = "html") %>% 
  kable_styling(bootstrap_options = c("striped", "condensed", "responsive")) %>% 
  add_header_above(c("Table 3: ROSMAP validation of top SNPs from NACC/ADGC logistic regression" = 7))
