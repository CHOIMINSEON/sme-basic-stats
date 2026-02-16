# ******************************************************************************
#
# lodge.decide() ---------------------------------------------------------------
#
# Description:
#
# ******************************************************************************
lodge.decide <- function(applicants, lodges) {
  
  n <- length(applicants)
  results <- rep(0, n)
  
  counts <- table(applicants[applicants > 0])
  lodgeID <- names(counts)
  
  for (i in 1:length(counts)) {
    this_lodge <- lodges[lodges$id == lodgeID[i],]
    this_subset <- applicants == lodgeID[i]
    
    if (counts[i] > this_lodge$size) {
      INDEX <- sample(counts[i], this_lodge$size)
      results[this_subset][INDEX] <- 1
    } else {
      results[this_subset] <- 1
    }
  }
  
  return(results)
}
