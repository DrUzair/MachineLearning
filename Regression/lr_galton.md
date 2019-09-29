## Reress: 
To Fall back (return) to the global mean

## Best-fit Linear model of the data: 
No other line can produce less error than the Best-fit line

 
# The Francis Galton's Dataset
__Taller parents__ produce __tall kids__, but not as much ... **a little shorter**

__Shorter parents__ produce __short kids__, but not as much ... **a little taller**

Data set

Install/Load the UsingR package
```{R}
install.packages('UsingR')
require('UsingR')
```

### Plot Galton's Dataset
```{R}
data(galton)
head(galton)
dim(galton)
plot(galton$parent, Galton$child,
     main='Taller Parents --> Tall Kids ... but not as much, a little shorter.',
     xlab='Parent`s Height',
     ylab='Child`s height')
plot(jitter(galton$parent), jitter(Galton$child), 
     main='Taller Parents --> Tall Kids ... but not as much, a little shorter.',
     xlab='Parent`s Height',
     ylab='Child`s height')
```

```{R}
mChild <- mean(galton$child)
mParent <- mean(galton$parent)

points(mParent, mChild, type = "p", col='red')
abline(lm(galton$child~galton$parent))

fit <- lm(child~parent, data=galton)
summary(fit) 

```
![Galton's Dataset](https://github.com/DrUzair/MLSD/blob/master/Regression/images/Galton_Dataset.png)

# Global mean

Any line, claiming to be **best fit** should pass through the **global mean**

All other points in the data will **Regress** to that line

```{R}
mChild <- mean(galton$child)
mParent <- mean(galton$parent)
points(mParent, mChild, type = "p", col='red')
```
![Global Mean of Galton's Dataset](https://github.com/DrUzair/MLSD/blob/master/Regression/images/Galton_Dataset_Mean.png)
# Best-fit line

```{R}
best_fit_line = lm(galton$child~galton$parent)
abline(best_fit_line)
```
![Galton's Dataset](https://github.com/DrUzair/MLSD/blob/master/Regression/images/Galton_Dataset_lm.png)

# Notes
```{R}
summary(lm(child~parent, data=galton))

Call:
lm(formula = child ~ parent, data = galton)

Residuals:
    Min      1Q  Median      3Q     Max 
-7.8050 -1.3661  0.0487  1.6339  5.9264 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 23.94153    2.81088   8.517   <2e-16 ***
parent       0.64629    0.04114  15.711   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.239 on 926 degrees of freedom
Multiple R-squared:  0.2105,	Adjusted R-squared:  0.2096 
F-statistic: 246.8 on 1 and 926 DF,  p-value: < 2.2e-16
```
### Residuals:
Model output - Actual value:

Heteroskedasticity

### R-squared 
Explained variation (RegressionSS) / Total variation (0~100%) 

TotalSS sum(yi-y_mean)^2, RegressionSS sum(y_est - y_mean)^2, SSE sum(y_est-yi)^2
100% implies that the model explains all the variability of the response data around its mean.
low R-square and a good model case

Adjusted R-squared: (adjusted for different number of predictors)
more predictor may increase R-square but Adjustment will penalize adding useless independent variables

### F-statistics
The larger the more unlikely that coefficients have no effect. 
Compared to random guess, how better is regression model compared to others


# Correlation ~ Regression
```{R}
galton$childX <- scale(galton$child)
galton$parentX <- scale(galton$parent)
head(galton)
plot(galton$parentX, galton$childX)
fitx <- lm(galton$childX~galton$parentX)
fitx$coefficients[2] 
cor(galton$childX, galton$parentX)
abline(fitx, col='pink')
```

# Confidence Interval vs Prediction Interval

Sampling process repeated large number (inifitiy) of time, (1-alpha)% of the outcomes will be in the range of 

$$x_{1,2} = {-b\pm\sqrt{b^2 - 4ac} \over 2a}.$$

