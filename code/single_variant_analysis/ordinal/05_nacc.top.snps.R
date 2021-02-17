##------------------------------------
## list of independent SNPs reaching 
## significance threshold (1e-5)
## will eventually do using PLINK but
## will do manually for now
##------------------------------------

library(pacman)
p_load(data.table)

threshold <- 1e-5

results <- fread("02_analysis/ordinal/nacc.results.csv")

results.sig <- results[P.Ord < threshold]
setorder(results.sig, CHR, BP)

write.table(results.sig$SNP, "02_analysis/ordinal/top.snps.txt", row.names = F, col.names = F, quote = F)
