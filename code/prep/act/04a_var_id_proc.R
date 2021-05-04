#===================================================================
# create list of ACT variants in the NACC/ROSMAP/ADNI mega-analysis
# and substitute new hg19 BP positions for variants
# and rsIDs for chr:bp:A1:A2 variant names
#===================================================================

source("code/00_load_options_packages_functions.R")
groundhog.library("stringi", day)
act_hg19_vars <- fread("data/tmp/act_qc3_hg19_var.tmp.bim")
setnames(act_hg19_vars, "V3", "bp_hg38")
out_bed <- fread("data/tmp/act_hg19.bed")
setnames(out_bed, "V3", "bp_hg19")

act_hg19_vars <- merge(act_hg19_vars, out_bed[, .(V4, bp_hg19)], by.x = "V2", by.y = "V4")
setorder(act_hg19_vars, V1, bp_hg38)
out_bim <- act_hg19_vars[, .(V1, V2, V3, bp_hg19, V5, V6)]
out_bim[, V1 := as.integer(stri_replace_all_fixed(V1, "chr", ""))]

mega_vars <- fread("data/adni_npc/nacc_adgc_rosmap_adni_unrelated.bim")
act_mega_vars <- merge(out_bim, mega_vars, by.x = c("V1", "bp_hg19"), by.y = c("V1", "V4"), suffixes = c("act", "mega"))

out_rsID_bim <- act_mega_vars[, .(V1, V2mega, V3act, bp_hg19, V5act, V6act)]
out_mega_vars <- act_mega_vars[, .(V2act)]

fwrite(out_mega_vars, file = "data/tmp/act_mega_var_ids.txt", col.names = FALSE, quote = FALSE, sep = " ")
fwrite(out_rsID_bim, file = "data/tmp/act_qc3_mega_vars_rsid.tmp.bim", col.names = FALSE, quote = FALSE, sep = " ")

rm(list = ls())
