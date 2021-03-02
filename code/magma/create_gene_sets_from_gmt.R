#=================================================
# create gene set file in column format for magma
#=================================================

source("code/00_load_options_packages_functions.R")
gene_sets <- read.gmt("raw_data/magma/Human_GOBP_AllPathways_with_GO_iea_February_05_2021_entrezgene.gmt")
gene_sets <- gene_sets[lengths(gene_sets) > 19]
names(gene_sets) <- stri_replace_all_fixed(names(gene_sets), " ", "_")
gene <- unlist(gene_sets, use.names = F)

set_id <- character(length(gene))
row_n <- 0
for (i in 1:length(gene_sets)) {
  set_id[(row_n + 1):(row_n + length(gene_sets[[i]]))] <- names(gene_sets)[i]
  row_n <- row_n + length(gene_sets[[i]])
}

gene_set_col <- data.table(set_id, gene)
length(unique(gene_set_col$set_id)) == length(unique(names(gene_sets)))

genes <- fread("raw_data/magma/NCBI37.3.gene.loc")
genes[, gene_id := as.character(V1)]
gene_set_col <- gene_set_col[gene %in% genes$gene_id]
fwrite(gene_set_col, file = "data/magma/gene_set_col.txt", col.names = F, sep = " ")
