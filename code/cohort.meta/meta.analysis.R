library(pacman)
p_load(data.table, magrittr)


for (i in 1:7){
  adc <- paste0("adc", i)
  assign(paste(adc), fread(paste0("log/ADC.", i, ".assoc.logistic"), header = T) %>% 
                            setorder(., P, na.last = T)
         )
}

head(adc1, 20)
head(adc2, 20)
head(adc3, 20)
head(adc4, 20)
head(adc5, 20)
head(adc6, 20)
head(adc7, 20)
head(meta, 20)

meta <- fread("log/np.meta", header = T) %>% 
  setorder(., `P(R)`, na.last = T)

np.log <- fread("log/np.logistic.assoc.logistic", header = T)
meta1.5 <- fread("log/np.1.5.meta", header = T) %>%
  setorder(., `P(R)`, na.last = T)

adc1[SNP == "rs6549072:G:A"]
adc2[SNP == "rs6549072:G:A"]
adc3[SNP == "rs6549072:G:A"]
adc4[SNP == "rs6549072:G:A"]