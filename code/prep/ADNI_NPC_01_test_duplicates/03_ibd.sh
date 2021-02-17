#!/bin/bash

plink \
  --bfile data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.pruned \
  --genome \
  --min 0.18 \
  --out data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.pruned