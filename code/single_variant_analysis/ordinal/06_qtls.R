#===============
# Explore QTLs
#===============

library(pacman)
p_load(data.table, magrittr, stringi)

qtl <- fread("02_analysis/ordinal/qtls.txt")
qtl<- qtl[grep("Artery|Brain|Cell|Blood", tissue)]
qtl<- qtl[pval_nominal < min_pval_nominal * 10]
top.indep.snps <- fread("02_analysis/logistic/indep.top.snps.txt", header = F) %>% 
  setnames(., "V1", "rsid") 
qtl.top.indep <- qtl[rsid %in% top.indep.snps$rsid]
table(qtl$variant_id)
table(qtl$tissue)
qtl.top.indep <- qtl[rsid %in% top.indep.snps$rsid]