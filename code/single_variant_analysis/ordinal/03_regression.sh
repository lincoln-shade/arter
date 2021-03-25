#!/bin/bash

list_length=$(ls data/tmp/ordinal_snp_list_* | wc -l)
touch data/tmp/snp_list_index.tmp
for i in $(seq 1 $list_length)
do
  echo $i >> data/tmp/snp_list_index.tmp
done

<data/tmp/snp_list_index.tmp xargs -n 1 -P 22 -I % \
  plink \
    --bfile data/nacc_adgc/nacc_adgc_unrelated \
    --extract data/tmp/ordinal_snp_list_% \
    --allow-no-sex \
    --recode A \
    --out data/tmp/ordinal_snp_list_%
    
#<data/tmp/snp_list_index.tmp xargs -n 1 -P 22 -I % \
#   Rscript --vanilla --slave code/single_variant_analysis/ordinal/03a_regression.R \
#    data/tmp/ordinal_snp_list_%.raw

rm data/tmp/snp_list_index.tmp
