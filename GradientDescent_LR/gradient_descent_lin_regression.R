N = 50;
#set.seed(1)
x = runif(N, min = -10, max=10) 
y = (x*(-.5) + 10) + rnorm(N, mean = 0, sd=3)  

ones = rep(1, N)
points = as.data.frame(cbind(ones, x, y))
#points = read.csv("data.csv", header = FALSE)
colnames(points) = c('ones', 'x', 'y')
points$x <- (points$x - mean(points$x))/sd(points$x)
points$y <- (points$y - mean(points$y))/sd(points$y)

plot(points$x,points$y)

num_iterations = 20
learning_rate = .1

theta_vector = c(0, 0)

N = nrow(points)
X = as.matrix(points[, c(1,2)])
Y = as.matrix(points[, 3])

for(i in seq(from = 1, to = num_iterations)){
  theta_vector[1] <- theta_vector[1] - learning_rate * ( (1/N) ) * sum( ( (X %*% theta_vector) - Y) ) 
  #theta_vector[2] <- theta_vector[2] - learning_rate * ( (1/N) * sum( t(X) %*% ((X %*% theta_vector) - Y) ))
  theta_vector[2] <- theta_vector[2] - learning_rate * ( (1/N) * sum( ((X %*% theta_vector) - Y)*X[,2] ))
  
  sse = ((t((X %*% theta_vector) - Y)) %*% ((X %*% theta_vector) - Y))/(2*N)
  
  print( sprintf ("After %s iterations error = %4.4f", i, sse ))
  
  abline(theta_vector[1], theta_vector[2], col='lightgrey', lwd=1)
}

print(theta_vector)
abline(theta_vector[1], theta_vector[2], col='red', lwd=6)
#############

abline(lm(y~x, points), col='blue', lwd=2)
lm(y~x, points) 
