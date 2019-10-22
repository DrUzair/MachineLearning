```R

moth_catcher <- read.csv("https://raw.githubusercontent.com/DrUzair/MLSD/master/Datasets/MothCatcher2.csv")
moth_catcher$Location <- as.factor(moth_catcher$Location)
moth_catcher$Treatment <- as.factor(moth_catcher$Treatment)

table(moth_catcher$Treatment, moth_catcher$Location)
# Box plot with two factor variables
boxplot(Catch ~ Location * Treatment, data=moth_catcher, frame = FALSE, 
        col = c("#00AFBB", "#E7B800"), ylab="Catch Count")
# Two-way interaction plot
interaction.plot(x.factor = moth_catcher$Location, trace.factor = moth_catcher$Treatment, 
                 response = moth_catcher$Catch, fun = mean, 
                 type = "b", legend = TRUE, 
                 xlab = "Location", ylab="Catch Count",
                 pch=c(1,19), col = c("#00AFBB", "#E7B800"))

summary(aov(Catch ~ Location + Treatment, data = moth_catcher))
```
![alt text](https://github.com/DrUzair/MLSD/blob/master/ANOVA/moath_catcher_boxplot.png "Mothcatcher dataset boxplot")

![alt text](https://github.com/DrUzair/MLSD/blob/master/ANOVA/moath_catcher_interaction.png "Mothcatcher dataset interaction")
# Notice
**Changing the order of treatment and block**
```R
> summary(aov(Catch ~ Location + Treatment, data = moth_catcher))
            Df Sum Sq Mean Sq F value   Pr(>F)    
Location     3   1981   660.5  11.327 7.17e-06 ***
Treatment    2    113    56.5   0.969    0.386    
Residuals   54   3149    58.3                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
> summary(aov(Catch ~ Treatment + Location, data = moth_catcher))
            Df Sum Sq Mean Sq F value   Pr(>F)    
Treatment    2    113    56.5   0.969    0.386    
Location     3   1981   660.5  11.327 7.17e-06 ***
Residuals   54   3149    58.3   
```
