N = 50;
#set.seed(1)
x1 = runif(N, min = -5, max=5)
x = runif(N, min = -5, max=5) 
y = (x*(-.5) + 10) + rnorm(N, mean = 0, sd=3)  

ones = rep(1, N)
points = as.data.frame(cbind(ones, x1, x, y))
#points = read.csv("data.csv", header = FALSE)
colnames(points) = c('ones', 'x1', 'x2', 'y')
#points$x <- (points$x - mean(points$x))/sd(points$x)
#points$y <- (points$y - mean(points$y))/sd(points$y)

plot(points$x,points$y)

num_iterations = 1000
learning_rate = .01

theta_vector = c(0, 0, 0)

N = nrow(points)
X = as.matrix(points[, c(1,2,3)])
Y = as.matrix(points[, 4])

for(i in seq(from = 1, to = num_iterations)){
  theta_vector[1] <- theta_vector[1] - learning_rate * ( (1/N) ) * sum( ( (X %*% theta_vector) - Y) ) 
  #theta_vector[2] <- theta_vector[2] - learning_rate * ( (1/N) * sum( t(X) %*% ((X %*% theta_vector) - Y) ))
  theta_vector[2] <- theta_vector[2] - learning_rate * ( (1/N) * sum( ((X %*% theta_vector) - Y)*X[,2] ))
  theta_vector[3] <- theta_vector[3] - learning_rate * ( (1/N) * sum( ((X %*% theta_vector) - Y)*X[,3] ))
  
  sse = ((t((X %*% theta_vector) - Y)) %*% ((X %*% theta_vector) - Y))/(2*N)
  
  print( sprintf ("After %s iterations error = %4.4f", i, sse ))
  
  abline(theta_vector[1], theta_vector[2], col='lightgrey', lwd=1)
}

print(theta_vector)
abline(theta_vector[1], theta_vector[2], col='red', lwd=6)
#############

abline(lm(y~x1, points), col='blue', lwd=2)
lm(y~ x1 + x2, points) 
