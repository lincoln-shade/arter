#===================================================
# Make Table 4: ADNI and ACT Replication and 
# Mega-Analysis Results
#===================================================
source("code/00_load_options_packages_functions.R")

# these objects may already be loaded into the environment
if (!exists("adni_replication_top")) {
  # will probably need to change this path later
  adni_replication_top <- fread("output/ADNI_NPC/top_replication.assoc.logistic")
}

if (!exists("act_meta_results")) {
  act_meta_results <- fread("output/act/act__nacc_adgc_rosmap_adni_unrelated.meta")
}

if (!exists("act_results")) {
  act_results <- fread("raw_data/brainartbin.assoc.logistic.txt", na.strings = "\\N")
}

top_snps <- c("rs2603462", "rs7902929")

adni_replication_top <- adni_replication_top[SNP %in% top_snps]
act_replication_top <- act_results[SNP %in% top_snps]

table_4_data <- merge(adni_replication_top, 
                                  act_replication_top, 
                                  by = c("CHR", "BP", "SNP", "A1"),
                                  suffixes = c("_ADNI", "_ACT"))

table_4_data <- merge(table_4_data, 
                                  adni_mega_results[SNP %in% top_snps, .(SNP, OR, L95, U95, P)],
                                  by="SNP")
setnames(table_4_data, 
         c("OR", "L95", "U95", "P"), 
         c("OR_ADNI_m", "L95_ADNI_m", "U95_ADNI_m", "P_ADNI_m"))

table_4_data <- merge(table_4_data,
                                  act_meta_results[SNP %in% top_snps, .(SNP, OR, P)],
                                  by="SNP")
table_4_data[, Gene := c("ELOVL4", "SORCS3")]

table_4_data[, adni_or_95ci := make_or_95_ci(OR_ADNI, L95_ADNI, U95_ADNI, flip_less_than_1 = FALSE)]
table_4_data[, act_or_95ci := make_or_95_ci(OR_ACT, L95_ACT, U95_ACT, flip_less_than_1 = FALSE)]
table_4_data[, adni_mega_or_95ci := make_or_95_ci(OR_ADNI_m, L95_ADNI_m, U95_ADNI_m, flip_less_than_1 = FALSE)]

table_4_data <- table_4_data[, .(CHR, BP, Gene, SNP, adni_or_95ci, P_ADNI, act_or_95ci, P_ACT, adni_mega_or_95ci, P_ADNI_m, OR, P)]

table_4_data[, P_ADNI_m := format(signif(P_ADNI_m, 2), scipen=2)]
table_4_data[, P := format(signif(P, 2), scipen=2)]
table_4_data[, P_ADNI := signif(P_ADNI, 2)]
table_4_data[, P_ACT := signif(P_ACT, 2)]
table_4_data[, OR := round(OR, 2)]
