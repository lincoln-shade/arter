##---------------------------------------------
## take input rsIDs and convert to 
## [chr]_[bp_hg38]_[ref]_[alt]_b38 format
##---------------------------------------------

packages <- c("data.table", "stringi", "rentrez", "magrittr")
for (package in packages) {
  if (!require(package, character.only = T)) install.packages(package)
}

rsids <- fread(commandArgs(trailingOnly = T), header = F)$V1
snps <- rsids
if (length(snps) == 0) stop("You must input at least 1 rsID")
snps <- stri_replace_first_regex(snps, "rs", "") %>% 
  stri_replace_last_regex(., ":[:alpha:]*:[:alpha:]*", "") %>% 
  as.integer()

# retrieve SNP summaries from dbSNP
dbsnp <- entrez_summary("snp", snps)

snps <- as.character(snps)

Reformat_SNP <- function(snp, len) {
  if (length(snps) < 2) {smry <- dbsnp} else {smry <- dbsnp[[snps[i]]]}
  alleles <- stri_extract_first_regex(smry[["docsum"]], "[:alpha:]*/[:alpha:]*") %>% 
    gsub(pattern = "/", replacement = "_", x=.)
  pos <- gsub(":", "_", smry[["chrpos"]])
  snp.new.lab <- paste0("chr", pos, "_", alleles, "_b38")
  snp.new.lab
}

snps.new <- rep(NA, length(snps))
for (i in 1:length(snps)) {
  snps.new[i] <- Reformat_SNP(snps[i], length(snps))
}

fwrite(as.data.table(snps.new), file = "snps.tmp", row.names = F, col.names = F, quote = F)

rsid.key <- data.table("rsid"=rsids, "variant_id"=snps.new)

fwrite(rsid.key, file = "rsid.key.tmp", row.names = F, col.names = T, quote = F)

