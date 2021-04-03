#==============================================
# create pheno files for mediation analysis 
#==============================================

source("code/00_load_options_packages_functions.R")

#----------------
# load datasets
#----------------
load.Rdata("data/nacc_adgc/nacc_adgc_unrelated.RData", "pheno")

uds <- 
  fread("/data_global/nacc/investigator_nacc52.csv", 
        header = T, na.strings = c(-4, "999", "9999", "888")
  )

uds <- 
  uds %>% 
  .[uds[, .I[which.max(NACCVNUM)], by=c("NACCID")]$V1, 
    c("NACCID", "DIABETES", "NACCDBMD", "DIABET", "HYPERTEN", "NACCAHTN", "HYPERT")
    ] %>% 
  setnames(., "NACCID", "IID") 

pheno <- merge(pheno, uds, by = "IID")

#------------------------------
# add diabetes indicator "dm"
#------------------------------
pheno_dm <- pheno[
  !is.na(DIABETES) |
    !is.na(NACCDBMD) |
    !is.na(DIABET)  
  ]

pheno_dm[
  DIABETES == 0 |
    NACCDBMD == 0 |
    DIABET == 0, 
  dm := 0
  ]

# be sure to place positive identifiers after negative to catch 
# people with condition that weren't caught under at least one of the identifiers
# (assuming people are less likely to report they have diabetes/HTN when they don't than
#  report they don't have diabetes when they do, we want to be more inclusive here)
pheno_dm[
  DIABETES %in% c(1, 2) |
    NACCDBMD == 1 |
    DIABET %in% c(1, 2, 3), 
  dm := 1
  ]

pheno_dm[, c("DIABETES", "NACCDBMD", "DIABET", "HYPERTEN", "NACCAHTN", "HYPERT") := c(NULL, NULL, NULL, NULL, NULL, NULL)]
pheno_dm <- pheno_dm[complete.cases(pheno_dm)]

pheno_dm[, table(dm, useNA = "a")]

#----------------------------------
# add hypertension indicator "htn"
#----------------------------------

pheno_htn <- pheno[
  !is.na(HYPERTEN) |
    !is.na(NACCAHTN) |
    !is.na(HYPERT)  
  ]

pheno_htn[
  HYPERTEN == 0 |
    NACCAHTN == 0 |
    HYPERT == 0, 
  htn := 0
  ]

pheno_htn[
  HYPERTEN %in% c(1, 2) |
    NACCAHTN == 1 |
    HYPERT == 1, 
  htn := 1
  ]

pheno_htn[, c("DIABETES", "NACCDBMD", "DIABET", "HYPERTEN", "NACCAHTN", "HYPERT") := c(NULL, NULL, NULL, NULL, NULL, NULL)]
pheno_htn <- pheno_htn[complete.cases(pheno_htn)]

pheno_htn[, table(htn, useNA = "a")]

#--------------------------------------
# write output pheno and covar files
#--------------------------------------

fwrite(pheno_dm, file = "data/nacc_adgc/nacc_adgc_unrelated_dm.txt", quote = FALSE, sep = " ")
fwrite(pheno_htn, file = "data/nacc_adgc/nacc_adgc_unrelated_htn.txt", quote = FALSE, sep = " ")

rm(list = ls())
p_unload(all)


