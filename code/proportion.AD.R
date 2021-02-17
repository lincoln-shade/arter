library(pacman)
p_load(data.table, magrittr, dplyr)
load("01_data/data/nacc.ordinal.RData")

adgc <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.fam", header = F) %>% 
  .[which(grepl("NACC", V2) == T), ] %>% 
  setnames(c("V1", "V2"), c("FID", "IID"))

nacc.adgc <- merge(nacc.ordinal, adgc, by=c("FID", "IID"))
nacc.adgc[, table(V6, useNA = "a")]

nacc <- fread("/data_global/nacc/investigator_nacc49.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>%
  # remove duplicate rows for participant be choosing row from last visit
  .[NACCVNUM == NACCAVST] %>% 
  setnames(., "NACCID", "IID") %>%
  # remove those with missing NACCARTE
  .[, NACCARTE := ifelse(NACCARTE == 8 | NACCARTE == 9, NA, NACCARTE)] %>% 
  na.omit(., c("NACCARTE"))

nacc.uds <- merge(nacc.ordinal[, .(FID, IID)], nacc, "IID")

mds <- fread("/data_global/nacc/fardo09062019.csv") %>% 
  setnames(., "NACCID", "IID") %>% 
  # remove those with missing NACCARTE
  .[, NACCARTE := ifelse(NACCARTE == 8 | NACCARTE == 9, NA, NACCARTE)] %>%
  .[!is.na(NACCARTE)] 

nacc.mds <- merge(nacc.ordinal[, .(FID, IID)], mds, "IID")

# check no duplicates
nacc.ids <- rbindlist(list(nacc.uds[, .(IID)], nacc.mds[, .(IID)]))
sum(duplicated(nacc.ids$IID))

# check AD cases UDS
# 1425 / 1680 have AD or some form of dementia
nacc.uds[, table(NACCALZD, useNA = "a")]

# check AD cases MDS
# 1576 / 1638 had some form of dementia
nacc.mds[, table(CLDEMDX, useNA = "a")]
nacc.mds[, table(CLINDEM, useNA = "a")]

# total proportion with dementia or AD
(1425 + 1576)/3318
