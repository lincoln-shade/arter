#===========================================
# Create Table 5: Gene-Set Analysis Results
#===========================================

source("code/load_packages.R")

magma <- fread("output/magma/act_mega.genes.out")
gene_labels <- fread("raw_data/magma/NCBI37.3.gene.loc", header = FALSE) %>% 
  .[, .(V1, V6)] %>% 
  setnames(colnames(.), c("GENE", "Gene"))

magma_genes <- merge(magma, gene_labels, "GENE") %>% 
  setorder(P)

table_s3_data <- magma_genes[P < 1e-3]
table_s3_data[, START := format(START, big.mark = ",")]
table_s3_data[, STOP := format(STOP, big.mark = ",")]
table_s3_data[, `Start-Stop` := paste0(START, " - ", STOP)]
table_s3_data[, P := format(P, scipen = 2, digits = 2)]

table_s3_data <- table_s3_data[, .(Gene, CHR, `Start-Stop`, P)]
