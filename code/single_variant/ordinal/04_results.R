##-----------------------------------------------
## merge ordinal and logistic regression results
##-----------------------------------------------

source("code/00_load_options_packages_functions.R")
cargs <- commandArgs(trailingOnly = TRUE)
logistic_results <- fread(cargs[1])
out_prefix <- cargs[2]
# include trailing "/"
directory <- "data/tmp/"
lists <- list.files(directory) %>% 
  .[grep("ordinal_results", .)]
list_set <- vector("list", length=length(lists))
for (i in 1:length(lists)) {
  list_set[[i]] <- fread(paste0(directory, lists[i]))
}

ordinal_results <- rbindlist(list_set)
setnames(ordinal_results, 
         c("snp", "slope", "std.er", "tval"), 
         c("SNP", "Beta.Ord", "SE.Ord", "STAT.Ord"))

# create columns for P value and OR for ordinal regression
ordinal_results[, P.Ord := pnorm(abs(STAT.Ord), lower.tail = F) * 2]
ordinal_results[, OR.Ord := round(exp(Beta.Ord), 2)]
setorder(ordinal_results, P.Ord)

# rename SNPs in ordinal regression to match those from logistic
ordinal_results[, SNP := stri_replace_last_regex(SNP, "_[:alpha:]*", "")]
ordinal_results[, SNP := stri_replace_last_fixed(SNP, ".", ":")]
ordinal_results[, SNP := stri_replace_last_fixed(SNP, ".", ":")]
ordinal_results[, SNP := stri_replace_first_fixed(SNP, "v", "")]

# merge ordinal and logistic
results <- merge(ordinal_results, logistic_results, "SNP")
setorder(results, P.Ord)
setnames(results, c("OR", "STAT", "P", "L95", "U95", "SE"), c("OR.Log", "STAT.Log", "P.Log", "L95.Log", "U95.Log", "SE.Log"))
setcolorder(results, c("CHR", "SNP", "BP", "A1", "OR.Ord", "SE.Ord", "P.Ord", "STAT.Ord", 
                       "OR.Log", "P.Log", "STAT.Log", "L95.Log", "U95.Log"))

# write.table
fwrite(results, file = paste0(out_prefix, "ordinal_results.txt"), quote = F, sep = " ")

