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

# install.packages(c("coda","mvtnorm","devtools","loo","dagitty", 'rstan', "brms", "readxl"))
# library(devtools)
# devtools::install_github("rmcelreath/rethinking")

# load the packages
library(rethinking)
library(brms)
library('readxl')

data = read_xls("Examples/Anaya-Rojas et al 2016/Fish_and_TankData.xls")
data[1:8,]

data$Origin = factor(data$Origin)
levels(data$Origin)

data$Nutrients = factor(data$Nutrients)
levels(data$Nutrients)

data$Exposure = factor(data$Exposure)
levels(data$Exposure)

# create dummy variables
data$Lake = ifelse(data$Origin == "Lake", 1, 0)
data$High = ifelse(data$Nutrients == "high", 1, 0)
data$G = ifelse(data$Exposure == 'G+', 1, 0)
data$CI = log(data$HIS)
data$Gyro = log(data$Gyrocount+1)
data$Tank = factor(data$Tank)
levels(data$Tank) = 1:length(levels(data$Tank))
data$Block = factor(data$Block)
levels(data$Block) = 1:length(levels(data$Block))


# Keep only the data needed for the anlysis
m.data = data[,c("CI", 'Lake','High','G','Tank','Block','Gyro')]
m.data$Tank = factor(m.data$Tank)
levels(m.data$Tank) = 1:length(levels(m.data$Tank)) # make sure that the levels are correct
m.data$Block = factor(m.data$Block)
levels(m.data$Block) = 1:length(levels(m.data$Block))  # make sure that the levels are correct
str(m.data) # see the structure of the m.data

# Run a model describing the relationship between body condition (CI) and parasite load (Gyro)
m.1 <- ulam(

    alist(
    CI ~ dnorm(mu, sigma),            # likelihood
    mu <- alpha + beta_G * Gyro,      # linear model
    alpha ~ dnorm(0,10),              # prior intercept
    beta_G ~ dnorm(0,10),             # prior slope 
    sigma ~ exponential(1)            # prior error
    ), data = m.data, log_lik = TRUE,
    chains = 4, 
    cores = 4,
    iter = 2000,
    warmup = 1000
)

traceplot_ulam(m.1) # 

precis(m.1, prob=.95) # look at the model estimations

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
        
    ), data = m.data, log_lik = TRUE,
    chains = 4, 
    cores = 4,
    iter = 4000,
    warmup = 2000,
    control = list(adapt_delta = 0.92, max_treedepth = 11) # options to tune up the model
)

traceplot_ulam(m.2)

m.3 <- ulam(

    alist(
    CI ~ dnorm(mu, sigma),            # likelihood
    mu <- alpha + beta_G * Gyro + beta_L*Lake +
        v_t[Tank]  + v_b[Block],      # linear model
    alpha ~ dnorm(0,10),              # prior intercept
    beta_G ~ dnorm(0,10),             # prior slope 
    beta_L ~ dnorm(0,10),             # prior slope 
    sigma ~ exponential(1),            # prior error
  
# Group level effects
    v_t[Tank] ~ dnorm(0,sigma_t), 
    v_b[Block] ~ dnorm(0,sigma_b),
    sigma_t ~ exponential(1),
    sigma_b ~ exponential(1)    
        
    ), data = m.data, log_lik = TRUE,
    chains = 4, 
    cores = 4,
    iter = 2000,
    warmup = 1000
)


m.4 <- ulam(

    alist(
    CI ~ dnorm(mu, sigma),            # likelihood
    mu <- alpha + beta_G * Gyro + beta_L*Lake + beta_GL*(Lake*Gyro) +
        v_t[Tank] + v_b[Block],      # linear model
    alpha ~ dnorm(0,10),              # prior intercept
    beta_G ~ dnorm(0,10),             # prior slope 
    beta_L ~ dnorm(0,10),             # prior slope 
    beta_GL ~ dnorm(0,10),             # prior slope 
    sigma ~ exponential(1),            # prior error
  
# Group level effects
    v_t[Tank] ~ dnorm(0,sigma_t), 
    v_b[Block] ~ dnorm(0,sigma_b),
    sigma_t ~ exponential(1),
    sigma_b ~ exponential(1)    
        
    ), data = m.data, log_lik = TRUE,
    chains = 4, 
    cores = 4,
    iter = 2000,
    warmup = 1000
)

traceplot_ulam(m.4)

compare(m.1, m.2, m.3, m.4)

post4 = extract.samples(m.4)
str(post4)

p.link = function(posteriors, Gyros = NULL, Lake = 1){
   Gyros<- log(Gyros+1)
   pred<- with(posteriors, alpha + beta_G*Gyros + beta_L*Lake + beta_GL*(Gyros*Lake))
   return(pred)
}

# Estimate the body condition of a lake fish with 10 parasites
mean(p.link(posteriors  = post4, Gyros = 10, Lake = 1))
HPDI(p.link(posteriors  = post4, Gyros = 10, Lake = 1), prob=.95)

Lgyro_count = seq(from = 0, to = max(m.data$Gyro[which(m.data$Lake == 1)]), length.out = 100)
raw.L = sapply(1:length(Lgyro_count), function(i)p.link(posteriors  = post4, Gyros = Lgyro_count[i], Lake = 1))
Sgyro_count = seq(from = 0, to = max(m.data$Gyro[which(m.data$Lake == 0)]), length.out = 100)
raw.S = sapply(1:length(Sgyro_count), function(i)p.link(posteriors  = post4, Gyros = Sgyro_count[i], Lake = 0))

str(raw.L)

mean.L = apply(raw.L, 2, mean)
mean.L

ci.L = apply(raw.L, 2, HPDI)
ci.L

mean.S = apply(raw.S, 2, mean)
ci.S = apply(raw.S, 2, HPDI)

# does parasite load reduces body condition?
post2 = extract.samples(m.2)
dens(post2$beta_G, show.HPDI = TRUE, show.zero = TRUE)

# what is the probability of $\beta_{G} < 0$?
n_negative = length(which(post2$beta_G <0 ))
n_total = length(post2$beta_G )
round((n_negative/n_total) * 100,3) 

# is this relationship different between ecotypes?
# what is the probability of $\beta_{GL} < 0$?
n_negative = length(which(post4$beta_GL >0 ))
n_total = length(post4$beta_GL )
round((n_negative/n_total) * 100,3) 


plot(CI ~ Gyro, m.data, pch="", xlab = "Gyrodactylus (log)")
points(CI ~ Gyro, subset(m.data, Lake == 1), pch=21, bg = "dodgerblue2" ,cex = 1.5)
lines(x =Lgyro_count, y = mean.L, col = "dodgerblue2", lty=1, lwd=3 )
shade(ci.L, Lgyro_count, col = col.alpha('dodgerblue2', 0.3) )

points(CI ~ Gyro, subset(m.data, Lake == 0), pch=21, bg = "tomato" ,cex = 1.5)
lines(x =Sgyro_count, y = mean.S, col = "tomato", lty=1, lwd=3 )
shade(ci.S, Sgyro_count, col = col.alpha('tomato', 0.3) )

precis(m.4, prob=.89)

glimmer(CI ~ Gyro + (1|Tank|Block), data = m.data)

Gyro_1 = brm(Gyrocount ~ Origin*Nutrients*Exposure + offset(Sd.lenght.mm) +
              (1|Tank/Block),
              family = zero_inflated_negbinomial,
             data = data, 
              cores = 4, chains = 4, iter= 4000, warmup=2000,
             control = list(adapt_delta = 0.95, max_treedepth = 14)
             )

plot(Gyro_1)

summary(Gyro_1)

conditional_effects(Gyro_1, effects = "Exposure:Origin")

Gyro_2 = brm(Gyrocount ~ Origin*Exposure + offset(Sd.lenght.mm) +
              (1|Tank/Block),
              family = zero_inflated_negbinomial,
             data = data, 
              cores = 4, chains = 4, iter= 4000, warmup=2000,
             control = list(adapt_delta = 0.95, max_treedepth = 14)
             )

Gyro_1 <- add_criterion(Gyro_1, criterion = 'loo')
Gyro_2 <- add_criterion(Gyro_2, criterion = 'loo')
loo_compare(Gyro_1, Gyro_2)

loo_model_weights(Gyro_1, Gyro_2)

post_G2 = posterior_samples(Gyro_2)
str(post_G2)

# What is the probability that Lake G+ have more parasites than Stream G+ fish?
LG = post_G2$b_Intercept + post_G2$b_OriginStream*0 + post_G2$b_ExposureGP*1 + post_G2$`b_OriginStream:ExposureGP`*0
SG = post_G2$b_Intercept + post_G2$b_OriginStream*1 + post_G2$b_ExposureGP*1 + post_G2$`b_OriginStream:ExposureGP`*1

n_negative = length(which(LG - SG > 0 ))
n_total = length(LG)
round((n_negative/n_total) * 100,3) 
