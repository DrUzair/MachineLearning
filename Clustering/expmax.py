'''
Author: Uzair Ahmad
'''

from scipy.stats import multivariate_normal
import numpy as np

class ExpectationMaximizer:

    def __init__(self, X, k=2, random_state=1):
        """initialize an object of ExpectationMaximizer by
      1. initializing prior probabilities of each cluster as uniform distribution.
      2. randomly selecting K samples as initial cluster-centers
      3. initializing covariance matrix as
        Keyword arguments:
        K -- the number of clusters (default 0.0)
        X -- the design matrix n rows m columns
        """
        self.cluster_assignments = None
        self.posteriors = None
        self.K = k
        self.X = X
        self.N = X.shape[0]  # number of data points
        self.iteration = 0
        np.random.seed(random_state)

    def maximization(self):
        """Performs the likelihood - maximization step
          1. create an NxK matrix to store likelihood values --> P(X | Ci)
          2. For each cluster,
            calculates pdf w.r.t. corresponding mean and covariance
            retrieves likelihood from the pdf          
        """
        # 1. create an NxK matrix to store likelihood values --> P(X | Ci)
        self.likelihood = np.zeros((self.N, self.K))
        for Ci in range(self.K):
            # 2. calculates pdf w.r.t. corresponding mean and covariance
            distribution = multivariate_normal(mean=self.mu_estimates[Ci],
                                               cov=self.cov_estimates[Ci],
                                               allow_singular=True)
            # retrieves likelihood from the pdf
            self.likelihood[:, Ci] = distribution.pdf(self.X)  # P(X | Ci) --> Likelihood

    def expectation(self):
        """Performs the expectation step
        [If the model parameters (mu, cov) are true, the
                1. For each cluster,
                  update estimates of cluster-centers
                  update covariance matrix
                  update priors for each cluster
        """
        if self.iteration == 0: # guess priors and cluster-distribution parameters
            # initialize prior probabilities as uniform distribution
            self.priors = np.full(shape=self.K, fill_value=1 / self.K)
            # randomly select K examples as mean of each cluster from dataset
            self.mu_estimates = [self.X[row_index, :] for row_index in
                                 np.random.randint(low=0, high=self.N, size=self.K)]
            # covariance matrix estimate from dataset
            self.cov_estimates = [np.cov(self.X.T) for _ in range(self.K)]
            self.iteration += 1

        else: # Calculate maximum-likelihood P(Ci | X) and update model parameters (mu, cov) and priors
            # calculate join probability --> P(X, C) = P(X | Ci) * P(Ci)
            joint_prob = (self.likelihood * self.priors)  # P(X, Ci) = P(X | Ci) * P(Ci)
            # calculate total evidence (a.k.a marginal probability) --> P(X)
            marginal_prob = joint_prob.sum(axis=1)[:, np.newaxis]  # P(X)
            # calculate posterior (class conditional probabilities for each datapoint) --> P(Ci | X) = P(X,C)/P(X)
            # maximum-likelihood that X is generated by Ci
            self.posteriors = joint_prob / marginal_prob  # P(Ci | X)
            # Update model parameters for each Ci
            for Ci in range(self.K):  # for each distribution (cluster)
                posterior_Ci = self.posteriors[:, [Ci]]  # P(Ci | X)
                # update mean estimate
                self.mu_estimates[Ci] = (self.X * posterior_Ci).sum(axis=0) / posterior_Ci.sum()
                # update covariance
                self.cov_estimates[Ci] = np.cov(self.X.T,
                                               aweights=posterior_Ci.flatten(), # weight of each datapoint
                                               )
            # update cluster assignments
            self.cluster_assignments = np.argmax(self.posteriors, axis=1)
            # update priors
            self.priors = np.sum(self.posteriors, axis=0) / self.N


    def run(self, iterations=10):
        """Performs the Epectation-maximization iterations
        """
        for i in range(iterations):
            self.expectation()
            self.maximization()
        return self


X = np.array([
    [1, 2, 3, 4,  8, 9, 10, 11,  -1, -5, -7, -3, -2, -1, -4, -3, -2]
]).T
#
# # X = np.array([
# #     [1, 2, 3, 4, -1, -2, -3, -4, -1, -2, -3, -4, 1, 2, 3, 4],
# #     [1, 2, 3, 4,  1,  2,  3,  4, -1, -2, -3, -4, -1, -2, -3, -4]
# # ]).T
em = ExpectationMaximizer(X=X, k=2).run(10)
print(em.mu_estimates)
print(em.cluster_assignments)
print(em.priors)
#
# centroids = np.array(em.mu_estimates).argsort()
# print(centroids)
