setwd('C:\\RnD\\Dev\\gradient_descent')
list.files(getwd())


step_gradient_matrix_calculus <- function(b_current, m_current, points, learningRate){

  X = as.matrix(points[, c(1,2)])
  Y = as.matrix(points[, 3])
  
  inv_X = solve(t(X)%*% X)
  
  X_Y = ( t(X) %*% Y)
  
  theta_vector = inv_X %*% X_Y
  
  return (theta_vector)
}

compute_error <- function(b, m, points){
  
  X = points[, 1]
  Y = points[, 2]
  
  sse = t(Y - (X*b + m)) %*% (Y- (X*b + m))
  
  return (sse)
}

run_gradient_descent <- function(points){
  plot(points$x, points$y)
  print ("Running...")
  
  num_iterations = 100
  learning_rate = .001
  last_b = 0# initial y-intercept guess
  last_m =  0 # initial slope guess
  
  
  for(i in seq(from = 1, to = num_iterations)){
    b_m = step_gradient_matrix_calculus(last_b, last_m, points, learning_rate)
    last_b = b_m[1]
    last_m = b_m[2]
    sse = compute_error(last_b, last_m, points)
    abline(last_b, last_m)
    print( sprintf ("After %i iterations b = %s, m = %s, error = %3.6f", i, last_b, last_m, sse) )
  }
  last_b = b_m[1]
  last_m = b_m[2]
  abline(last_b, last_m, col='red')
}


N = 200;

a = rep(1, N)
x = rnorm(N, mean = 10, sd=10) 
y = x + rnorm(N, mean = 10, sd=1)  * -1
points = as.data.frame(cbind(a, x, y))
#points = read.csv("soup_data.csv", sep=',', header = TRUE)
colnames(points) = c('a', 'x', 'y')
points$x <- (points$x - mean(points$x))/sd(points$x)
points$y <- (points$y - mean(points$y))/sd(points$y)

last_b = 0;
last_m = 0;


run_gradient_descent(points)
#############
abline(lm(y~x, points), col='blue')
lm(y~x, points) 
