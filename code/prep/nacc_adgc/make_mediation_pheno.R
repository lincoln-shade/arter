########################################################
# create pheno and covar files for mediation analysis ##
########################################################

library(pacman)
p_load(data.table, magrittr)

############################
# load datasets
############################
main <- fread("../data/pheno.txt")

uds <- 
  fread("/data_global/nacc/investigator_nacc45.csv", 
        header = T, na.strings = c(-4, "999", "9999", "888")
  )

uds <- 
  uds %>% 
  .[uds[, .I[which.max(NACCVNUM)], by=c("NACCID")]$V1, 
    c("NACCID", "DIABETES", "NACCDBMD", "DIABET", "HYPERTEN", "NACCAHTN", "HYPERT")
    ] %>% 
  setnames(., "NACCID", "IID") 

pheno <- merge(main, uds, by = "IID")

rm(main, uds)
###############################
# add diabetes indicator "dm"
###############################
pheno <- pheno[
  !is.na(DIABETES) |
    !is.na(NACCDBMD) |
    !is.na(DIABET)  
  ]

pheno[
  DIABETES == 0 |
    NACCDBMD == 0 |
    DIABET == 0, 
  dm := 0
  ]

# be sure to place positive identifiers after negative to catch 
# people with condition that weren't caught under at least one of the identifiers
# (assuming people are less likely to report they have diabetes/HTN when they don't than
#  report they don't have diabetes when they do, we want to be more inclusive here)
pheno[
  DIABETES %in% c(1, 2) |
    NACCDBMD == 1 |
    DIABET %in% c(1, 2, 3), 
  dm := 1
  ]

pheno[, c("DIABETES", "NACCDBMD", "DIABET") := c(NULL, NULL, NULL)]

pheno[, table(dm, useNA = "a")]

###############################
# add hypertension indicator "htn"
###############################

pheno <- pheno[
  !is.na(HYPERTEN) |
    !is.na(NACCAHTN) |
    !is.na(HYPERT)  
  ]

pheno[
  HYPERTEN == 0 |
    NACCAHTN == 0 |
    HYPERT == 0, 
  htn := 0
  ]

pheno[
  HYPERTEN %in% c(1, 2) |
    NACCAHTN == 1 |
    HYPERT == 1, 
  htn := 1
  ]

pheno[, c("HYPERTEN", "NACCAHTN", "HYPERT") := c(NULL, NULL, NULL)]

pheno <- pheno[!is.na(htn) & !is.na(dm)]

# effect modification was checked and none really noticed, 
# so no interaction term between dm and htn used

########################################
## write output pheno and covar files ##
########################################

# multivariate analysis with both htn and dm (not part of simple mediation analysis)
setcolorder(pheno, c("FID", "IID", "NACCARTE"))
# pheno
write.table(pheno, "01_data/pheno.txt", row.names = F, quote = F)
# covar
write.table(pheno[, -"NACCARTE"], "01_data/covar.txt", row.names = F, quote = F)

# Step 1 in mediation analysis: regression BASC on genotype (neither htn nor dm as covariates)
write.table(pheno[, -c("htn", "dm")], "01_data/mediation.s1.pheno.txt", row.names = F, quote = F)
write.table(pheno[, -c("NACCARTE", "htn", "dm")], "01_data/mediation.s1.covar.txt", row.names = F, quote = F)

# Step 2 in mediation analysis: regress mediatior on genotype (htn and dm one at a time)

# Step 2 htn
pheno[, htn := htn + 1] # binary dependent variable in PLINK needs to be coded 1/2 instead of 0/1
setcolorder(pheno, c("FID", "IID", "htn"))
write.table(pheno[, -c("NACCARTE", "dm")], "01_data/mediation.s2.htn.pheno.txt", row.names = F, quote = F)
#note: covar is same as in step one, just making new one to keep filesets for each step. Will reuse this for dm.
write.table(pheno[, -c("NACCARTE", "htn", "dm")], "01_data/mediation.s2.covar.txt", row.names = F, quote = F)

# Step 2 dm
pheno[, dm := dm + 1] # binary dependent variable in PLINK needs to be coded 1/2 instead of 0/1
setcolorder(pheno, c("FID", "IID", "dm"))
write.table(pheno[, -c("NACCARTE", "htn")], "01_data/mediation.s2.dm.pheno.txt", row.names = F, quote = F)

# Step 3 in mediation analysis: regress dependent variable on genotype and mediator

# Step 3 htn
pheno[, htn:= htn - 1] # used as covariate so subtract 1 just cause I prefer 0/1 when possible
setcolorder(pheno, c("FID", "IID", "NACCARTE"))
write.table(pheno[, -c("dm")], "01_data/mediation.s3.htn.pheno.txt", row.names = F, quote = F)
write.table(pheno[, -c("NACCARTE", "dm")], "01_data/mediation.s3.htn.covar.txt", row.names = F, quote = F)

# Step 3 dm
pheno[, dm := dm - 1]
write.table(pheno[, -c("htn")], "01_data/mediation.s3.dm.pheno.txt", row.names = F, quote = F)
write.table(pheno[, -c("NACCARTE", "htn")], "01_data/mediation.s3.dm.covar.txt", row.names = F, quote = F)

rm(pheno)
p_unload(all)





