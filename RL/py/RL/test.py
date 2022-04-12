
from Environment import Environment
from Agent import Agent
from Agent import path

e = Environment()
e.add_path(path(0, 1))
e.add_path(path(1, 2))
e.add_path(path(2, 3))
e.add_path(path(3, 4))
e.add_path(path(4, 0))
e.add_path(path(4, 5))
e.add_path(path(5, 0))
e.add_path(path(5, 1))
e.add_path(path(5, 2))
e.add_path(path(5, 3))
e.add_path(path(5, 4))
e.add_path(path(5, 5), 1.1)

a = Agent(env=e, goal_state=5, explore=0.1, iterations=1000)
a.learn()
a.tester()
for state in e.states:
    print('from ', state)
    a.path_length = 0
    a.go(state)
