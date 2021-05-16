#===================================================
# Make Table 4: ADNI and ACT Replication and 
# Mega-Analysis Results
#===================================================
source("code/load_packages.R")

top_snps <- c("rs2603462", "rs7902929")

adni_replication_top <- adni_replication_top[SNP %in% top_snps]
act_replication_top <- act_results[SNP %in% top_snps]

table_4_data <- merge(adni_replication_top, 
                                  act_replication_top, 
                                  by = c("CHR", "BP", "SNP", "A1"),
                                  suffixes = c("_ADNI", "_ACT"))

table_4_data[, Gene := c("ELOVL4", "SORCS3")]

table_4_data[, adni_or_95ci := make_or_95_ci(OR_ADNI, L95_ADNI, U95_ADNI, OR_ADNI, flip_less_than_1 = FALSE)]
table_4_data[, act_or_95ci := make_or_95_ci(OR_ACT, L95_ACT, U95_ACT, OR_ACT, flip_less_than_1 = FALSE)]

table_4_data <- table_4_data[, .(CHR, BP, Gene, SNP, adni_or_95ci, P_ADNI, act_or_95ci, P_ACT)]

table_4_data[, P_ADNI_m := format(signif(P_ADNI_m, 2), scipen=2)]
table_4_data[, P := format(signif(P, 2), scipen=2)]
table_4_data[, P_ADNI := signif(P_ADNI, 2)]
table_4_data[, P_ACT := signif(P_ACT, 2)]
table_4_data[, OR := round(OR, 2)]
