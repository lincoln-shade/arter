#--------------------------------------------------
# Step 2: identify related clusters and duplicates
# and remove all but 1 ID from each cluster
#--------------------------------------------------
# create PLINK fileset with only unpruned SNPs
plink \
  --bfile data/tmp/rosmap_2.tmp \
  --extract data/tmp/rosmap_1e_pruned.tmp.prune.in \
  --make-bed \
  --geno 0.05 \
  --out data/tmp/rosmap_2_pruned.tmp;

# identify related clusters within rosmap
plink \
  --bfile data/tmp/rosmap_2_pruned.tmp \
  --genome \
  --min 0.18 \
  --out data/tmp/rosmap_2_related.tmp

# check missingness rate for related pairs
cat data/tmp/rosmap_2_related.tmp.genome | awk '{if ($2 != "IID1") {print $1, $2} }' >> data/tmp/rosmap_related.tmp.txt
cat data/tmp/rosmap_2_related.tmp.genome | awk '{if ($4 != "IID2") {print $3, $4} }' >> data/tmp/rosmap_related.tmp.txt

plink \
  --bfile data/tmp/rosmap_2.tmp \
  --keep data/tmp/rosmap_related.tmp.txt \
  --missing \
  --allow-no-sex \
  --out data/tmp/rosmap_2_related_miss.tmp
  

# remove related individuals, leaving one from each cluster
# (29 individuals to remove)
Rscript code/prep/rosmap/03a_check_relatedness.R

plink \
  --bfile data/tmp/rosmap_2.tmp \
  --remove data/tmp/rosmap_related_remove.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_unrelated.tmp

