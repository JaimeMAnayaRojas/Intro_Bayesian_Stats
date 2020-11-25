# variables
height <- 4

height

height = 5

height

width <- 3
#calculate the are of a rectangle
area = height * width
area

# variables can also strore many entries

numbers = 1:100
numbers

# letters are store as characters,
letters = c("a", "b", "c")
letters

# you can also use your variable as factors, where values are id by levels

animals = c('mammals', 'birds', "reptiles", 'amphibians', 'humans')
animals = factor(animals)
levels(animals)

levels(animals)[3] <- "mammals" 

levels(animals)
animals

# Do this part in R directly
# install.packages(c("coda","mvtnorm","devtools","loo","dagitty", 'rstan', "brms", "readxl"))
# library(devtools)
# devtools::install_github("rmcelreath/rethinking")

# load the packages
library(rethinking)
library(brms)
library('readxl')

setwd("/home/mauriciok8/Dropbox/Projects_JM/Muenster/Intro_Bayesian_Stats/")


data = read_xls("Examples//Anaya-Rojas et al 2016/Fish_and_TankData.xls")

data[1:8,]

data$Origin = factor(data$Origin)
levels(data$Origin)

data$Nutrients = factor(data$Nutrients)
levels(data$Nutrients)

data$Exposure = factor(data$Exposure)
levels(data$Exposure)

data$Lake = ifelse(data$Origin == "Lake", 1, 0)
data$High = ifelse(data$Nutrients == "high", 1, 0)
data$G = ifelse(data$Exposure == 'G+', 1, 0)
data$CI = log(data$HIS)
data$Gyro = log(data$Gyrocount+1)
data$Tank = factor(data$Tank)
levels(data$Tank) = 1:length(levels(data$Tank))

data$Block = factor(data$Block)
levels(data$Block) = 1:length(levels(data$Block))

m.data = data[complete.cases(data),c("CI", 'Lake','High','G','Tank','Block','Gyro')]


str(m.data)

m.1 <- ulam(

    alist(
    CI ~ dnorm(mu, sigma),            # likelihood
    mu <- alpha + beta_G * Gyro,      # linear model
    alpha ~ dnorm(0,10),              # prior intercept
    beta_G ~ dnorm(0,10),             # prior slope 
    sigma ~ exponential(1)            # prior error
    ), data = m.data, 
    chains = 4, 
    cores = 4,
    iter = 2000,
    warmup = 1000
)

precis(m.1, prob=.95)

traceplot_ulam(m.1)

m.2 <- ulam(

    alist(
    CI ~ dnorm(mu, sigma),            # likelihood
    mu <- alpha + beta_G * Gyro + v_t[Tank] + v_b[Block] ,      # linear model
    alpha ~ dnorm(0,10),              # prior intercept
    beta_G ~ dnorm(0,10),             # prior slope 
    sigma ~ exponential(1),            # prior error
  
# Group level effects
    v_t[Tank] ~ dnorm(0,sigma_t), 
    v_b[Block] ~ dnorm(0,sigma_b),
    sigma_t ~ exponential(1),
    sigma_b ~ exponential(1)    
        
    ), data = m.data, 
    chains = 4, 
    cores = 4,
    iter = 2000,
    warmup = 1000
)




Condition_1 = brm(Condition ~ Gyro +  (1|Tank/Block),
              family = gaussian(),
             data = data, 
              cores = 2, chains = 2, iter= 3000, warmup=1500
             )



plot(Condition_1)

# use the summary function to see the bayesian inference
summary(Condition_1)

conditional_effects(Condition_1, effects = "Gyro")



# testing interactions
Condition_2 = brm(Condition ~ Gyro*Origin*Nutrients +  (1|Tank/Block),
              family = gaussian(),
             data = data, 
              cores = 2, chains = 2, iter= 3000, warmup=1500
             )


summary(Condition_2)

conditional_effects(Condition_2, effects = "Gyro:Nutrients")

loo_R2(Condition_1)
loo_R2(Condition_2)

Condition_1 = add_criterion(Condition_1, 'loo', moment_match = TRUE)
Condition_2 = add_criterion(Condition_2, 'loo', moment_match = TRUE)

loo_compare(Condition_1, Condition_2)

loo_model_weights(Condition_1, Condition_2)



Gyro_1 = brm(Gyrocount ~ Origin*Nutrients*Exposure + offset(Sd.lenght.mm) +
              (1|Tank/Block),
              family = zero_inflated_negbinomial,
             data = data, 
              cores = 2, chains = 2, iter= 3000, warmup=1500
             )

plot(Gyro_1)

Gyro_2 =brm(Gyrocount ~ Origin*Exposure + offset(Sd.lenght.mm) +
              (1|Tank/Block),
              family = zero_inflated_negbinomial,
             data = data, 
              cores = 2, chains = 2, iter= 3000, warmup=1500
             )

Gyro_3 =brm(Gyrocount ~ Origin*Exposure*Nutrients + offset(Sd.lenght.mm) +
              (1|Tank/Block),
              family = zero_inflated_negbinomial,
             data = data, 
              cores = 2, chains = 2, iter= 3000, warmup=1500
             )

# add criterion to the models for comparison

Gyro_1 = add_criterion(Gyro_1, 'loo')
Gyro_2 = add_criterion(Gyro_2, 'loo')
Gyro_3 = add_criterion(Gyro_3, 'loo')
# compare models

loo_compare(Gyro_1, Gyro_2, Gyro_3, criterion = 'loo')

# estimate model averaging
loo_model_weights(Gyro_1, Gyro_2, Gyro_3, criterion = 'loo')

summary(Gyro_2)

conditional_effects(Gyro_2, effects = "Origin:Exposure")

# What is the probability that expose lake fish have higher numbers of parasites than no-exposed lake fish?
post2 = posterior_samples(Gyro_2)

LakeGyr = post2$b_Intercept + post2$b_OriginStream * 0 + post2$b_ExposureYes * 1  + post2$`b_OriginStream:ExposureYes`*0
LakeNoGyr = post2$b_Intercept + post2$b_OriginStream * 0 + post2$b_ExposureYes * 0  + post2$`b_OriginStream:ExposureYes`*0
length(which(LakeGyr - LakeNoGyr > 0))/ length(LakeGyr)

# the probability that expose lake fish have higher numbers of parasites than no-exposed lake fish:


