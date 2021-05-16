library(pacman)
p_load(data.table, magrittr, ggplot2, ggrepel)

results <- fread("02_analysis/ACAT/acat.results.logistic.txt")

##----------------------------------------------------
## Create data.table of cumulative basepair position
## for each chromosome
##----------------------------------------------------
## find the last bp position for each chromosome
cum.bp <- results[, max(End), Chromosome]
setorder(cum.bp, Chromosome)

## set as numeric
cum.bp[, V1 := as.numeric(V1)]

## initialize cumulative position vector
sum.bp <- numeric(length = nrow(cum.bp))
## sum the max basepairs from preceding chromosomes
for (i in cum.bp$Chromosome) {
  sum.bp[i] <- cum.bp[Chromosome < i, 
                   as.numeric(sum(V1))]
  results[Chromosome == i, 
          cum.bp := End + sum.bp[i]]
}

## add summed bp positions and the center position for each chromosome
cum.bp[, sum.bp := sum.bp]
cum.bp[, center := V1 / 2 + sum.bp]

##-------
## Plot
##-------
# suggestive threshold
suggestive <- 5e-4
plot1 <- results[, ggplot(.SD, aes(cum.bp, -log10(ACAT.P), color=factor(Chromosome %% 2)))] +
  
  geom_point() +
  
  ## add labels for top genes
  geom_label_repel(data=results[ACAT.P < suggestive], aes(label=Gene)) +
  
  ## make x-axis labeled with chromosome
  scale_x_continuous(label=cum.bp$Chromosome, breaks = cum.bp$center) + 
  scale_color_manual(values = rep(c("#000066", "#606060"), 22 )) +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  ) +
  #ggtitle("Gene-based ACAT in NACC: 80+ logistic") +
  ylab("-log10(p-value)") +
  xlab("Position")

ggsave("02_analysis/ACAT/logistic.plot.png", plot=plot1, units = "in", width = 9, height = 6)

