#===================================
# make graph B-ASC vs age of death
#===================================
library(pacman)
# having trouble downloading ggplot2, need to move to my desktop (only summary stats)
p_load(data.table, magrittr)
load("../ADGC.HRC/65+/01_data/data/nacc.ordinal.RData")
nacc <- nacc.ordinal

nacc[, BASC := ifelse(NACCARTE < 2, 0, 1)]
basc.v.age <- nacc[NACCDAGE %in% 60:100] %>% 
  .[, mean(BASC), NACCDAGE]

save(basc.v.age, file = "basc.v.age.RData")
