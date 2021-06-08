##-------------------------
## ordinal regression
##-------------------------
library(pacman)
p_load(data.table, magrittr, MASS, stringi)

#-----------------------------------------------
# command-line arguments
cargs <- commandArgs(trailingOnly = TRUE)
# cargs[1]  = snp list index number
# cargs[2] = path to Rds w phenotype and covars
# cargs[3] = phenotype name
#-----------------------------------------------


#.raw file from regression.sh output with variant minor allele values for each participant
raw <-fread(paste0("data/tmp/ordinal_snp_list_", cargs[1], ".raw"), header = T) 
model_data <- readRDS(cargs[2])
phenotype <- cargs[3]

# make sure FID and IID are character vectors for merging
model_data[, `:=`(FID = as.character(FID), IID = as.character(IID))]
raw[, `:=`(FID = as.character(FID), IID = as.character(IID))]
set(raw, j = c("PAT", "MAT", "SEX", "PHENOTYPE"), value = list(NULL, NULL, NULL, NULL))

# merge to create model matrix file
ord_data <- merge(model_data, raw, by = c("FID", "IID"))
ord_data[[phenotype]] <- as.ordered(ord_data[[phenotype]]) 

# skip number of columns in model_data get to genetic variant columns
n_cols <- ncol(ord_data)
skip_cols <- ncol(model_data) 
  
# replace colons with periods in SNP names, as colons in variable names messes up polr regression
sub_colons <- function(x) { 
  x <- gsub(":", ".", x)
}

# add the character "v" in the front of all variant names that do not start with "rs"
# (variant names that start with numbers mess up the regression)

for (i in which(colnames(ord_data) %in% 
                colnames(ord_data)[-grep("rs", colnames(ord_data))][-c(1:skip_cols)])) {
  colnames(ord_data)[i] <- paste0("v", colnames(ord_data)[i])
}
  
colnames(ord_data) <- sub_colons(colnames(ord_data))

# initialize output table
results <- data.table(
  snp = character(length = (n_cols - skip_cols)),
  slope = numeric(length = (n_cols - skip_cols)),
  std.er = numeric(length = (n_cols - skip_cols)),  
  tval = numeric(length = (n_cols - skip_cols))  
)

# ordinal regression loop
system.time(for (i in (skip_cols + 1):n_cols) {
  f <- as.formula(paste0(phenotype, " ~ ", colnames(ord_data)[i],
                         " + ", paste(colnames(model_data)[4:ncol(model_data)], collapse = " + ")))
  m <- polr(f, data = ord_data, Hess = T)
  s <- as.data.frame(summary(m)["coefficients"])
  set(
    results,
    i     = i - skip_cols,
    j     = c("snp", "slope", "std.er", "tval"),
    value = list(
      snp = colnames(ord_data)[i],
      slope = round(s[colnames(ord_data)[i], "coefficients.Value"], 4),
      std.er = round(s[colnames(ord_data)[i], "coefficients.Std..Error"], 4),
      tval   = round(s[colnames(ord_data)[i], "coefficients.t.value"], 4)
    )
  )
})

# write outputs to file
fwrite(results, file = paste0("data/tmp/ordinal_results_snp_list_", cargs[1], ".txt"), 
       quote = F, sep = " ")
