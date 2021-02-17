library(GENESIS)
library(SNPRelate)
library(GWASTools)

snpgdsBED2GDS(bed.fn = "01_data/plink/adgc.related.filtered.bed",
              bim.fn = "01_data/plink/adgc.related.filtered.bim",
              fam.fn = "01_data/plink/adgc.related.filtered.fam",
              out.gdsfn = "01_data/pcair/pcair.gds")

# create list of uncorrelated SNPs
gdsfile <- "01_data/pcair/pcair.gds"
gds <- snpgdsOpen(gdsfile)
snpset <- snpgdsLDpruning(gds, method="corr", slide.max.bp=10e6, 
                          ld.threshold=sqrt(0.1), verbose=FALSE)
pruned <- unlist(snpset, use.names=FALSE)
snpgdsClose(gds)

# create kinship matric
KINGmat <- kingToMatrix("01_data/king/king.kin")

geno <- GWASTools::GdsGenotypeReader(filename = gdsfile)

mypcair <- pcair(geno, kinobj = KINGmat, divobj = KINGmat, snp.include = pruned)

save(mypcair, file = "01_data/pcair/mypcair.RData")
