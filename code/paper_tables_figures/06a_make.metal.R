#====================================================================
# Convert .assoc.logistic file format to Metal format for locuszoom
#====================================================================

library(pacman)
p_load(data.table, stringi)
source("StripAlleles.R")

# cargs[1] = path to .assoc.logistic file
# cargs[2] = path to .clumped file
cargs <- commandArgs(trailingOnly = T)

# write metal.tmp variant file
results <- fread(cargs[1])
results[, SNP := StripAlleles(SNP)]
fwrite(results[, .(SNP, P)], file = "metal.tmp", col.names = T, row.names = F, quote = F, sep = " ")

clumped <- fread(cargs[2])
clumped[, SNP := StripAlleles(SNP)]
fwrite(clumped[1], file = "clumped.tmp", col.names = T, row.names = F, quote = F, sep = " ")

rm(list = ls())
p_unload(all)
