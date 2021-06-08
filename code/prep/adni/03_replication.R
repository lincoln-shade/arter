#======================================
# replicate Kwangsik Nho's analysis
# testing top SNPs from NACC/ROSMAP
# mega-analysis: rs2603462 & rs7902929
#======================================

library(pacman)
p_load(data.table)

#---------------------
# load and prep data
#---------------------

adni <- fread("raw_data/ADNI_NPC/ADNI_NPC_wCovariate.csv")
adni[, phenotype := phenotype - 1]
snps <- fread("data/ADNI_NPC/ADNI_NPC_N47_top.raw")
pcs <- fread("data/ADNI_NPC/ADNI_NPC_pca.eigenvec")

adni.snps <- merge(adni, snps, "IID")
adni.snps.pcs <- merge(adni.snps, pcs, by.x=c("FID", "IID"), by.y = c("V1", "V2"))
setnames(adni.snps.pcs, c("V3", "V4", "V5", "V6", "V7"), c("PC1", "PC2", "PC3", "PC4", "PC5"))

#---------------------
# regressions no PCs
#---------------------

rs2603462 <- adni.snps[,
                       glm(phenotype ~ rs2603462_C + NPSEX + NPDAGE,
                           family = "binomial")]
summary(rs2603462)

rs7902929 <- adni.snps[,
                       glm(phenotype ~ rs7902929_C + NPSEX + NPDAGE,
                           family = "binomial")]
summary(rs7902929)

rs61944465 <- adni.snps[,
                        glm(phenotype ~ rs61944465_A + NPSEX + NPDAGE,
                            family = "binomial")]
summary(rs61944465)

#-----------------------
# regressions with PCs
#-----------------------

rs2603462 <- adni.snps.pcs[,
                       glm(phenotype ~ rs2603462_C + NPSEX + NPDAGE + PC1 + PC2 + PC3 + PC4 + PC5,
                           family = "binomial")]
summary(rs2603462)

rs7902929 <- adni.snps.pcs[,
                       glm(phenotype ~ rs7902929_C + NPSEX + NPDAGE + PC1 + PC2 + PC3 + PC4 + PC5,
                           family = "binomial")]
summary(rs7902929)

rs61944465 <- adni.snps.pcs[,
                        glm(phenotype ~ rs61944465_A + NPSEX + NPDAGE + PC1 + PC2 + PC3 + PC4 + PC5,
                            family = "binomial")]
summary(rs61944465)

#---------------
# save results 
#---------------

save(rs2603462, rs7902929, rs61944465, file = "output/ADNI_NPC/replication.results.rds")
