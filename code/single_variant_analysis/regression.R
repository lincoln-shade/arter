library(pacman)
p_load(data.table, magrittr, SNPRelate, GMMAT, GENESIS)

# load pheno data
load("01_data/pheno.RData")
pheno[, FID := NULL]
pheno[, NACCARTE := ifelse(NACCARTE < 2, 0, 1)]

# convert king ibs file into a matrix
ibs <- GENESIS::kingToMatrix("01_data/king/ibs.seg", sample.include = pheno$IID)

# snps
bim <- fread("01_data/plink/adgc.related.filtered.bim", header = F)
snps <- bim$V2

# model
model1 <- GMMAT::glmm.wald(
  fixed = NACCARTE ~ NACCDAGE + NPSEX + PC1 + PC2,
  data = pheno,
  id = "IID", 
  family = binomial(link = "logit"), 
  infile = "01_data/plink/adgc.related.filtered", # plink fileset prefix
  snps = snps
)

save(model1, file="02_analysis/results.test.RData")

