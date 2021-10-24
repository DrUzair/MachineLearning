# Wilcoxon Ranksum Test 
This article explains
1. How R calculates wilcoxon ranksum statistic **W**, and why it changes by changing the reference group.
2. How the p-value is calculated for wilcoxon ranksum test.
The following example data is used to explain above two points.

**Example Data**
```r
s1 <- c(235, 225, 190, 188)
s2 <- c(180, 169, 180, 185, 178, 182)
```
# Why T changes by changing the reference group

## The Wilcoxon Ranksum Statistic T
The Wilcoxon Ranksum statistic T is calculated as [proposed by wilcoxon in 1947 in this paper](https://www.jstor.org/stable/3001968?origin=crossref).
- T1 = sum(ranks_s1)
- T1_star : sum of the ranks of s1 if ranks of s1s2 are reversed (descending order)
- T = min (T1, T1_star)
The following R code calculates T;
```r
# combine s1 and s2 into one vector
s1s2 <- c(s1, s2)
# Let N, N1 and N2 represent length of s1s2, s1, and s2 respectively
N <- length(s1s2)
N1 <- length(s1)
N2 <- length(s2)
# Ranksum of s1
ranks_s1 <- rank(s1s2)[1:4]
T1 <- sum(ranks_s1)
# T1_star : sum of the ranks of s1 if ranks of s1s2 are reversed (descending order)
T1_star = N1*(N+1)-T1
# Wilcox Ranksum Statistic T : minimun of T1 and T1_star
T <- min (T1, T1_star)
```
## How **W** is calculated in wilcox.test

### Runnging wilcox.test function in R, 
  - **with s2 as reference group**
```r
> wilcox.test(s2, s1, exact = FALSE)

	Wilcoxon rank sum test with continuity correction

data:  s2 and s1
**W** = 0, p-value = 0.01392
alternative hypothesis: true location shift is not equal to 0
```
  - **with s2 as reference group.**
```r
> wilcox.test(s1, s2, exact = FALSE)

	Wilcoxon rank sum test with continuity correction

data:  s1 and s2
**W** = 24, p-value = 0.01392
alternative hypothesis: true location shift is not equal to 0
```
As can be seen, the wilcox.test function does not report **T** statistic. Instead, it calculates Mann-whitney statistic W as proposed [original paper](https://zbmath.org/?format=complete&q=an:0041.26103).
The Mann-whitney statis W is calculated with respect to reference group as following
- When S1 is the reference group, W is the number of times s1 is less than s2
W = N1*N2 + (N1*(N1+1))/2 - T1
- When S2 is the reference group, W is the number of times s2 is less than s1
W = N1*N2 + (N2*(N2+1))/2 - T2 

#### Mann-whitney Ranksum Statistic W in R:

```r
N1 <- length(s1)
N2 <- length(s2)
ranks_s2 <- rank(s1s2)[5:10]
T2 <- sum(ranks_s2)
W1 <- N1*N2 + (N1*(N1+1))/2 - T1
W2 <- N1*N2 + (N2*(N2+1))/2 - T2
# W1 is the number of times s1 is less than s2
W <- 0
for(i in 1:length(s1)){
  for(j in 1:length(s2)){
    if(s1[i] < s2[j]) W <- W + 1
  }
}
W
# W2 is the number of times s2 is less than s1
W <- 0
for(i in 1:length(s2)){
  for(j in 1:length(s1)){
    if(s2[i] < s1[j]) W <- W + 1
  }
}
W
```
The **W** ranges from 0 to N1*N2 
- W = 0 --> complete separation (H0 is unlikely)
- W = n1*n2 --> complete overlap (Ha is unlikely)

# Calculating p-value from Wilcoxon Ranksum Statistic (approximated to z-score)
The mean and variance of Wilcoxons T1 statistic are approximated to be
```math
W_dist_mean = N1 * ( N1 + N2 + 1 ) / 2 

W_dist_var = N1 * N2 * (N1 + N2 + 1) / 12
```
The corresponding *z*-score is calculated as 
(T - W_dist_mean)/sqrt(W_dist_var)

```r
W_dist_mean = N1 * ( N1 + N2 + 1 ) / 2 
W_dist_var = N1 * N2 * (N1 + N2 + 1) / 12
continuity_corrected_T <- T1 - 0.5 # Ranksum of reference group
W_z_approx = (continuity_corrected_T - W_dist_mean)/sqrt(W_dist_var)
pnorm(q=W_z_approx, mean = 0, sd = 1, lower.tail = FALSE) * 2  
```
