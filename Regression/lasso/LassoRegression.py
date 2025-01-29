import numpy as np

class LassoRegression:
    def __init__(self, learning_rate=0.01, lambda_param=0.1, num_iterations=1000):
        self.learning_rate = learning_rate
        self.lambda_param = lambda_param
        self.num_iterations = num_iterations
        self.theta = None

    def soft_threshold(self, rho, lambda_param):
        """ Soft-thresholding function used for coordinate descent """
        if rho < -lambda_param:
            return rho + lambda_param
        elif rho > lambda_param:
            return rho - lambda_param
        else:
            return 0

    def fit(self, X, y):
        """ Train the model using coordinate descent """
        m, n = X.shape
        self.theta = np.zeros(n)
        
        for _ in range(self.num_iterations):
            for j in range(n):
                # Compute rho
                residual = y - (X @ self.theta) + X[:, j] * self.theta[j]
                rho = np.dot(X[:, j], residual) / m

                # Update coefficient using soft-thresholding
                self.theta[j] = self.soft_threshold(rho, self.lambda_param)

    def predict(self, X):
        """ Make predictions """
        return np.dot(X, self.theta)

    def mse(self, y_true, y_pred):
        """ Compute Mean Squared Error """
        return np.mean((y_true - y_pred) ** 2)

# Example Usage
if __name__ == "__main__":
    # Generate synthetic dataset
    np.random.seed(42)
    X = np.random.rand(100, 5)
    true_theta = np.array([2, -3, 0, 5, 0])  # Some coefficients are zero (sparse)
    y = X @ true_theta + np.random.randn(100) * 0.5  # Add noise

    # Train Lasso regression
    lasso = LassoRegression(lambda_param=0.1, num_iterations=1000)
    lasso.fit(X, y)
    
    # Predictions
    y_pred = lasso.predict(X)
    
    # Performance
    print("Trained Coefficients:", lasso.theta)
    print("MSE:", lasso.mse(y, y_pred))
