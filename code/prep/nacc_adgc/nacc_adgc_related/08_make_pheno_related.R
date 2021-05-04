#==============================================================
# perform PC-AiR and create model phenotype-covariate file for 
# related regression
#==============================================================

source("code/00_load_options_packages_functions.R")

#-----------
# PC-AiR
#-----------
# (mostly taken from here: https://www.bioconductor.org/packages/release/bioc/vignettes/GENESIS/inst/doc/pcair.html)
gdsfile <- "data/tmp/pcair.gds"
snps <- fread("data/nacc_adgc/nacc_adgc_related_pruned.bim")
snpgdsBED2GDS(bed.fn = "data/nacc_adgc/nacc_adgc_related_pruned.bed",
              bim.fn = "data/nacc_adgc/nacc_adgc_related_pruned.bim",
              fam.fn = "data/nacc_adgc/nacc_adgc_related_pruned.fam",
              out.gdsfn = gdsfile)

# # create list of uncorrelated SNPs
# 
# gds <- snpgdsOpen(gdsfile)
# snpset <- snpgdsLDpruning(gds, method="corr", slide.max.bp=10e6, 
#                           ld.threshold=sqrt(0.1), verbose = TRUE)
# pruned <- unlist(snpset, use.names=FALSE)
# snpgdsClose(gds)

# create kinship matric
KINGmat <- kingToMatrix("data/nacc_adgc/nacc_adgc_related.kin", estimator = "Kinship")

geno <- GWASTools::GdsGenotypeReader(filename = gdsfile)

mypcair <- pcair(geno, kinobj = KINGmat, divobj = KINGmat, snp.include = snps$V2)

pcs <- as.data.table(mypcair$vectors[, 1:5], keep.rownames = TRUE)
setnames(pcs, colnames(pcs), c("IID", "PC1", "PC2", "PC3", "PC4", "PC5"))

#---------------------------------
# create pheno analysis data set
#---------------------------------

# load UDS and MDS
uds <- fread("/data_global/nacc/investigator_nacc52.csv", header = T, na.strings = c(-4, "999", "9999", "888")) %>%
  .[NACCVNUM == NACCAVST]

mds <- fread("/data_global/nacc/fardo09062019.csv")

# variables to keep
vars <- c("NACCID", "NACCARTE", "NPSEX", "NACCDAGE")

# concatenate UDS and MDS
nacc <- rbind(uds[, ..vars], mds[, ..vars])
setnames(nacc, "NACCID", "IID")

nacc <- merge(nacc, pcs, "IID")
nacc <- nacc[complete.cases(nacc)]

##--------------------------------------------
## add indicator variables for ADGC cohorts 
##--------------------------------------------

# load ADGC covariate dataset
adgc_covar <- fread("/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.covar", header = T) %>% 
  .[which(grepl("ADC", cohort) == T), ] %>% 
  .[, c("IID", "cohort")]

nacc <- merge(nacc, adgc_covar, by = c("IID")) # merge data

adgc_adc <- table(nacc$cohort, useNA = "a")
adgc_adc #check to see no NA
adgc_adc <- adgc_adc[-length(adgc_adc)] # remove NA index
adgc_adc <- adgc_adc[-(which(adgc_adc == max(adgc_adc)))] # remove the largest adgc_adc group so that is is the "control" group without an indicator

adgc_adc.names <- names(adgc_adc)

for (i in 1:length(adgc_adc.names)) {
  cohort.num <- paste0("adgc_", adgc_adc.names[i])
  nacc[, paste(cohort.num) := ifelse(cohort == adgc_adc.names[i], 1, 0)]
  if (adgc_adc[i] != table(nacc[, ..cohort.num])[2]) {print(paste0(
    "error: cohort ", adgc_adc.names[i], ": ", adgc_adc[i], "; ", cohort.num, ": ", table(nacc[, ..cohort.num])[2]
  ))}
}

nacc <- nacc[, -"cohort"]

##--------------------
## write pheno files
##--------------------
# ordinal
nacc_adgc_related <- nacc
save(nacc_adgc_related, file = "data/nacc_adgc/nacc_adgc_related.RData")

rm(list = ls())
p_unload(all)

