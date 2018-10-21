# Weasel

Program that simulate the evolution of digital individuals (Based on Richard Dawkins algorithm Weasel)

<img src="https://raw.githubusercontent.com/paternogbc/weasel/master/img/weasel_logo.jpg" width="180">

The [Weasel Algorithm](https://en.wikipedia.org/wiki/Weasel_program) was developed by [Richard Dawkings](https://en.wikipedia.org/wiki/Richard_Dawkins) to demonstrate how random variation combined with non-random cumulative selection can drive evolutionary change. 

## Before you start

1. Install the following R packages:  

```{r}
install.packages("ggplot2")
install.packages("stringdist")
install.packages("reshape2")
install.packages("ggpubr")
install.packages("ggpubr")
install.packages("devtools")
```

## Get started

### Source the weasel function

```{r}
source_url(url = "https://raw.githubusercontent.com/paternogbc/weasel/master/R/weasel.R")
```

### Main arguments:

- __mutat:__ mutation rate (default = 0.05)  
- __gener:__ Maximum number of generations (default = 400)  
- __pop.n:__ Population size (default = 200)  
- __phrase:__ Aim phrase (default = "METHINKS IT IS LIKE A WEASEL")  
- __start.phrase:__ Start phrase (default = random string with 28 letters)  

### Run weasel
```r
res <- weasel(mutat = .05, gener = 1000, pop.n = 200, phrase = "METHINKS IT IS LIKE A WEASEL")
```

<img src="https://raw.githubusercontent.com/paternogbc/weasel/master/img/run.gif" width="400">

### Get the evolutionary trajectory:
```r
head(res$simulation)
tail(res$simulation)

### Start phrase:
res$start

### Solution
res$solution

### Number of generations to reach solution
res$Ngeneration
```

### Plot fitness and mutations curves

```r
### Plot fitness curve
res$plot.fitness

### Plot Mutations curve (N)
res$plot.mutations

### Plot Mutations curve (%)
res$plot.relative
```

![image](https://user-images.githubusercontent.com/9639481/47270094-fcc01180-d53c-11e8-99b4-a9a0f8f0a30d.png)