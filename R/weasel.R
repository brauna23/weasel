### Function to simulate evolution of digital individuals (Based on Richard Dawkins software Weasel)
### Written by Gustavo B. Paterno
### Last update: 28/03/2018
### Requires packages: ggplot2 & stringdist installed

weasel <- function(phrase = "Sorry, but evolution is true!", pop.n = 100, mutat = .01, gener = 400, method = "hamming",
                   case.sensitive = "CAPS", spe.char = FALSE, track = TRUE, wait  = .01,  seed = NULL,
                   start.phrase = NULL, wait.0 = 0, genome = NULL)
{
  
  ### Define function for best match
  best_match <- function(string, stringVector){
    wm <- amatch(string , stringVector, maxDist=Inf, method = method)
    stringVector[wm]
  }
  
  ### Difining values
  fz <- phrase
  if (!is.null(start.phrase)) {
    if (nchar(start.phrase) != nchar(phrase)) {
      stop(paste("'start.phrase' must contain:", nchar(phrase), "characters."))
    }
  }
  
  special.characters <- c("!","?",",",".","'")
  size <- nchar(fz)
  if(!is.null(seed)) {set.seed(seed)}
  
  ### Choose source bases:
  if(case.sensitive == TRUE) {bases <- c(letters,LETTERS, " ")}
  if(case.sensitive == "CAPS") {bases <- c(LETTERS, " ")}
  if(case.sensitive == "lower") {bases <- c(letters, " ")}
  
  ### include special characters:
  if(spe.char == TRUE) {bases <- c(bases, special.characters)}
  if(!is.null(genome)) {bases <- genome}
  n.bas <- length(bases)
  
  ### Set variables to store values in the global loop
  variants <- character()
  dis <- as.numeric()
  mutations <- data.frame("generation" = numeric(),
                          "neutral" = numeric(), 
                          "positive" = numeric(),
                          "negative" = numeric())
  ### Original population:
  if(!is.null(start.phrase)){finit <- strsplit(start.phrase, split = "")[[1]]}
  else finit <- sample(x = bases, size = size, replace = T)
  f0  <- finit
  fm  <- paste(finit, collapse = "")
  
  ### Initial distance: (number of mutations to reach soluton)
  dist0 <- stringdist(fz, paste(finit, collapse = ""), method = "hamming")
  
  ### set probabilities:
  anti.p <- mutat/(size)
  prob  <- rep(anti.p, each = n.bas)
  pro.h <- 1-mutat 
  
  cat("Initial state: ", paste(finit, collapse = ""), "\n")
  cat("Evolutionary aim: ", phrase, "\n")
  Sys.sleep(wait.0) 
  
  for (ger in 1:gener){
    
    Sys.sleep(wait) 
    ### Multiply individuals:
    fn <- matrix(rep(f0, each = pop.n), ncol = size)
    
    ### Mutate individual
    f1 <- matrix(nrow = pop.n, ncol = size)
    for (i in 1:pop.n){
      for (j in 1:size) {
        prop.x <- prob
        ws <- which(bases == fn[i, j]) 
        prop.x[ws] <- pro.h
        f1[i, j] <- sample(bases, size = 1, prob = prop.x)
      }
    }
    
    ### Calulate number of deleterious, neutral and benefitial mutation in all childs:
    ### Transform matrix in string vector:
    childs       <- tidyr::unite(as.data.frame(f1), sep = "")
    dist.parent  <- stringdist(fz, fm,  method = "hamming")
    dist.childs  <- apply(childs, 1, function(x) stringdist(fz, x,  method = "hamming" ))
    neutral  <- sum(dist.childs == dist.parent)
    positive <- sum(dist.childs < dist.parent)
    negative <- sum(dist.childs >  dist.parent)
    
    mutations[ger, ] <- c(ger, neutral, positive, negative)
    
    ### find best match
    md  <- best_match(string = fz, childs[,1])
    dis[ger] <- stringdist(fz, md, method = "hamming")
    #if (length(md) == 1) {chosed <- md}
    #if (length(md) > 1) {chosed <- sample(md, 1)} 
    wchosed <- which(childs[,1] == md)[1]
    
    f0 <- f1[wchosed, ]
    fm <- paste(f0, collapse = "")
    
    # store variatants
    variants[ger] <- fm
    
    ### Stop if match is reached
    
    if(track == TRUE) {
      cat( variants[ger], " | " , paste("Generation = ", ger),"\n")
    }
    if (fz == fm) {
      #cat(paste("Number of generations to reach evolutionary aim = ", ger, "\n"))
      cat("Solution = ", fm, "\n")
      #result <- data.frame(generation = seq(1:ger), variants, distance = dis, aim = fz)
      break}
  }
  
  ### Data.frame with evolution dataL
  result <- data.frame(generation = seq(1:ger), variants, distance = dis, aim = fz)
  result <- rbind(data.frame(generation = 0, variants = paste(finit, collapse = ""),
                             distance = dist0, aim = fz), result)
  ### Plot fitness curve: 
  p1 <- ggplot(result, aes(y = 1-(distance/dist0), x = generation)) +
    geom_smooth(se = F, color = "gray", alpha = .5, method = "loess")+
    geom_point(shape = 16, size = 4, color = "tomato") +
    geom_line()+
    theme_bw(base_size = 18) +
    scale_y_continuous(breaks = seq(0,1,.1)) +
    xlab("Generation") + ylab("Fitness [percetange of correct letters]") +
    theme(panel.grid = element_blank())
  
  ### Plot mutation curve
  mut.long <- melt(mutations, variable.name = "type",
                   measure.vars = c("positive", "neutral", "negative"))
  
  p2 <- ggplot(mut.long, aes(y = value, x = generation, color = type,
                             fill = type)) +
    geom_point(shape = 16, size = 2, show.legend = F) +
    geom_line(show.legend = F)+
    theme_bw(base_size = 18) +
    #scale_y_continuous(breaks = seq(0,1,.1)) +
    xlab("Generation") + ylab("Number of mutations") +
    theme(panel.grid = element_blank()) 
  
  
  ### Plot mutation against fitness:
  res.mut <- cbind(result[-1,], mutations[,-1])
  
  res.mut.long <- melt(res.mut, variable.name = "type",
                       measure.vars = c("positive", "neutral", "negative"))
  
  p3 <- ggplot(res.mut.long, aes(x = 1-(distance/dist0),
                                 y = value/pop.n, color = type, fill = type))+
    geom_point(shape = 16, size = 2) +
    geom_smooth(method = "loess") +
    theme_bw(base_size = 18) +
    scale_y_continuous(breaks = seq(0,1,.1)) +
    xlab("Fitness [percetange of correct letters]") + ylab("Percentage of mutations") +
    theme(panel.grid = element_blank(),
          legend.position = "top", 
          legend.background = element_blank())
  
  pall <- ggarrange(p1, p2, p3,  
                    labels = c("A", "B", "C"),
                    ncol = 3, nrow = 1)
  res <- list(simulation = result,
              plot.fitness = p1,
              plot.mutations = p2,
              plot.relative = p3,
              plot.all = pall,
              start = paste(finit, collapse = ""),
              solution = fm,
              Ngeneration = ger)
  res
}

