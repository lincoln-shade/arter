#===========================================
# Create manhattan plot to use for Figure 2
#===========================================

library(pacman)
p_load(data.table, magrittr)
source("code/functions/plot_manhattan.R")
library(latex2exp)

results <- fread("output/nacc_rosmap/nacc_rosmap.assoc.logistic")
annotate <- c("rs2603462", "rs7902929")

man_plot <- plot_manhattan(results) +
  ylab(TeX('$-log_{10}($p-value$)$'))

ggsave(filename = "doc/figure_2_manhattan.pdf",
       plot = man_plot,
       width = 12,
       height = 7,
       units = "in")
