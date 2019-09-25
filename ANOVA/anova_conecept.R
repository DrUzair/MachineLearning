N <- 500
a <- rnorm(N, mean =5, sd=1)
b <- rnorm(N, mean =5, sd=1)
c <- rnorm(N, mean =5, sd=1)


abc <- c(a, b, c)
abc_labels <- rep(1:3, rep(N, 3))
abc_labels <- as.factor(abc_labels)
abc_df <- data.frame(samples=abc, treatments=abc_labels)
boxplot(samples~treatments, abc_df)
mean_abc <- mean(abc)
Total_SS <- sum((abc - mean_abc)^2)
Total_SS
# Between class variance
Btw_SST <- sum(N*(mean(a) - mean_abc)^2 , N*(mean(b) - mean_abc)^2 , N*(mean(c) - mean_abc)^2)
Btw_SST <- sum( (N-1)*(sqrt(var(a))) , (N-1)*(sqrt(var(b))) , (N-1)*(sqrt(var(c))))
Btw_MST <- Btw_SST / (3 - 1)
# Within class variance
Wthn_SSE <- sum((a - mean(a))^2 , (b - mean(b))^2 , (c - mean(c))^2)
Wthn_MSE <- Wthn_SSE / (length(abc) - 3)
# Wthn_SSE + Btw_SST == Total_SS ???
Wthn_SSE + Btw_SST
# F-ratio
Btw_MST / Wthn_MSE
# change mean of one of the a, b, c
# rerun
# Wthn_SSE + Btw_SST == Total_SS ???
c(mean(a), mean(b), mean(c))
# tally the numbers in output
summary(aov(samples ~ treatments, abc_df))

# Select all, Run many times until you get an odd result... Pr(>F)=0.01~.. dare to explain?