#=========================================
# compare all top NACC/ROSMAP SNPs with
# results from ADNI mega
#=========================================

library(pacman)
p_load(data.table)

nr <- fread("NACC.ROSMAP.meta/02_analysis/logistic/mega.assoc.logistic")
nra <- fread("output/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.mega.assoc.logistic")
nra <- nra[!(is.na(P))]
setorder(nr, P)
setorder(nra, P)

head(nr, 100)
head(nra, 100)
