#!/bin/bash

plink19b3x \
  --meta-analysis \
  log/ADC.1.assoc.logistic log/ADC.2.assoc.logistic log/ADC.3.assoc.logistic log/ADC.4.assoc.logistic \
  log/ADC.5.assoc.logistic log/ADC.6.assoc.logistic log/ADC.7.assoc.logistic \
  --out log/np