#===================================
# Make Table S2 
# NACC and ROSMAP ordinal OR and P
#===================================

source("code/functions/strip_alleles.R")
source("code/functions/make_or_95_ci.R")

# should have single-variant analysis results already loaded when sourcing this
# load nacc top snps
nacc_results <- fread("output/nacc/ordinal_results.txt") %>% 
  .[, SNP := strip_alleles(SNP)]
nacc_top_snps <- fread("output/nacc/ordinal.clumped") %>% 
  .[, SNP := strip_alleles(SNP)]

# load nacc bim file to get a1 and a2 data for switching effect alleles
nacc_snps <- fread("data/nacc/nacc.bim") %>% 
  setnames(c("V2", "V5", "V6"), c("SNP", "A1", "A2")) %>% 
  .[, SNP := strip_alleles(SNP)] %>% 
  .[SNP %in% nacc_top_snps$SNP, .(SNP, A1, A2)]

rosmap_results <- fread("output/rosmap/ordinal_results.txt")

table_s2_data <- merge(
  nacc_results[SNP %in% nacc_top_snps$SNP],
  rosmap_results[SNP %in% nacc_top_snps$SNP],
  by = c("CHR", "SNP", "BP"),
  all.x = T,
  suffixes = c("_NACC", "_ROSMAP")
)

table_s2_data <- merge(table_s2_data, nacc_snps, c("SNP"))

# check to make sure NACC and ROSMAP have same effect alleles
# 0 snps discordant effect alleles
table_s2_data[!is.na(A1_ROSMAP), .N - sum(A1_NACC == A1_ROSMAP)]

#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

calc_95ci_bound <- function(or, se, ci = 0.95, lower = TRUE) {
  quant <- qnorm((1 - ci) / 2, lower.tail = lower)
  bound <- exp(log(or) + quant * se)
  return(bound)
} %>% 
  Vectorize()

table_s2_data[, L95_NACC := calc_95ci_bound(OR.Ord_NACC, SE.Ord_NACC)]
table_s2_data[, U95_NACC := calc_95ci_bound(OR.Ord_NACC, SE.Ord_NACC, lower = FALSE)]
table_s2_data[!(is.na(OR.Ord_ROSMAP)), L95_ROSMAP := calc_95ci_bound(OR.Ord_ROSMAP, SE.Ord_ROSMAP)]
table_s2_data[!(is.na(OR.Ord_ROSMAP)), U95_ROSMAP := calc_95ci_bound(OR.Ord_ROSMAP, SE.Ord_ROSMAP, lower = FALSE)]
table_s2_data[, `NACC OR [95% CI]` := make_or_95_ci(OR.Ord_NACC, L95_NACC, U95_NACC, OR.Ord_NACC)]
table_s2_data[OR.Ord_NACC >= 1, `A1/A2` := paste0(A1, "/", A2)]
table_s2_data[OR.Ord_NACC < 1, `A1/A2` := paste0(A2, "/", A1)]
table_s2_data[, `ROSMAP OR [95% CI]` := make_or_95_ci(OR.Ord_ROSMAP, L95_ROSMAP, U95_ROSMAP, OR.Ord_NACC)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------

setorder(table_s2_data, CHR, BP)
table_s2_data[, Gene := c("FANCL",
                          "SPRED2",
                          "GYPC",
                          "TRAIP",
                          "KCNIP4",
                          "PPARGC1A",
                          "SPRY1",
                          "F13A1",
                          "BCKDHB",
                          "NOVA1",
                          "RBFOX1",
                          "MOCOS",
                          "FFAR3",
                          "TOMM40",
                          "SLC24A3",
                          "FAM19A5")]
# table_s2_data[, Gene := "TBD"]
#-------------------
# make table
#-------------------

# rename and round p-values to 2 significant figures
setnames(table_s2_data, c("P.Ord_NACC", "P.Ord_ROSMAP"), c("NACC P", "ROSMAP P"))
table_s2_data[, `NACC P` := signif(`NACC P`, 2)]
table_s2_data[, `ROSMAP P` := as.character(signif(`ROSMAP P`, 2))]
table_s2_data[is.na(`ROSMAP P`), `ROSMAP P` := " - "]
table_s2_data$`NACC P` <- format(table_s2_data$`NACC P`, scipen=2)
table_s2_data$`ROSMAP P` <- format(table_s2_data$`ROSMAP P`, drop0trailing = TRUE)


table_s2_data <- table_s2_data[, .(SNP, CHR, BP, Gene, `A1/A2`, `NACC OR [95% CI]`, `NACC P`, `ROSMAP OR [95% CI]`, `ROSMAP P`)]
