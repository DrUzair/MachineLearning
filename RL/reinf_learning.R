# MODEL-FREE Reinforcement Learning
# In the absence of Markove-decision-process (MDP), Agent interacts with the environment and learns based on rewards
# temporal difference methods 
# Richard S. Sutton. Learning to predict by the method of temporal differences. Machine Learning, 3(1):9-44, 1988.

state <- function(x, storeObject = FALSE, ...) {
  name <- toString(x)
  return(name)
}

gridworldEnvironment2 <- function (state, action) 
{
  reward <- -10
  next_state <- state
  if (state == state("s1") && action == "down") {
    next_state <- state("s2")
    reward <- 1
  }
  # two policies (ways to reach to s6)
  #if (state == state("s1") && action == "right") {
  #  next_state <- state("s4")
  #  reward <- 5
  #}
  if (state == state("s2") && action == "up") {
    next_state <- state("s1")
    reward <- -1
  }
  if (state == state("s2") && action == "right") {
    next_state <- state("s3")
    reward <- 1
  }
  if (state == state("s3") && action == "left") {
    next_state <- state("s2")
    reward <- -1
  }
  if (state == state("s3") && action == "up") {
    next_state <- state("s4")
    reward <- 1
  }
  if (next_state == state("s4") && action == "right") {
    next_state <- state("s5")
    reward <- 1
  }
  if (next_state == state("s4") && action == "down") {
    next_state <- state("s3")
    reward <- -1
  }
  if (next_state == state("s5") && action == "left") {
    next_state <- state("s4")
    reward <- -1
  }
  if (next_state == state("s6") && action == "up") {
    next_state <- state("s5")
    reward <- -1
  }
  if (next_state == state("s5") && action == "down") {
    next_state <- state("s6")
  }
  if (next_state == state("s6") && state != state("s6")) {
    reward <- 10
  }
  
  if (reward == -10)
    reward <- -10
  
  out <- list(NextState = next_state, Reward = reward)
  return(out)
}

states <- c("s1", "s2", "s3", "s4", "s5", "s6")
#states <- c("s1", "s2", "s3", "s4")
actions <- c("up", "down", "left", "right")

State_Action_Hash <- hash()
for (i in unique(states)) {
  State_Action_Hash[[i]] <- hash(unique(actions), rep(0, length(unique(actions))))
}

N = 200
sampleStates <- sample(states, N, replace = T)

#RANDOM ACTION SELECTION
sampleActions <- sapply(sampleStates, function(state) names(sample(values(Q[[state]]), 1)))
action_reward_nextstate_list <- lapply(1:length(sampleStates), function(x) gridworldEnvironment2(sampleStates[x], sampleActions[x]))
action_reward_nextstate <- data.table::rbindlist(lapply(action_reward_nextstate_list, data.frame))

data <- data.frame(
  State = sampleStates,
  Action = sampleActions,
  Reward = action_reward_nextstate$Reward,
  NextState = as.character(action_reward_nextstate$NextState),
  stringsAsFactors = F
)

d <- data.frame(
  s = data[, "State"],
  a = data[, "Action"],
  r = data[, "Reward"],
  s_new = data[, "NextState"],
  stringsAsFactors = F
)

control <- list(alpha = 0.1, gamma = 0.7)
# alpha: learning rate
# gamma: Discount factor: importance of future rewards. 0 means agent prefers immediate rewards, greater value will allow focusing on longer-term rewards

for(i in 1:nrow(data)){
  d <- data[i,]
  state <-      d$State
  action <-     d$Action
  reward <-     d$Reward
  nextState <-  d$NextState
  currentQ <- Q[[state]][[action]]
  if(has.key(nextState,Q)) {
    max_of_NextState_ActionRewards <- max(values(State_Action_Hash[[nextState]]))
  } else{
    maxNextQ <- 0
    print(paste0('Q dont have ', nextState))
  }
  # Q-learning Rule
  #  adjust the estimated value of a state_action based on 
  # 1. the immediate reward 
  # 2. the estimated value of the next state. --> control$gamma * max_of_NextState_ActionRewards - currentQ
  State_Action_Hash[[state]][[action]] <- currentQ + control$alpha *  (reward + control$gamma * max_of_NextState_ActionRewards - currentQ)
  # temporal difference methods 
  #if (state == 's1' && action == 'up'){
  #  print(paste0(i, ' state ', state,  ' action ', action, ' reward ', reward,' currentQ ', Q[[state]][[action]], ' NextState ', nextState, ' maxNextState ', max(values(Q[[nextState]])) ))
  #  print(values(Q[[nextState]]))
  #  print(values(Q[[state]]))
  #}
}

State_Action_List <- lapply(State_Action_Hash, function(x) as.list(x, all.names = T))
State_Action_Table <- t(data.frame(lapply(State_Action_List, unlist)))
policy <- colnames(State_Action_Table)[apply(State_Action_Table, 1, which.max)]
names(policy) <- rownames(State_Action_Table)
print(policy)

