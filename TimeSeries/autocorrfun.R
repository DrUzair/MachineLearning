# AUTOCORRELATION FUNCTION
# acf(i) = mean(y(i)-mean(y)*(y(i)-mean(y)))/var(y)

# Even though it computes correlation between a vector and lagged version of itself
# The cor function cannot be used for autocorrelation
# 1. autocorrelation function assumes that the mean and variance of the vector (time series here) is constant
# however, cor function will compute mean and variance for every lagged version and that would be different 
 
# following code is a simple example how acf can be calculated (without using acf function)

x <- as.vector(1:10)

as.vector(lag(x,3))

acf(x, plot=F)
y <- 1:10

y <-ts(data = 1:10, start = 1)

ts_variance <- var(y)
ts_mean <- mean(y)
N <- length(y)

ac_vals <- rep(NA, N)
for(lag in 0:N-1){
  Y <- ts.union(y, lag(y, k =  lag))
  ac_vals[lag+1] <- (sum((Y[, 1] - m) * (Y[, 2] - m), na.rm = T)/(N-1)) / ts_variance
}
ac_vals
# the output is same as acf
acf_vals <- acf(y, plot=F)
all.equal(ac_vals, as.double(acf_vals$acf))
# TRUE