
[PCA in R](https://gist.github.com/DrUzair/a81492eda3b446c2bdd358ffdaae93c9)

```R
pca <- function(X)  {
  X = scale(X, center = T, scale = T)
  e = eigen(cov(X))    #cov = t(as.matrix(X)) %*% as.matrix(X)
  return (e)
}
pca_ <- pca(df)
pca_$values / sum(pca_$values) # variance in data explained by each comp
pca_$vectors # rotation matrix
as.matrix(df) %*%  as.matrix(pca_$vectors) 
```

Install required packages **scaterplot3d** and **rgl**
```r
rm(df, height, width)

require(scatterplot3d)
library(rgl)
```

Synthetic dataset: 
```r

N <- 100

set.seed(786)
width = sample(1:100, N)
height = sample(1:100, N)
df <- data.frame(width, height)

df$area1 <- df$width * df$height 

noise <- floor(rnorm(N, mean=10, sd=50)) * round(runif(N, -1, 1), 0) # add some masala
df$area2 <- df$area1 +  noise
```
Visualize
```r
scatterplot3d(df$height,df$width,df$area1, main="3D Scatterplot")
# plot3d(df$height,df$width,df$area1, col="red", size=3) 
# plot3d(df$height,df$width,df$area2, col="red", size=3) 
```
![Plot](https://github.com/DrUzair/MLSD/blob/master/PCA/pca_plot1.png)

Principal Components:

```r
df <- df[, c('width', 'height', 'area1')]
pc_df<-princomp(df,cor=TRUE, score=TRUE)
summary(pc_df)
Output:
Importance of components:
                          Comp.1    Comp.2     Comp.3
Standard deviation     1.3726199 1.0250742 0.25522073
Proportion of Variance 0.6280284 0.3502590 0.02171254
Cumulative Proportion  0.6280284 0.9782875 1.00000000
```

Transformation Matrix a.k.a Loadings
```r
pc_df$loadings
# eigen(cor(df)) Transformation matrix
Loadings:
       Comp.1 Comp.2 Comp.3
width   0.525  0.664 -0.533
height  0.459 -0.748 -0.479
area1   0.717         0.697

               Comp.1 Comp.2 Comp.3
SS loadings     1.000  1.000  1.000
Proportion Var  0.333  0.333  0.333
Cumulative Var  0.333  0.667  1.000
```
Transformed data
```r
pc_df_scores <- data.frame(pc_df$scores) 
colnames(pc_df_scores) <- c('comp_1', 'comp_2', 'comp_3')
plot3d(comp_1,comp_2,comp_3, col="red", size=3)
```
![Plot](https://github.com/DrUzair/MLSD/blob/master/PCA/pca_plot3.png)
Visualizing components
```r
lapply(X=pc_df_scores, FUN= range)
biplot(pc_df)
```
![Plot](https://github.com/DrUzair/MLSD/blob/master/PCA/pca_plot2.png)
The Scree Plot
```r
# selecting components
screeplot(pc_df,type="line",main="Scree Plot")
```
