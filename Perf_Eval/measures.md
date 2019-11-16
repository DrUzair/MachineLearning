# Regression
## R^2
# Classification
## Confusion Matrix
```R
library('e1071')
rn_train <- sample(nrow(iris), floor(nrow(iris)*.70))
train <- iris[rn_train,]
test <- iris[-rn_train,]
model <- naiveBayes(Species~., data=train)
predictions <- predict(model, test)
table(True = test$Species, Pred = predictions)

##############OUTPUT#########################
                          Pred
#  True         setosa versicolor virginica
#  setosa         19          0         0
#  versicolor      0         10         1
#  virginica       0          1        14
```
