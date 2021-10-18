library(synapser) 
library(synapserutils) 
library(data.table)

synLogin() 
files <- synapserutils::syncFromSynapse('syn25998806') 
ath_results <- fread(files[[1]]$path)
elovl4_ath <- ath_results[CHR == 6][SNP == "rs2603462"]
sorcs3_ath <- ath_results[CHR == 10][SNP == "rs7902929"]

ath_snps <- rbind(elovl4_ath, sorcs3_ath)

saveRDS(ath_snps, file = "output/ath_snps.Rds")
