# Regression / OLS / Best-fit

## Reress: 
To Fall back (return) to the global mean

## Best-fit Linear model of the data: 
No other line can produce less error than the Best-fit line

## 3 Assumptions
 
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
plot(galton<img src="/Regression/tex/b87f9d3a5dc3b14bc099ab166d14e99c.svg?invert_in_darkmode&sanitize=true" align=middle width=106.20883844999997pt height=22.831056599999986pt/>child,
     main='Taller Parents --> Tall Kids ... but not as much, a little shorter.',
     xlab='Parent`s Height',
     ylab='Child`s height')
plot(jitter(galton<img src="/Regression/tex/eb7d328a803ddfb8222f07f780f22732.svg?invert_in_darkmode&sanitize=true" align=middle width=159.76720319999998pt height=24.65753399999998pt/>child), 
     main='Taller Parents --> Tall Kids ... but not as much, a little shorter.',
     xlab='Parent`s Height',
     ylab='Child`s height')
```

```{R}
mChild <- mean(galton<img src="/Regression/tex/0f035ab03a353f16d6c9e4ffc86631ce.svg?invert_in_darkmode&sanitize=true" align=middle width=237.57219419999993pt height=24.65753399999998pt/>parent)

points(mParent, mChild, type = "p", col='red')
abline(lm(galton<img src="/Regression/tex/42e7122172230caa76cee4a67136da69.svg?invert_in_darkmode&sanitize=true" align=middle width=87.63077894999999pt height=22.831056599999986pt/>parent))

fit <- lm(child~parent, data=galton)
summary(fit) 

```
![Galton's Dataset](https://github.com/DrUzair/MLSD/blob/master/Regression/images/Galton_Dataset.png)

# Global mean

Any line, claiming to be **best fit** should pass through the **global mean**

All other points in the data will **Regress** to that line

```{R}
mChild <- mean(galton<img src="/Regression/tex/0f035ab03a353f16d6c9e4ffc86631ce.svg?invert_in_darkmode&sanitize=true" align=middle width=237.57219419999993pt height=24.65753399999998pt/>parent)
points(mParent, mChild, type = "p", col='red')
```
![Global Mean of Galton's Dataset](https://github.com/DrUzair/MLSD/blob/master/Regression/images/Galton_Dataset_Mean.png)
# Best-fit line

```{R}
best_fit_line = lm(galton<img src="/Regression/tex/42e7122172230caa76cee4a67136da69.svg?invert_in_darkmode&sanitize=true" align=middle width=87.63077894999999pt height=22.831056599999986pt/>parent)
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

### Coefficients

**Intercept = 23.94**
If the information about independent variable is not available, the average height will be 23.94??

**slope = 0.64**
One unit change in the x/predictor/independent variable (parent's height) will cause +0.64 times change in y/the dependent variable. 

#### t-Test
Null: slope is zero (no relationship between x and y)

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

##

# Correlation ~ Regression
```{R}
galton<img src="/Regression/tex/810dc3536ad3519016d14134b0aba0af.svg?invert_in_darkmode&sanitize=true" align=middle width=174.54670199999998pt height=24.65753399999998pt/>child)
galton<img src="/Regression/tex/f756cd7c4c6499af6ef2b15d10a6f591.svg?invert_in_darkmode&sanitize=true" align=middle width=186.80403554999998pt height=24.65753399999998pt/>parent)
head(galton)
plot(galton<img src="/Regression/tex/78989b704f4a96d763a1331c9806904d.svg?invert_in_darkmode&sanitize=true" align=middle width=115.70997405pt height=22.831056599999986pt/>childX)
fitx <- lm(galton<img src="/Regression/tex/289f86396e0c30e1c0311decaabe81a2.svg?invert_in_darkmode&sanitize=true" align=middle width=102.53944469999999pt height=22.831056599999986pt/>parentX)
fitx<img src="/Regression/tex/4c03e38cea4701114889baedcb5eefd2.svg?invert_in_darkmode&sanitize=true" align=middle width=184.79173184999996pt height=24.65753399999998pt/>childX, galton<img src="/Regression/tex/4ea4bbb47547abc3c8d8b5efbaae0397.svg?invert_in_darkmode&sanitize=true" align=middle width=850.3681032pt height=291.15234389999995pt/><img src="/Regression/tex/ff4274680eea5812a2bc6d6f89179121.svg?invert_in_darkmode&sanitize=true" align=middle width=136.81109145pt height=33.20539200000001pt/>$
```


SE = \frac{\sigma}{\sqrt{n}}

