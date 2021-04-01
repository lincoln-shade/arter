#--------------------------------------------------
# Step 2: identify duplicates and remove
#--------------------------------------------------
# create PLINK fileset with only unpruned SNPs
plink \
  --bfile data/tmp/nacc_adgc_qc2.tmp \
  --extract data/tmp/nacc_adgc_qc1_pruned.tmp.prune.in \
  --make-bed \
  --geno 0.05 \
  --out data/tmp/nacc_adgc_qc2_pruned.tmp;

# identify related clusters
plink \
  --bfile data/tmp/nacc_adgc_qc2_pruned.tmp \
  --genome \
  --min 0.90 \
  --out data/tmp/nacc_adgc_qc2_related.tmp

# check missingness rate for related pairs
cat data/tmp/nacc_adgc_qc2_related.tmp.genome | awk '{if ($2 != "IID1") {print $1, $2} }' >> data/tmp/nacc_adgc_related.tmp.txt
cat data/tmp/nacc_adgc_qc2_related.tmp.genome | awk '{if ($4 != "IID2") {print $3, $4} }' >> data/tmp/nacc_adgc_related.tmp.txt

plink \
  --bfile data/tmp/nacc_adgc_qc2.tmp \
  --keep data/tmp/nacc_adgc_related.tmp.txt \
  --missing \
  --allow-no-sex \
  --out data/tmp/nacc_adgc_qc2_related_miss.tmp
  

# remove related individuals, leaving one from each cluster
# (29 individuals to remove)
Rscript code/prep/nacc_adgc/03a_check_relatedness.R

plink \
  --bfile data/tmp/nacc_adgc_qc2.tmp \
  --remove data/tmp/nacc_adgc_related_remove.tmp.txt \
  --make-bed \
  --out data/tmp/nacc_adgc_qc3.tmp

