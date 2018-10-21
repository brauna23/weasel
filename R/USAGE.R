### Packages required to run the code (need to be installed before using)
library(ggplot2)
library(stringdist)
library(reshape2)
library(ggpubr)
library(devtools)

### Source Weasel function:
source_url(url = "https://raw.githubusercontent.com/paternogbc/weasel/master/R/weasel.R")

res <- weasel(mutat = .05, phrase = "METHINKS IT IS LIKE A WEASEL", pop.n = 200)

### Get the evolution progress:
head(res$simulation)
tail(res$simulation)

### Start phrase:
res$start

### Solution
res$solution

### Number of generations to reach solution
res$Ngeneration

### Plot fitness curve
res$plot.fitness

### Plot Mutations curve (N)
res$plot.mutations

### Plot Mutations curve (%)
res$plot.relative

### Plot all graphs:
res$plot.all
