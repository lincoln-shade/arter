##------------------------------------
## make model dataset files for
## binary and ordinal B-ASC analyses
##------------------------------------

library(pacman)
p_load(data.table, magrittr, readxl)

rosmap <- readxl::read_xlsx("/data_global/ROSMAP/greg_20200109/dataset_843_basic_01-09-2020.xlsx", sheet = 1) %>% 
  as.data.table() %>% 
  setnames("projid", "IID") %>% 
  .[, .(IID, arteriol_scler, msex, age_death, study)] %>% 
  .[, study := ifelse(study == "ROS", 1, 0)]

# keep rosmap european ids and add first 5 PCs
rosmap_pcs <- fread("data/rosmap/rosmap_pca.eigenvec", header = F)
setnames(rosmap_pcs, 
         c("V1", "V2", "V3", "V4", "V5", "V6", "V7"), 
         c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))
rosmap_pcs[, IID := as.character(IID)]

rosmap <- merge(rosmap, rosmap_pcs, "IID")
setcolorder(rosmap, "FID")

##--------------------
## write pheno files
##--------------------
# ordinal
rosmap <- rosmap
saveRDS(rosmap, file = "data/rosmap/rosmap.Rds")

# logistic 
rosmap[, arteriol_scler := ifelse(arteriol_scler < 2, 1, 2)]
write.table(rosmap, file = "data/rosmap/rosmap_pheno.txt", row.names = F, col.names = T, quote = F)
write.table(rosmap[, -c("arteriol_scler")], file = "data/rosmap/rosmap_covar.txt", row.names = F, col.names = T, quote = F)

rm(list = ls())
p_unload(all)
