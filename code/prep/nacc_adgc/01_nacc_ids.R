##--------------------------------------------------------------
## Create list if NACC IDs aged 80+ and meet includion criteria
##--------------------------------------------------------------

library(pacman)
p_load(data.table, magrittr, dplyr)

# set age minimum to 80 years at death
age.min <- 0

adgc <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.fam", header = F) %>% 
  .[, 1:2] %>% 
  setnames(., colnames(.), c("FID", "IID")) %>% 
  .[which(grepl("NACC", IID) == T), ]

Exclusion.Criteria <- function(nacc.dt) {
  nacc.dt %>% 
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
  .[NACCDAGE >= age.min]

nacc.adgc <- merge(nacc, adgc, by = "IID")

# MDS file
mds <- fread("/data_global/nacc/fardo09062019.csv") %>% 
  Exclusion.Criteria() %>% 
  .[, c("NACCID", "NACCARTE", "NACCDAGE", "NPSEX")] %>%
  setnames(., "NACCID", "IID") %>% 
  # remove those with missing NACCARTE
  .[, NACCARTE := ifelse(NACCARTE == 8 | NACCARTE == 9, NA, NACCARTE)] %>%
  .[!is.na(NACCARTE)] %>% 
  # remove those who died younger than minimum age of death
  .[NACCDAGE >= age.min]

mds.adgc <- merge(mds, adgc, by = "IID")

# make merged dataset
mds.nacc.adgc <- merge(mds.adgc, nacc.adgc, by = colnames(nacc.adgc), all = T) 

np.adgc <- mds.nacc.adgc
sum(duplicated(np.adgc$IID))
##---------------
## write table
##---------------

write.table(np.adgc[, .(FID, IID)], file = "data/tmp/nacc_ids.tmp.txt", row.names = F, col.names = F, quote = F)

rm(list = ls())
p_unload(all)
