#!/bin/bash

<data/tmp/snp_list_index.tmp xargs -n 1 -P 22 -I % \
  plink \
    --bfile $3 \
    --extract data/tmp/ordinal_snp_list_% \
    --allow-no-sex \
    --recode A \
    --out data/tmp/ordinal_snp_list_%
    
<data/tmp/snp_list_index.tmp xargs -n 1 -P 22 -I % \
  Rscript --vanilla --slave code/single_variant_analysis/ordinal/02a_regression.R % $1 $2

