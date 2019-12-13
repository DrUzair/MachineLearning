---
title: 'Fuel Economy: Predictive Modelling'
author: "Uzair Ahmad"
date: '2019-12-05'
output:
  pdf_document:
    toc: true
    toc_depth: 3
    number_sections: true
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{R, load_libraries, message=F, warning=F, echo=FALSE}
library(caret) 
library(stringr)
```

# Q2: Build a model to predict city mpg (variable “UCity” in column BG). 

EDA led the choice of variables and models. (ref WW_FuelEco_Q3.pdf)

## Dataset

```{R, laod_data, echo=FALSE}
vhcls_data = read.csv('https://raw.githubusercontent.com/DrUzair/MLSD/master/Datasets/vehicles.csv')
```

## Feature Selection

- Excluding 
  - city08: city MPG for fuelType1. Very strongly correlated (0.9975) with dependent variable UCity
  - comb08: combined MPG for fuelType1. Very strongly correlated (0.9859) with dependent variable UCity
  - highway08: highway MPG for fuelType1. cor(UCity, highway08) 0.9334
  - highway08U: highway unrounded MPG for fuelType1. Highly correlated for available values. Not available values are represented by zero which is going to mislead the distributions. 
  - eng_dscr: 559 unique engine descriptions: adds no information
  - c240bDscr: 6 descriptions of EV enginer chargers. 
  - c240Dscr: 5 descriptions of EV enginer chargers.
  - mpgData: boolean to say whether vehicle is having mpgData variables or not
  - tCharger: 34653 NA's
  - sCharger
  - charge120 drop zero variance
  - remove id column as it adds no information to the model

## Data Preparation

- remove zero UCity vehicles (25)
```{R, echo=FALSE}
vhcls_data$year_cat <- as.factor(vhcls_data$year)
vhcls_data$cylinders_cat <- as.factor(vhcls_data$cylinders)
vhcls_data$feScore_cat <- as.factor(vhcls_data$feScore)
vhcls_data$evMotor_Bin <- as.factor(ifelse(vhcls_data$evMotor == "", 'noMotor', 'evMotor' ))
#lm(UCity~evMotor, vhcls_data)
vhcls_data$evMotor <- as.factor(ifelse(vhcls_data$evMotor == "", 'noMotor', vhcls_data$evMotor ))
```
- atvType missing values treatment

- displ column type cast to factor


- Year column type cast to factor

- cylinders type cast to factor

- feScore type cast to factor

- ghgScore type cast to factor

- evMotor binarized

## Modeling Results
  
```{R, train_models, message=F, warning=F, echo=FALSE}
set.seed(1)
inputs_vars = c(
# numerics
  #'barrels08',
  'barrelsA08',
  'displ',
  'fuelCost08',
  'youSaveSpend',
# factors
  'atvType',
  'cylinders_cat', 
  'drive',
  'evMotor',
 #  'evMotor_Bin',
  'feScore_cat',
 #  'fuelType',
  'make',
 # 'trans_dscr',
 #  'trany',
  'VClass',
  'year_cat',
  
  'UCity'
)

vhcls_data_complete = subset(vhcls_data, select=inputs_vars)
cc = complete.cases(vhcls_data_complete)
vhcls_data_complete = subset(vhcls_data_complete, cc)
nrow(vhcls_data_complete)
control <- trainControl(method="cv", number=10)
#lm_reg <- train(UCity~., data=vhcls_data_complete, method="lm", metric="RMSE", trControl=control)
mtry <- sqrt(ncol(vhcls_data_complete)-1)
tunegrid <- expand.grid(.mtry=mtry)
rf_reg <- train(UCity~., data=vhcls_data_complete, method="rf", metric="RMSE", tuneGrid=tunegrid, 
                trControl=control)

results <- resamples(list(LM=lm_reg, RF=rf_reg))
```
```{R}
vhcls_data_complete
folds <- createFolds(vhcls_data_complete$UCity, k = 10)
folds
for(fold in folds){
  testData <- vhcls_data_complete[fold, ]
  trainData <- vhcls_data_complete[-fold, ]
  rf_model <- randomForest(UCity~., data=trainData, maxnodes =200, ntree=500)
  predict(rf_model, testData)
}
testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- yourData[testIndexes, ]
    trainData <- yourData[-testIndexes, ]
randomFrest(UCity~., data=)
```
- Input Variables
```{R, echo=FALSE}
print((data.frame(input_vars=inputs_vars[inputs_vars!='UCity'])))
```
- Complete Dataset size
```{R, echo=FALSE}
print(nrow(vhcls_data_complete))
```
- Modeling method
  - Linear Regression
  - Random Forest
- Evalutation method
  - 10 fold Cross Validation
- Results
```{R, echo=FALSE}
summary(results)
bwplot(results)
```
