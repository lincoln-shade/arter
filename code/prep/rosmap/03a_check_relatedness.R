#===============================================
# Create list of related individuals to remove
#===============================================

library(pacman)
p_load(data.table, magrittr, stringi, readxl)

related <- fread("data/tmp/rosmap_2_related.tmp.genome")
related[, `:=`(IID1 = as.character(IID1),
               IID2 = as.character(IID2))]
related[, pair := 1:.N]
related <- related[, .(IID1, IID2, pair, PI_HAT)]
related.long <- melt.data.table(related, measure.vars = c("IID1", "IID2"), value.name = "IID")
# no ids in multiple pairs
dup.iids <- related.long$IID[duplicated(related.long$IID)]
setorder(related.long, pair, variable)

#-------------------------------------------------------
# examining individuals related to more than one person
#-------------------------------------------------------

# don't need to worry about 3+ person clusters as removing person with highest 
# missingness in each pair still leaves just one person in each cluster
# (because as long as name is flagged at least once, PLINK will remove)

# 0 sets of 2+ pairs that have one shared person in both pairs.
related.one.dup <- related[(IID1 %in% dup.iids & !(IID2 %in% dup.iids)) |
                           (!(IID1 %in% dup.iids) & IID2 %in% dup.iids)
                           ]
related.one.dup.dups <- intersect(dup.iids, c(related.one.dup$IID1, related.one.dup$IID2))

#-------------------------------------------------------------
# add missingness and demographics info for visual inspection
#-------------------------------------------------------------

missingness <- fread("data/tmp/rosmap_2_related_miss.tmp.imiss")
missingness[, IID := as.character(IID)]

rosmap <- read_xlsx("/data_global/ROSMAP/greg_20200109/dataset_843_basic_01-09-2020.xlsx",
                    sheet = 1) %>% 
  as.data.table %>% 
  setnames("projid", "IID") %>% 
  merge(related.long, "IID") %>% 
  merge(missingness, "IID") %>% 
  setorder(., pair, F_MISS) %>% 
  setcolorder(., c("FID", "IID", "PI_HAT"))

  

# check for duplicates
# each pair has different sex and birth years
# remove both individuals
rosmap.mz <- rosmap[PI_HAT > 0.9]

# uncomplicated pairs
rosmap.simple.pairs <- rosmap[!(pair %in% related.one.dup$pair | pair %in% rosmap.mz$pair)]

#-------------------------------
# create list of IDs to remove
#-------------------------------

# individuals all have no missingness, so just remove randomly in given order
rosmap.related.remove.simple <- rosmap.simple.pairs[seq(2, .N, 2), IID]
rosmap.related.remove <- c(rosmap.related.remove.simple,
                         rosmap.mz$IID,
                         related.one.dup.dups
                         )
sum(duplicated(rosmap.related.remove))

rosmap.related.rm <- data.table(FID="0", IID=rosmap.related.remove)
write.table(rosmap.related.rm, file = "data/tmp/rosmap_related_remove.tmp.txt", quote = F, row.names = F, col.names = F)

rm(list = ls())
p_unload(all)
