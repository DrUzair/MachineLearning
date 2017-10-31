library(MASS)
###################################
model0 <- glm(vs~ 1 , data=mtcars, family="binomial")
summary(model0) # AIC: 45.86

model1 <- glm(vs~ hp , data=mtcars, family="binomial")
summary(model1) # AIC: 20.838
model1 <- glm(vs~ drat , data=mtcars, family="binomial")
summary(model1) # AIC: 41.159
model1 <- glm(vs~ wt , data=mtcars, family="binomial")
summary(model1) # AIC: 35.367

model2 <- glm(vs~ wt + hp , data=mtcars, family="binomial")
summary(model2) # AIC: 22.109
model2 <- glm(vs~ wt + drat , data=mtcars, family="binomial")
summary(model2) # AIC: 37.366
model2 <- glm(vs~ hp + drat , data=mtcars, family="binomial")
summary(model2) # AIC: 21.856

model3 <- glm(vs~ wt + hp + drat , data=mtcars, family="binomial")
summary(model3) # AIC: 23.395


influence(model)

step <- stepAIC(model3, direction="backward")
step$anova # display results 

####################################################
install.packages('leaps')
library(leaps)
leaps<-regsubsets(vs~ wt + hp + drat,data=mtcars,nbest=7)
summary(leaps)
# plot a table of models showing variables in each model.
# models are ordered by the selection statistic.
plot(leaps,scale="bic") # bic, cp, adjr2, and rss
####################################################
anova(model1, model2) 

####################################################
install.packages('car')
install.packages('quantreg')
library(car)
library(effects)
model_effects <- effect("hp", model, xlevels=list(hp = seq(50, 340, 10)))
plot(model_effects)
model_effects <- effect("hp", model, list(drat=mean(mtcars$drat), disp = mean(mtcars$disp)))
plot(model_effects)

##############################

data(Arrests)
dim(Arrests)
Arrests[sort(sample(5226, 10)),] # sample 10 of 5226 observations
Arrests$year <- as.factor(Arrests$year)
arrests.mod <- glm(released ~ employed + citizen + checks + colour*year + colour*age, family=binomial, data=Arrests)
summary(arrests.mod)
Anova(arrests.mod)
plot(effect("colour:year:age", arrests.mod, xlevels=list(age=15:45)),  multiline=TRUE, ylab="Probability(released)", rug=FALSE)
