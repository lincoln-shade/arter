#===================================
# Make Table 2: NACC top SNPs with 
# nacc and rosmap OR and P
# intended to be sourced within
# manuscript .Rmd file
#===================================

source("code/00_load_options_packages_functions.R")

# should have single-variant analysis results already loaded when sourcing this
# load nacc top snps
nacc_top_snps <- fread("output/nacc_adgc/nacc_adgc_unrelated.clumped") %>% 
  .[, SNP := strip_alleles(SNP)]

# load nacc_adgc bim file to get a1 and a2 data for switching effect alleles
nacc_adgc_snps <- fread("data/nacc_adgc/nacc_adgc_unrelated.bim") %>% 
  setnames(c("V2", "V5", "V6"), c("SNP", "A1", "A2")) %>% 
  .[, SNP := strip_alleles(SNP)] %>% 
  .[SNP %in% nacc_top_snps$SNP, .(SNP, A1, A2)]

table_2_data <- merge(
  nacc_adgc_results[SNP %in% nacc_top_snps$SNP],
  rosmap_results[SNP %in% nacc_top_snps$SNP],
  by = c("CHR", "SNP", "BP"),
  all.x = T,
  suffixes = c("_NACC", "_ROSMAP")
)

table_2_data <- merge(table_2_data, nacc_adgc_snps, c("SNP"))
setorder(table_2_data, P_NACC)

# check to make sure NACC and ROSMAP have same effect alleles
# 0 snps discordant effect alleles
table_2_data[!is.na(A1_ROSMAP), .N - sum(A1_NACC == A1_ROSMAP)]

#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

# SNPs with NACC OR >= 1
table_2_data[OR_NACC >= 1, `NACC OR [95% CI]` := paste0(round(OR_NACC, 2), " [", round(L95_NACC, 2), "-", round(U95_NACC, 2), "]")]
table_2_data[OR_NACC >= 1, `A1/A2` := paste0(A1, "/", A2)]
table_2_data[OR_NACC >= 1 & !is.na(OR_ROSMAP), `ROSMAP OR [95% CI]` := paste0(round(OR_ROSMAP, 2), " [", round(L95_ROSMAP, 2), "-", round(U95_ROSMAP, 2), "]")]

# SNPs with NACC OR < 1
table_2_data[OR_NACC < 1, `NACC OR [95% CI]` := paste0(round(1/OR_NACC, 2), " [", round(1/U95_NACC, 2), "-", round(1/L95_NACC, 2), "]")]
table_2_data[OR_NACC < 1 & !is.na(OR_ROSMAP), `ROSMAP OR [95% CI]` := paste0(round(1/OR_ROSMAP, 2), " [", round(1/U95_ROSMAP, 2), "-", round(1/L95_ROSMAP, 2), "]")]
table_2_data[OR_NACC < 1, `A1/A2` := paste0(A2, "/", A1)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------

# table_2_data[, Gene := c("ELOVL4", "PPARGC1A", "FANCL", "WASF3 ", "SLC24A3", "FFAR1/FFAR3", "N4BP3", "SORCS3")]
table_2_data[, Gene := "TBD"]
#-------------------
# make table
#-------------------

# rename and round p-values to 2 significant figures
setnames(table_2_data, c("P_NACC", "P_ROSMAP"), c("NACC P", "ROSMAP P"))
table_2_data[, `NACC P` := signif(`NACC P`, 2)]
table_2_data[, `ROSMAP P` := signif(`ROSMAP P`, 2)]


table_2_data <- table_2_data[, .(CHR, BP, Gene, SNP, `A1/A2`, `NACC OR [95% CI]`, `NACC P`, `ROSMAP OR [95% CI]`, `ROSMAP P`)]
