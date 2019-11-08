import matplotlib.pyplot as plt
from sklearn.datasets.samples_generator import make_blobs
import cv2
import numpy as np
from scipy.stats import multivariate_normal
import argparse
from sklearn.mixture import GaussianMixture


def prep_data():
    X, Y = make_blobs(cluster_std=1, random_state=20, n_samples=1000, centers=10)
    x, y = np.meshgrid(np.sort(X[:, 0]), np.sort(X[:, 1]))
    XY =  np.array([x.flatten(),y.flatten()]).T
    return X, Y, XY

def get_P_of_Data_Given_Param(means, covs, weights, X, method='scipy'):  # P(Data | Param)
    samples = zip(range(0, len(X)), X)
    p = {}
    if method == 'scipy':
        g = [multivariate_normal(mean=means[k], cov=covs[k], allow_singular=False) for k in range(0, len(weights))]
        gaussians = {}
        for index, x in samples:
            gaussians[index] = np.array([g_k.pdf(x) for g_k in g])
        for index, x in samples:
            probabilities = np.multiply(gaussians[index], weights)
            probabilities = probabilities / np.sum(probabilities)
            p[index] = probabilities
    else:
        gmm = GaussianMixture(n_components=len(weights), covariance_type='diag').fit(X)
        gmm.precisions_cholesky_ = 1  # crude way to make GMM think that model is fit
        gmm.means_ = means
        gmm.covariances_ = covs
        gmm.weights_ = weights

        for index, x in samples:
            x = x.reshape(1, -1)
            likelihood_ratio = gmm.predict_proba(x.reshape(1, -1))
            # likelihood_ratio = likelihood_ratio / np.sum(likelihood_ratio)
            p[index] = likelihood_ratio
    return p

def get_P_of_Param_Given_Data(X, gmm_k, method='cv2'): # P(Param | Data)
    if method == 'cv2':
        print('cv2 training gmm of {0} kernels and {1} samples'.format(gmm_k, X.shape[0]))
        em = cv2.ml.EM_create()
        em.setClustersNumber(gmm_k)
        em.setCovarianceMatrixType(cv2.ml.EM_COV_MAT_DIAGONAL)
        em.trainEM(X)
        gmm = em
    else:
        gmm = GaussianMixture(n_components=gmm_k, covariance_type='diag', max_iter=1000).fit(X)
    return gmm

def plot_gaussians(means, covs, query_points):
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

def fisher_vector_scipy(covs, gaussians):
    s0, s1, s2 = {}, {}, {}

    for k in range(0, len(weights)):
        s0[k], s1[k], s2[k] = 0, 0, 0
        for index, x in samples:
            probabilities = np.multiply(gaussians[index], weights)
            probabilities = probabilities / np.sum(probabilities)
            s0[k] = s0[k] + np.float32([1]) * probabilities[k]
            s1[k] = s1[k] + np.power(np.float32(x), 1) * probabilities[k]
            s2[k] = s2[k] + np.power(np.float32(x), 2) * probabilities[k]
        print(s0, s1, s2)
    T = X.shape[0]
    covs = np.float32([np.diagonal(covs[k]) for k in range(0, covs.shape[0])])
    a = np.float32([((s0[k] - T * weights[k]) / np.sqrt(weights[k])) for k in range(0, len(weights))])
    b = np.float32([(s1[k] - means[k] * s0[k]) / (np.sqrt(weights[k] * covs[k])) for k in range(0, len(weights))])
    c = np.float32(
        [(s2[k] - 2 * means[k] * s1[k] + (means[k] * means[k] - covs[k]) * s0[k]) / (np.sqrt(2 * weights[k]) * covs[k])
         for k in range(0, len(weights))])
    fv = np.concatenate([np.concatenate(a), np.concatenate(b), np.concatenate(c)])
    v = np.sqrt(abs(fv)) * np.sign(fv)
    # power-normalization
    v = v / np.sqrt(np.dot(v, v))
    print('cv2 gmm fisher vector', v)

def fisher_vector_sklearn():
    gmm = GaussianMixture(n_components=gmm_k, covariance_type='diag', max_iter=1000).fit(X)
    print(gmm.weights_)
    print(weights)
    X_matrix = X.reshape(-1, X.shape[-1])
    likelihood_ratio = gmm.predict_proba(X_matrix)
    norm_dev_from_modes = np.tile(X[:, None, :], (1, gmm_k, 1))
    np.subtract(norm_dev_from_modes, gmm.means_, out=norm_dev_from_modes)
    var = np.diagonal(gmm.covariances_)
    np.divide(norm_dev_from_modes, var, out=norm_dev_from_modes)

    # mean deviation
    mean_dev = np.multiply(likelihood_ratio[:, :, None], norm_dev_from_modes).mean(
        axis=0)  # (n_images, n_kernels, n_feature_dim)
    mean_dev = np.multiply(1 / np.sqrt(gmm.weights_[:, None]), mean_dev)  # (n_images, n_kernels, n_feature_dim)

    # covariance deviation
    cov_dev = np.multiply(likelihood_ratio[:, :, None], norm_dev_from_modes ** 2 - 1).mean(axis=0)
    cov_dev = np.multiply(1 / np.sqrt(2 * gmm.weights_[:, None]), cov_dev)
    # fisher_vectors
    fisher_vectors = np.concatenate([mean_dev, cov_dev], axis=1)
    # normalize
    fisher_vectors = np.sqrt(np.abs(fisher_vectors)) * np.sign(fisher_vectors)  # power normalization
    fisher_vectors = fisher_vectors / np.linalg.norm(fisher_vectors)

    print('sklearn gmm fisher vector', fisher_vectors)
    plt.show()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fisher Vector compute')
    parser.add_argument('--gmm_k', type=int, required=False, default=10, help='number of gmm kernels')
    parser.add_argument('--data_dir', type=str, required=True, help='data directory')
    parser.add_argument('--samples', type=str, required=False, default='all', help='number of samples for training gmm')
    parser.add_argument('--train_gmm', type=bool, required=False, default=False, help='train gmm or load existing?')
    parser.add_argument('--compute_sift', type=bool, required=False, default=False, help='compute and store sift?')
    parser.add_argument('--root_sift', type=bool, required=False, default=False, help='sift norm on?')
    parser.add_argument('--compute_fv', type=bool, required=False, default=False, help='compute fv afresh ?')
    parser.add_argument('--pca', type=bool, required=False, default=False, help='reduce dimensions of SIFT Descs ?')


    X, Y, XY_Grid = prep_data()
    # XY = np.append(X, Y, axis=0)
    gmm_k = 10
    # means, covs, weights = train_gmm_cv2(X, gmm_k)
    gmm_method = 'cv2'
    gmm = get_P_of_Param_Given_Data(X, gmm_k, method=gmm_method)
    means = gmm.means_ if gmm_method == 'sklearn' else np.float32(gmm.getMeans())
    covs = gmm.covariances_ if gmm_method == 'sklearn' else np.float32(gmm.getCovs())
    weights = gmm.weights_ if gmm_method == 'sklearn' else np.float32(gmm.getWeights())[0]

    posteriors_scipy = get_P_of_Data_Given_Param(means, covs, weights, X, method='scipy')
    pp = np.vstack(posteriors_scipy.values())
    r = np.argmax(pp, axis=1)


    posteriors_sklearn = get_P_of_Data_Given_Param(means, covs, weights, X, method='sklearn')
    r2 = np.argmax(np.vstack(posteriors_sklearn.values()), axis=1)
    xxx = np.sum(np.abs(r - r2))
    likelihood_ratio = gmm.predict_proba(X)

    print('x')
    query_points = [[0.5, 0.5], [-10, 5]]
