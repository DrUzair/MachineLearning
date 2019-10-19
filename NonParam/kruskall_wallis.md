# Use of Ranks in One-Criterion Variance Analysis
William H. Kruskal and W. Allen Wallis: Use of Ranks in One-Criterion Variance Analysis, Journal of the American Statistical Association, Vol. 47, No. 260 (Dec., 1952), pp. 583-621
## Explaination
The Kruskal Wallis test is a non parametric test, which means that the test doesn't assume your data comes from a particular distribution. 
The test is the non parametric alternative to the One Way ANOVA and is used when the assumptions for ANOVA aren't met (like the assumption of normality). 
It is sometimes called the one-way ANOVA on ranks, as the ranks of the data values are used in the test rather than the actual data points.
The test determines whether the medians of two or more groups are different. 
The hypotheses for the test are:
## H0: population medians are equal.
## H1: population medians are not equal.

# Sample question: A shoe company wants to know if three groups of workers have different salaries:
# Women: 23K, 41K, 54K, 66K, 78K.
# Men: 45K, 55K, 60K, 70K, 72K
# Minorities: 18K, 30K, 34K, 40K, 44K.
# 
# Step 1: Sort the data for all groups/samples into ascending order in one combined set.
# 18K
# 23K
# 30K
# 34K
# 40K
# 41K
# 44K
# 45K
# 54K
# 55K
# 60K
# 66K
# 70K
# 72K
# 78K
# 
# Step 2: Assign ranks to the sorted data points. Give tied values the average rank.
# 20K 1
# 23K 2
# 30K 3
# 34K 4
# 40K 5
# 41K 6
# 44K 7
# 45K 8
# 54K 9
# 55K 10
# 60K 11
# 66K 12
# 70K 13
# 72K 14
# 90K 15
# 
# Step 3: Add up the different ranks for each group/sample.
# Women: 23K, 41K, 54K, 66K, 90K = 2 + 6 + 9 + 12 + 15 = 44.
 Men: 45K, 55K, 60K, 70K, 72K = 8 + 10 + 11 + 13 + 14 = 56.
 Minorities: 20K, 30K, 34K, 40K, 44K = 1 + 3 + 4 + 5 + 7 = 20.
 
 Step 4: Calculate the test statistic:
 H=[(12/n(n+1))sum(Tj/nj)]-3(n+1)
 
 
 Where:
   
 n = sum of sample sizes for all samples,
 c = number of samples,
 Tj = sum of ranks in the jth sample,
 nj = size of the jth sample.
 h-test-2
 H=[(12/15(15+1)){44^2/5 +56^2/5 20^2/5}]-3(15+1)
 
 
 H = 6.72
 
 Step 5: Find the critical chi-square value. With c-1 degrees of freedom. For 3 - 1 degrees of freedom and an alpha level of .05, the critical chi square value is 0.03ish.
 
Step 5: Compare the H value from Step 4 to the critical chi-square value from Step 5.

If the critical chi-square value is less than the test statistic, reject the null hypothesis that the medians are equal.
 
The chi-square value is not less than the test statistic, so there is not enough evidence to suggest that the means are unequal.

```{r}
wages = data.frame('salary'=c(45, 55, 60, 70, 72, 23, 41, 54, 66, 90, 20, 30, 34, 40, 44), 'group'=c(rep('men', 5), rep('women', 5), rep('minority',5)))
boxplot(salary~group, data=wages)
kruskal.test(salary~group, data=wages) 
```
