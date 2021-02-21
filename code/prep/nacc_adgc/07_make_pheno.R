##------------------------------------
## make model dataset files for
## binary and ordinal B-ASC analyses
##------------------------------------

library(pacman)
p_load(data.table, magrittr)

# load UDS and MDS
uds <- fread("/data_global/nacc/investigator_nacc52.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>%
  .[NACCVNUM == NACCAVST]

mds <- fread("/data_global/nacc/fardo09062019.csv")

# variables to keep
vars <- c("NACCID", "NACCARTE", "NPSEX", "NACCDAGE")

# concatenate UDS and MDS
nacc <- rbind(uds[, ..vars], mds[, ..vars])
setnames(nacc, "NACCID", "IID")

# keep nacc european ids and add first 5 PCs
nacc.pcs <- fread("data/nacc_adgc/nacc_adgc_unrelated_pca.eigenvec", header = F)
setnames(nacc.pcs, c("V1", "V2", "V3", "V4", "V5", "V6", "V7"), c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

nacc <- merge(nacc, nacc.pcs, "IID")
setcolorder(nacc, "FID")
nacc <- nacc[complete.cases(nacc)]

##--------------------------------------------
## add indicator variables for ADGC cohorts 
##--------------------------------------------

# load ADGC covariate dataset
adgc.covar <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.covar", header = T) %>% 
  .[, c("FID", "IID", "cohort")] %>% 
  .[which(grepl("ADC", cohort) == T), ]

nacc <- merge(nacc, adgc.covar, by = c("FID", "IID")) # merge data

adgc.adc <- table(nacc$cohort, useNA = "a")
adgc.adc #check to see no NA
adgc.adc <- adgc.adc[-length(adgc.adc)] # remove NA index
adgc.adc <- adgc.adc[-(which(adgc.adc == max(adgc.adc)))] # remove the largest adgc.adc group so that is is the "control" group without an indicator

adgc.adc.names <- names(adgc.adc)

for (i in 1:length(adgc.adc.names)) {
  cohort.num <- paste0("adgc_", adgc.adc.names[i])
  nacc[, paste(cohort.num) := ifelse(cohort == adgc.adc.names[i], 1, 0)]
  if (adgc.adc[i] != table(nacc[, ..cohort.num])[2]) {print(paste0(
    "error: cohort ", adgc.adc.names[i], ": ", adgc.adc[i], "; ", cohort.num, ": ", table(nacc[, ..cohort.num])[2]
  ))}
}

nacc <- nacc[, -"cohort"]

##--------------------
## write pheno files
##--------------------
# ordinal
nacc_adgc_unrelated <- nacc
save(nacc_adgc_unrelated, file = "data/nacc_adgc/nacc_adgc_unrelated.RData")

# logistic 
nacc[, NACCARTE := ifelse(NACCARTE < 2, 1, 2)]
write.table(nacc, file = "data/nacc_adgc/nacc_adgc_unrelated_pheno.txt", row.names = F, col.names = T, quote = F)
write.table(nacc[, -c("NACCARTE")], file = "data/nacc_adgc/nacc_adgc_unrelated_covar.txt", row.names = F, col.names = T, quote = F)

rm(list = ls())
p_unload(all)
