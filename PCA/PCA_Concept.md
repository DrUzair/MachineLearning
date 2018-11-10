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
plot3d(df$height,df$width,df$area1, col="red", size=3) 
# plot3d(df$height,df$width,df$area2, col="red", size=3) 
```
![Plot](https://github.com/DrUzair/MLSD/blob/master/PCA/pca_plot1.png)


```r
df <- df[, c('width', 'height', 'area1')]
pc_df<-princomp(df,cor=TRUE, score=TRUE)

summary(pc_df)
pc_df$loadings
# eigen(cor(df)) Transformation matrix

# Transformed data
pc_df_scores <- data.frame(pc_df$scores) 
colnames(pc_df_scores) <- c('comp_1', 'comp_2', 'comp_3')

# visualizing components
# scatterplot3d(comp_1,comp_2,comp_3, main="3D Scatterplot")
lapply(X=pc_df_scores, FUN= range)
biplot(pc_df)

plot3d(comp_1,comp_2,comp_3, col="red", size=3) 

# selecting components
screeplot(pc_df,type="line",main="Scree Plot")
```
