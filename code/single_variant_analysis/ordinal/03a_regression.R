##-------------------------
## ordinal regression
##-------------------------

source("code/00_load_options_packages_functions.R")

cargs <- commandArgs(trailingOnly = TRUE)

#.raw file from regression.sh output with variant minor allele values for each participant
raw <- fread(cargs[1], header = T) 
model_data <- load.Rdata(cargs[2], "model_data")
phenotype <- cargs[3]
# file with other model_data for each participant

# merge to create model matrix file
ord_data <- merge(model_data, raw, by = c("FID", "IID"))
n_cols <- ncol(ord_data)

# skip number of columns in model_data and the first 4 non-merge-by columns in raw to get to genetic variant columns
skip_cols <- ncol(model_data) + 4 
  
# replace colons with periods in SNP names, as colons in variable names messes up polr regression
sub_colons <- function(x) { 
  x <- gsub(":", ".", x)
}

# add the character "v" in the front of all variant names that do not start with "rs"
# (variant names that start with numbers mess up the regression for some reason)

for (i in which(colnames(ord_data) %in% 
                colnames(ord_data)[-grep("rs", colnames(ord_data))][-c(1:skip_cols)])) {
  colnames(ord_data)[i] <- paste0("v", colnames(ord_data)[i])
}
  
colnames(ord_data) <- sub_colons(colnames(ord_data))
  
# response in ordered logistic regression must be a factor
ord_data[[phenotype]] <- as.ordered(ord_data$NACCARTE) 

# initialize output vectors
tval <- numeric(length = (n_cols - skip_cols))
slope <- numeric(length = (n_cols - skip_cols))
snp <- character(length = (n_cols - skip_cols))
std.er <- numeric(length = (n_cols - skip_cols))  
# ordinal regression loop
for (i in (skip_cols + 1):n_cols) {
  f = as.formula(paste("NACCARTE ~", colnames(ord_data)[i],
                       " + NPSEX + NACCDAGE + PC1 + PC2 + PC3 + PC4 + PC5 + ",
                       "ADGC.ADC2 + ADGC.ADC3 + ADGC.ADC4 + ADGC.ADC5 + ADGC.ADC6 + ADGC.ADC7", sep = ""))
  m <- polr(f, data = ord_data, Hess = T)
  s <- as.data.frame(summary(m)["coefficients"])
  snp[(i - skip_cols)] <- colnames(ord_data)[i]
  tval[(i - skip_cols)] <- s[colnames(ord_data)[i], "coefficients.t.value"] #t-value of variant
  slope[(i - skip_cols)] <- s[colnames(ord_data)[i], "coefficients.Value"] #slope of variant
  std.er[(i - skip_cols)] <- s[colnames(ord_data)[i], "coefficients.Std..Error"]
}

# write outputs to file
snp.results <- data.table(snp, slope, std.er, tval)
fwrite(snp.results, file = paste0("02_analysis/ordinal/vals/", snp.results[1, snp], ".txt"), 
       row.names = F, col.names = T, quote = F)
