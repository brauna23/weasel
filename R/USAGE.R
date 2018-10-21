### Packages required to run the code (need to be installed before using)
library(ggplot2)
library(stringdist)
library(reshape2)
library(ggpubr)

### Source Weasel function:
source("R/weasel.R")

fit <- weasel(mutat = .05, phrase = "METHINKS IT IS LIKE A WEASEL", pop.n = 200)

### Get the evolution progress:
head(fit$simulation)
tail(fit$simulation)

### Start phrase:
fit$start

### Solution
fit$solution

### Number of generations to reach solution
fit$Ngeneration

### Plot fitness curveL
fit$plot.fitness

### Plot Mutations curve (N)
fit$plot.mutations

### Plot Mutations curve (%)
fit$plot.relative

### Plot all graphs:
fit$plot.all
