##-------------------------------
## locate top independent SNPs
##-------------------------------

library(pacman)
p_load(data.table, magrittr, knitr, kableExtra)

snps <- fread("02_analysis/ordinal/plink.clumped")
indep.top.snps <- snps$SNP
write.table(indep.top.snps, file = "02_analysis/ordinal/indep.top.snps.txt", quote = F, row.names = F, col.names = F)
