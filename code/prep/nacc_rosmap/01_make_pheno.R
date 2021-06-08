#===========================================================
# make pheno and covar files for nacc and rosmap mega
#===========================================================

library(pacman)
p_load(data.table, magrittr)
nacc <- readRDS("data/nacc/nacc.Rds")
rosmap <- readRDS("data/rosmap/rosmap.Rds")

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

pca <- fread("data/nacc_rosmap/nacc_rosmap_pca.eigenvec")
setnames(pca, 
         c("V1", "V2", "V3", "V4", "V5", "V6", "V7"),
         c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

nacc_rosmap <- merge(nacc_rosmap, pca, c("FID", "IID"))

#-------------
# write files
#-------------
saveRDS(nacc_rosmap, file = "data/nacc_rosmap/nacc_rosmap.Rds")
nacc_rosmap[arteriol_scler %in% 1:3, arteriol_scler := arteriol_scler - 1]
saveRDS(nacc_rosmap, file = "data/nacc_rosmap/nacc_rosmap_ord.Rds")
nacc_rosmap[, arteriol_scler := ifelse(arteriol_scler == 0, 1, 2)]

write.table(nacc_rosmap, 
            file = "data/nacc_rosmap/nacc_rosmap_pheno.txt",
            quote = F, 
            row.names = F)
write.table(nacc_rosmap[, -"arteriol_scler"], 
            file = "data/nacc_rosmap/nacc_rosmap_covar.txt",
            quote = F, 
            row.names = F)

rm(list = ls())
p_unload(all)
