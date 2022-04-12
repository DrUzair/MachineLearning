import random
from collections import namedtuple

path = namedtuple('path', 'from_ to_')


class Agent:
    def __init__(self,
                 env,
                 goal_state,
                 explore=0.9,
                 discount_rate=0.9,
                 learning_rate=0.1,
                 iterations=1000,
                 seed=2):
        self.gamma = discount_rate
        self.alpha = learning_rate
        self.env = env
        self.Q = {}
        self.len_path_to_goal = 0
        self.goal_state = goal_state
        self.explore_or_exploit = explore
        self.iterations = iterations
        random.seed(seed)

    def update_Q(self, action, reward):
        future_paths = [p for p in self.Q.keys if p._from == action[1]]
        # max_value_future_path =
        self.Q[action] = reward + self.gamma * self.Q[action] - self.Q[action]

    def learn(self):
        for i in range(self.iterations):
            from_ = random.choice(range(len(self.env.states)))
            # Explore or exploit
            x = random.random()
            print(x)
            if x > self.explore_or_exploit: # Explore
                to_ = random.choice(range(len(self.env.states)))
                print('Exploring path ', path(from_, to_))
            else: # exploit
                max_quality = 0
                to_ = from_
                for fs, ts in self.Q.keys():
                    if fs == from_ and (max_quality < self.Q[(fs,ts)]):
                        max_quality = self.Q[path(fs,ts)]
                        to_ = ts
                print('Exploiting path ', path(from_, to_))
            action = path(from_, to_)
            # get reward
            R = self.env.reward(action)
            # update quality of action
            #
            if action not in self.Q.keys():
                self.Q[action] = 0
            # quality of a state is equal to the action
            # that can be taken in this state
            current_state_quality = self.Q[action]
            future_paths = []  # [p for p  in self.Q.keys() if p.from_ == action.to_]
            for p in self.Q.keys():
                if p.from_ == action.to_:
                    future_paths.append(p)
            if len(future_paths) == 0:
                future_state_quality = 0
            else:
                future_state_quality = max(
                    [self.Q[p] for p in future_paths])  # max achievable quality of possible actions in future state
            # max_value_future_path =
            td = R + (self.gamma * future_state_quality) - current_state_quality
            self.Q[action] = self.Q[action] + (self.alpha * td)
        print(self.Q)

    def go(self, from_):
        max_q_action = 0
        max_q_state = None
        for to_ in self.env.states:
            if self.Q[path(from_, to_)] > max_q_action:
                max_q_action = self.Q[path(from_, to_)]
                max_q_state = to_
        print(from_, max_q_state)
        if max_q_state == self.goal_state:
            return  # reached
        # quit recursion if path is too long
        self.len_path_to_goal += 1
        if self.len_path_to_goal > 20:
            return
        self.go(from_=max_q_state)

    def tester(self):
        self.matrix = []
        for from_ in self.env.states:
            v = []
            for to_ in self.env.states:
                v.append(self.Q[path(from_, to_)])
            self.matrix.append({from_: v})
        for x in self.matrix:
            print(x)
