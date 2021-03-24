#!/bin/bash

#test!
# variables
list_length=(ls data/tmp/ordinal_snp_list_* | wc -l)
touch data/tmp/
for i in {1..$list_length}
  do
  echo $i >> 

ls $lists | xargs -n 1 -P 22 -I % \
  plink \
    --bfile 02_analysis/ordinal/plink/plink \
    --extract % \
    --allow-no-sex \
    --recode A \
    --out 02_analysis/ordinal/tmp/$0.tmp; \
    
   Rscript --vanilla --slave 02_analysis/ordinal/03a_regression.R \
    02_analysis/ordinal/tmp/$0.tmp.raw # ; 
  
  rm tmp/$0.tmp*
  '
