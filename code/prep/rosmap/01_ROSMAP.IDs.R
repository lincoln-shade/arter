library(pacman)
p_load(data.table, magrittr)


rosmap <- as.data.table(readxl::read_xlsx("/data_global/ROSMAP/greg_20200109/dataset_843_basic_01-09-2020.xlsx", sheet = 1))
rosmap <- rosmap[!(is.na(age_death))]
setnames(rosmap, "projid", "IID")

fam <- fread("/data_global/ROSMAP/rare_imputed_resilience/ROSMAP_rare_imputed_final.fam")
setnames(fam, c("V1", "V2"), c("FID", "IID"))
fam[, IID := as.character(IID)]
fam <- fam[, .(FID, IID)]

rosmap.fam <- merge(rosmap, fam, "IID")
rosmap.fam <- rosmap.fam[
  !is.na(arteriol_scler) & age_death >= 80,
  .(FID, IID, arteriol_scler, msex, age_death)
  ]

#write.table(rosmap.fam[, .(FID, IID)], "01_data/king/KING_IDs.txt", row.names = F, quote = F, col.names = F)
write.table(rosmap.fam[, .(FID, IID)], "01_data/data/ROSMAP.IDs.txt", row.names = F, quote = F, col.names = F)
#write.table(rosmap.fam[, -c("arteriol_scler")], "01_data/covar.txt", row.names = F, quote = F)
#save(rosmap.fam, file = "01_data/rosmap.fam.RData")

rm(list = ls())
p_unload(all)
