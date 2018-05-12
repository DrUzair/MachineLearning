Install/Load the UsingR package
```{R}
require('UsingR')
data(galton)
head(galton)
plot(galton$parent, Galton$child)
```

```{R}
mChild <- mean(galton$child)
mParent <- mean(galton$parent)

points(mParent, mChild, type = "p", col='red')
abline(lm(galton$child~galton$parent))

fit <- lm(child~parent, data=galton)
summary(fit) 

```
R-squared = Explained variation (RegressionSS) / Total variation (0~100%) 
TotalSS sum(yi-y_mean)^2, RegressionSS sum(y_est - y_mean)^2, SSE sum(y_est-yi)^2
100% implies that the model explains all the variability of the response data around its mean.
low R-square and a good model case
