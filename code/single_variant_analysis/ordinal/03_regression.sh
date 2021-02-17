#!/bin/bash

#test!
# variables
lists=02_analysis/ordinal/snp.lists
ls $lists | xargs -n 1 -P 22 bash -c '
  plink19b3x \
    --bfile 02_analysis/ordinal/plink/plink \
    --extract 02_analysis/ordinal/snp.lists/$0 \
    --allow-no-sex \
    --recode A \
    --out 02_analysis/ordinal/tmp/$0.tmp;
    
   Rscript --vanilla --slave 02_analysis/ordinal/03a_regression.R \
    02_analysis/ordinal/tmp/$0.tmp.raw # ; 
  
  rm tmp/$0.tmp*
  '
