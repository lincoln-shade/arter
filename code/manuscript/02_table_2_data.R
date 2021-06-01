#===================================
# Make Table 2: NACC top SNPs with 
# NACC and ROSMAP OR and P
# intended to be sourced within
# manuscript .Rmd file
#===================================

source("code/load_packages.R")
source("code/functions/strip_alleles.R")
source("code/functions/make_or_95_ci.R")

# should have single-variant analysis results already loaded when sourcing this
# load nacc top snps
nacc_top_snps <- fread("output/nacc/nacc.clumped") %>% 
  .[, SNP := strip_alleles(SNP)]

# load nacc bim file to get a1 and a2 data for switching effect alleles
nacc_snps <- fread("data/nacc/nacc.bim") %>% 
  setnames(c("V2", "V5", "V6"), c("SNP", "A1", "A2")) %>% 
  .[, SNP := strip_alleles(SNP)] %>% 
  .[SNP %in% nacc_top_snps$SNP, .(SNP, A1, A2)]

table_2_data <- merge(
  nacc_results[SNP %in% nacc_top_snps$SNP],
  rosmap_results[SNP %in% nacc_top_snps$SNP],
  by = c("CHR", "SNP", "BP"),
  all.x = T,
  suffixes = c("_NACC", "_ROSMAP")
)

table_2_data <- merge(table_2_data, nacc_snps, c("SNP"))

# check to make sure NACC and ROSMAP have same effect alleles
# 0 snps discordant effect alleles
table_2_data[!is.na(A1_ROSMAP), .N - sum(A1_NACC == A1_ROSMAP)]

#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

table_2_data[, `NACC OR [95% CI]` := make_or_95_ci(OR_NACC, L95_NACC, U95_NACC, OR_NACC)]
table_2_data[, `A1/A2` := paste0(A1, "/", A2)]
table_2_data[, `A1/A2` := paste0(A2, "/", A1)]
table_2_data[, `ROSMAP OR [95% CI]` := make_or_95_ci(OR_ROSMAP, L95_ROSMAP, U95_ROSMAP, OR_NACC)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------

setorder(table_2_data, CHR, BP)
table_2_data[, Gene := c("FANCL", 
                         "PPARGC1A", 
                         "N4BP3", 
                         "BCKDHB", 
                         "PACSIN1", 
                         "HCG27", 
                         "IGF2BP3", 
                         "SORCS3", 
                         "OR8A1/PANX3",
                         "WASF3", 
                         "NOVA1", 
                         "CA10", 
                         "FFAR1/FFAR3", 
                         "SLC24A3")]
# table_2_data[, Gene := "TBD"]
#-------------------
# make table
#-------------------

# rename and round p-values to 2 significant figures
setnames(table_2_data, c("P_NACC", "P_ROSMAP"), c("NACC P", "ROSMAP P"))
table_2_data[, `NACC P` := signif(`NACC P`, 2)]
table_2_data[, `ROSMAP P` := as.character(signif(`ROSMAP P`, 2))]
table_2_data[is.na(`ROSMAP P`), `ROSMAP P` := " - "]


table_2_data <- table_2_data[, .(SNP, CHR, BP, Gene, `A1/A2`, `NACC OR [95% CI]`, `NACC P`, `ROSMAP OR [95% CI]`, `ROSMAP P`)]
