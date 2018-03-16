
- Apply PCA on the indepenent variables of IRIS Dataset. Hint: use prcomp function from stats library
Load the data and keep only the first 4 variables.
```r
data(iris)
iris<-iris[,1:4]
```
```r
iris.pca.rawdata <- prcomp(iris, scale = FALSE, center= FALSE)
iris.pca.rawdata$rotation  # eigen vector / rotation matrix / tranformation matrix
iris.pca.rawdata$x         # Transformed data
```
- Plot the proportion of variancane explained by each component. How many components will you choose to capture maximum variability in the data set ?
```r
plot(iris.pca.rawdata, type = "l", main='without data normalization')
```
- What is the effect of normalizing (centering and scaling) on the PCA results.?
```r
iris.pca.normdata <- prcomp(iris, scale = TRUE, center= TRUE)
plot(iris.pca.normdata, type = "l", main='with data normalization')
```
- Transform the dataset using calculated PCAs. Plot the original dataset and transformed one. What do you observe.?
```r
iris.pca.normdata$x
# or manually
x_iris = as.matrix(iris)%*%iris.pca.rawdata$rotation # manual transformation
boxplot(x_iris, main='Raw Data Transformation')
x_iris = as.matrix(iris)%*%iris.pca.normdata$rotation # manual transformation
boxplot(x_iris, main='Norm Data Transformation')
boxplot(iris, main='Original Data')
```
