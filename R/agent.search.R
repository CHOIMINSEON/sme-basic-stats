# ******************************************************************************
#
# agent.search() ---------------------------------------------------------------
#
# Description:
#
# ******************************************************************************
agent.search <- function(agent, lodges, dist, n = nrow(lodges), decay = 2) {
  
  target <- lodges$id %in% sample(lodges$id, n)

  lodges <- lodges[target,]
  dist <- dist[target]
  
  inv_dist <- dist^(-1 * decay)
  inv_year <- order(lodges$yrBuilt)
  
  distScore <- ((inv_dist - min(inv_dist)) / (max(inv_dist) - min(inv_dist)))
  yearScore <- ((inv_year - min(inv_year)) / (max(inv_year) - min(inv_year)))
  
  distScore <- distScore + 0.1
  yearScore <- yearScore + 0.1
  
  scores <- agent$distWgt * distScore + agent$yearWgt * yearScore
  if (any(dist > agent$distCut))
    scores[dist > agent$distCut] <- 0
  
  scores <- (scores - mean(scores)) / sd(scores)
  scores.df <- data.frame(id = lodges$id, dist = dist, scores = scores)
  
  return(scores.df)
}
