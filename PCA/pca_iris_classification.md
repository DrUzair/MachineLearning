```r
attach(iris)
iris_bin <- iris[ which(Species=='setosa' | Species == 'virginica'), ]
iris_bin_x = iris_bin[, 1:4]
head(iris_bin)
glm(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width , data=iris_bin, family='binomial')

iris_bin_pca_obj <- prcomp(iris_bin_x, center = TRUE, scale= TRUE)
screeplot(iris_bin_pca_obj,type="line",main="Scree Plot")


iris_bin_pca_data <- as.data.frame(iris_bin_pca_obj$x)
iris_bin_pca_data <- cbind(iris_bin_pca_data, as.factor(iris_bin$Species))
colnames(iris_bin_pca_data) <- c('PC1', 'PC2', 'PC3', 'PC4', 'Species')


glm(Species ~ PC1 + PC2 + PC3 + PC4 , data=iris_bin_pca_data, family='binomial')
glm(Species ~ PC1 + PC2 , data=iris_bin_pca_data, family='binomial')

```
