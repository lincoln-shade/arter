#==================================================
# Retrieve relevant information for QC flowcharts
#==================================================

library(pacman)
p_load(data.table, magrittr, dplyr)

adgc <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.fam", header = F) %>% 
  .[, 1:2] %>% 
  setnames(., colnames(.), c("FID", "IID")) %>% 
  .[which(grepl("NACC", IID) == T), ]

vals.keep <- c("NACCID", "NACCARTE", "NACCDAGE", "NPSEX", "NACCDOWN", "NPPDXA", "NPPDXB", 
               "NPPDXD", "NPPDXE", "NPPDXF", "NPPDXG", "NPPDXH", "NPPDXJ", "NPPDXL", "NPPDXN", "NPPATH10", 
               "NPFTDTAU", "NPFTDTDP", "NPPDXI", "NPPDXK", "NPPDXM", "NACCPRIO", "NPALSMND", "NPOFTD")

uds <- fread("/data_global/nacc/investigator_nacc49.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>% 
  # remove duplicate rows for participant be choosing row from last visit
  .[NACCVNUM == NACCAVST, ..vals.keep]

# MDS file
mds <- fread("/data_global/nacc/fardo09062019.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>% 
  .[, ..vals.keep] 

# NACC neuropath
np <- rbindlist(list(uds, mds)) %>% 
  .[!is.na(NACCDAGE)]

# NACC NP and ADGC intersection
setnames(np, "NACCID", "IID")
np.adgc <- merge(np, adgc, "IID")

# # keep those aged 80+ at death
# age.min <- 80
# np.adgc <- np.adgc[NACCDAGE >= age.min]

# keep those with B-ASC grading
np.adgc[NACCARTE %in% c(8, 9), NACCARTE := NA]
np.adgc.basc <- np.adgc[!(is.na(NACCARTE))]

# keep those without NP exclusion criteria
Exclusion.Criteria <- function(dt) {
  dt %>% 
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
np.adgc.basc.noNP <- Exclusion.Criteria(np.adgc.basc)

# keep those that pass genotyping QC and only 1 relative in each related cluster
np.adgc.basc.noNP.pass.qc <- fread("../ADGC.HRC/65+/01_data/qc.files/nacc.pass.basic.qc.fam")

# keep those who are european
np.adgc.basc.noNP.pass.qc.eur <- fread("../ADGC.HRC/65+/01_data/data/pheno.txt")

n.np <- np[, .N]
n.adgc <- adgc[, .N]
n.np.adgc <- np.adgc[, .N]
# n.np.adgc <- np.adgc[, .N]
# n.drop.np.adgc <- np.adgc[NACCDAGE < age.min, .N]
n.np.adgc.basc <- np.adgc.basc[, .N]
n.drop.np.adgc.basc <- np.adgc[is.na(NACCARTE), .N]
n.np.adgc.basc.noNP <- np.adgc.basc.noNP[, .N]
n.drop.np.adgc.basc.noNP <- n.np.adgc.basc - n.np.adgc.basc.noNP
n.np.adgc.basc.noNP.pass.qc <- np.adgc.basc.noNP.pass.qc[, .N]
n.drop.np.adgc.basc.noNP.pass.qc <-n.np.adgc.basc.noNP - n.np.adgc.basc.noNP.pass.qc
n.np.adgc.basc.noNP.pass.qc.eur <- np.adgc.basc.noNP.pass.qc.eur[, .N]
n.drop.np.adgc.basc.noNP.pass.qc.eur <- n.np.adgc.basc.noNP.pass.qc - n.np.adgc.basc.noNP.pass.qc.eur

rm(list = ls()[!(grepl("n[.]", ls()))])
