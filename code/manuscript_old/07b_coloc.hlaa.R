##-------------------------------
## Plots of HLA-A B-ASC and qtl
##-------------------------------

library(pacman)
p_load(data.table, ggplot2, stringi)

tissue <- commandArgs(trailingOnly = T)[1]
basc.qtl <- fread(paste0("../ADGC.HRC/80+/02_analysis/coloc.hla/",
             tissue,
             "/basc.qtl.tsv"))

# top B-ASC and qtl variant positions
top.basc.variant.bp <- basc.qtl[P_basc == min(P_basc), BP_hg38]
top.qtl.variant.bp <- basc.qtl[P_qtl == min(P_qtl), BP_hg38]

# B-ASC plot
p.basc <- basc.qtl[, ggplot(.SD, aes(BP_hg38, -log10(P_basc), 
                                     alpha=ifelse(P_basc == min(P_basc), 1, 0.7), 
                                     color=ifelse(P_basc == min(P_basc), "red", "black")))] +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  ) +
  geom_point() +
  geom_vline(xintercept = top.basc.variant.bp - 2e5) +
  geom_vline(xintercept = top.basc.variant.bp + 2e5) +
  ggtitle(paste0(stri_replace_all_fixed(tissue, "_", " "), " B-ASC")) +
  ylab("-log10(P)") +
  xlab("BP")

# qtl plot
p.qtl <- basc.qtl[, ggplot(.SD, aes(BP_hg38, -log10(P_qtl), 
                                    alpha=ifelse(P_basc == min(P_basc), 1, 0.7), 
                                    color=ifelse(P_basc == min(P_basc), "red", "black")))] +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  ) +
  geom_point() +
  geom_vline(xintercept = top.basc.variant.bp - 2e5) +
  geom_vline(xintercept = top.basc.variant.bp + 2e5) +
  ggtitle(paste0(stri_replace_all_fixed(tissue, "_", " "), " eQTL")) +
  ylab("-log10(P)") +
  xlab("BP")

ggsave(p.basc, file=paste0("tabs.figs/coloc.hlaa/hlaa.",
                           tissue,
                           ".basc.png"))

ggsave(p.qtl, file=paste0("tabs.figs/coloc.hlaa/hlaa.",
                           tissue,
                           ".eqtl.png"))
rm(list = ls())  
p_unload(all)
         