# Reress: To Fall back (return) to the global mean

Install/Load the UsingR package
```{R}
install.packages('UsingR')
require('UsingR')
```
# The Francis Galton's Dataset
__Taller parents__ produce __tall kids__, but not as much ... **a little shorter**

__Shorter parents__ produce __short kids__, but not as much ... **a little taller**

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
[Check her](./images/galton_dataset.png)


![Galton's Dataset](/images/Galton_Dataset.png)
Format: ![Alt Text](url)

# Global mean

```{R}
mChild <- mean(galton$child)
mParent <- mean(galton$parent)
points(mParent, mChild, type = "p", col='red')
```

# Best-fit line
Any line, claiming to be **best fit** should pass through the **global mean**

All other points in the data will **Regress** to that line
```{R}
best_fit_line = lm(galton$child~galton$parent)
abline(best_fit_line)
```

# R-Squared
R-squared = Explained variation (RegressionSS) / Total variation (0~100%) 

TotalSS sum(yi-y_mean)^2, RegressionSS sum(y_est - y_mean)^2, SSE sum(y_est-yi)^2
100% implies that the model explains all the variability of the response data around its mean.
low R-square and a good model case
