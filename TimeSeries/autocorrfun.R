# AUTOCORRELATION FUNCTION
# acf(i) = mean(y(i)-mean(y)*(y(i)-mean(y)))/var(y)

# Even though it computes correlation between a vector and lagged version of itself
# The cor function cannot be used for autocorrelation
# 1. autocorrelation function assumes that the mean and variance of the vector (time series here) is constant
# however, cor function will compute mean and variance for every lagged version and that would be different 
 
# following code is a simple example how acf can be calculated (without using acf function)

# create a time series y containing 10 values
y <-ts(data = 1:10, start = 1)
# calculate var and mean of the time series y
ts_variance <- var(y)
ts_mean <- mean(y)
N <- length(y)
# create a list ac_vals to save autocorrelation values for each lag
ac_vals <- rep(NA, N)
# following loop with calcular autocorrelation for each lag 0 to N (0 means no lag, so autocorrelation should be 1)
for(lag in 0:N-1){
  Y <- ts.union(y, lag(y, k =  lag))
  ac_vals[lag+1] <- (sum((Y[, 1] - ts_mean) * (Y[, 2] - ts_mean), na.rm = T)/(N-1)) / ts_variance
}
ac_vals
# the output is same as acf
acf_vals <- acf(y, plot=F)
all.equal(ac_vals, as.double(acf_vals$acf))
# TRUE
