# ******************************************************************************
#
# getDist() --------------------------------------------------------------------
#
# ******************************************************************************
getDist <- function(agents.xy, lodges.xy) {
  
  dist_mat <- matrix(NA, nrow = nrow(lodges.xy), ncol = nrow(agents.xy))
  
  for (i in 1:nrow(lodges.xy)) {
    lodge.xy <- matrix(lodges.xy[i,], ncol = 2)
    dist <- colSums(apply(agents.xy, 1, function(z) (z - lodge.xy)^2))
    dist_mat[i,] <- sqrt(dist)
  }
  
  return(dist_mat)
}
