#===================================================
# append alleles  to SNP rsIDs in ADNI_NPC_N60
#===================================================

library(pacman)
p_load(data.table, magrittr, stringi)

StripAlleles <- function(x) {
  stri_replace_last_regex(x, ":[:alpha:]*:[:alpha:]*", "")
}

bim <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.bim")
bim[, V2 := StripAlleles(V2)]

fwrite(bim, file = "ADGC_HRC_strip_alleles.bim", quote = F, sep = " ", col.names = F)
