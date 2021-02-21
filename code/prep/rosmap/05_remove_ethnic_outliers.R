##----------------------------------------------
## create PCA plot of 1KG and rosmap NP subjects
##----------------------------------------------

library(pacman)
p_load(data.table, magrittr, ggplot2)

# 1000g (otg) data population data
otg <- fread("/data_global/1000g/integrated_call_samples_v3.20130502.ALL.panel") %>% 
  .[, sample, super_pop]

# PCA data
merged <- fread("data/tmp/rosmap_1000g_merged_pca.eigenvec", header = F) %>% 
  .[, 2:4] %>% 
  setnames(., c("V2", "V3", "V4"), c("sample", "PC1", "PC2")) %>% 
  .[, PC1.norm := scale(PC1)] %>% 
  .[, PC2.norm := scale(PC2)] 

# merge
otg.merged <- merge(merged, otg, by = c("sample"), all = T)

# reverse PCs if needed to make European pop top right of plot & label samples
if (otg.merged[super_pop == "EUR", mean(PC1.norm)] < 0) {
  otg.merged[, `:=`(PC1 = -PC1, PC1.norm = -PC1.norm)]
}

if (otg.merged[super_pop == "EUR", mean(PC2.norm)] < 0) {
  otg.merged[, `:=`(PC2 = -PC2, PC2.norm = -PC2.norm)]
}

#ggplot of first 2 normalized PCs
pca.plot <- ggplot(otg.merged, aes(PC1.norm, PC2.norm, color = as.factor(super_pop))) +
  geom_point() +
  ggtitle("PCA of 1000 Genomes and ROSMAP participants") 

#scree plot
eigenval <- fread("data/tmp/rosmap_1000g_merged_pca.eigenval", header = F) %>% 
  setnames(., "V1", "eigenvalue") %>% 
  .[, var.expl := eigenvalue / sum(eigenvalue)] %>% 
  .[, PC := 1:2]

scree <- ggplot(eigenval, aes(PC, var.expl)) +
  geom_point() +
  ggtitle("Scree plot for 1000 Genomes and ROSMAP subjects") +
  ylab("Proportion of variance explained")

# create objects for mean values for EUR PC1 and PC2 and create selection criteria based off them

#######################
## set circle radius ##
#######################
radius <- 0.35  #######
#######################

CircleFun <- function(center = c(otg.merged[super_pop == "EUR", mean(PC1.norm)],
                                 otg.merged[super_pop == "EUR", mean(PC2.norm)]), 
                      r = 1, npoints = 100){
  tt <- seq(0,2*pi,length.out = npoints)
  xx <- center[1] + r * cos(tt)
  yy <- center[2] + r * sin(tt)
  return(data.frame(x = xx, y = yy))
}

##-------------------
## Make plot
##-------------------
pca.plot2 <- ggplot(otg.merged, aes(PC1.norm, PC2.norm, color = as.factor(super_pop))) +
  theme_bw() +
  theme(
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  ) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") +
  geom_path(data = CircleFun(r=radius), aes(x, y), color = "red")

pca.plot2

InsideCircle <- function(x, y, r, center = c(0, 0)) {
  ifelse((x - center[1])^2 + (y - center[2])^2 <= r, TRUE, FALSE)
}

otg.merged <- 
  otg.merged[, include := 
               ifelse(
                 is.na(super_pop) == T & 
                   InsideCircle(PC1.norm, 
                                PC2.norm, 
                                radius, 
                                c(otg.merged[super_pop == "EUR", 
                                             mean(PC1.norm)], 
                                  otg.merged[super_pop == "EUR", 
                                             mean(PC2.norm)]
                                )
                   ) == T, TRUE, FALSE)
  ]

rosmap <- otg.merged[include == T, ]
rosmap.ids <- fread("data/tmp/rosmap_ids.tmp.txt", header = F)
rosmap.ids <- rosmap.ids[V2 %in% rosmap$sample]

ggsave(filename = "output/rosmap/rosmap_1000g_pca.png", pca.plot2, units="in", width=7, height=7)

# tmp file bc still need to check for relatedness to nacc_adgc
write.table(rosmap.ids, "data/tmp/rosmap_unrelated.tmp.txt", col.names = F, row.names = F, quote = F)

rm(list = ls())
p_unload(all)
