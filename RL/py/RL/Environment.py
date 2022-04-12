from collections import namedtuple

path = namedtuple('path', 'from_ to_')


class Environment:
    def __init__(self, states=[], paths={}):
        self.states = states
        self.paths = paths

    def add_state(self, name='S'):
        self.states[name] = name

    def add_path(self, path, reward=1):
        if path not in self.paths.keys():  # no duplicates
            self.paths[path] = reward
        if path.from_ not in self.states:
            self.states.append(path.from_)
        if path.to_ not in self.states:
            self.states.append(path.to_)

    def reward(self, action):
        if action in self.paths:
            return self.paths[action]
        else:
            return 0

    def __str__(self):
        e = 'States:\n\t'
        e += ' '.join([str(s) for s in self.states])
        e += '\nPaths:'
        e += ' '.join(['\n ' + str(p) for p in self.paths])
        return e
