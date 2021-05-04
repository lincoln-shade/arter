#===============================================
# Create list of related individuals to remove
#===============================================

source("code/00_load_options_packages_functions.R")
groundhog.library("stringi", day)
related <- fread("data/tmp/nacc_adgc_qc2_related.tmp.genome")
related[, pair := 1:.N]
related <- related[, .(IID1, IID2, pair, PI_HAT)]
related.long <- melt.data.table(related, measure.vars = c("IID1", "IID2"), value.name = "IID")

# 10 IDs in multiple pairs on most recent run 2021-02-15
dup.iids <- related.long$IID[duplicated(related.long$IID)]
setorder(related.long, pair, variable)

#-------------------------------------------------------
# examining individuals related to more than one person
#-------------------------------------------------------

# don't need to worry about 3+ person clusters as removing person with highest 
# missingness in each pair still leaves just one person in each cluster
# (because as long as name is flagged at least once, PLINK will remove)

# 3 sets of 2 pairs that have one shared person in both pairs.
# - 1 PO and one 2nd-degree pair
# - 1 PO and one 2nd-degree pair
# - 2 2nd-degree pairs
# In the interest of maximizing sample size, 
# I will preferentially remove the individuals present
# in 2 pairs (i.e. NACC903503, NACC697927, NACC696497).
related.one.dup <- related[(IID1 %in% dup.iids & !(IID2 %in% dup.iids)) |
                           (!(IID1 %in% dup.iids) & IID2 %in% dup.iids)
                           ]
related.one.dup.dups <- intersect(dup.iids, c(related.one.dup$IID1, related.one.dup$IID2))

#-------------------------------------------------------------
# add missingness and demographics info for visual inspection
#-------------------------------------------------------------

missingness <- fread("data/tmp/nacc_adgc_qc2_related_miss.tmp.imiss")

uds <- fread("/data_global/nacc/investigator_nacc49.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>% 
  .[NACCVNUM == NACCAVST] %>% 
  setnames(., "NACCID", "IID") %>% 
  merge(related.long, ., "IID") %>% 
  .[, .(IID, pair, PI_HAT, NPSEX, BIRTHMO, BIRTHYR, HISPANIC, RACE)]

mds <- fread("/data_global/nacc/fardo09062019.csv", na.strings = c(-4, "999", "9999", "888")) %>%
  setnames(., "NACCID", "IID") %>% 
  merge(related.long, ., "IID") %>% 
  .[, .(IID, pair, PI_HAT, NPSEX, MDSBIRTHMO, MDSBIRTHYR, MDSHISPANIC, MDSRACE)] 

colnames(mds) <- stri_replace_all_fixed(colnames(mds), "MDS", "")

# examine demographics of pairs
nacc <- rbindlist(list(uds, mds)) %>% 
  merge(., missingness, "IID") %>% 
  # set order by pair and missingness
  setorder(., pair, F_MISS) %>% 
  .[, FID := "ADC"] %>% 
  setcolorder(., c("FID", "IID"))

# check for duplicates
# each pair has people with different birth years, so genotyping sample mixup
# remove both individuals
nacc.mz <- nacc[PI_HAT > 0.9]

# uncomplicated pairs
nacc.simple.pairs <- nacc[!(pair %in% related.one.dup$pair | pair %in% nacc.mz$pair)]

#-------------------------------
# create list of IDs to remove
#-------------------------------

# individual in each pair with higher missingness is in even row
nacc.related.remove.simple <- ifelse(nrow(nacc.simple.pairs) > 0, nacc.simple.pairs[seq(2, .N, 2), IID], NA)
nacc.related.remove <- c(nacc.related.remove.simple,
                         nacc.mz$IID,
                         related.one.dup.dups
                         ) 
nacc.related.remove <- nacc.related.remove[!(is.na(nacc.related.remove))]
sum(duplicated(nacc.related.remove))

nacc.related.rm <- data.table(FID="ADC", IID=nacc.related.remove)
write.table(nacc.related.rm, file = "data/tmp/nacc_adgc_related_remove.tmp.txt", quote = F, row.names = F, col.names = F)

rm(list = ls())
p_unload(all)
