###########################
#####       EFA       #####
#reference: web.stanford.edu#

#dataset -> 240 particapants give self ratings on 32 personality traits(columns)
#get data
data <- read.table("http://www.stanford.edu/class/psych253/data/personality0.txt")

#explore data
str(data)
colnames(data)

#corrplot is useful for when there is lots of columns in a dataframe
library(corrplot)
#there are 2 main classes of traits; positive and negative. 
#there are subclusters e.g kind and friendly in one group and talkative, outgoing and sociable in onother.
#blue scale is for positive correlation and red for negative. 
#so we can see disorgn is +vely correlated to carelss, whereas organiz is -vely related to carelss
corrplot(cor(d), order = "hclust", tl.col='black', tl.cex=.75) 

#standardize the variables
data_stand <- as.data.frame(scale(data))

#factor analysis with no rotation 
#factanal() rotates the factors. default rotation='varimax'
factan_0 = factanal(data_stand, factors = 10, rotation = "none", na.action = na.omit)
factan_0$loadings
#ss , sumofsquared loadings are eignevalues; the variance in all variables which is accounted for by that factor. 
#if high ss, then factor is helping explain the variance in variables. 
#a factor is important if its eignvalue is greater than 1(the avg)<-kaiser rule; factors 1-6 are important

#calculate eignevalue of factor1.
loadings_fac1=factan_0$loadings[,1]
eigenv_fac1=sum(loadings_fac1^2)
eigenv_fac1

#compute proportion variance;proportion variance=the eigenvalue/# of variables 
eigenv_fac1/32

#uniqueness=1-communality;communality=SS factor loadings for all factors for A GIVEN VARIABLE 
#variable has high communality(and low uniqueness) if all the factors jointly explain a large percent of variance in it.
factan_0$uniqueness

# can calculate uniqueness for each variable manually
#loadings_distant = factan_0$loadings[1,] ;#first variable
#communality_distant = sum(loadings_distant^2); 
#uniqueness_distant = 1-communality_distant; uniqueness_distant

### Plot loadings for factor 1 and 2 #does not tell much as factors not rotated
plot = factan_0$loadings[,1:2]
plot(plot, type="n") # set up plot 
text(plot,labels=names(data_stand),cex=.7) # add variable names

### Factor analysis with rotation. factanal rotates orthogonally
factan_1 = factanal(data_stand, factors = 10, rotation = "varimax", na.action = na.omit)
factan_1$loadings

### Plot loadings against one another
plot1 = factan_1$loadings[,1:2]
plot(plot1, type="n") # set up plot 
text(plot1,labels=names(data_stand),cex=.7) # add variable names
#sociabl and shy load heavily on factor 1(have high values irrespective of sign).we can label factor 1 using these terms (extrover vs introvert). 
#factor 2 can be labelled with hardwork vs lazy 

#create composite variables ;try to combine synonomous variables into composites.
#See how many factors we get from small dataset.e.g reduce our dataset down to p=5 variables,but then we cant have k=10 factors.
#In order to extract k factors we need more datapoints (p) than independent parameters, i.e., (p???k)^2>p+k
k = 2
p = 5
yes = 'yes! lets extract k factors!'
no = 'no! we need more data or fewer factors!'
ifelse(((p-k)^2 > p+k), yes, no)

#combine synonyms then look at the extracted Factors!
shy = rowMeans(cbind(data_stand$distant, data_stand$shy, data_stand$withdrw, data_stand$quiet))
outgoing = rowMeans(cbind(data_stand$talkatv, data_stand$outgoin, data_stand$sociabl))
hardworking = rowMeans(cbind(data_stand$hardwrk, data_stand$persevr, data_stand$discipl))
friendly = rowMeans(cbind(data_stand$friendl, data_stand$kind, data_stand$coopera, data_stand$agreebl, data_stand$approvn, 
                          data_stand$sociabl))
anxious = rowMeans(cbind(data_stand$tense, data_stand$anxious, data_stand$worryin))

combined_dataset = cbind(shy,outgoing,hardworking,friendly,anxious)
combined_dataset = as.data.frame(combined_dataset)
factan_2 = factanal(combined_dataset, factors = 2, na.action=na.omit)
factan_2$loadings

#plot
plot2 = factan_2$loadings[,1:2]
plot(plot2, type="n") # set up plot 
text(plot2,labels=names(combined_dataset),cex=.7) # add variable names
