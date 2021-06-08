#==============================================================
# logistic GLMM using related nacc/adgc data set for top snps
#==============================================================

source("code/00_load_options_packages_functions.R")
#---------------
# prep data
#---------------

# load pheno data
load.Rdata("data/nacc_adgc/nacc_adgc_related.RData", "pheno")
pheno[, NACCARTE := ifelse(NACCARTE < 2, 0, 1)]
setnames(pheno, "IID", "scanID")
pheno_scan <- ScanAnnotationDataFrame(pheno)

# convert king ibs file into a matrix
grm <- GENESIS::kingToMatrix("data/nacc_adgc/nacc_adgc_related.kin", estimator = "Kinship")

# snps
gds <- "data/nacc_adgc/top.gds"
geno <- snpgdsBED2GDS(bed.fn = "data/nacc_adgc/nacc_adgc_related_top.bed", 
              bim.fn = "data/nacc_adgc/nacc_adgc_related_top.bim", 
              fam.fn = "data/nacc_adgc/nacc_adgc_related_top.fam", 
              out.gdsfn = gds)
geno_reader <- GdsGenotypeReader(gds)
geno_data <- GenotypeData(geno_reader)


#---------
# model
#---------

# null model
null_model <- fitNullModel(pheno_scan, 
                           outcome = "NACCARTE", 
                           covars = colnames(pheno[, 3:ncol(pheno)]),
                           cov.mat = grm,
                           family = binomial)

geno_iterator <- GenotypeBlockIterator(geno_data)
results <- assocTestSingle(geno_iterator, null.model = null_model)
nacc_adgc_related_top_results <- results

fwrite(nacc_adgc_related_top_results, file="output/nacc_adgc/nacc_adgc_related_top_results.txt", sep = " ", col.names = TRUE, quote = FALSE)

rm(list = ls())
p_unload(all)
