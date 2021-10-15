# Install the necessary packages
# 
# install.packages(c("coda","mvtnorm","devtools","loo","dagitty", 'rstan', "brms"))
# library(devtools)
# devtools::install_github("rmcelreath/rethinking")

# After installing the packages you can delete  the code above or outcomment by adding an # in front of each line or by selecting the lines and 
# pressing cntr + shift + c


# load the packages
library(rethinking)
library(brms)

rm(list=ls()) # clean the memory of R

getwd()
setwd("~/Dropbox/Projects_JM/Muenster/Intro_Bayesian_Stats/")

data <- read.delim("data/data.txt")

head(data) # 


data$X = factor(data$X)
levels(data$X)


data$Z[which(data$Z == 1)] = 0.999999999999999



 mod.1  = brm(Y ~ X  + (1|Person), family = Beta(), data = data, 
              cores = 1, chains = 1, 
              iter = 3000, warmup = 1500)

 
 
summary(mod.1)



# Extact the posteriors

post = posterior_samples(mod.1)
head(post)


### Define the treatments 

A = post$b_Intercept
Ac = post$b_Intercept + post$b_XAc


# Probability of being different
length(which((A-Ac) > 0))/ length(A) 


Cc = post$b_Intercept + post$b_XCc
length(which((A-Cc) > 0))/ length(A) 

mean(logistic(A) - logistic(Cc))




# Compare the person:


# it the effect of person 1 different ?

length(which(post$`r_Person[1,Intercept]` > 0))/ length(post$`r_Person[1,Intercept]`)  

# it the effect of person 2 different ?

length(which(post$`r_Person[2,Intercept]` > 0))/ length(post$`r_Person[1,Intercept]`)  

# it the effect of person 3 different ?
length(which(post$`r_Person[3,Intercept]` > 0))/ length(post$`r_Person[1,Intercept]`)  

## plot

p1 = logistic( Ac + post$`r_Person[1,Intercept]`)
p2 = logistic( Ac +  post$`r_Person[2,Intercept]`)
p3 = logistic( Ac +  post$`r_Person[3,Intercept]`)


# % Ac P1 != Ac P2?

length(which((p1 - p2) < 0 )) / length(p1) * 100

length(which((p1 - p3) < 0 )) / length(p1) * 100

length(which((p2 - p3) < 0 )) / length(p1) * 100


# 

logistic(1) + logistic(0.5)
logistic(1 + 0.5)


## 


# Person effect
p1 = ( Ac + post$`r_Person[1,Intercept]`)
p2 = ( Ac +  post$`r_Person[2,Intercept]`)
p3 = ( Ac +  post$`r_Person[3,Intercept]`)

df = cbind(p1, p2, p3)
means = apply(df, 2, mean)
ci = t(apply(df, 2, HPDI, prob= .95))
ci
persons = 1:3
plot(apply(df, 2, mean) ~ persons, ylim = c(-4, 4), xlim = c(0.5, 3.5), cex = 2, pch = 21, bg = 'black', xaxt = "n", xlab = "", ylab = "Survival", main = "Ac")
segments(x0 = persons, x1 = persons, y0 = ci[,1], y1 = ci[,2])
axis(side = 1, at = c(1,2,3), labels = c("Person 1", "Person 2", "Person 3"))
abline(h = 0, lty = 2)