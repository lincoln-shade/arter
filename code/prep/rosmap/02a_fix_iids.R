##-----------------------------------------------------------------------
## fix IIDs in rosmap.tmp.fam file to match those in the neuropath files
##-----------------------------------------------------------------------

library(pacman)
p_load(data.table, stringi)

##-------------
## .fam IIDs
##-------------
# I renamed the original .fam and .bim files by addind "_original" to the end of the file prefix
fam <- fread("data/tmp/rosmap.tmp.fam")
setnames(fam, "V2", "IID")

# 1. remove "_" and duplicate IID number following it (ie 1111_1111 -> 1111)
# 2. if the IID is < 8 digits long, fill the front of the IID with 0's until it is
# (ie 1111 -> 00001111)
fam[, IID := stri_replace_last_regex(IID, "_[:digit:]*", "")]
fillers <- 8-nchar(fam$IID)
for (i in 1:nrow(fam)) {
  fam$IID[i] <- paste(paste(integer(fillers[i]), collapse = ""), 
                      fam$IID[i], 
                      collapse = "", sep = "")
}

# write .fam file with changed IIDs
write.table(fam, file = "data/tmp/rosmap_fixed_iids.tmp.fam", 
            row.names = F, col.names = F, quote = F)

rm(list = ls())
p_unload(all)
