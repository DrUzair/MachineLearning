# T-Distribution
x <- seq(from =-5, to = 5, by=.1)
plot(x, dt(x, df = 30), ylab='Probability',xlab='x', main="PDF of T-Distribution dt(x, df)")

t.value <- seq(from = -3, to = 3, by=.1)
plot(t.value, pt(t.value, df = 74), ylab='Cumulative Probability',xlab='T-Value', main="T-Distribution (CDF) pt(tvalues, df)")
# probability of getting a number smaller than (or equal to) the argument of pt function

# area under the curve from x to y 
pt(1, df=70) - pt(-1, df=70)
pt(2, df=70) - pt(-2, df=70)
pt(3, df=70) - pt(-3, df=70)

# qt --> what is the T-Value at given quantile
# qt(.95,30) --> 1.697261 means that 95% of of all numbers in the distribution are less than 1.69
# pt(1.69,30) --> ~ .95
quantiles <- seq(from = 0.001 , to = .999, by=.001)
plot(qt(quantiles, df = 30), quantiles, xlab='Statistic(T-Value)',ylab='Quantile', main="T-Density Distribution (Inverse CDF) qt(quantiles, df)")

# notice symmetry
qt(c(.025, .975), df=30)   # 30 degrees of freedom 

#####################Question 1
set.seed(0)
treeVolume <- c(rnorm(75, mean = 36500, sd = 2000))
t.test(treeVolume, mu = 39000, alternative = "two.sided", conf.level=0.95) # Ho: mu = 39000, Population Variance Unknown
# t = -12.288, df = 74, p-value < 2.2e-16
# It is a two.tailed test
# from t-table we can check that for .95 confidence level and 74 df, the critical-values are -1.992543, 1.992543 
# OR: we can calculate using qt function: 
alpha <- 0.05
t.half.alpha <- qt(1-alpha/2, df = 74)
c(-t.half.alpha,t.half.alpha) # Critical Values: -1.992543 & 1.992543
# Since -12.288 does not lie between critical values -1.992543 & 1.992543
# Therefore: test statistic falls in rejection region, hence Ho is rejected (with 5% chance of Type I error)
# ALTERNATIVELY
# Calculate the p-value for t = -12.288 and df = 74
pval <- 2 * pt(-12.288, df = 74) # pval = 1.516651e-19
# Since it is way less than the .05 significance level, we can reject Ho
# In other words, the probability of randomly encountering/observing such a statistic is very low  (p-value < 2.2e-16) 
# Therefore: the rejection decision is statistically significant as well


#####################Question 2
results = c(65, 78, 88, 55, 48, 95, 66, 57, 79, 81)
mean(results) # 71.2
sd(results)
t.test (results, mu=75, alternative = "two.sided", conf.level=0.95) # Ho: mu = 75, Population Variance Unknown
# t = -0.78303, df = 9, p-value = 0.4537
# Since it is a two.tailed test
# from t-table we can check that for .95 confidence level and 9 df, the critical values are ( -2.262157 & 2.262157) 
# OR: we can calculate using qt function: qt(0.025, 9)
alpha <- 0.05
t.half.alpha <- qt(1-alpha/2, df = 9) 
c(-t.half.alpha,t.half.alpha) # Critical Values: -2.262157  2.262157
# Since -0.78303 does lie between critical values (Acceptance Region) 
# Therefore: test statistic does not fall in rejection region, hence Ho cannot be rejected 
# ALTERNATIVELY
# Calculate the p-value for t = -0.78303 and df = 9
pval <- 2 * pt(-0.78303, df = 9) # 0.45372
# Since pval=0.45372 turns out to be greater than the .05 significance level, we cannot reject Ho
# In Other words, the probability of randomly encountering/observing such a statistic is quite high  (p-value = 0.4537) 
# Therefore: rejecting the Ho is not possible with this evidence

####################Question 3
bottles <- c(484.11,459.49,471.38,512.01,494.48,528.63,493.64,485.03,473.88,501.59,502.85,538.08,465.68,495.03,475.32,529.41,518.13,464.32,449.08,489.27)
mean(bottles) # 491.5705
sd(bottles)
t.test(bottles, mu=500, alternative="less", conf.level=0.99) # Ho: mu = 500, Population Variance Unknown
# t = -1.5205, df = 19, p-value = 0.07243
# from t-table we can check that for .99 confidence level and 19 df, the critical value is -2.539483
# OR: we can calculate using qt function: qt(0.01, 19)
alpha <- 0.01
t.alpha <- qt(1-alpha, df = 19) # Critical Value:  -2.539483 (- because its lower tailed test)
# Since t=-1.5205 > -2.539483 therefore: test statistic falls in acceptance region, hence Ho cannot be rejected
# ALTERNATIVELY
# Calculate the lower-tail p-value for t = -1.5205, df = 19
pval <- pt(-1.5205, df = 19) # 0.07242646
# Since it is greater than the .01 significance level, we cannot reject Ho
# In other words: the probability of randomly encountering/observing such a statistic is not low enough (p-value < 0.07243) 


####################Question 4
x = c(0.593,0.142,0.329,0.691,0.231,0.793,0.519,0.392,0.418) 
t.test(x, mu=0.3, alternative="greater", conf.level= 0.95)  # Ho: mu = 500, Population Variance Unknown
# t = 2.2051, df = 8, p-value = 0.02927
# from t-table we can check that for .95 confidence level and 8 df, the t-value is 1.859548
# OR: we can calculate using qt function: qt(0.05, 8)
alpha <- 0.05
t.alpha <- qt(1-alpha, df = 8) # Critical Value:  1.859548 
# Since t=2.2051 >  1.859548 therefore: test statistic falls in rejection region, 
# Hence Ho can be rejected (with 5% chance of Type I error)
# ALTERNATIVELY
# Calculate the upper-tail p-value for t = 2.2051, df = 8
pval <- pt(2.2051, df = 8, lower.tail=FALSE) # 0.02926329
# Since pval=0.02926329 is less than the .05 significance level, we can reject Ho
# In other words: the probability of randomly encountering/observing such a statistic is low  (p-value < 0.02926329) 
# Therefore: the rejection decision is statistically significant as well



###################Question 5
automatic = mtcars$am == 0 
mpg.auto = mtcars[automatic,]$mpg 
mpg.auto 
mpg.manual = mtcars[!automatic,]$mpg 
mpg.manual
t.test(mpg.auto, mpg.manual)
#     Welch Two Sample t-test
# data:  mpg.auto and mpg.manual
# t = -3.7671, df = 18.332, p-value = 0.001374
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
# -11.280194  -3.209684
# sample estimates:
# mean of x mean of y 
# 17.14737  24.39231 
# INTERPRETATION
#  Welch’s t-test is a t-test with unequal variances.
#  at 95% confidence level, there is a significant difference (p-value = 0.001374) of the two means. 
#  Since p-value is smaller than 0.05 (95% conf.level), we should reject H0 (H0 says both means are equal)
#  The difference of means can be as low as -11.280194 and as high as -3.209684; the t-statistic -3.7671 falls 
#  within the confidence interval -11.280194  -3.209684

#Question 6
High.protein<- c(134,146,104,119,124,161,107,83,113,129,97,123)
Low.protein<- c(70,118,101,85,107,132,94)
# Assuming equal variances
t.test(High.protein,Low.protein,var.equal=TRUE)
# OUTPUTS
# Two Sample t-test
# data:  High.protein and Low.protein
# t = 1.8914, df = 17, p-value = 0.07573
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
# -2.193679 40.193679
# sample estimates:
# mean of x mean of y 
#      120       101 
# INTERPRETATION
# at 95% confidence level, there is NO significant difference (p-value = 0.07573) between the two means. 
# Since p-value is larger than 0.05 (95% conf.level), we cannot reject H0 (H0 says both means are equal)
# The maximum difference of means can be as low as -2.193679 and as high as 40.193679; the t-statistic 1.8914 falls 
# within the confidence interval -2.193679 40.193679

# WHAT IF Variances are not equal:
t.test(High.protein,Low.protein)
# OUTPUTS
# Welch Two Sample t-test
# data:  High.protein and Low.protein
# t = 1.9107, df = 13.082, p-value = 0.07821
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
# -2.469073 40.469073
# sample estimates:
# mean of x mean of y 
#      120       101 

#Question 7
install.packages('MASS')
library(MASS)
ttest <- t.test(immer$Y1, immer$Y2, paired=TRUE) 
names(ttest)
st <- ttest$statistic
pvalue <- ttest$p.value

#Question 8
s <- c(25, 32, 18, 20)
chisq.test(s)
