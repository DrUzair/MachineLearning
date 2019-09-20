import matplotlib.pyplot as plt
from sklearn.datasets.samples_generator import make_blobs
import cv2
import numpy as np
from scipy.stats import multivariate_normal

def prep_data():
    X, Y = make_blobs(cluster_std=1, random_state=20, n_samples=1000, centers=10)
    x, y = np.meshgrid(np.sort(X[:, 0]), np.sort(X[:, 1]))
    XY =  np.array([x.flatten(),y.flatten()]).T
    # fig = plt.figure(figsize=(10,10))
    # ax0 = fig.add_subplot(111)
    # ax0.scatter(X[:,0], X[:,1])
    # # plt.show()

    return X, Y, XY

def train_gmm_cv2(descs, gmm_k):
    print('cv2 training gmm of {0} kernels and {1} samples'.format(gmm_k, descs.shape[0]))
    em = cv2.ml.EM_create()
    em.setClustersNumber(gmm_k)
    em.setCovarianceMatrixType(cv2.ml.EM_COV_MAT_DIAGONAL)
    em.trainEM(descs)
    return (np.float32(em.getMeans()), np.float32(em.getCovs()), np.float32(em.getWeights())[0])

if __name__ == '__main__':
    X, Y, XY_Grid = prep_data()
    # XY = np.append(X, Y, axis=0)
    gmm_k = 10
    means, covs, weights = train_gmm_cv2(X, gmm_k=gmm_k)
    # save to disc
    np.save(str(gmm_k) + "_means.gmm", means)
    np.save(str(gmm_k) + "_covs.gmm", covs)
    np.save(str(gmm_k) + "_weights.gmm", weights)

    g = [multivariate_normal(mean=means[k], cov=covs[k], allow_singular=False) for k in range(0, len(weights))]
    gaussians = {}
    query_points = [[0.5, 0.5], [-10, 5]]
    for index, x in X:
        gaussians[index] = np.array([g_k.pdf(x) for g_k in g])
    fig3 = plt.figure(figsize=(10, 10))
    ax2 = fig3.add_subplot(111)
    for m, c in zip(means, covs):
        multi_normal = multivariate_normal(mean=m, cov=c)
        xy_ = multi_normal.pdf(XY_Grid)
        xy_p = xy_.reshape(len(X), len(X))
        ax2.contour(np.sort(X[:, 0]),
                    np.sort(X[:, 1]),
                    xy_p, colors='black', alpha=0.3)
    for y in query_points:
        ax2.scatter(y[0], y[1], c='orange', zorder=10, s=100)
    ax2.scatter(X[:, 0], X[:, 1])
    plt.show()
    print('x')

    sum_post_probs = np.sum([multivariate_normal(mean=mean, cov=cov).pdf(query_points[0]) for mean, cov in zip(means, covs)])
    prediction = np.argmax(np.divide([multivariate_normal(mean=mean, cov=cov).pdf(query_points[0]) for mean, cov in zip(means, covs)], sum_post_probs))
    print(prediction)
    sum_post_probs = np.sum(
        [multivariate_normal(mean=mean, cov=cov).pdf(query_points[1]) for mean, cov in zip(means, covs)])
    prediction = np.argmax(
        np.divide([multivariate_normal(mean=mean, cov=cov).pdf(query_points[1]) for mean, cov in zip(means, covs)],
                  sum_post_probs))
    print(prediction)
