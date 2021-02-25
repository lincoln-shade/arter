#==================================
# remove alleles from SNP names
#==================================

library(pacman)
p_load(data.table, stringi)

StripAlleles <- function(dt, v) {
  dt[, paste0(v) := stri_replace_last_regex(get(v), ":[:alpha:]*:[:alpha:]*", "")]
  dt[]
}

sumstats <- fread(commandArgs(trailingOnly = T)[1])
variant.col <- commandArgs(trailingOnly = T)[2]

sumstats <- StripAlleles(sumstats, variant.col)

fwrite(sumstats, file = "sumstats.tmp", quote = F, row.names = F, col.names = T)