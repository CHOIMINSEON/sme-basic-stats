# ******************************************************************************
#
# 1. Load functions and set up parameters --------------------------------------
#
# ******************************************************************************

# install.packages("EnvStats")
library(EnvStats)
source("R/createAgents.R")
source("R/getDist.R")
source("R/agent.consider.R")
source("R/agent.search.R")
source("R/agent.decide.R")
source("R/lodge.decide.R")

env <- list(econ = 0, covid = FALSE)
weeks <- read.csv("data/weeks.csv") # Based on the calendar of year 2020

studyarea <- matrix(c(0, 1, 0, 1), ncol = 2, 
                    dimnames = list(c("x", "y"), c("min", "max")))
# set.seed(0)
# agents <- createAgents(bbox = studyarea)
# write.csv(agents, file = "data/agents.csv", row.names = FALSE)

agents <- read.csv("data/agents.csv", encoding = "UTF-8")
lodges <- read.csv("data/lodges.csv", encoding = "UTF-8")
colnames(lodges) <- c("x", "y", "size", "yrBuilt")
lodges <- data.frame(id = 1:nrow(lodges), lodges)

dist.mat <- getDist(matrix(c(agents$x, agents$y), ncol = 2),  
                    matrix(c(lodges$x, lodges$y), ncol = 2))

results.applicants <- matrix(-9, nrow = nrow(agents), ncol = nrow(weeks))
results.users <- matrix(0, nrow = nrow(agents), ncol = nrow(weeks))
results.lodges <- matrix(0, nrow = nrow(lodges), ncol = nrow(weeks))


# ******************************************************************************
#
# 2. Run the simulation! -------------------------------------------------------
#
# ******************************************************************************
for (i in 1:52) {
  
  this_week <- weeks[i,]
  
  oo <- sample(1:nrow(agents), nrow(agents))
  
  for (j in oo) {
    
    cat("Week ", i, ": Agent #", j, " is considering now ...\n", sep = "")
    
    this_agent <- agents[j,]
    this_records <- results.users[j,]
    this_dist <- dist.mat[,j]
    
    prob <- agent.consider(this_agent, this_records, this_week, env)
    start_search <- rbinom(1, 1, prob)
    
    if (start_search) {
      score.df <- agent.search(this_agent, lodges, this_dist, decay = 2)
      decision <- agent.decide(this_agent, prob, score.df, 
                               cutoff = this_agent$distCut)
      
      if (decision$apply) {
        results.applicants[j, i] <- decision$lodgeID
        results.lodges[decision$lodgeID, i] <- 
          results.lodges[decision$lodgeID, i] + 1
      }
    }
  }
  
  results <- lodge.decide(results.applicants[,i], lodges)
  results.users[,i] <- results
}

# Clean up mess
rm(oo, i, j, results, this_week, this_agent, this_dist, this_records, prob, 
   start_search, decision)


# ******************************************************************************
#
# 3. Tidy up the results -------------------------------------------------------
#
# ******************************************************************************
colnames(results.lodges) <- 1:52
rownames(results.lodges) <- LETTERS[1:4]

colnames(results.users) <- 1:52
rownames(results.users) <- 1:500

colnames(results.applicants) <- 1:52
rownames(results.applicants) <- 1:500

# Number of applications each person made in a year
a <- apply(results.applicants, 1, function(z) sum(z != -9))

# Number of successful applications for each person in the same year
b <- apply(results.users, 1, function(z) sum(z))

# At the current setting, the success rate was about 20% on average.
summary(b/a)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 0.0000  0.0000  0.2000  0.2100  0.3333  1.0000       4

plot(results.lodges[1,], type = "b", ylim = c(0, max(results.lodges)), 
     col = "orange", xlab = "Weeks", ylab = "# Applicants")
lines(results.lodges[2,], type = "b", col = "tomato")
lines(results.lodges[3,], type = "b", col = "blue")
lines(results.lodges[4,], type = "b", col = "darkgrey")
