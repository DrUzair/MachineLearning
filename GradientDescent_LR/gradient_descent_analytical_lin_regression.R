
  N = 100;
  
  a = rep(1, N)
  x = runif(N, min = 1, max=100) 
  y = (x*(-.510) + 10) + rnorm(N, mean = 0, sd=3)  

  points = as.data.frame(cbind(a, x, y))
  
  colnames(points) = c('a', 'x', 'y')
  #points$x <- (points$x - mean(points$x))/sd(points$x)
  #points$y <- (points$y - mean(points$y))/sd(points$y)
  
  plot(points$x, points$y)
  
  num_iterations = 1
  learning_rate = .001
  last_b = 0# initial y-intercept guess
  last_m =  0 # initial slope guess
  
  X = as.matrix(points[, c(1,2)])
  Y = as.matrix(points[, 3])
    
  inv_X = solve(t(X)%*% X)
    
  X_Y = ( t(X) %*% Y)
    
  theta_vector = inv_X %*% X_Y
    
  sse = t(Y - (X%*%theta_vector)) %*% (Y- (X%*%theta_vector))
  
  abline(theta_vector[1], theta_vector[2])
  print( sprintf ("b = %s, m = %s, error = %3.6f", theta_vector[1], theta_vector[2], sse) )
  
  abline(theta_vector[1], theta_vector[2], col='red', lwd=8)

#############
  abline(lm(y~x, points), col='blue', lwd = 2)
  lm(y~x, points) 

