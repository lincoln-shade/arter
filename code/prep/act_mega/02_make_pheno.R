#===========================================================
# create pheno files for nacc+rosmap+adni+act mega-analysis
#==========================================================

source("code/00_load_options_packages_functions.R")

load("data/adni/nacc_rosmap_adni.RData")
adni_mega <- nacc_adgc_rosmap_adni_unrelated

act <- readRDS("data/act/act.RData")

pca <- fread("data/act/act_mega_pca.eigenvec")

setnames(act, 
         c("micro_arteriolosclerosis_id", "gender", "autopsyage"),
         c("arteriol_scler", "msex", "age_death"))

# from https://www.maelstrom-research.org/variable/act_recruitment:gender:Collected
# gender coded as 2 female, 1 male in ACT
act[msex == 2, msex := 0]

act[, `:=`(
  act = 1,
  adni = 0,
  study = 0,
  rosmap = 0,
  adgc_ADC2 = 0,
  adgc_ADC3 = 0,
  adgc_ADC4 = 0,
  adgc_ADC5 = 0,
  adgc_ADC6 = 0,
  adgc_ADC7 = 0,
  PC1 = NULL,
  PC2 = NULL,
  PC3 = NULL,
  PC4 = NULL,
  PC5 = NULL
)]

adni_mega[, `:=`(
  act = 0,
  PC1 = NULL,
  PC2 = NULL,
  PC3 = NULL,
  PC4 = NULL,
  PC5 = NULL
)]

setnames(pca,
         c("V1", "V2", "V3", "V4", "V5", "V6", "V7"),
         c("FID", "IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

act_mega <- rbindlist(list(adni_mega, act), use.names = TRUE)

act_mega <- merge(act_mega, pca, c("FID", "IID"))

saveRDS(act_mega, 
     file = "data/act/act_mega.Rds")

act_mega[, arteriol_scler := ifelse(arteriol_scler < 2, 1, 2)]

write.table(act_mega, 
            file = "data/act/act_mega.pheno",
            quote = F,
            row.names = F)

write.table(act_mega[, -"arteriol_scler"], 
            file = "data/act/act_mega.covar",
            quote = F,
            row.names = F)
