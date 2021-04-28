#===============================================
# check if top variants are associated with HS
#===============================================

source("code/00_load_options_packages_functions.R")
load_packages()

nacc <- fread("/data_global/nacc/investigator_nacc52.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>%
  # remove duplicate rows for participant be choosing row from last visit
  .[NACCVNUM == NACCAVST, c("NACCID", "NPHIPSCL")] %>%
  setnames(., "NACCID", "IID") %>%
  .[, NPHIPSCL := ifelse(NPHIPSCL == 8 | NPHIPSCL == 9, NA, NPHIPSCL)] %>% 
  na.omit(., c("NPHIPSCL"))

mds <- fread("/data_global/nacc/fardo09062019.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>% 
  .[, c("NACCID", "NPHIPSCL")] %>%
  setnames(., "NACCID", "IID") %>%
  .[, NPHIPSCL := ifelse(NPHIPSCL == 8 | NPHIPSCL == 9, NA, NPHIPSCL)] %>% 
  na.omit(., c("NPHIPSCL"))

nacc <- rbind(nacc, mds)

nacc[, table(NPHIPSCL)]
nacc[, NPHIPSCL := ifelse(NPHIPSCL == 0, 0, 1)]

pheno <- fread("data/nacc_adgc/nacc_adgc_unrelated_pheno.txt")

pheno <- merge(pheno, nacc, "IID")
pheno[, NACCARTE := NULL]
setcolorder(pheno, c("FID", "IID", "NPHIPSCL"))

nacc_hs <- pheno
save(nacc_hs, file = "data/nacc_adgc/nacc_hs.RData")

pheno[, NPHIPSCL := NPHIPSCL + 1]

fwrite(pheno, file = "data/nacc_adgc/nacc_adgc_hs_pheno.txt", sep = " ", quote = FALSE)
fwrite(pheno[, -"NPHIPSCL"], file = "data/nacc_adgc/nacc_adgc_hs_covar.txt", sep = " ", quote = FALSE)
