Parsimony

# opposing objectives: 
- complete model (all variables related to dependent variable) vs. as few variables as possible (irrelevent variable decreases the precision of coefficient)
- fitness vs. simplicity
- unvderfitting (high bias) vs. overfitting (generalizability)
- bias <--> variance of a model

### Akaiki Information Criterion
AIC = 2K - log(Likelihood( params | data) )
2 --> [Burnham & Anderson 2002]
K: dof (estimable params)

AICc = AIC + 2K(K+1)/(n-k-1) --> small sample correction [Hurvich&Tsai 1989]

Akaike (1973) : what and how regressors influence dependent var

The best model has the LOWEST AIC


## Search procedures
- Outliers and collinearity can cause different selection. 
- Without Outliers and collinearity all procedures lead to same selection of variables.

