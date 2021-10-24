s1 <- c(235, 225, 190, 188)
s2 <- c(180, 169, 180, 185, 178, 182)
wilcox.test(s1, s2)
wilcox.test(s2, s1)
s1s2 <- c(s1, s2)
# 
N <- length(s1s2)
N1 <- length(s1)
N2 <- length(s2)
ranksum_s1s2 = N*(N+1)/2
ranks_s1 <- rank(s1s2)[1:4]
T1 <- sum(ranks_s1)
# T1_star : sum of the ranks of s1 if ranks of s1s2 are reversed (descending order)
T1_star = N1*(N+1)-T1
# Wilcox Ranksum Statistic T : minimun of T1 and T1_star
# https://www.jstor.org/stable/3001968?origin=crossref
T <- min (T1, T1_star)

## Mann-whitney Ranksum Statistic W :
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
# Mann-Whitney U test, 
# https://zbmath.org/?format=complete&q=an:0041.26103
# W range [0 - N1*N2] 
# W = 0 --> complete separation (H0 is unlikely)
# W = n1*n2 --> complete overlap (Ha is unlikely)
# pwilcox(q = 13, m = 8, n = 8) * 2

# Calculating p-value from Wilcoxon Ranksum Statistic (approximated to z-score)
W_dist_mean = N1 * ( N1 + N2 + 1 ) / 2 
W_dist_var = N1 * N2 * (N1 + N2 + 1) / 12
continuity_corrected_T <- T1 - 0.5 # Ranksum of reference group
W_z_approx = (continuity_corrected_T - W_dist_mean)/sqrt(W_dist_var)
pnorm(q=W_z_approx, mean = 0, sd = 1, lower.tail = FALSE) * 2  
wilcox.test(s1, s2, exact = FALSE)
wilcox.test(s2, s1, exact = FALSE)
