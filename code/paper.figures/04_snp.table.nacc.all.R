#============================
# top SNP tables
#============================

library(pacman)
p_load(data.table, magrittr, stringi, knitr, kableExtra)
source("StripAlleles.R")

# nacc <- fread("../ADGC.HRC/65+/02_analysis/ordinal/nacc.results.csv")
# nacc[, SNP := StripAlleles(SNP)]
nacc.log <- fread("../ADGC.HRC/65+/02_analysis/logistic/regression.assoc.logistic") %>%
  .[, SNP := StripAlleles(SNP)]
# rosmap <- fread("../ROSMAP/all/02_analysis/ordinal/rosmap.results.csv")
# rosmap[, SNP := StripAlleles(SNP)]
rosmap.log <- fread("../ROSMAP/all/02_analysis/logistic/regression.assoc.logistic") %>% 
  .[, SNP := StripAlleles(SNP)]

nacc.snps <- fread("../ADGC.HRC/65+/01_data/qc.files/nacc.pass.basic.qc.bim") %>% 
  setnames(colnames(.), c("CHR", "SNP", "V3", "BP", "A1", "A2")) %>% 
  .[, SNP := StripAlleles(SNP)]
# nacc.ord.top <- fread("../ADGC.HRC/65+/02_analysis/ordinal/plink.clumped") %>% .[, SNP := StripAlleles(SNP)]
nacc.log.top <- fread("../ADGC.HRC/65+/02_analysis/logistic/plink.clumped") %>% .[, SNP := StripAlleles(SNP)]
# rosmap.ord.top <- fread("../ROSMAP/all/02_analysis/ordinal/plink.clumped") %>% .[, SNP := StripAlleles(SNP)]
rosmap.log.top <- fread("../ROSMAP/all/02_analysis/logistic/plink.clumped") %>% .[, SNP := StripAlleles(SNP)]

nacc.log[SNP %in% c(nacc.log.top$SNP)]
rosmap.log[SNP %in% c(nacc.log.top$SNP)]

# nacc[SNP %in% c(nacc.ord.top$SNP)]
# rosmap[SNP %in% c(nacc.ord.top$SNP)]
# 
# rosmap[SNP %in% c(rosmap.log.top$SNP, rosmap.ord.top$SNP)]
# nacc[SNP %in% c(rosmap.log.top$SNP, rosmap.ord.top$SNP)]

# .(CHR, SNP, BP, A1, OR.Log, L95.Log, U95.Log, P.Log)
nacc.log.tab <- merge(
  nacc.log[SNP %in% nacc.log.top$SNP], 
  rosmap.log[SNP %in% nacc.log.top$SNP], 
  by = c("CHR", "SNP", "BP"), 
  all.x = T, 
  suffixes = c("_NACC", "_ROSMAP"))

nacc.log.tab <- merge(nacc.log.tab, nacc.snps[, .(SNP, A1, A2)], c("SNP"))
setorder(nacc.log.tab, P_NACC)

# check to make sure NACC and ROSMAP have same effect alleles
# (This prints how many alleles are discordant)
nacc.log.tab[!is.na(A1_ROSMAP), .N - sum(A1_NACC == A1_ROSMAP)]

#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

# SNPs with NACC OR >= 1
nacc.log.tab[OR_NACC >= 1, `NACC OR [95% CI]` := paste0(round(OR_NACC, 2), " [", round(L95_NACC, 2), "-", round(U95_NACC, 2), "]")]
nacc.log.tab[OR_NACC >= 1, `A1/A2` := paste0(A1, "/", A2)]
nacc.log.tab[OR_NACC >= 1 & !is.na(OR_ROSMAP), `ROSMAP OR [95% CI]` := paste0(round(OR_ROSMAP, 2), " [", round(L95_ROSMAP, 2), "-", round(U95_ROSMAP, 2), "]")]

# SNPs with NACC OR < 1
nacc.log.tab[OR_NACC < 1, `NACC OR [95% CI]` := paste0(round(1/OR_NACC, 2), " [", round(1/U95_NACC, 2), "-", round(1/L95_NACC, 2), "]")]
nacc.log.tab[OR_NACC < 1 & !is.na(OR_ROSMAP), `ROSMAP OR [95% CI]` := paste0(round(1/OR_ROSMAP, 2), " [", round(1/U95_ROSMAP, 2), "-", round(1/L95_ROSMAP, 2), "]")]
nacc.log.tab[OR_NACC < 1, `A1/A2` := paste0(A2, "/", A1)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------

nacc.log.tab[, Gene := c("ELOVL4", "PPARGC1A", "FANCL", "WASF3 ", "SLC24A3", "FFAR1/FFAR3", "N4BP3", "SORCS3")]

#-------------------
# make table
#-------------------

# rename and round p-values to 2 significant figures
setnames(nacc.log.tab, c("P_NACC", "P_ROSMAP"), c("NACC P", "ROSMAP P"))
nacc.log.tab[, `NACC P` := signif(`NACC P`, 2)]
nacc.log.tab[, `ROSMAP P` := signif(`ROSMAP P`, 2)]


nacc.log.tab <- nacc.log.tab[, .(SNP,Gene, CHR, BP, `A1/A2`, `NACC OR [95% CI]`, `NACC P`, `ROSMAP OR [95% CI]`, `ROSMAP P`)]

nacc.log.tab %>% 
  kable() %>% 
  kable_styling(bootstrap_options = c("condensed")) %>% 
  add_header_above(c("Table X: NACC variants most associated with B-ASC"=ncol(nacc.log.tab)))
