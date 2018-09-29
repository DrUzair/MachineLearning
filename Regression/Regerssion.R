install.packages('UsingR')
install.packages('ggplot2')
install.packages('colorspace')
library(UsingR)
library(colorspace)
library(ggplot2)

data(galton)
head(galton)
plot(galton$parent, galton$child)
plot(jitter(galton$parent), jitter(galton$child))

mChild <- mean(galton$child)
mParent <- mean(galton$parent)

points(mParent, mChild, type = "p", col='red')
abline(lm(galton$child~galton$parent))

fit <- lm(child~parent, data=galton)
summary(fit) 
# R-squared = Explained variation (RegressionSS) / Total variation (0~100%) 
# TotalSS sum(yi-y_mean)^2, RegressionSS sum(y_est - y_mean)^2, SSE sum(y_est-yi)^2
# 100% implies that the model explains all the variability of the response data around its mean.
# low R-square and a good model case

# Adjusted R-squared: (adjusted for different number of predictors)
# more predictor may increase R-square but Adjustment will penalize adding useless independent variables

# F-statistics: The larger the more unlikely that coefficients have no effect. 
# Compared to random guess, how better is regression

# Correlation ~ Regression
galton$childX <- scale(galton$child)
galton$parentX <- scale(galton$parent)
head(galton)
plot(galton$parentX, galton$childX)
fitx <- lm(galton$childX~galton$parentX)
fitx$coefficients[2] 
cor(galton$childX, galton$parentX)
abline(fitx, col='pink')

# The prediction
predict(fit, newdata=data.frame(parent=c(40)))
        
# Point Estimates and Intervals
newx <- seq(64, 75, by = 1)
# confidence interval
# most likely location of the true population parameter (if repeated N times, the mu will be found in this interval (1-alpha)*N times).
conf_interval95 <- predict(fit, newdata=data.frame(parent=newx), interval="confidence", level = 0.95)
lines(newx, conf_interval95[,2], col="blue", lty=2)
lines(newx, conf_interval95[,3], col="blue", lty=2)

conf_interval90 <- predict(fit, newdata=data.frame(parent=newx), interval="confidence", level = 0.90)
lines(newx, conf_interval90[,2], col="lightblue", lty=2)
lines(newx, conf_interval90[,3], col="lightblue", lty=2)

# prediciton interval
# Expection range of Y given X:
pred_interval95 <- predict(fit, newdata=data.frame(parent=newx), interval="prediction", level = 0.95)
lines(newx, pred_interval95[,2], col="blue", lty=2)
lines(newx, pred_interval95[,3], col="blue", lty=2)

pred_interval90 <- predict(fit, newdata=data.frame(parent=newx), interval="prediction", level = 0.90)
lines(newx, pred_interval90[,2], col="lightblue", lty=2)
lines(newx, pred_interval90[,3], col="lightblue", lty=2)


# Multiple Regression
# Example 
data(swiss)
head(swiss)
fitA <- lm(Fertility ~ Agriculture, swiss)
summary(fitA)

fitCA <- lm(Fertility ~ Agriculture + Catholic, swiss)
summary(fitCA)

fitCAE <- lm(Fertility ~ Agriculture + Catholic + Education, swiss)
summary(fitCAE)

fitE <- lm(Fertility ~ Education , swiss)
summary(fitE)

fitAll <- lm(Fertility ~ ., swiss)
summary(fitAll)
swiss$ce <- swiss$Catholic + swiss$Education
fitAllce <- lm(Fertility ~ ., swiss)
summary(fitAllce)

summary(lm(Fertility ~ ce, swiss))

data("InsectSprays")
head(InsectSprays)
table(InsectSprays$spray)
boxplot(InsectSprays$count ~ InsectSprays$spray)
summary(lm(count~spray, InsectSprays))

summary(lm(count~spray - 1, InsectSprays))
