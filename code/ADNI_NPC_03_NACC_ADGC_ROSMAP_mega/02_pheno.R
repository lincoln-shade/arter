#======================================
# create .pheno and .covar files for
# ADNI/NACC/ROSMAP mega-analysis
#======================================

library(pacman)
p_load(data.table)

#---------------------
# load data
#---------------------

adni <- fread("raw_data/ADNI_NPC/ADNI_NPC_wCovariate.csv")
nacc.rosmap <- fread("NACC.ROSMAP.meta/01_data/data/pheno.txt")
pcs <- fread("data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.pca.eigenvec")


#---------
# Format 
#---------

## ADNI

# add FID variable
adni[, FID := "2"]

# change sex variable coding to match nacc.rosmap
# msex is 0 female 1 male
# NPSEX is 2 female 1 male
# interestingly, 39 male while only 8 female
adni[, msex := ifelse(NPSEX == 1, NPSEX, 0)]
adni[, NPSEX := NULL]

# make cohort indicator variables
adni[, adni := 1]
adni[, rosmap := 0]

# format arteriolosclerosis variable
adni[, NPARTER := NULL]
setnames(adni, "phenotype", "arteriol_scler")

# format age of death variable
adni[, age_death := as.numeric(NPDAGE)]
adni[, NPDAGE := NULL]

# add indicators for ADGC.ADC cohort (all 1 bc styled as 1 or 2)
for (i in 2:7) {
  adni[, paste0("ADGC.ADC", i) := as.integer(1)]
}


## NACC/ROSMAP


# format cohort variables
nacc.rosmap[, adni := 0]
setnames(nacc.rosmap, "cohort", "rosmap")

# remove old PC variables
for (i in 1:5) {
  nacc.rosmap[, paste0("PC", i) := NULL]
}

## PCs

setnames(pcs, 
         c("V1", "V2", "V3", "V4", "V5", "V6", "V7"), 
         c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

#---------
# combine
#---------

adni.nacc.rosmap <- rbindlist(list(adni, nacc.rosmap), use.names = T)
setcolorder(adni.nacc.rosmap, c("FID", "IID", "arteriol_scler"))

adni.nacc.rosmap <- merge(adni.nacc.rosmap, pcs, c("FID", "IID"))

#----------
# output
#----------

save(adni.nacc.rosmap, file = "data/ADNI_NPC/adni.nacc.rosmap.rds")

fwrite(adni.nacc.rosmap, file = "data/ADNI_NPC/adni.nacc.rosmap.pheno.txt", row.names = F, quote = F, sep = " ")
fwrite(adni.nacc.rosmap[, -"arteriol_scler"], file = "data/ADNI_NPC/adni.nacc.rosmap.covar.txt", row.names = F, quote = F, sep = " ")


