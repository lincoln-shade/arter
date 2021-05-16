#============================
# top SNP tables
#============================

library(pacman)
p_load(data.table, magrittr, stringi, knitr, kableExtra)

results <- fread("../NACC.ROSMAP.meta/02_analysis/logistic/mega.assoc.logistic")
snps <- fread("../NACC.ROSMAP.meta/01_data/merged/plink.bim") %>% 
  setnames(colnames(.), c("CHR", "SNP", "V3", "BP", "A1", "A2"))
top.snps <- fread("../NACC.ROSMAP.meta/02_analysis/logistic/plink.clumped")

rts <- merge(results, top.snps[, .(SNP)], "SNP") %>% 
  merge(., snps[, .(SNP, A2)], "SNP") %>% 
  setorder(., P)

#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

# SNPs with NACC OR >= 1
rts[OR >= 1, `OR [95% CI]` := paste0(round(OR, 2), " [", round(L95, 2), "-", round(U95, 2), "]")]
rts[OR >= 1, `A1/A2` := paste0(A1, "/", A2)]

# SNPs with NACC OR < 1
rts[OR < 1, `OR [95% CI]` := paste0(round(1/OR, 2), " [", round(1/U95, 2), "-", round(1/L95, 2), "]")]
rts[OR < 1, `A1/A2` := paste0(A2, "/", A1)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------

rts[, Gene := c("SORCS3", "ELOVL4", "WASF3", "CTH", "SLC24A3", "COPG2", "SPOCK3", "N4BP3", "ZDHHC21", "CD83")]

#-------------------
# make table
#-------------------

# round p-values to 2 significant figures
rts[, P := signif(P, 2)]


rts <- rts[, .(SNP, Gene, CHR, BP, `A1/A2`, `OR [95% CI]`, P)]

rts %>% 
  kable() %>% 
  kable_styling(bootstrap_options = c("condensed")) %>% 
  add_header_above(c("Table X: NACC & ROSMAP mega-analysis variants associated with B-ASC"=ncol(rts)))
