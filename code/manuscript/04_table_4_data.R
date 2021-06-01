#========================================================
# make Table 4: NACC + ROSMAP + ADNI + ACT mega results
#========================================================

source("code/load_packages.R")
source("code/functions/make_or_95_ci.R")

act_mega_clump <- fread("output/act/act_mega.clumped")
act_mega_snps <- fread("data/act/act_mega.bim", header = F)
setnames(act_mega_snps, c("V2", "V5", "V6"), c("SNP", "A1", "A2"))

act_mega_top <- act_mega_results[SNP %in% act_mega_clump$SNP]
table_4_data <- merge(act_mega_top, act_mega_snps[, .(SNP, A1, A2)], by = c("SNP", "A1"))
#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

# SNPs with NACC OR >= 1
table_4_data[, `OR [95% CI]` := make_or_95_ci(OR, L95, U95, OR)]
table_4_data[OR >= 1, `A1/A2` := paste0(A1, "/", A2)]
table_4_data[OR < 1, `A1/A2` := paste0(A2, "/", A1)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------
setorder(table_4_data, CHR, BP)
table_4_data[, Gene := c("BC041441", 
                         "N4BP3", 
                         "BCKDHB",
                         "ZDHHC21",
                         "SORCS3",
                         "FGD4",
                         "WASF3",
                         "ZNF221",
                         "SLC24A3")]
# table_4_data[, Gene := "TBD"]
#-------------------
# make table
#-------------------

# round p-values to 2 significant figures
table_4_data[, P := format(signif(P, 2), scientific = TRUE)]


table_4_data <- table_4_data[, .(SNP, CHR, BP, Gene, `A1/A2`, `OR [95% CI]`, P)]
setorder(table_4_data, CHR, BP)
