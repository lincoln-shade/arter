#===============================================
# Create list of related individuals to remove
#===============================================

library(pacman)
p_load(data.table, magrittr, stringi, readxl)

related <- fread("data/tmp/rosmap_nacc_merged_related.tmp.genome")
related[, `:=`(IID1 = as.character(IID1),
               IID2 = as.character(IID2))]
related[, pair := 1:.N]
related <- related[, .(IID1, IID2, pair, PI_HAT)]
related.long <- melt.data.table(related, measure.vars = c("IID1", "IID2"), value.name = "IID")
# no ids in multiple pairs
dup.iids <- related.long$IID[duplicated(related.long$IID)]
setorder(related.long, pair, variable)

# just remove all non-NACC ids
nacc_id_rows <- grep("NACC", related.long$IID)
rosmap_ids <- related.long[!nacc_id_rows, IID]
rosmap_ids <- data.table(FID = "0", 
                         IID = rosmap_ids)

write.table(rosmap_ids, file = "data/tmp/rosmap_nacc_related_remove.tmp.txt", 
            quote = FALSE, row.names = FALSE, col.names = FALSE)

rm(list = ls())
p_unload(all)
