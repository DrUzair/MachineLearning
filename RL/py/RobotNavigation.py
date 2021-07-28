import numpy as np
from numpy import savetxt
from Agent import Agent
location_to_state = {
    'L0': 0,
    'L1': 1,
    'L2': 2,
    'L3': 3,
    'L4': 4,
    'L5': 5,
    'L6': 6,
    'L7': 7,
    'L8': 8
}
# Maps indices to locations
state_to_location = dict((state, location) for location, state in location_to_state.items())
# Define the actions
actions = [0, 1, 2, 3, 4, 5, 6, 7, 8]
# Define the rewards
rewards = np.array([

    [0, 1, 0, 0, 0, 0, 0, 0, 0],  # S0, L0
    [1, 0, 1, 0, 1, 0, 0, 0, 0],  # S1, L1
    [0, 1, 0, 0, 0, 1, 0, 0, 0],  # S2, L2
    [0, 0, 0, 0, 0, 0, 1, 0, 0],  # S3, L3
    [0, 1, 0, 0, 0, 0, 0, 1, 0],  # S4, L4
    [0, 0, 1, 0, 0, 0, 0, 0, 0],  # S5, L5
    [0, 0, 0, 1, 0, 0, 0, 1, 0],  # S6, L6
    [0, 0, 0, 0, 1, 0, 1, 0, 1],  # S7, L7
    [0, 0, 0, 0, 0, 0, 0, 1, 0]   # S8, L8
])

# Initialize parameters
gamma = 0.75  # Discount factor
alpha = 0.9  # Learning rate
np.random.seed(11)
end_location = 'L5'
Q = np.array(np.zeros([9,9]))
agent = Agent(alpha, gamma, location_to_state, actions, rewards, state_to_location, Q)
agent.trainQ(end_location = end_location, iterations= 450)
savetxt('Q.csv', np.ndarray.round(agent.Q, decimals=2), delimiter=',', fmt= '%10.2f')
print("agent is ready !")


location_to_dest = {
    'L0': ['L0', 'L1', 'L2', 'L5'],
    'L1': ['L1', 'L2', 'L5'],
    'L2': ['L3', 'L5'],
    'L3': ['L3', 'L6', 'L7', 'L4', 'L1', 'L2', 'L5'],
    'L4': ['L4', 'L1', 'L2', 'L5'],
    'L5': ['L5'],
    'L6': ['L6', 'L7', 'L4', 'L1', 'L2', 'L5'],
    'L7': ['L7', 'L4', 'L1', 'L2', 'L5'],
    'L8': ['L8', 'L7', 'L4', 'L1', 'L2', 'L5']
}

for start_location, correct_route in location_to_dest.items():
    end_location = 'L5'
    route = [start_location]
    next_location = start_location
    route = agent.get_optimal_route(start_location, end_location, next_location, route)
    #if correct_route != route:
    print(f"start_location: {start_location}, \ncorct_route: {correct_route}, \nagent_route: {route}")
    #print(route)
