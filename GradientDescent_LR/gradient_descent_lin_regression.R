setwd('C:\\RnD\\Dev\\gradient_descent')
list.files(getwd())


compute_error_for_line_given_points <- function(b, m, points){
  totalError = 0
  N = nrow(points)
  for (i in seq(from = 1, to = N)){
    x = points[i, 1]
    y = points[i, 2]
    print(sprintf("%f  %f %f", (m * x + b), y,  ((m * x + b) - y)^2))
    totalError <- totalError + ((m * x + b) - y) ^ 2
  }
  return (totalError / N)
}

step_gradient <- function(b_current, m_current, points, learningRate){
  b_gradient = 0
  m_gradient = 0  
  N = nrow(points)
  for (i in seq(from = 1, to = N)){
    x = points[i, 1]
    y = points[i, 2]
    #m_gradient = m_gradient + -x * (y - ( (m_current * x) + b_current) ) 
    #b_gradient = b_gradient + - (y - ((m_current * x) + b_current ))
    m_gradient = m_gradient + ( ( (m_current * x) + b_current) - y ) * x
    b_gradient = b_gradient + ( ( (m_current * x) + b_current ) - y)
  }
  b_gradient = (1/N) * b_gradient
  m_gragient = (1/N) * m_gradient
  new_b = b_current - (learningRate * b_gradient)
  new_m = m_current - (learningRate * m_gradient)
  
  return (c(new_b, new_m))
}

gradient_descent_runner <- function(points, initial_b, initial_m, learning_rate, num_iterations){
  last_b = initial_b
  last_m = initial_m
  for(i in seq(from = 1, to = num_iterations)){
    b_m = step_gradient(last_b, last_m, points, learning_rate)
    last_b = b_m[1]
    last_m = b_m[2]
    print(sprintf('last_b %f', last_b))
    print(sprintf('last_m %f', last_m))
    print( sprintf ("After %s iterations b = %s, m = %s, error = %3.6f", i, last_b, last_m, compute_error_for_line_given_points(last_b, last_m, points)) )
    if(i %% 10 == 0)
      abline(last_b, last_m)
  }
  return (c(last_b, last_m))
}

run_gradient_descent <- function(points){
  plot(points$x, points$y)
  print (sprintf ("Starting gradient descent at b = %s, m = %s, error = %s", initial_b, initial_m, compute_error_for_line_given_points(initial_b, initial_m, points)))
  print ("Running...")
  b_m = gradient_descent_runner(points, initial_b, initial_m, learning_rate, num_iterations)
  last_b = b_m[1]
  last_m = b_m[2]
  abline(last_b, last_m)
}

num_iterations = 15

N = 150;

#set.seed(1)
x = rnorm(N, mean = 50, sd=10) 
y = x + rnorm(N, mean = 100, sd=1)  * -10
points = as.data.frame(cbind(x, y))
#points = read.csv("data.csv", header = FALSE)
colnames(points) = c('x', 'y')
points$x <- (points$x - mean(points$x))/sd(points$x)
points$y <- (points$y - mean(points$y))/sd(points$y)

learning_rate = .01
initial_b = 0 # initial y-intercept guess
initial_m =  0 # initial slope guess
last_b = 0;
last_m = 0;


run_gradient_descent(points)
#############
abline(lm(y~x, points), col='blue')
lm(y~x, points) 
