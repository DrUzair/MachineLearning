# Regression
## R^2
# Classification
## Confusion Matrix
### k-Folds
```R
library("class")
library("caret") 
folds <- createFolds(iris$Species, k = 10)

for (f in folds) {   
  iris_train_x = iris[-f, 1:4]
  iris_train_y = iris[-f, 5]
  iris_test_x = iris[f,1:4]
  iris_test_y = iris[f,5]
  preds <- knn(train = iris_train_x, test = iris_test_x,cl = iris_train_y, k=10)
  print(table(True = iris_test_y, Pred = preds))
}

```
### Random Sampling
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
