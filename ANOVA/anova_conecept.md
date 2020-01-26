# Understanding ANOVA

ANOVA is a ratio of two number a.k.a F-ratio
- Between class spread (Sum of Squares for Treatments: SST)
- Within class spread (Sum of Squares for Errors: SSE)

Theoreticall the Total Sum of Squares is composed of SST and SSE
```math
TotalSS = SST + SSE
```

## Simulate Data
Input 3 sample means and stds

```R
gen_data <- function(seed, N, means, stds) {
  set.seed(seed)
  a <- rnorm(N, mean = means[1], sd = stds[1])
  b <- rnorm(N, mean = means[2], sd = stds[2])
  c <- rnorm(N, mean = means[3], sd = stds[3])
  abc <- c(a, b, c)
  abc_labels <- rep(1:3, rep(N, 3))
  abc_labels <- as.factor(abc_labels)
  abc_df <- data.frame(samples=abc, treatments=abc_labels)
  return abc_df
}
```
Plot the simulated data
```R
boxplot(samples~treatments, gen_data(seed=0, N=10, means=c(0,0,0), stds=c(1,1,1)))
```
## Total Spread: 
- Total_SS Sum of squared distances of each point from the mean of all data points.
```R
Total_SS <- sum((abc - mean_abc)^2)
```  
## Between class variance
- 
```R
Btw_SST <- sum((N)*(mean(a) - mean_abc)^2 , (N)*(mean(b) - mean_abc)^2 , (N)*(mean(c) - mean_abc)^2)
#Btw_SST <- sum( (N-1)*(sqrt(var(a))) , (N-1)*(sqrt(var(b))) , (N-1)*(sqrt(var(c))))
Btw_MST <- Btw_SST / (3 - 1)
```
## Within class variance
```R
Wthn_SSE <- sum((a - mean(a))^2 , (b - mean(b))^2 , (c - mean(c))^2)
Wthn_MSE <- Wthn_SSE / (length(abc) - 3)
```

```R
anova_sim <- function(seed, N, means, stds) {
  set.seed(seed)
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
  
  return(data.frame('seed'=seed, 'Btw_MST'=Btw_MST, 'Wthn_MSE'=Wthn_MSE,'F_ratio'=F_ratio, 'p_Value'=df(F_ratio, df1=3-1, df2=(length(abc) - 3)) ))
  # Select all, Run many times until you get an odd result... Pr(>F)=0.01~.. dare to explain?
  
}
```

```R
sim_results <- data.frame('seed'=0,'Btw_MST'=0, 'Wthn_MSE'=0,'F_ratio'=0, 'p_Value'=0)
```

```R
for(i in 1:100) {
  result <- anova_sim(seed=i, N=50, means=c(5,5,5), stds=c(1, 1, 1))
  sim_results <- rbind(sim_results, result)
}
attach(sim_results)
plot(F_ratio, p_Value)
hist(p_Value, breaks=seq(from =0, to = 1, by = .05))
sim_results[order(F_ratio, p_Value),]
```
# Note:
- for p_Value near above 0.05 to 1, we are sure H0 cannot be rejected
- for p_Value less than 0.05, we cannot accept H0
- Such small p_Value occur when F is larger than 3
- F larger than 3 means Between-Class-Variance(Btw_MST) is three times larger than Within-class-Variance(Wthn_MSE)
```R
anova_sim(seed=73, N=50, means=c(5,5,5), stds=c(1, 1, 1))
```
