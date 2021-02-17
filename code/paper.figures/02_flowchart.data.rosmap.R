#==================================================
# Retrieve relevant information for QC flowcharts
#==================================================

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

rosmap.fam <- rosmap.fam[age_death >= 80]
rosmap.fam <- rosmap.fam[arteriol_scler %in% c(0:3)]

rosmap.qc <- fread("../ROSMAP/01_data/king/rosmap.pass.basic.qc.fam")
