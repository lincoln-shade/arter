##------------------------------------
## make model dataset files for
## binary and ordinal B-ASC analyses
##------------------------------------

source("code/00_load_options_packages_functions.R")
groundhog.library("readxl", day)

act <- as.data.table(read_xlsx("/data_global/ACT/DataForE235_20210421.xlsx", sheet = 2))
act_clinical <- as.data.table(read_xlsx("/data_global/ACT/DataForE235_20210421.xlsx", sheet = 1))

# variables to keep
act_vars <- c("IDfromDave", "micro_arteriolosclerosis_id", "autopsyage")
act_clinical_vars <- c("IDfromDave", "gender")

# concatenate UDS and MDS
act <- act[, ..act_vars]
act_clinical <- act_clinical[, ..act_clinical_vars]
act <- merge(act, act_clinical, "IDfromDave")
setnames(act, "IDfromDave", "IID")

# keep act european ids and add first 5 PCs
act_pcs <- fread("data/act/act_pca.eigenvec", header = F)
setnames(act_pcs, c("V1", "V2", "V3", "V4", "V5", "V6", "V7"), c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

act <- merge(act, act_pcs, "IID")
setcolorder(act, "FID")
act <- act[complete.cases(act)]

##--------------------
## write pheno files
##--------------------
# ordinal
save(act, file = "data/act/act.RData")

# logistic 
act[, micro_arteriolosclerosis_id := ifelse(micro_arteriolosclerosis_id < 2, 1, 2)]
write.table(act, file = "data/act/act_pheno.txt", row.names = F, col.names = T, quote = F)
write.table(act[, -c("micro_arteriolosclerosis_id")], file = "data/act/act_covar.txt", row.names = F, col.names = T, quote = F)

rm(list = ls())