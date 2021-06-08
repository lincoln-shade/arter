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
nacc_pcs <- fread("data/nacc/nacc_pca.eigenvec", header = F)
setnames(nacc_pcs, c("V1", "V2", "V3", "V4", "V5", "V6", "V7"), c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

nacc <- merge(nacc, nacc_pcs, "IID")
setcolorder(nacc, "FID")
nacc <- nacc[complete.cases(nacc)]

##--------------------------------------------
## add indicator variables for ADGC cohorts 
##--------------------------------------------

# load ADGC covariate dataset
adgc_covar <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.covar", header = T) %>% 
  .[, c("FID", "IID", "cohort")] %>% 
  .[which(grepl("ADC", cohort) == T), ]

nacc <- merge(nacc, adgc_covar, by = c("FID", "IID")) # merge data

adgc_adc <- table(nacc$cohort, useNA = "a")
# adgc_adc #check to see no NA
adgc_adc <- adgc_adc[-length(adgc_adc)] # remove NA index
adgc_adc <- adgc_adc[-(which(adgc_adc == max(adgc_adc)))] # remove the largest adgc_adc group so that is is the "control" group without an indicator

adgc_adc.names <- names(adgc_adc)

for (i in 1:length(adgc_adc.names)) {
  cohort.num <- paste0("adgc_", adgc_adc.names[i])
  nacc[, paste(cohort.num) := ifelse(cohort == adgc_adc.names[i], 1, 0)]
  if (adgc_adc[i] != table(nacc[, ..cohort.num])[2]) {print(paste0(
    "error: cohort ", adgc_adc.names[i], ": ", adgc_adc[i], "; ", cohort.num, ": ", table(nacc[, ..cohort.num])[2]
  ))}
}

nacc <- nacc[, -"cohort"]

##--------------------
## write pheno files
##--------------------
# ordinal 4 levels
saveRDS(nacc, file = "data/nacc/nacc.Rds")

# ordinal 3 levels (combine none and mild) 
# levels labeled as 0, 1, 2
nacc[NACCARTE %in% 1:3, NACCARTE := NACCARTE - 1]
saveRDS(nacc, file = "data/nacc/nacc_ord.Rds")

# logistic for PLINK
nacc[, NACCARTE := ifelse(NACCARTE == 0, 1, 2)]
write.table(nacc, file = "data/nacc/nacc_pheno.txt", row.names = F, col.names = T, quote = F)
write.table(nacc[, -c("NACCARTE")], file = "data/nacc/nacc_covar.txt", row.names = F, col.names = T, quote = F)

# rm(list = ls())
# p_unload(all)
