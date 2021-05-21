!#/bin/bash

seq 1 22 | xargs -n 1 -P 22 -I % plink \
  --bfile data/act/act_mega \
  --chr % \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/act/act_mega.pheno \
  --covar data/act/act_mega.covar \
  --allow-no-sex \
  --out output/act/act_mega_chr%

file_list=output/act/file_list.txt
echo > $file_list
seq 1 22 | xargs -n 1 -I % echo output/act/act_mega_chr%.assoc.logistic > $file_list

plink \
  --bmerge $file_list \
  --out output/act/act_mega

bash code/single_variant/clump_top_snps.sh data/act/act_mega output/act/act_mega.assoc.logistic output/act/act_mega
