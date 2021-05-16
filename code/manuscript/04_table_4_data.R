#========================================================
# make Table 4: NACC + ROSMAP + ADNI + ACT mega results
#========================================================

source("code/load_packages.R")

if (!exists("act_mega_top")) {
  act_mega_top <- fread("output/act/act_mega.clumped")
}

if (!exists("act_mega_snps")) {
  act_mega_snps <- fread("data/act/act_mega.bim", header = F)
  setnames(act_mega_snps, c("V2", "V5", "V6"), c("SNP", "A1", "A2"))
}

table_4_data <- merge(act_mega_mega_top[, -c("P")], act_mega_mega_results, by = c("SNP", "CHR", "BP"))
table_4_data <- merge(table_4_data, act_mega_snps[, .(SNP, A1, A2)], by = c("SNP", "A1"))
#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

# SNPs with NACC OR >= 1
table_4_data[OR >= 1, `OR [95% CI]` := paste0(round(OR, 2), " [", round(L95, 2), "-", round(U95, 2), "]")]
table_4_data[OR >= 1, `A1/A2` := paste0(A1, "/", A2)]

# SNPs with NACC OR < 1
table_4_data[OR < 1, `OR [95% CI]` := paste0(round(1/OR, 2), " [", round(1/U95, 2), "-", round(1/L95, 2), "]")]
table_4_data[OR < 1, `A1/A2` := paste0(A2, "/", A1)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------

# table_4_data[, Gene := c("SORCS3", "ELOVL4", "WASF3", "CTH", "SLC24A3", "COPG2", "SPOCK3", "N4BP3", "ZDHHC21", "CD83")]
table_4_data[, Gene := "TBD"]
#-------------------
# make table
#-------------------

# round p-values to 2 significant figures
table_4_data[, P := signif(P, 2)]


table_4_data <- table_4_data[, .(CHR, BP, Gene, SNP, `A1/A2`, `OR [95% CI]`, P)]
setorder(table_4_data, P)

# table_4_data %>% 
#   kable() %>% 
#   kable_styling(bootstrap_options = c("condensed")) %>% 
#   add_header_above(c("Table X: NACC & ROSMAP mega-analysis variants associated with B-ASC"=ncol(table_4_data)))
