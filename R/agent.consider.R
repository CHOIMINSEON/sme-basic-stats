# ******************************************************************************
#
# agent.consider() -------------------------------------------------------------
#
# Description: 
# Calculate how likely the agent visits the forest lodge
#
# Details:
# This function calculates how likely the given agent visits one of the forest 
# lodges. A high 'prob' value indicates that the agent is willing to visit the
# lodge. A low 'prob' value implies the opposite. If 'prob' is somewhere in
# between, the agent's action depends more on external factors, such as the 
# lodges.
#
# ******************************************************************************
agent.consider <- function(agent, records, week, env, prob = 0.1) {

  # ****************************************************************************
  #
  # Adjust the base probability based on the global parameters
  #
  # ****************************************************************************
  if (env$econ == 0)
    prob <- prob * 0.7                  # Decrease by 30% during the downturn
  if (env$covid)
    prob <- prob * 0.5                  # Decrease by 50% if COVID-19 is spread
  
  
  # ****************************************************************************
  #
  # Rule 1. The probability depends on the household income.
  #
  # ****************************************************************************
  if (agent$income > 5000)
    prob <- prob * 1.5                  # Increase by 50%
  else if (agent$income > 4000)
    prob <- prob * 1.3                  # Increase by 30%
  else if (agent$income < 1000)
    prob <- prob * 0.2                  # Decrease by 80%
  else if (agent$income < 3000)
    prob <- prob * 0.8                  # Decrease by 20%
  
  
  # ****************************************************************************
  #
  # Rule 2. Those with children are more likely to visit the forest?
  #
  # ****************************************************************************
  if (agent$hasChild)
    prob <- prob * 1.3                  # Increase by 30%
  
  
  # ****************************************************************************
  #
  # Rule 3. If one stayed at the lodge recently, she/he may skip this time.
  #
  # ****************************************************************************
  prev1 <- week$id - 3
  if (prev1 < 1)
    prev1 <- 1
  
  prev3 <- week$id - 11
  if (prev3 < 1)
    prev3 <- 1

  if (any(records[prev1:(week$id)] == 1))
    prob <- prob * 0.1                  # Decrease by 90%
  else if (any(records[prev3:(week$id)] == 1))
    prob <- prob * 0.4                  # Decrease by 60%

  
  # ****************************************************************************
  #
  # Rule 4. There are seasonal fluctuations.
  #
  # ****************************************************************************
  if (week$season == "spring" | week$season == "fall")
    prob <- prob * 1.4                  # Increase by 40%
  
  if (week$peak)
    prob <- prob * 1.5                  # Increase by 50%

  return(prob)
}
