##--------------------------------------------------------------
## Create list if NACC IDs that meet includion criteria
##--------------------------------------------------------------

source("code/00_load_options_packages_functions.R")

# set age minimum to 80 years at death
min_age <- 0

adgc <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.fam", header = F) %>% 
  .[, 1:2] %>% 
  setnames(., colnames(.), c("FID", "IID")) %>% 
  .[which(grepl("NACC", IID) == T), ]

Exclusion.Criteria <- function(nacc_dt) {
  nacc_dt %>% 
  filter(is.na(NACCDOWN) | NACCDOWN != 1) %>%
    filter(is.na(NPPDXA) | NPPDXA != 1) %>% filter(is.na(NPPDXB) | NPPDXB != 1) %>%
    filter(is.na(NPPDXD) | NPPDXD != 1) %>% filter(is.na(NPPDXE) | NPPDXE != 1) %>%
    filter(is.na(NPPDXF) | NPPDXF != 1) %>% filter(is.na(NPPDXG) | NPPDXG != 1) %>%
    filter(is.na(NPPDXH) | NPPDXH != 1) %>% filter(is.na(NPPDXI) | NPPDXI != 1) %>%
    filter(is.na(NPPDXJ) | NPPDXJ != 1) %>% filter(is.na(NPPDXK) | NPPDXK != 1) %>% 
    filter(is.na(NPPDXL) | NPPDXL != 1) %>% filter(is.na(NPPDXM) | NPPDXM != 1) %>% 
    filter(is.na(NPPDXN) | NPPDXN != 1) %>% filter(is.na(NACCPRIO) | NACCPRIO != 1) %>% 
    filter(is.na(NPPATH10) | NPPATH10 != 1) %>% filter(is.na(NPALSMND) | NPALSMND != 1) %>% 
    filter(is.na(NPFTDTAU) | NPFTDTAU != 1) %>% filter(is.na(NPOFTD) | NPOFTD != 1) %>% 
    filter(is.na(NPFTDTDP) | NPFTDTDP != 1) %>% 
    as.data.table()
}

# UDS file
nacc <- fread("/data_global/nacc/investigator_nacc52.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>%
  Exclusion.Criteria() %>% 
  # remove duplicate rows for participant be choosing row from last visit
  .[NACCVNUM == NACCAVST, c("NACCID", "NACCARTE", "NACCDAGE", "NPSEX")] %>%
  setnames(., "NACCID", "IID") %>%
  # remove those with missing NACCARTE
  .[, NACCARTE := ifelse(NACCARTE == 8 | NACCARTE == 9, NA, NACCARTE)] %>% 
  na.omit(., c("NACCARTE")) %>% 
  # remove those who died younger than minimum age of death
  .[NACCDAGE >= min_age]

nacc_adgc <- merge(nacc, adgc, by = "IID")

# MDS file
mds <- fread("/data_global/nacc/fardo09062019.csv") %>% 
  Exclusion.Criteria() %>% 
  .[, c("NACCID", "NACCARTE", "NACCDAGE", "NPSEX")] %>%
  setnames(., "NACCID", "IID") %>% 
  # remove those with missing NACCARTE
  .[, NACCARTE := ifelse(NACCARTE == 8 | NACCARTE == 9, NA, NACCARTE)] %>%
  .[!is.na(NACCARTE)] %>% 
  # remove those who died younger than minimum age of death
  .[NACCDAGE >= min_age]

mds_adgc <- merge(mds, adgc, by = "IID")

# make merged dataset
mds_nacc_adgc <- merge(mds_adgc, nacc_adgc, by = colnames(nacc_adgc), all = T) 

np_adgc <- mds_nacc_adgc
sum(duplicated(np_adgc$IID))
##---------------
## write table
##---------------

write.table(np_adgc[, .(FID, IID)], file = "data/tmp/nacc_ids.tmp.txt", row.names = F, col.names = F, quote = F)
write.table(np_adgc[, .(FID, IID)], file = "data/nacc_adgc/nacc_ids_pass_exclusion.txt", row.names = F, col.names = F, quote = F)


rm(list = ls())
p_unload(all)
