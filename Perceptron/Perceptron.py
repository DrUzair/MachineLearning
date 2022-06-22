import numpy as np
from sklearn.datasets import make_blobs
import pandas as pd
from pandas import DataFrame
import matplotlib.pyplot as plt
from mlxtend.plotting import plot_decision_regions


def prep_data():
    X, labels = make_blobs(n_samples=100, centers=2, n_features=2, cluster_std=1, random_state=3)
    # labels = np.where(labels == 0, -1, 1)
    # df = DataFrame(dict(constant=np.repeat(1, len(X)), input_1=X[:,0], input_2=X[:,1], label=labels))
    df = DataFrame(dict(input_1=X[:, 0], input_2=X[:, 1], label=labels))
    print(df.head())
    colors = {1: 'blue', 0: 'red'}
    fig, ax = plt.subplots()
    grouped = df.groupby('label')
    for key, group in grouped:
        group.plot(ax=ax, kind='scatter', x='input_1', y='input_2', label=key, color=colors[key])
    plt.show()
    # y = np.where(labels == 0, -1, 1)
    y = labels
    # sepal length and petal length # from sklearn.datasets.samples_generator import make_blobs
    X = df.iloc[0:100, [0, 1]].values
    return X, y


class Perceptron(object):
    """Perceptron class

    Usage:
    ppn = Perceptron(epochs=10, lr=0.01)
    ppn.train(X, y)
    ppn.plot_delta()

    Author: Uzair Ahmad
    """

    def __init__(self, lr=0.1, epochs=50):
        self.lr = lr
        self.epochs = epochs

    def predict(self, X):
        return np.where(np.dot(X, self.w_) >= 0, 1, -1)

    def train(self, X, y):
        # Initialize weights
        self.w_ = np.array([-2.7, 0]) #, np.zeros(2)
        self.errors = []
        for epoch in range(self.epochs):
            # Calculate classification errors
            self.errors.append(np.sum(np.abs(y - self.predict(X))))
            # self.plot_dr(X, y, title='epoch {0} \n w_1={1} w_2={2} Errors={3}'.format(epoch, np.round(self.w_[0], 2),
            #                                                                           np.round(self.w_[1], 2),
            #                                                                           int(np.sum(
            #                                                                               np.abs(
            #                                                                                   y - self.predict(X))))))
            # print(epoch, self.w_)

            if np.sum(np.abs(y - self.predict(X))) == 0:
                break


            for i, example in enumerate(zip(X, y)):
                xi, yi = example
                y_hat = self.predict(xi)
                update = np.zeros(2)
                if yi != y_hat:
                    # calculate update
                    update = self.lr * (yi - y_hat) * xi
                    # Update w
                    self.w_ += update

                    self.plot_dr(X, y,
                                 title='epoch {0} - #{1} \n w_1={2} w_2={3} Errors={4}'
                                      .format(epoch,
                                              i,
                                              np.round(self.w_[0], 2),
                                              np.round(self.w_[1], 2),
                                              int(np.sum(np.abs(y - self.predict(X))))))
                print('Epoch {}, i {}, example {}, y_hat {}, update {}, w {}'.format(epoch, i, example, y_hat, update, self.w_))
        return self

    def plot_dr(self, X, y, title):
        plot_decision_regions(X, y, clf=self)
        plt.title(title)
        plt.xlabel('input 1')
        plt.ylabel('input 2')
        plt.show()

    def plot_delta(self):
        plt.plot(range(1, len(self.errors) + 1), self.errors, marker='o')
        plt.title('Errors / Epoch')
        plt.xlabel('Epochs')
        plt.ylabel('Error Count')
        plt.show()

# X, y = prep_data()
X = np.array([[2,4],
              [2,6],
              [4,2],
              [2,3]]
             )
y = np.array([1,1,-1,-1])
np.random.seed(1000)
ppn = Perceptron(epochs=5, lr=0.1)
ppn.train(X, y)
ppn.plot_delta()
