library(qusage)
library(stringi)
library(data.table)
x <- read.gmt("Human_GOBP_AllPathways_with_GO_iea_February_05_2021_entrezgene.gmt")
names(x) <- stri_replace_all_fixed(names(x), " ", "_")
genes <- unlist(x)

gene_sets <- as.data.table(genes, keep.rownames = TRUE)

fwrite(gene_sets, file = "gene_sets.txt", quote = F, row.names = F, col.names = F, sep = " ")
