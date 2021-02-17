#!/bin/bash

# Find if input variants are eQTLs in GTEx
# and write summary information to file

# reformat variant names
Rscript /home/commons/arter/coloc/R/01_reformat.snps.R $1;

# search for QTLs
grep --file=snps.tmp -r --include \*.signif_pairs.txt /data_global/GTEx/GTEx_Analysis_v8_QTLs/GTEx_Analysis_v8_eQTL_Eur/eqtls >> qtls.tmp;
grep --file=snps.tmp -r --include \*.signif_pairs.txt /data_global/GTEx/GTEx_Analysis_v8_QTLs/GTEx_Analysis_v8_sQTL_Eur/ >> qtls.tmp;
# tidy QTL summary table
Rscript /home/commons/arter/coloc/R/02_qtls.R qtls.tmp rsid.key.tmp;

rm snps.tmp rsid.key.tmp qtls.tmp

