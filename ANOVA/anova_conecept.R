```R
anova_sim <- function(N, means, stds) {
  #N <- 500
  a <- rnorm(N, mean = means[1], sd = stds[1])
  b <- rnorm(N, mean = means[2], sd = stds[2])
  c <- rnorm(N, mean = means[3], sd = stds[3])
  abc <- c(a, b, c)
  abc_labels <- rep(1:3, rep(N, 3))
  abc_labels <- as.factor(abc_labels)
  abc_df <- data.frame(samples=abc, treatments=abc_labels)
  boxplot(samples~treatments, abc_df)
  mean_abc <- mean(abc)
  Total_SS <- sum((abc - mean_abc)^2)
  Total_SS
  # Between class variance
  Btw_SST <- sum((N)*(mean(a) - mean_abc)^2 , (N)*(mean(b) - mean_abc)^2 , (N)*(mean(c) - mean_abc)^2)
  #Btw_SST <- sum( (N-1)*(sqrt(var(a))) , (N-1)*(sqrt(var(b))) , (N-1)*(sqrt(var(c))))
  Btw_MST <- Btw_SST / (3 - 1)
  # Within class variance
  Wthn_SSE <- sum((a - mean(a))^2 , (b - mean(b))^2 , (c - mean(c))^2)
  Wthn_MSE <- Wthn_SSE / (length(abc) - 3)
  # Wthn_SSE + Btw_SST == Total_SS ???
  Wthn_SSE + Btw_SST
  # F-ratio
  F_ratio <- Btw_MST / Wthn_MSE
  # change mean of one of the a, b, c
  # rerun
  # Wthn_SSE + Btw_SST == Total_SS ???
  c(mean(a), mean(b), mean(c))
  # tally the numbers in output
  aov_summary <- summary(aov(samples ~ treatments, abc_df))
  aov_summary
  
  return(data.frame('F'=F_ratio, 'p_Value'=df(F_ratio, df1=3-1, df2=(length(abc) - 3)) ))
  # Select all, Run many times until you get an odd result... Pr(>F)=0.01~.. dare to explain?
  
}
sim_results <- data.frame('F'=0, 'p_Value'=0)
set.seed(1)
for(i in 1:100) {
  result <- anova_sim(N=50, means=c(5,5,5), stds=c(1, 1, 1))
  sim_results <- rbind(sim_results, result)
}
plot(sim_results$F, sim_results$p_Value)



# Select all, Run many times until you get an odd result... Pr(>F)=0.01~.. dare to explain?
```
