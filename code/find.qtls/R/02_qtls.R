##-----------------------------------
## Tidy up QTL files for input SNPs
##-----------------------------------
packages <- c("data.table", "stringi")
for (package in packages) {
  if (!require(package, character.only = T)) install.packages(package)
}

qtls <- fread(commandArgs(trailingOnly = T)[1], header = F)
setnames(qtls, colnames(qtls), 
         c("phenotype_id", "variant_id",	"tss_distance",	"maf",	"ma_samples",
           "ma_count",	"pval_nominal",	"slope",	"slope_se",	"pval_nominal_threshold",
           "min_pval_nominal", "pval_beta"))

# split the file:phenotype string into separate columns
genes.files <- matrix(unlist(stri_split_fixed(qtls$phenotype_id, ":", n=2)), ncol=2, byrow = T)
qtls[, filename := genes.files[, 1]]
qtls[, phenotype_id := genes.files[, 2]]

# create a variable for tissue type
qtls[, tissue := stri_replace_first_regex(
  filename, "/data_global/GTEx/GTEx_Analysis_v8_QTLs/GTEx_Analysis_v8_.QTL_Eur/.qtls/", "")]
qtls[, tissue := stri_replace_last_fixed(tissue, ".v8.EUR.signif_pairs.txt", "")]

# create variable for QTL type
qtls[grep("eQTL", filename), qtl.type := "eQTL"]
qtls[grep("sQTL", filename), qtl.type := "sQTL"]

# create gene variable
qtls[qtl.type == "eQTL", gene := phenotype_id]
qtls[qtl.type == "sQTL", gene := stri_replace_all_regex(phenotype_id, ".*ENSG", "ENSG")]

# merge with rsid.key
rsid.key <- fread(commandArgs(trailingOnly = T)[2])
qtls <- merge(qtls, rsid.key, "variant_id")
setcolorder(qtls, c("rsid", "variant_id", "phenotype_id", "gene", "tissue", "pval_nominal", "slope", "slope_se"))
setorder(qtls, rsid, tissue)

# write file
fwrite(qtls, file = "qtls.txt", sep = " ", row.names = F, col.names = T, quote = F)
