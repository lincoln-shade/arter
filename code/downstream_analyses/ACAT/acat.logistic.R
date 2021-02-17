##---------------------------------------------
## Performing ACAT analysis on UCSD genome
## browser genes using
## p-values from logistic analysis
##---------------------------------------------

library(pacman)
p_load(data.table, ACAT, magrittr)

##-------------------------------
## data tables
##-------------------------------

## logistic regression results
reg.results <- fread("02_analysis/logistic/regression.assoc.logistic")

## table of gene names, chromosome, and start and end transciption sites from chromosome 3
## made  using https://genome.ucsc.edu/cgi-bin/hgTables
genes <- fread("/data_global/UCSC_genome_browser/genes/genes.chr1-22.txt")

##---------------------------
## gene-based ACAT analysis
##---------------------------

## flanking region for genes (subtract from start of gene and add to end of gene positions)
flank <- 1e5

CalcACAT <- function(chr, start, end, flank) {
  ACAT(
    reg.results[CHR == chr & 
                  BP > (start - flank) &
                  BP < (end + flank) & 
                  P != 1, 
                P]
  )
}

ACAT.P <- rep(NA, nrow(genes))
for (i in 1:nrow(genes)) {
  ACAT.P[i] <- CalcACAT(genes$Chromosome[i], 
                        genes$Start[i], 
                        genes$End[i], 
                        flank)
  if (i %% 100 == 0) {print(i)}
}

genes$ACAT.P <- ACAT.P
setorder(genes, ACAT.P)

write.table(genes, file = "02_analysis/ACAT/acat.results.logistic.txt", row.names = F, col.names = T, quote = T)


