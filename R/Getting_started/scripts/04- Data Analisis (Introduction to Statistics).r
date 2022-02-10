# Introduction to statistics
# Make as many anotations as necessary
rm(list=ls())

# load the libraries

library(ggplot2)
library(dplyr)



# generate 10 random temperature values in F
n = 20
x = runif(n, -10:100)
x

# what are those values in Celsius

y = (5/9)*x - 17.77
y = -17.77 + (5/9)*x
y

data <- data.frame(F = x, C =y)
glimpse(data)

# let's plot the data
ggplot(data, aes(x = F, y = C)) +
geom_point(size = 5) + 
#geom_abline(intercept = -17.777, slope = 5/9, color = "red") +
theme_bw()



# let's plot the data
ggplot(data, aes(x = F, y = C)) +
geom_point(size = 5) + 
geom_abline(intercept = -17.777, slope = 5/9, color = "red") +
theme_bw()

# add noise

yy = rnorm(n, mean = - 17.77 + (5/9)*x , sd = 0.5)
yy

# let's plot the data

data$Cs <- yy
ggplot(data, aes(x = F, y = Cs)) +
geom_point(size = 5) + 
geom_abline(intercept = -17.777, slope = 5/9, color = "red") +
theme_bw()

m1 <- lm(Cs ~ F, data)
summary(m1)



alpha <- -17.77 + (5/9)*0
alpha

C1 = -17.77 + (5/9)*1
C2 = -17.77 + (5/9)*2

C2 - C1



data$Cs <- yy
ggplot(data, aes(x = F, y = Cs)) +
geom_point(size = 5) + 
geom_abline(intercept = -17.777, slope = 5/9, color = "red") +
geom_smooth(method = 'lm') + 
theme_bw()

# more noise

yy = rnorm(n, mean = - 17.77 + (5/9)*x , sd = 1)
yy

data$Cs <- yy

ggplot(data, aes(x = F, y = Cs)) +
geom_point(size = 5) + 
geom_abline(intercept = -17.777, slope = 5/9, color = "red") +
geom_smooth(method = 'lm') + 
theme_bw()

m2 <- lm(Cs ~ F, data)
summary(m2)

anova(m2)

-18.14346/ 0.38545

# add less noise

yy = rnorm(n, mean = - 17.77 + (5/9)*x , sd = 0.1)
yy

data$Cs <- yy

ggplot(data, aes(x = F, y = Cs)) +
geom_point(size = 5) + 
geom_abline(intercept = -17.777, slope = 5/9, color = "red") +
geom_smooth(method = 'lm') + 
theme_bw()

com <- read.csv('datasets-master/compensation.csv')
# compare the fruit production between grazed and ungrazed plants
# get more information about the box-plot
ggplot(com, aes(y=Fruit, x=Grazing))+
geom_boxplot() + 
geom_jitter(size = 5, colour= "gray", alpha =0.8, width = 0.25) +
theme_bw() + 
ylab("Fruit Production")

mc1 <- lm(Fruit ~ Grazing, com)

model.matrix(Fruit ~ Grazing, com)

summary(mc1)

anova(mc1)

# Change the size of the points
# color the points by groups, e.g. Grazing
# remove the gray background
# change axis names
ggplot(com, aes(y=Fruit, x=Root, colour= Grazing))+
geom_point(size = 3) + 
xlab(label = "Root biomass") +
ylab("Fruit Production") +
ylim(-50, 120) +  xlim(0, 15) + 
geom_hline(yintercept = -41.286) +
theme_bw()

## regression Fruit and Root

mc2 <- lm(Fruit ~ Root, com)
summary(mc2)

ggplot(com, aes(y=Fruit, x=Root, colour= Grazing))+
geom_point(size = 3) + 
xlab(label = "Root biomass") +
ylab("Fruit Production") +
#ylim(-50, 120) +  xlim(0, 15) + 
#geom_hline(yintercept = -41.286) +
theme_bw()

# Centering
com$Root_c <- com$Root - 7.5
com$Root_c

mc3 <- lm(Fruit ~ Root_c, com)
summary(mc3)

# scaling 
com$Root_sc <- (com$Root - mean(com$Root)) / sd(com$Root)
com$Root_sc

mc4 <- lm(Fruit ~ Root_sc, com)
summary(mc4)

 sd(com$Root)
