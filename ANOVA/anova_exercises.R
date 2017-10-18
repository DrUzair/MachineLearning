install.packages('gplots')
library(gplots)
growth= c(75,75,73, 61,67,64,62,63)
sugar = c('C', 'C', 'C', 'F','F', 'F','S','S')
plotmeans(growth~sugar)
summary(model <- aov(growth~sugar))
# The ANOVA F-test answers the question whether there are significant differences in the K population means. 
# However, it does not provide us with any information about how they differ. 
# additional analyses may be performed using 
pairwise.t.test(growth, sugar, p.adjust.method = 'bonferroni')
# or Tukey's Honest Significant Differences
TukeyHSD(model, ordered = TRUE)

# EXAMPLE 2
attach(mtcars)
cyl <- factor(cyl)
plotmeans(mpg~cyl,xlab="Number of Cylinders", ylab="Miles Per Gallon", main="Mean Plot\nwith 95% CI")
aov(mpg~cyl)
summary(model <-  aov(mpg~cyl+factor(am)) )
summary(model <-  aov(mpg~cyl*factor(am)) )
detach()

## area~region
data(state)
plotmeans(state.area ~ state.region)
plotmeans(state.area ~ state.region,
          mean.labels=TRUE, digits=-3,
          col="red", connect=FALSE)

##Warpbeaks
summary(fm1 <- aov(breaks ~ wool + tension, data = warpbreaks))
TukeyHSD(fm1, "tension", ordered = TRUE)

# EXAMPLE 
# new-menu-test dataset
#Item1,Item2,Item3 
#E1,25,39,36 
#E2,36,42,24 
#E3,31,39,28 
#E4,26,35,29 
#W1,51,43,42 
#W2,47,39,36 
#W3,47,53,32 
#W4,52,46,33

new_menu_test <- read.csv('new_menu_test.csv')

response = c(t(as.matrix(new_menu_test))) # response data 

Items = c("Item1", "Item2", "Item3")          # 1st factor levels 
Locations = c("East", "West")                 # 2nd factor levels 
Item_Levels = length(Items)                   # number of 1st factors 
Location_Levels = length(Locations)           # number of 2nd factors 
obs_count = 4                                 # observations per treatment

Treatment1 <- gl(n = Item_Levels, k = 1, length = obs_count * Location_Levels * Item_Levels, labels = Items)
Treatment2 <- gl(n = Location_Levels, k = obs_count * Item_Levels , length = obs_count * Location_Levels * Item_Levels, labels = Locations)
cbind(response, Treatment1, Treatment2)
summary(aov(response ~ Treatment1 + Treatment2))
summary(aov(response ~ Treatment1 * Treatment2))

# Block design
# Ignore location for now.
# Three item are tested (randomly) on menu for one week (for three weeks) at 8 franchises.
# Each row represents sales figures of 3 new menu items after test marketing
# Question: the mean sales of 3 new items are equal
block_obs_count = 8
Treatment = gl(n = Item_Levels, k = 1, block_obs_count * Item_Levels, Items)
Block = gl(n = block_obs_count, k = Item_Levels, length = block_obs_count * Item_Levels)
cbind(response, Treatment, Block)
summary(aov(response ~ Treatment + Block))

# http://www.r-tutor.com/elementary-statistics/analysis-variance/completely-randomized-design

data1<-c(
  49,47,46,47,48,47,41,46,43,47,46,45,
  48,46,47,45,49,44,44,45,42,45,45,40,
  49,46,47,45,49,45,41,43,44,46,45,40,
  45,43,44,45,48,46,40,45,40,45,47,40)
matrix(data1, ncol= 4, dimnames = list(paste("subj", 1:12), c("Shape1.Color1", "Shape2.Color1", "Shape1.Color2", "Shape2.Color2")))

Hays.df <- data.frame(rt = data1,
                      subj = factor(rep(paste("subj", 1:12, sep=""), 4)),
                      shape = factor(rep(rep(c("shape1", "shape2"), c(12, 12)), 2)),
                      color = factor(rep(c("color1", "color2"), c(24, 24))))
summary(aov(rt ~ shape * color, data=Hays.df))

summary(aov(rt ~ shape * color + Error(subj/(shape * color)), data=Hays.df))
Error(subj/(shape * color))
