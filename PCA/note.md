
- Apply PCA on the indepenent variables of IRIS Dataset. Hint: use prcomp or princomp functions from stats library
```r
data(iris)
iris<-iris[,1:4]
```
- Plot the proportion of variancane explained by each component. How many components will you choose to capture maximum variability in the data set ?
- What is the effect of normalizing (centering and scaling) on the PCA results.?
- Transform the dataset using calculated PCAs. Plot the original dataset and transformed one. What do you observe.?
