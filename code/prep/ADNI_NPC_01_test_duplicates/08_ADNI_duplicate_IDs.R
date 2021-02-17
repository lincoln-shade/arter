#===============================================
# list of ADNI_NPC_N60 IDs that are duplicates 
#===============================================

library(pacman)
p_load(data.table)

dups <- fread("ADNI_NPC/test_duplicate_ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.pruned.genome")
dups <- dups[FID1 == "2" | FID2 == "2"] # all ADNI FIDs are in col FID1
dups <- melt(dups, measure.vars = )