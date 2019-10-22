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
