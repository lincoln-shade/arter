!#/bin/bash

(seq 1 22) | xargs -n 1 -P 22 -I % plink \
  --bfile data/act/act_mega \
  --chr % \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/act/act_mega.pheno \
  --covar data/act/act_mega.covar \
  --allow-no-sex \
  --out output/act/act_mega_chr%
