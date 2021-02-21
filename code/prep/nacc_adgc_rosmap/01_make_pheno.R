#===========================================================
# make pheno and covar files for nacc/adgc and rosmap mega
#===========================================================

source("code/00_load_packages.R")

load("data/nacc_adgc/nacc_adgc_unrelated.RData")
load("data/rosmap/rosmap_unrelated.RData")
nacc <- nacc_adgc_unrelated
rosmap <- rosmap_unrelated
rm(nacc_adgc_unrelated, rosmap_unrelated)

#----------------------------------------
# change nacc variables to match rosmap
#----------------------------------------
setnames(nacc, 
         c("NACCARTE", "NPSEX", "NACCDAGE"),
         c("arteriol_scler", "msex", "age_death"))

# female sex is coded as 2 in nacc but 0 in rosmap
nacc[msex == 2, msex := 0]
nacc[, study := 0]
nacc[, rosmap := 0]

#---------------------------------------
# change rosmap variables to match nacc
#---------------------------------------
rosmap[, IID := as.character(IID)]
rosmap[, rosmap := 1]

# add adgc cohort indicators
for (i in 2:7) {
  cohort.num <- paste0("adgc_ADC", i)
  rosmap[, paste(cohort.num) := 0]
}

nacc_rosmap <- rbindlist(list(nacc, rosmap), use.names = TRUE)
#--------------------------
# add principal components
#--------------------------
for (i in 1:5) {
  nacc_rosmap[, paste0("PC", i) := NULL]
}

pca <- fread("data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated_pca.eigenvec")
setnames(pca, 
         c("V1", "V2", "V3", "V4", "V5", "V6", "V7"),
         c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

nacc_rosmap <- merge(nacc_rosmap, pca, c("FID", "IID"))

#-------------
# write files
#-------------

nacc_adgc_rosmap_unrelated <- nacc_rosmap
save(nacc_adgc_rosmap_unrelated, file = "data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.RData")

nacc_rosmap[, arteriol_scler := ifelse(arteriol_scler < 2, 1, 2)]

write.table(nacc_rosmap, 
            file = "data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.pheno.txt",
            quote = F, 
            row.names = F)
write.table(nacc_rosmap[, -"arteriol_scler"], 
            file = "data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.covar.txt",
            quote = F, 
            row.names = F)

rm(list = ls())
p_unload(all)
