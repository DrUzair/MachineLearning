import numpy as np
class Agent():
    # Initialize alpha, gamma, states, actions, rewards, and Q-values
    def __init__(self, alpha, gamma, location_to_state, actions, rewards, state_to_location, Q):

        self.gamma = gamma
        self.alpha = alpha

        self.location_to_state = location_to_state
        self.actions = actions
        self.rewards = rewards
        self.state_to_location = state_to_location

        self.Q = Q  # V(s) in Bellman's equation

    # Training the robot in the environment
    def training2(self, end_location, iterations):

        rewards_new = np.copy(self.rewards)  # R(s, a) in Bellman Equation

        ending_state = self.location_to_state[end_location]
        rewards_new[ending_state, ending_state] = 999

        for i in range(iterations):
            current_state = np.random.randint(0, 9)

            playable_actions = [a for a in range(9) if rewards_new[current_state, a] != 0]

            eps = 0.5
            if np.random.random() <= eps:
                # explore
                next_state = np.random.choice(playable_actions)
            else:
                # exploit
                next_state = playable_actions[np.argmax(self.Q[current_state, playable_actions])]
                # print('current_state',current_state, 'playable_actions', playable_actions, 'self.Q[current_state,]', self.Q[current_state,playable_actions],'next_state', next_state)

            r = rewards_new[current_state, next_state]
            TD = r + self.gamma * np.max(self.Q[next_state]) - self.Q[current_state, next_state]
            # Q_t = Q_t-1 + alpha * TD_t_(a,s)
            self.Q[current_state, next_state] = self.Q[current_state, next_state] + self.alpha * TD

    def trainQ(self, end_location, iterations):
        rewards_new = np.copy(self.rewards)

        ending_state = self.location_to_state[end_location]

        rewards_new[ending_state, ending_state] = 5 # THIS LINE IS VERY IMPORTANT

        state_trials = {}
        for i in range(iterations):
            current_state = np.random.randint(0, len(self.actions))


            playable_actions = self.actions#[]
            # playable_actions = []
            # for j in self.actions:
            #    if rewards_new[current_state, j] > 0:
            #        playable_actions.append(j)

            # explore
            best_action = np.random.choice(playable_actions)
            eps = 0.5
            explore = True
            if np.random.uniform(0, 1) <= eps or len(playable_actions) == 1:
                # exploit
                explore = False
                best_value_action_index = np.argmax(self.Q[current_state, playable_actions])
                best_action = playable_actions[best_value_action_index]

            R_sa = rewards_new[current_state, best_action]

            if current_state in [0, 1, 2, 3]:
                if not explore:
                    print(
                        f"iteration: {i}, Exploiting\ncurrent_state: {current_state}, playable_actions: {playable_actions} "
                        f"\nQ[current_state, playable_actions] {self.Q[current_state, playable_actions]}"
                        #f"\nbest_value_action_index = np.argmax(Q[current_state, playable_actions] = {np.argmax(self.Q[current_state, playable_actions])}"
                        f"\n best_action: {best_action}, R_sa: {rewards_new[current_state, best_action]}")
                else:
                    print(
                        f"iteration: {i}, Exploring\n current_state: {current_state}, playable_actions: {playable_actions} "
                        f"\n Q[current_state, playable_actions] {self.Q[current_state, playable_actions]}"
                        f"\n best_action: {best_action}, R_sa: {rewards_new[current_state, best_action]}")

            next_state = best_action # from current state, what will be the next state if agent takes best_action
            if (current_state, next_state) in state_trials.keys():
                state_trials[(current_state, next_state)] = state_trials[(current_state, next_state)] + 1
            else:
                state_trials[(current_state, next_state)] = 1
            Q_sprime_aprime = np.max(self.Q[next_state, :]) # The quality_of_best_action
            Q_s_a = self.Q[current_state, best_action] # The state-value for the current_state if agent takes best_action
            TD = R_sa + self.gamma * Q_sprime_aprime - Q_s_a # Temporal difference

            if current_state in [0, 1, 2, 3]:
                print(f"Q_s'_a': {np.round(Q_sprime_aprime,2)}, Q_s_a {np.round(Q_s_a, decimals=2)}, \nTD = R_sa + gamma * Q_sprime_aprime - Q_s_a =  {np.round(TD, 2)}")
                print(f"-------befor--Q---------\n{np.ndarray.round(self.Q, decimals=2)}")

            self.Q[current_state, best_action] = self.Q[current_state, best_action] + self.alpha * TD
            if current_state in [0, 1 , 2, 3]:
                print(f"Q_s_a = Q_s_a + alpha * TD = {np.round(self.alpha * TD, 2)}")
                print(f"-------after--Q---------\n{np.ndarray.round(self.Q, decimals=2)}")
                print(';')
        print(f"state_trials\n{sorted(state_trials.items())}")
    # Get the optimal route
    def get_optimal_route(self, start_location, end_location, next_location, route):
        while (next_location != end_location):
            starting_state = self.location_to_state[start_location]
            next_state = np.argmax(self.Q[starting_state,])
            next_location = self.state_to_location[next_state]
            route.append(next_location)
            start_location = next_location
            if len(route) > 9:
                break
        return route