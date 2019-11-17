```r
df <- iris[, c('Sepal.Length', 'Petal.Length', 'Species')]
df[, 1:2] <- scale(df[,1:2])
plot(df$Sepal.Length, df$Petal.Length, col=df$Species)

d <- dist(df, method = "euclidean")

n <-100
df = data.frame(
  x1 = c(rnorm(n, mean = 10, sd = 3), rnorm(n, mean = 20, sd = 3), rnorm(n, mean = 20, sd = 3), rnorm(n, mean = 10, sd = 3)), 
  x2 = c(rnorm(n, mean = 10, sd = 3), rnorm(n, mean = 20, sd = 3), rnorm(n, mean = 10, sd = 3), rnorm(n, mean = 20, sd = 3)),
  y = c(rep(1, n), rep(2, n), rep(3, n), rep(4, n))
  )
plot(df$x1, df$x2, col=df$y)

d <- dist(df[, 1:2], method = "euclidean")

# Hierarchical clustering using Complete Linkage
hc_model <- hclust(d, method = "complete" ) # Dendogram object
hc_tree <- cutree(hc_model, k = 4)
table(hc_tree)
hc_tree
# Plot the obtained dendrogram
plot(hc_model, cex = 0.6)
rect.hclust(hc_model, k = 4, border = 2:5)
plot(df$x1, df$x2, col=hc_tree, main='Hierarchical Clustering')
#----------
install.packages("factoextra")
library(factoextra)
k4 <- kmeans(df[,1:2], centers = 4)
str(k4)
k4$cluster
plot(df$x1, df$x2, col=k4$cluster, main='k-means')
#fviz_cluster(k4, data = df) # pca-ed 

```
