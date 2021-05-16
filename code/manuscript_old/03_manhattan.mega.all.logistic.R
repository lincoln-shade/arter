##-----------------------------------------------------
## NACC and ROSMAP ordinal regression mega-analysis
##-----------------------------------------------------
library(pacman)
p_load(data.table, magrittr, ggplot2, dplyr, ggrepel, stringi)
StripAlleles <- function(x) {
  stri_replace_last_regex(x, ":[:alpha:]*:[:alpha:]*", "")
}

results <- fread("../NACC.ROSMAP.meta/02_analysis/mega.ordinal/ordinal.assoc.logistic")

top.snps <- fread("../NACC.ROSMAP.meta/02_analysis/mega.ordinal/plink.clumped")

results[SNP %in% top.snps$SNP, is_annotate := "yes"]
results[is_annotate == "yes", SNP := StripAlleles(SNP)]

ordinal.significant <- results[P < 0.05]   

snp_mod <- ordinal.significant %>%
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=as.numeric(max(BP))) %>%
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(chr_len)-chr_len) %>%
  dplyr::select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(ordinal.significant, snp_mod, by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate(BPcum= BP+tot + 20000000*(CHR - 1)) 

# snp_mod <- snp_mod %>%
# # highlight and annotate snps
# mutate(is_highlight = ifelse(BPcum > snp_mod[which(snp_mod$P == min(snp_mod$P)), ]$BPcum - 10000 &
#                               BPcum < snp_mod[which(snp_mod$P == min(snp_mod$P)), ]$BPcum + 10000  , "yes", "no")) %>%
# mutate(is_annotate= ifelse(-log10(P)> 6.2, "yes", "no"))

axisdf = snp_mod %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 ) #add label for x-axis

manplot <- ggplot(snp_mod, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#606060", "#000066"), 22 )) +
  #geom_hline(yintercept = 7.3, color = "black") + #genome-wide significance threshold
  geom_hline(yintercept = 5, color = "black") + #suggestibility threshold
  
  # custom X axis:
  scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
  scale_y_continuous(expand = c(0.05, 0) ) +     # remove space between plot area and x axis
  xlab("Chromosome") +
  ylab("-log(P)") +
  
  # Add highlighted points
  #geom_point(data=subset(snp_mod, is_highlight=="yes"), color="orange", size=2) +
  
  # Add label using ggrepel to avoid overlapping
  geom_label_repel(data=subset(snp_mod, is_annotate=="yes"), aes(label=SNP), size=5) +
  
  # Custom the theme:
  theme_bw() +
  theme(
    text = element_text(family = "Calibri", size = 20),
    axis.text = element_text(size = 12), 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )

ggsave("tabs.figs/manhattan.mega.all.ordinal.png", manplot, units = "in", width = 12, height = 6)

rm(list=ls())
p_unload(all)
