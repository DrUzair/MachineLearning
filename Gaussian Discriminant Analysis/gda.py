import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import matplotlib.colors as colors
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits import mplot3d
from sklearn import linear_model, datasets
import seaborn as sns
import itertools


def multivariate_gaussian_pdf(X, MU, SIGMA):
    '''Returns the pdf of a nultivariate gaussian distribution
     - X, MU are p x 1 vectors
     - SIGMA is a p x p matrix'''
    # Initialize and reshape
    X = X.reshape(-1, 1)
    MU = MU.reshape(-1, 1)
    p, _ = SIGMA.shape

    # Compute values
    SIGMA_inv = np.linalg.inv(SIGMA)
    denominator = np.sqrt((2 * np.pi) ** p * np.linalg.det(SIGMA))
    exponent = -(1 / 2) * ((X - MU).T @ SIGMA_inv @ (X - MU))

    # Return result
    return float((1. / denominator) * np.exp(exponent))

def calculate_boundary(X,MU_k,MU_l, SIGMA,pi_k,pi_l):
    return (np.log(pi_k / pi_l) - 1/2 * (MU_k + MU_l).T @ np.linalg.inv(SIGMA) @ (MU_k - MU_l) + X.T @ np.linalg.inv(SIGMA)@ (MU_k - MU_l)).flatten()[0]



def LDA_score(X,MU_k,SIGMA,pi_k):
    #Returns the value of the linear discriminant score function for a given class "k" and
    # a given x value X
    return (np.log(pi_k) - 1/2 * (MU_k).T @ np.linalg.inv(SIGMA)@(MU_k) + X.T @ np.linalg.inv(SIGMA)@ (MU_k)).flatten()[0]


def predict_LDA_class(X, MU_list, SIGMA, pi_list):
    # Returns the class for which the the linear discriminant score function is largest
    scores_list = []
    classes = len(MU_list)

    for p in range(classes):
        score = LDA_score(X.reshape(-1, 1), MU_list[p].reshape(-1, 1), sigma, pi_list[0])
        scores_list.append(score)

    return np.argmax(scores_list)

iris = sns.load_dataset("iris")
sns.pairplot(iris, hue="species")

iris = iris.rename(index = str, columns = {'sepal_length':'1_sepal_length','sepal_width':'2_sepal_width', 'petal_length':'3_petal_length', 'petal_width':'4_petal_width'})
sns.FacetGrid(iris, hue="species", size=6) .map(plt.scatter,"1_sepal_length", "2_sepal_width", )  .add_legend()
plt.title('Scatter plot')
df1 = iris[["1_sepal_length", "2_sepal_width",'species']]

mu_list = np.split(df1.groupby('species').mean().values,[1,2])
sigma = df1.cov().values
pi_list = df1.iloc[:,2].value_counts().values / len(df1)


def plot_boundaries():
    # Initialize seaborn facetplot
    g = sns.FacetGrid(iris, hue="species", height=10, palette='colorblind').map(plt.scatter, "1_sepal_length",
                                                                                "2_sepal_width", ).add_legend()
    my_ax = g.ax  # Retrieving the faceplot axes
    N = 50
    X = np.linspace(3, 8, N)
    Y = np.linspace(1.5, 5, N)
    X, Y = np.meshgrid(X, Y)
    for i,v in enumerate(itertools.combinations([0,1,2],2)):
        mu = mu_list[i]
        Sigma = sigma
        # Computing the predicted class function for each value on the grid
        zz = np.array([predict_LDA_class(np.array([xx, yy]).reshape(-1, 1), mu_list, Sigma, pi_list)
                       for xx, yy in zip(np.ravel(X), np.ravel(Y))])

        # Reshaping the predicted class into the meshgrid shape
        Z = zz.reshape(X.shape)

        # Plot the filled and boundary contours
        my_ax.contourf(X, Y, Z, 2, alpha=.1, colors=('blue', 'green', 'red'))
        my_ax.contour(X, Y, Z, 2, alpha=1, colors=('blue', 'green', 'red'))

    # Addd axis and title
    my_ax.set_xlabel('X')
    my_ax.set_ylabel('Y')
    my_ax.set_title('LDA and boundaries')

    plt.show()


def plot_distributions():
    # Our 2-dimensional distribution will be over variables X and Y
    N = 100
    X = np.linspace(3, 8, N)
    Y = np.linspace(1.5, 5, N)
    X, Y = np.meshgrid(X, Y)

    # fig = plt.figure(figsize = (10,10))
    # ax = fig.gca()
    color_list = ['Blues', 'Greens', 'Reds']
    my_norm = colors.Normalize(vmin=-1., vmax=1.)

    g = sns.FacetGrid(iris, hue="species", size=10, palette='colorblind').map(plt.scatter, "1_sepal_length",
                                                                              "2_sepal_width", ).add_legend()
    my_ax = g.ax

    for i, v in enumerate(itertools.combinations([0, 1, 2], 2)):
        mu = mu_list[i]
        Sigma = sigma

        # Computing the cost function for each theta combination
        zz = np.array([multivariate_gaussian_pdf(np.array([xx, yy]).reshape(-1, 1), mu, Sigma)
                       for xx, yy in zip(np.ravel(X), np.ravel(Y))])

        bb = np.array([calculate_boundary(np.array([xx, yy]).reshape(-1, 1), mu_list[v[0]].reshape(-1, 1),
                                          mu_list[v[1]].reshape(-1, 1), sigma, .33, .33)
                       for xx, yy in zip(np.ravel(X), np.ravel(Y))])

        # Reshaping the cost values
        Z = zz.reshape(X.shape)
        B = bb.reshape(X.shape)

        # Plot the result in 3D
        my_ax.contour(X, Y, Z, 3, cmap=color_list[i], norm=my_norm, alpha=.3)

        my_ax.contour(X, Y, B, levels=[0], cmap=color_list[i], norm=my_norm)

    # Adjust the limits, ticks and view angle
    my_ax.set_xlabel('X')
    my_ax.set_ylabel('Y')
    my_ax.set_title('LDA: gaussians of each class and boundary lines')

    plt.show()


plot_distributions()