#=================================================
# make Table 3: nacc/adgc and rosmap mega results
#=================================================

source("code/00_load_options_packages_functions.R")

# these objects may already be loaded in rmd environment
if (!exists("nacc_rosmap_mega_results")) {
  nacc_rosmap_mega_results <- fread("output/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.assoc.logistic")
}

if (!exists("nacc_rosmap_mega_top")) {
  nacc_rosmap_mega_top <- fread("output/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.clumped")
}

if (!exists("nacc_adgc_rosmap_snps")) {
  nacc_adgc_rosmap_snps <- fread("data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.bim", header = F)
  setnames(nacc_adgc_rosmap_snps, c("V2", "V5", "V6"), c("SNP", "A1", "A2"))
}

table_3_data <- merge(nacc_rosmap_mega_top[, -c("P")], nacc_rosmap_mega_results, by = c("SNP", "CHR", "BP"))
table_3_data <- merge(table_3_data, nacc_adgc_rosmap_snps[, .(SNP, A1, A2)], by = c("SNP", "A1"))
#---------------------------------------------------------------------------------
# 1. convert all NACC odds ratios to be > 1 and switch effect allele if need be, 
# 2. make table variables for OR [95% CI] and effect/non-effect allele
#---------------------------------------------------------------------------------

# SNPs with NACC OR >= 1
table_3_data[OR >= 1, `OR [95% CI]` := paste0(round(OR, 2), " [", round(L95, 2), "-", round(U95, 2), "]")]
table_3_data[OR >= 1, `A1/A2` := paste0(A1, "/", A2)]

# SNPs with NACC OR < 1
table_3_data[OR < 1, `OR [95% CI]` := paste0(round(1/OR, 2), " [", round(1/U95, 2), "-", round(1/L95, 2), "]")]
table_3_data[OR < 1, `A1/A2` := paste0(A2, "/", A1)]

#----------------------------------
# Add clostest protein-coding gene 
# using UCSC genome browser
# (or QTL gene is variant is QTL)
#----------------------------------

# table_3_data[, Gene := c("SORCS3", "ELOVL4", "WASF3", "CTH", "SLC24A3", "COPG2", "SPOCK3", "N4BP3", "ZDHHC21", "CD83")]
table_3_data[, Gene := "TBD"]
#-------------------
# make table
#-------------------

# round p-values to 2 significant figures
table_3_data[, P := signif(P, 2)]


table_3_data <- table_3_data[, .(CHR, BP, Gene, SNP, `A1/A2`, `OR [95% CI]`, P)]
setorder(table_3_data, P)

# table_3_data %>% 
#   kable() %>% 
#   kable_styling(bootstrap_options = c("condensed")) %>% 
#   add_header_above(c("Table X: NACC & ROSMAP mega-analysis variants associated with B-ASC"=ncol(table_3_data)))
