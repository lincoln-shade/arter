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
  act_results <- fread("raw_data/brainartbin.assoc.logistic.txt")
}

top_snps <- c("rs2603462", "rs7902929")

adni_replication_top <- adni_replication_top[SNP %in% top_snps]
act_replication_top <- act_results[SNP %in% top_snps]

adni_act_replication_top <- merge(adni_replication_top, act_replication_top, by = c("CHR", "BP", "SNP", "A1"),
                                  suffixes = c("_ADNI", "_ACT"))

adni_act_replication_top <- merge(adni_act_replication_top, 
                                  adni_mega_results[SNP %in% top_snps, .(SNP, OR, L95, U95, P)],
                                  by="SNP")
setnames(adni_act_replication_top, 
         c("SNP", "OR", "L95", "U95", "P"), 
         c("SNP_ADNI_m", "OR_ADNI_m", "L95_ADNI_m", "U95_ADNI_m", "P_ADNI_m"))

adni_act_replication_top <- merge(adni_act_replication_top,
                                  act_meta_results[SNP %in% top_snps, .(SNP, OR, L95, U95, P)],
                                  by="SNP")
