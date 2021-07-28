import numpy as np
from numpy import savetxt
from Agent import Agent
location_to_state = {
    'L0': 0,
    'L1': 1,
    'L2': 2,
    'L3': 3
}
# Maps indices to locations
state_to_location = dict((state, location) for location, state in location_to_state.items())
# Define the actions
actions = [0, 1, 2, 3]
# Define the rewards
rewards = np.array([
        # A0, A1, A2, A3,
        [0, 1, 1, 0], #S0
        [1, 0, 1, 1], #S1
        [1, 1, 0, 1], #S2
        [0, 1, 1, 0]  #S3

])

# Initialize parameters
gamma = 0.75  # Discount factor
alpha = 0.9   # Learning rate

np.random.seed(11)

end_location = 'L3'

Q = np.array(np.zeros([4,4]))

agent = Agent(alpha, gamma, location_to_state, actions, rewards, state_to_location, Q)

agent.trainQ(end_location = end_location, iterations= 200)
savetxt('Q_SimpleExample.csv', np.ndarray.round(agent.Q, decimals=4), delimiter=',', fmt= '%10.2f')
print("agent is ready !")

location_to_dest = {
    'L0': ['L0', 'L1', 'L3'],
    'L1': ['L1', 'L3'],
    'L2': ['L2', 'L3'],
    'L3': ['L3'],
}

for start_location, correct_route in location_to_dest.items():
    end_location = 'L3'
    route = [start_location]
    next_location = start_location
    route = agent.get_optimal_route(start_location, end_location, next_location, route)
    #if correct_route != route:
    print(f"start_location: {start_location}, \ncorct_route: {correct_route}, \nagent_route: {route}")
    #print(route)
