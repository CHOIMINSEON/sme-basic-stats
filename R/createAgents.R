# ******************************************************************************
#
# createAgents() ---------------------------------------------------------------
#
# Description:
# Create a required number of agents in different age groups
#
# Details:
# Each agent represents a household. The variable 'age' indicates the age of 
# the householder. All the other variables are assumed to follow certain
# probability mass/density functions with parameters. Some of the parameters
# are dependent on the variable 'age' as follows.
# 
#     income ~ Normal(mu, sd)              # 'mu' and 'sd' depend on 'age'.
#     hasChild ~ Binomial(trial = 1, p)    # 'p' depends on 'age'.
#     distWgt ~ Uniform(min, max)          # 'min' >= 0 and 'max' <= 1
#     distCut ~ Pareto(location = 2, shape = 1)
#
# These functions are only for exploratory, so their suitability should be
# evaluated carefully.
#
# ******************************************************************************
createAgents <- function(size = 500, ageGrp = seq(20, 60, by = 10), 
                         ageDist = c(0.08, 0.15, 0.20, 0.23),
                         meanInc = c(2800, 4800, 5300, 5700, 3500), 
                         sdevInc = c(600, 450, 450, 600, 750),
                         prChild = c(0.1, 0.4, 0.6, 0.5, 0.3), bbox) {
  
  require(EnvStats)
  
  ageSize <- trunc(size * ageDist)
  ageSize <- append(ageSize, size - sum(ageSize))
  
  age <- rep(ageGrp, ageSize)
  
  for (i in 1:length(ageGrp)) {
    
    if (i == 1) {
      income <- rnorm(ageSize[i], meanInc[i], sdevInc[i])
      hasChild <- rbinom(ageSize[i], 1, prob  = prChild[i])  
    } else {
      income <- append(income, rnorm(ageSize[i], meanInc[i], sdevInc[i]))
      hasChild <- append(hasChild, rbinom(ageSize[i], 1, prob  = prChild[i]))
    }
  }
  
  distWgt <- runif(size, min = 0.6, max = 0.9)
  yearWgt <- 1 - distWgt
  
  distCut <- EnvStats::rpareto(size, location = 2, shape = 1)

  x <- runif(size, min = bbox[1,1], max = bbox[2,1])
  y <- runif(size, min = bbox[1,2], max = bbox[2,2])
  
  agents.df <- data.frame(id = 1:size, age, income, hasChild, 
                          distWgt, yearWgt, distCut, x, y)
  return(agents.df)
}
