# 2000 General Social Survey, cross classifies gender and political party identification. (2757 subjects)

M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
dimnames(M) <- list(gender = c("F", "M"), party = c("Democrat","Independent", "Republican"))
M

#          CONTINGENCY TABLE (OBSERVED VALUES)
#                    party
#gender Democrat Independent Republican |  Total
#  F      762         327        468    |  1557
#  M      484         239        477    |  1200
#         --------------------------------------
# Total   1246        566        945    |  2757
  
# Estimation Expected Values
# If both variables are independent, (JointProb of Party and Gender) = (MargianlProb of Party) X (MarginalPob of Gender)
# The marginal probabilities then determine the joint probabilities.
# To test the independence of Party and Gender: ExpectedCounts MSUT BE EQUAL TO --> N * (JointProb of Party and Gender)

# Ususually ExpectedCounts and MarginalProb are not known: Therefore, sample proportions are substituted instead of JointProb

# E = N * P_i+ * P_+j = N * ( n_i+ / N ) * ( n_+j / N ) = (n_i+)*(n_+j) / N
# Same row/columns totals as OBSERVATION counts BUT display the patterns of independence

#         CONTINGENCY TABLE (EXPECTED VALUES)
#                    party
#gender Democrat                  Independent Republican  |  Total  |   (MARGINAL PROPORTIONS)
#  F (1557x1246)/2757=703.6714     319.6453   533.6834    |  1557   |   p11 = 1557/2757=0.565
#  M (1200x1246)/2757=542.3286     246.3547   411.3166    |  1200   |   p22 = 1246/2757=0.452
# --------------------------------------------------------------------------------------------
# Total   1246                      566        945        |  2757   |             1.107

# 
# standardized residual = ( OBSERVED - EXPECTED ) / StandardError (SE)
# Standard Error(SE)    = sqrt(EXPECTED * (1 - p11)(1 - p22))

#          CONTINGENCY TABLE (standardized residual)
#                    party
#gender Democrat          Independent         Republican   
#  F      762 (4.5)         327 (0.70)         468  (-5.32) 
#  M      484 (-4.5)        239 (-.70)         477  (5.32)  

# Point 1: large positive residuals for female Democrats and male Republicans.
# Point 2: There were more female Democrats and male Republicans than the null hypothesis sugggests. 
# Point 3: There were fewer female Republicans and male Democrats than the hypothesis of independence predicts. 

# Point 4: Gender Gap Odds Ratio: Democrat and Republican identifiers has a sample odds ratio of (762 × 477)/(468 × 484) = 1.60. 
#          Of those subjects identifying with one of the two parties, the estimated odds of identifying with the Democrats rather
#          than the Republicans were 60% higher for females than males.


(Xsq <- chisq.test(M))  # Prints test summary
Xsq$observed   # observed counts (same as M)
Xsq$expected   # expected counts under the null
Xsq$residuals  # Pearson residuals
Xsq$stdres     # standardized residuals

# agresti-introduction-to-categorical-data