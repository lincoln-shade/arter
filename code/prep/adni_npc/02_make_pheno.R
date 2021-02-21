
source("code/00_load_packages.R")

load("data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.RData")
nacc_rosmap <- nacc_adgc_rosmap_unrelated
rm(nacc_adgc_rosmap_unrelated)

adni <- fread("raw_data/ADNI_NPC/ADNI_NPC_wCovariate.csv")

pca <- fread("data/adni_npc/nacc_adgc_rosmap_adni_unrelated_pca.eigenvec")

setnames(adni, 
         c("NPARTER", "NPSEX", "NPDAGE"),
         c("arteriol_scler", "msex", "age_death"))

#female sex coded as 2 in adni but 0 in nacc rosmap
adni[msex == 2, msex := 0]

adni[, `:=`(
  FID = "2",
  adni = 1,
  study = 0,
  rosmap = 0,
  adgc_ADC2 = 0,
  adgc_ADC3 = 0,
  adgc_ADC4 = 0,
  adgc_ADC5 = 0,
  adgc_ADC6 = 0,
  adgc_ADC7 = 0,
  phenotype = NULL
)]

nacc_rosmap[, `:=`(
  adni = 0,
  PC1 = NULL,
  PC2 = NULL,
  PC3 = NULL,
  PC4 = NULL,
  PC5 = NULL
)]

setnames(pca,
         c("V1", "V2", "V3", "V4", "V5", "V6", "V7"),
         c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

nacc_rosmap_adni <- rbindlist(list(nacc_rosmap, adni), use.names = TRUE)

nacc_rosmap_adni <- merge(nacc_rosmap_adni, pca, c("FID", "IID"))

nacc_adgc_rosmap_adni_unrelated <- nacc_rosmap_adni
save(nacc_adgc_rosmap_adni_unrelated, 
     file = "data/adni_npc/nacc_adgc_rosmap_adni_unrelated.RData")

nacc_rosmap_adni[, arteriol_scler := ifelse(arteriol_scler < 2, 1, 2)]

write.table(nacc_rosmap_adni, 
            file = "data/adni_npc/nacc_adgc_rosmap_adni_unrelated.pheno",
            quote = F,
            row.names = F)

write.table(nacc_rosmap_adni[, -"arteriol_scler"], 
            file = "data/adni_npc/nacc_adgc_rosmap_adni_unrelated.covar",
            quote = F,
            row.names = F)
