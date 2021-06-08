#!/bin/bash 

# nacc/adgc 80+
bash code/single_variant_analysis/clump_top_snps.sh \
  data/nacc_adgc/nacc_adgc_unrelated_80 \
  output/nacc_adgc/nacc_adgc_unrelated_80.assoc.logistic \
  "output/nacc_adgc/nacc_adgc_unrelated_80"

# rosmap
bash code/single_variant_analysis/clump_top_snps.sh \
  data/rosmap/rosmap_unrelated \
  output/rosmap/rosmap_unrelated.assoc.logistic \
  "output/rosmap/rosmap"

# macc/rosmap mega
bash code/single_variant_analysis/clump_top_snps.sh \
  data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated \
  output/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.assoc.logistic \
  "output/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated"

# adni mega
bash code/single_variant_analysis/clump_top_snps.sh \
  data/adni_npc/nacc_adgc_rosmap_adni_unrelated \
  output/adni_npc/nacc_adgc_rosmap_adni_unrelated.assoc.logistic \
  "output/adni_npc/nacc_adgc_rosmap_adni_unrelated"
