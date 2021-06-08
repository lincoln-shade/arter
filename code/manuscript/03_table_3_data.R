#===================================================
# Make Table 4: ADNI and ACT Replication and 
# Mega-Analysis Results
#===================================================

top_snps <- c("rs2603462", "rs7902929")

adni_replication_top <- adni_replication_top[SNP %in% top_snps]
act_replication_top <- act_results[SNP %in% top_snps]
nacc_rosmap_top <- nacc_rosmap_results[SNP %in% nacc_rosmap_clump$SNP]

table_3_data <- merge(adni_replication_top, 
                      act_replication_top, 
                      by = c("CHR", "BP", "SNP", "A1"),
                      suffixes = c("_ADNI", "_ACT"))

table_3_data <- merge(nacc_rosmap_top, 
                      table_3_data,
                      by = c("CHR", "BP", "SNP", "A1"),
                      all.x = TRUE)
setorder(table_3_data, CHR, BP)
table_3_data[, Gene := c("BC041441", 
                         "FLJ30838",
                         "ZNF385D",
                         "PPARGC1A",
                         "FSTL5", 
                         "SPOCK3", 
                         "PDE4D", 
                         "N4BP3", 
                         "BCKDHB",
                         "SORCS3",
                         "WASF3")]
# table_3_data[SNP %in% top_snps, Gene := c("ELOVL4", "SORCS3")]
# table_3_data[is.na(Gene), Gene := "TBD"]

table_3_data[, adni_or_95ci := make_or_95_ci(OR_ADNI, L95_ADNI, U95_ADNI, OR)]
table_3_data[, act_or_95ci := make_or_95_ci(OR_ACT, L95_ACT, U95_ACT, OR)]
table_3_data[, nacc_rosmap_or_95ci := make_or_95_ci(OR, L95, U95, OR)]

table_3_data <- table_3_data[, .(SNP, CHR, BP, Gene, nacc_rosmap_or_95ci, P, adni_or_95ci, P_ADNI, act_or_95ci, P_ACT)]

table_3_data[, P := format(signif(P, 2), scipen=2)]
table_3_data[, P_ADNI := as.character(signif(P_ADNI, 2))]
table_3_data[, P_ACT := as.character(signif(P_ACT, 2))]
table_3_data[is.na(P_ADNI), 
             `:=`(P_ADNI = " - ",
                  P_ACT = " - ")]
