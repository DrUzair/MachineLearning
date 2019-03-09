
# The Link Function
y =1/(1 + exp(mx + b))

# Important Transformations

* probability p =   n/N = [exp(mx + b) / (1+exp(mx+b))] =   [1/(1+exp(-(mx+b)))]
  * range between 0~1  
  * range(0 (if mx+b a large -ve), 1 ((if mx+b a large +ve))). 
* odds          =   p / (1 - p)                 =   exp(mx  + b) 
* log(odds)     =   logit(p)                    =   log(p/(1-p))          =   mx + b  
   * range between -inf ~ +inf
* exp(log(odds))=   exp(log(p/(1-p))            =   odds                  =   exp(mx + b)   
* oddsratio     =   odds1 / odds2 
* m            =   log(odds1) - log(odds2)     =   log(odds1/odds2)      =   log(oddsratio)   
* exp(m)       =   exp(log(oddsratio))         =   oddsratio        

*Logistic regression is in reality an ordinary regression using the logit as the response variable.*
*The logit transformation allows for a linear relationship between the response variable and the coefficients:*

```r
hon_data <- read.csv("..\\sample.csv")
library(gmodels)
CrossTable(hon_data$hon, hon_data$female, expected = T, format="SPSS")
CrossTable(hon_data$hon, hon_data$female, prop.t=F, prop.r=F, prop.c=F, prop.chisq=F, format="SPSS")
```
hon_data     | Male | Female | Row Total
------------ | --- | --- | -------------
No Hon       | 74  | 77  | 151
Hon          | 17  | 32  | 49   
Column Total | 91  | 109 | 200            

 
# Connecting the Probability, Odds, Odds Ratio and Logistic Regression
## no predictors. just the intercept
```r
glm(hon~1, hon_data, family = 'binomial')

**Coefficients:**
(Intercept)  
 -1.125  
```
 * log(odds) = log(p/(1-p)) = -1.125
 * the logodds of any gender student in hon class
 * p = overall prob of being in honors class = n/N = 49/200 = exp(-1.125)/(1+exp(-1.125))

## The case of one categorical predictor
```r
glm(hon~female, hon_data, family = 'binomial')

 Coefficients: 
  (Intercept)       female  
   -1.4709       0.5928  
```
 * males being the reference group (female=0)
 * the logodds of a male in honors class are log(17/74) = -1.4709 --> Intercept
 * the logodds ratio between female & male (32/77) / (17/74) = 1.809
 * exp(coef of female) --> exp(0.5928) --> 1.809 --> female 80% more likely to be in hon class
 
## The case of one continuous predictor
```r
glm(hon~math, hon_data, family = 'binomial')

Coefficients:
 (Intercept)   math  
 -9.7939       0.1563  
```
 * the logodds of a student with zero math score --> Intercept
 * odds of an hon student with zero math score exp(Intercept) = -.00005579
 * math coef
   * consider two consecutive numbers. say 40 and 41
   * placing 40 and 41 in the equation and taking the diff will give 0.1563
   * Thus math coef is "the change in logodds"
 * SO. for one unit incriment in math score will result in 0.1563 increment in logodds
 * Translate change in logodds to odds
   * change in logodds = exp (logodds(math=40) - logodds(math=41))
   * change in logodds = exp (logodds(math=40) / exp (logodds(math=41)))
   * change in logodds = odds(math=40) / odds(math=41)
   * change in logodds = exp(.1563404) = 1.169224 = 1 additonal number in math score 16% more likely to be in hon

## The case of multiple predictors (categorical and numeric)
```r
glm(hon~math+read+female, hon_data, family = 'binomial')

**Coefficients:**
 (Intercept)      math         read        female  
 -11.77025      0.12296      0.05906      0.97995  
```
 * math: keeping read and female constant, one-unit increase in math increases the odds of hon by exp(0.1229589)
 * read: keeping math and female constant, one-unit increase in read increases the odds of hon by exp(0.0590632)
 * female: keeping read and math constant, female have exp(0.97995) better odds than males for getting into hon class
### Interaction analysis
    * assess the extent to which the association between one predictor and the outcome depends on a second predictor.
```r
glm(hon~ read + female + read*female, hon_data, family = 'binomial')
# glm(hon~ female + math + femalxmath, hon_data, family = 'binomial') --> same thing

**Coefficients:**
  (Intercept)       female         math  female:math  
       8.7458       2.8999      -0.1294      -0.0670  
```
 * Adding an interaction term to a model drastically changes the interpretation of all of the coefficients. 
 * If there were no interaction term, -0.1294 would be interpreted as the unique effect of math on hon. 
 * But the interaction means that the effect of math on hon is different for different values of female.  
 * So the unique effect of math on hon is not limited to math coef(-0.1294), but also depends on the values of female and -0.0670. 

## Changing the REFERENCE LEVEL in R
```r
hon_data$hon <- as.factor(hon_data$hon)
str(hon_data$hon)
levels(hon_data$hon)
hon_data$hon <- relevel(hon_data$hon, '1')
levels(hon_data$hon)
CrossTable(hon_data$hon, hon_data$female, prop.t=F, prop.r=F, prop.c=F, prop.chisq=F, format="SPSS")

               | hon_data$female 
hon_data$hon   |        0  |        1  | Row Total | 
  -------------|-----------|-----------|-----------|
             1 |       74  |       77  |      151  | 
  -------------|-----------|-----------|-----------|
             0 |       17  |       32  |       49  | 
  -------------|-----------|-----------|-----------|
  Column Total |       91  |      109  |      200  | 
  -------------|-----------|-----------|-----------|
 
```


## Another example
```r
data <- read.csv("..\\binary_classification.csv")
data$Studied <- (data$Studied - mean(data$Studied))/sd(data$Studied)
data$Slept <- (data$Slept - mean(data$Slept))/sd(data$Slept)
glm(Passed~., data, family = 'binomial')
```

# Model Output Interpretation

A typical output:
```r
Call:
glm(formula = hon ~ female, family = "binomial", data = hon_data)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-0.8337  -0.8337  -0.6431  -0.6431   1.8317  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -1.4709     0.2690  -5.469 4.53e-08 ***
female        0.5928     0.3414   1.736   0.0825 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 222.71  on 199  degrees of freedom
Residual deviance: 219.61  on 198  degrees of freedom
AIC: 223.61

Number of Fisher Scoring iterations: 4
```
## Deviance: 
Measure of Badness 0f Fit --> the lower the better

* Null Deviance:  How good/bad are the estimates of response variable using ONLY INTERCEPT or (grand mean)

* Residual Deciance: How better/worse are the estimates of response variable using other INDEPENDENT vars in addition to the INTERCEPT or (grand mean)

* DoF Null/Residual Deviance


## AIC: [Akaike Information Criterion]
* related concept ~ Adjusted R-squared: Penalize including inrrelevant variables.
   * Parsimony: unvderfitting (high bias) vs. overfitting (generalizability)
   * bias <--> variance of a model
* AIC = 2K - log(Likelihood( params | data) )2 
  * [Burnham & Anderson 2002]K: dof (estimable params)
* AICc = AIC + 2K(K+1)/(n-k-1) 
  * small sample correction [Hurvich&Tsai 1989]
* Akaike (1973) : what and how regressors influence dependent var

* The best model has the LOWEST AIC

  * Hosmer-Lemeshow Goodness of Fit: (another piece of measurement of goodness)
   - Measures difference between the model and the samples
   - library(ResourceSelection)
   - hoslem.test(mtcars$vs, fitted(model))
   - lower p-value(than alpha) indicates significant difference between obs and model output
 
 ##  Fisher Scoring Algorithm (maximum likelihood estimation)
 How many iterations it took to converge. 
