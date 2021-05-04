!#/bin/bash

plink \
  --bfile data/act/act \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/act/act_pheno.txt \
  --covar data/act/act_covar.txt \
  --allow-no-sex \
  --out output/act/act