set.seed(9)                            # this makes the simulation exactly reproducible

power5050 = vector(length=10000)       # these will store the p-values from each 
power7525 = vector(length=10000)       # simulated test to keep track of how many 
power9010 = vector(length=10000)       # are 'significant'

for(i in 1:10000){                     # I run the following procedure 10k times
  
  n1a = rnorm(50, mean=0,  sd=1)       # I'm drawing 2 samples of size 50 from 2 normal
  n2a = rnorm(50, mean=.5, sd=1)       # distributions w/ dif means, but equal SDs
  
  n1b = rnorm(75, mean=0,  sd=1)       # this version has group sizes of 75 & 25
  n2b = rnorm(25, mean=.5, sd=1)
  
  n1c = rnorm(90, mean=0,  sd=1)       # this one has 90 & 10
  n2c = rnorm(10, mean=.5, sd=1)
  
  power5050[i] = t.test(n1a, n2a, var.equal=T)$p.value         # here t-tests are run &
  power7525[i] = t.test(n1b, n2b, var.equal=T)$p.value         # the p-values are stored
  power9010[i] = t.test(n1c, n2c, var.equal=T)$p.value         # for each version
}

mean(power5050<.05)                # this code counts how many of the p-values for
#[1] 0.7019                         # each of the versions are less than .05 &
mean(power7525<.05)                # divides the number by 10k to compute the % 
#[1] 0.5648                         # of times the results were 'significant'. That 
mean(power9010<.05)                # gives an estimate of the power
#[1] 0.3261

#test is still valid but limited by the smaller sample size
#smaller sub-sample will limit the statistical power of the test.
#no methodical treatment, try to get equal samples