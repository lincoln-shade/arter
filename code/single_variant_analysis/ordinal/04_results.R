##-----------------------------------------------
## merge ordinal and logistic regression results
##-----------------------------------------------

library(pacman)
p_load(data.table, magrittr, stringi)

directory <- "02_analysis/ordinal/vals/"
lists <- list.files(directory)
list.set <- vector("list", length=length(lists))
for (i in 1:length(lists)) {
  list.set[[i]] <- fread(paste0(directory, lists[i]))
}

ordinal.results <- rbindlist(list.set)
setnames(ordinal.results, 
         c("snp", "slope", "std.er", "tval"), 
         c("SNP", "Beta.Ord", "SE.Ord", "STAT.Ord"))

# create columns for P value and OR for ordinal regression
ordinal.results[, P.Ord := pnorm(abs(STAT.Ord), lower.tail = F) * 2]
ordinal.results[, OR.Ord := round(exp(Beta.Ord), 2)]
setorder(ordinal.results, P.Ord)

# rename SNPs in ordinal regression to match those from logistic
ordinal.results[, SNP := stri_replace_last_regex(SNP, "_[:alpha:]*", "")]
ordinal.results[, SNP := stri_replace_last_fixed(SNP, ".", ":")]
ordinal.results[, SNP := stri_replace_last_fixed(SNP, ".", ":")]
ordinal.results[, SNP := stri_replace_first_fixed(SNP, "v", "")]

# merge ordinal and logistic
logistic.results <- fread("02_analysis/logistic/regression.assoc.logistic")
results <- merge(ordinal.results, logistic.results, "SNP")
setorder(results, P.Ord)
setnames(results, c("OR", "STAT", "P", "L95", "U95", "SE"), c("OR.Log", "STAT.Log", "P.Log", "L95.Log", "U95.Log", "SE.Log"))
setcolorder(results, c("CHR", "SNP", "BP", "A1", "OR.Ord", "SE.Ord", "P.Ord", "STAT.Ord", 
                       "OR.Log", "P.Log", "STAT.Log", "L95.Log", "U95.Log"))

# remove :A1:A2
# results[, SNP := stri_replace_last_regex(SNP, ":[:alpha:]:[:alpha:]", "")]

# write.table
nacc.results <- results
save(nacc.results, file = "02_analysis/ordinal/nacc.results.RData")
fwrite(nacc.results, file = "02_analysis/ordinal/nacc.results.csv", quote = F)

# try to make in PLINK file format .assoc.logistic
setnames(nacc.results, c("OR.Ord", "SE.Ord", "P.Ord", "STAT.Ord"), c("OR", "SE", "P", "STAT"))
nacc.results <- nacc.results[, .(CHR, SNP, BP, A1, TEST, NMISS, OR, SE, STAT, P)]

fwrite(nacc.results, file = "02_analysis/ordinal/ordinal.assoc.logistic", sep = " ", row.names = F, col.names = T, quote = F)

rm(list = ls())
p_unload(all)
