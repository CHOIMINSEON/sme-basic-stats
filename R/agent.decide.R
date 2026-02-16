# ******************************************************************************
#
# agent.decide() ---------------------------------------------------------------
#
# Description:
#
# ******************************************************************************
agent.decide <- function(agent, intention, score.df, cutoff) {
  
  decision <- list(apply = FALSE, lodgeID = NA)
  
  pref <- (min(score.df$dist) / cutoff)
  proceed <- rbinom(1, 1, prob = 1 - (intention * pref))
  
  if (proceed == 1) {
    decision$apply <- TRUE
    
    eligible <- which(score.df$score > 0)
    p <- score.df$score[eligible] / sum(score.df$score[eligible])
    decision$lodgeID <- sample(as.character(score.df$id[eligible]), 1, prob = p)
    decision$lodgeID <- as.numeric(decision$lodgeID)
  }
  
  return(decision)
}
