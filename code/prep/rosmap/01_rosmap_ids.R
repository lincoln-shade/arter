#===========================================
# create list of rosmap ids with b-asc data
#===========================================


library(pacman)
p_load(data.table, magrittr)


rosmap <- as.data.table(readxl::read_xlsx("/data_global/ROSMAP/greg_20200109/dataset_843_basic_01-09-2020.xlsx", sheet = 1))
rosmap <- rosmap[!(is.na(age_death))]
setnames(rosmap, "projid", "IID")

fam <- fread("/data_global/ROSMAP/rare_imputed_resilience/converted/ROSMAP_rare_imputed_final_converted.fam")
setnames(fam, c("V1", "V2"), c("FID", "IID"))
fam[, IID := as.character(IID)]
fam <- fam[, .(FID, IID)]

rosmap.fam <- merge(rosmap, fam, "IID")
rosmap.fam <- rosmap.fam[
  !is.na(arteriol_scler),
  .(FID, IID, arteriol_scler, msex, age_death)
  ]

write.table(rosmap.fam[, .(FID, IID)], "data/tmp/rosmap_ids.tmp.txt", row.names = F, quote = F, col.names = F)
write.table(rosmap.fam, "data/rosmap/rosmap_ids_np.txt", row.names = F, quote = F, col.names = F)

