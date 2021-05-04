#--------------------------------------------------
# Step 2: identify related clusters and duplicates
# and remove all but 1 ID from each cluster
#--------------------------------------------------
# create PLINK fileset with only unpruned SNPs
plink \
  --bfile data/tmp/act_qc2.tmp \
  --extract data/tmp/act_qc1_pruned.tmp.prune.in \
  --make-bed \
  --geno 0.05 \
  --out data/tmp/act_qc2_pruned.tmp;

# identify related clusters
plink \
  --bfile data/tmp/act_qc2_pruned.tmp \
  --genome \
  --min 0.18 \
  --out data/tmp/act_qc2_related.tmp

# check missingness rate for related pairs
cat data/tmp/act_qc2_related.tmp.genome | awk '{if ($2 != "IID1") {print $1, $2} }' >> data/tmp/act_related.tmp.txt
cat data/tmp/act_qc2_related.tmp.genome | awk '{if ($4 != "IID2") {print $3, $4} }' >> data/tmp/act_related.tmp.txt

plink \
  --bfile data/tmp/act_qc2.tmp \
  --keep data/tmp/act_related.tmp.txt \
  --missing \
  --allow-no-sex \
  --out data/tmp/act_qc2_related_miss.tmp
  
# no related individuals

plink \
  --bfile data/tmp/act_qc2.tmp \
  --make-bed \
  --out data/tmp/act_qc3.tmp

