##-------------
## Simulation
##-------------

library(data.table)
rosmap.acat <- fread("ROSMAP/02_analysis/ACAT/acat.results.logistic.txt")
nacc.acat <- fread("ADGC.HRC/80+/02_analysis/ACAT/acat.results.logistic.txt")
setorder(nacc.acat, Gene, Chromosome, Start)
setorder(rosmap.acat, Gene, Chromosome, Start)
rosmap.acat$log.P <- -log10(rosmap.acat$ACAT.P)
nacc.acat$log.P <- -log10(nacc.acat$ACAT.P)

cor(rosmap.acat$log.P, nacc.acat$log.P, method = "p")

n.sims <- 1e4
sim.pop.n <- nrow(nacc.acat)
null.cor <- rep(NA, n.sims)
for (i in 1:n.sims) {
  sim <- data.table(x=-log10(runif(sim.pop.n)), y=-log10(runif(sim.pop.n)))
  null.cor[i] <- sim[, cor(x, y)]
}

quantile(null.cor, 0.95)
