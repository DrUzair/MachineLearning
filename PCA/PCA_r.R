###########################
#####       PCA      #####
#reference: web.stanford.edu#

#get data # the score of each athlete in 7 events and 8th variable being their final score
data("heptathlon", package = "HSAUR")
str(heptathlon) #explore data

#large values are good. 
#need to recalculate hurdles, run200m and run800m as right now the smaller their values the better the performance
heptathlon$hurdles <- max(heptathlon$hurdles) - heptathlon$hurdles
heptathlon$run200m <- max(heptathlon$run200m) - heptathlon$run200m
heptathlon$run800m <- max(heptathlon$run800m) - heptathlon$run800m

#most are positive correlated; javelin seems to be the one with which some are -vely correlated.
round(cor(heptathlon[,1:7]), 2)

#apply PCA 
heptathlon_pca <- prcomp(heptathlon[, 1:7], scale = TRUE)
print(heptathlon_pca)
score <- which(colnames(heptathlon) == "score")
plot(heptathlon[,-score])

#summary
summary(heptathlon_pca)
#The linear combination for the first principal component is:
 heptathlon_pca$rotation[,1]
# the longjump and hurdles get the highest weight and javelin gets the least. 

#rescale
center <- heptathlon_pca$center
scale <- heptathlon_pca$scale

#compute the first principal component score for each competitor
predict(heptathlon_pca)[,1] 

#variances explained by PC's;#The first two components account for 81% of the variance. 
plot(heptathlon_pca)

#correlation b/w the score given to each athlete by standard scoring and first PC score 
cor(heptathlon$score, heptathlon_pca$x[,1])
#result implies their is good agreement

#scatterplot of official score and first PC:
plot(heptathlon$score, heptathlon_pca$x[,1])
#############################################################
#############################################################
#############################################################
#############################################################
#IRIS DATASET
# Load data
data(iris)
head(iris, 3)

#apply PCA to the numerical variables and use Species to visualize the PC's later
#skewness and magnitude of variables influences the PCs, so it is good to apply skewness transformation and scale
# log transform 
log.iris <- log(iris[, 1:4])
iris.species <- iris[, 5]

# apply PCA - scale. = TRUE is highly 
# advisable, but default is FALSE. 
iris.pca <- prcomp(log.iris,
                 center = TRUE,
                 scale. = TRUE) 

# plot #first 2 PC's explain most of the variability
plot(iris.pca, type = "l")

# summary method # commulative proportion of first 2 PC's is more than 95%
summary(iris.pca)

#predict PC values
# Predict PCs
predict(iris.pca, newdata=tail(log.iris, 2)) #assuming last 2 rows are new

#ggbiplot
library(devtools)
#install_github("ggbiplot", "vqv")
library(ggplot2)
library(plyr)
library(scales)
library(grid)
library(ggbiplot)
biplot <- ggbiplot(iris.pca, obs.scale = 1, var.scale = 1, 
              groups = iris.species, ellipse = TRUE, 
              circle = TRUE)
biplot <- biplot + scale_color_discrete(name = '')
biplot <- biplot + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(biplot)

#biplot
biplot(iris.pca)
