
# Install the necessary packages

# install.packages(c("coda","mvtnorm","devtools","loo","dagitty", 'rstan', "brms"))
# library(devtools)
# devtools::install_github("rmcelreath/rethinking")

# After installing the packages you can delete  the code above or out comment by adding an # in front of each line or by selecting the lines and 
# pressing cntr + shift + c


# load the packages
library(rethinking)
library(brms)
library('readxl')


rm(list=ls()) # clean the memory of R
data("Howell1") # get the data from the the rethinking package
data <- Howell1

# look at the data
head(data)
hist(data$height)


# Make the plots for the presentation

op<-par(mfrow=c(2,3), mar = c(4, 5, 2, 1), oma = c(1, 1, 1, 1), cex = 0.75)
boxplot(height ~ male, data, ylab = "Height (cm)", xlab = 'Sex', xaxt='n')
axis(1, at = c(1,2), labels = c("Female", "Make"))

plot(height ~ weight, data, pch='', ylab = '')
points(height ~ weight, subset(data, male == 1), pch=21, bg = "tomato")
points(height ~ weight, subset(data, male == 0), pch=21, bg = "cyan")
legend('topleft', legend = c("Male","Female"), pch = 21, pt.bg = c('tomato', 'cyan'), bty = 'n')


plot(height ~ age, data, pch='',  ylab='')
points(height ~ age, subset(data, male == 1), pch=21, bg = "tomato")
points(height ~ age, subset(data, male == 0), pch=21, bg = "cyan")


boxplot(log(height) ~ male, data, ylab = "Height log(cm)", xlab = 'Sex', xaxt='n')
axis(1, at = c(1,2), labels = c("Female", "Make"))


plot(log(height) ~ log(weight), data, pch='', ylab = '')
points(log(height) ~ log(weight), subset(data, male == 1), pch=21, bg = "tomato")
points(log(height) ~ log(weight), subset(data, male == 0), pch=21, bg = "cyan")


plot(log(height) ~ log(age), data, pch='', ylab = '')
points(log(height) ~ log(age), subset(data, male == 1), pch=21, bg = "tomato")
points(log(height) ~ log(age), subset(data, male == 0), pch=21, bg = "cyan")


# Question: Do man and women differe in their height?
# Test hypothesis: Males are taller than women:
# Run the model using the Rethingking package


glimmer(height ~ male, family = gaussian, data = data) # get the structure of the model with the glimmer function



# Run the model with the map2stan function from the rethinking package
m1 <- map2stan(
  alist(
    height ~ dnorm( mu , sigma ), # likelihood
    mu <- Intercept +   b_male*male, # linear model 
    Intercept ~ dnorm(134,10), # priors for intercept, I know that the mean women's hight is around 134 cm, I am not sure about the sd, so I add a large one
    b_male ~ dnorm(0,10), # priors for the slople
    sigma ~ dcauchy(0,2) # priors for model error
  ), data = data, chains = 4, cores = 4, iter = 3000, warmup = 1500, WAIC = TRUE
  
)

# are the HMC chains mixing well?
tracerplot(m1)
graphics.off()
# summary statistics with High Probability Density Intervals at 95% i.e. Confidence Interval
precis(m1, digits = 5, prob = .95) 
# What do these results mean? 
# Males are coded as 1, and women  as 0, therefore the intercept represent women's height
# The model predicts that a women has a mean height of 134.77 cm, and ranges  from 131.6 to 137.8 with 95% confidence
# Males on the other hand, are between 2.83 to 11.88 cm taller than women with 95% confidence
# the error of the models ranges from 25.8 to 29.06, 


# Compare those results with a classical frequentist analysis
summary(lm(height ~ male, data)) # as you can see the results are very similar.
# but the interpretation is a bid different, normally people will read it as:
# Males are significantly than females (F_{1,542} = 10.71p-value < 0.05)


# let's do more things, and test our hypothesis using the posterior samples.
post = extract.samples(m1) # get the posterior samples after the warming period

# Model the height of Males 
Males = post$Intercept +  post$b_male * 1 # Estimate men's height from the posterior samples
Females = post$Intercept +  post$b_male * 0 # Estimate women's height from the posterior samples

# What is the probability that males are taller than women?
SexDifference = Males - Females
PP = length(which(SexDifference > 0)) / length(SexDifference) # Number of posterior predicted samples where males are taller than females / total number of samples
PP*100 # the answer is males are defenetly larger than females with a ~100% certainty



# plot those predictions
op<-par(mfrow=c(2,1), mar = c(4, 5, 2, 1), oma = c(1, 1, 1, 1), cex = 1)
dens(Females, show.HPDI = T, show.zero = F, main = "", ylim = c(0,0.4), xlim = c(120,150), xlab = 'Height (cm)',  col = 'blue')
values = round(mean(Females),2)
text(x = mean(Females), y = 0.35, labels = values )
values = paste("(", round(HPDI(Females, prob = .95), 2)[1], " : ", round(HPDI(Females, prob = .95), 2)[2], ")", sep ="" )
text(x = mean(Females), y = 0.3, labels = values )

dens(Males, show.HPDI = T, show.zero = T, main = "Males", ylim = c(0,0.4), xlim = c(120,150), xlab = 'Height (cm)', add = T, col = 'red')
values = round(mean(Males),2)
text(x = mean(Males), y = 0.35, labels = values )
values = paste("(", round(HPDI(Males, prob = .95), 2)[1], " : ", round(HPDI(Males, prob = .95), 2)[2], ")", sep ="" )
text(x = mean(Males), y = 0.3, labels = values )


dens(SexDifference, show.HPDI = T, show.zero = T, xlim=c(-1,18), main = "Males - Females", ylim = c(0,0.25))
values = round(mean(SexDifference),2)
text(x = mean(SexDifference), y = 0.245, labels = values )
values = paste("(", round(HPDI(SexDifference, prob = .95), 2)[1], " : ", round(HPDI(SexDifference, prob = .95), 2)[2], ")", sep ="" )
text(x = mean(SexDifference), y = 0.2, labels = values )


# let's plot the results in another way
# Make a barplot

df = data.frame(male = c(0,1), mean = c(mean(Females), mean(Males)), 
                LC = c(HPDI(Females, prob = .95)[1], HPDI(Males, prob = .95)[1]), 
                UC = c(HPDI(Females, prob = .95)[2], HPDI(Males, prob = .95)[2]))

df

graphics.off()
plot(height ~ male, data, pch='', xaxt='n', ylim = c(min(df$LC), max(df$UC)), xlab = "Sex", ylab = 'Height (cm)')
axis(1, at = c(0.25,0.75), labels = c("Female", "Make"))
segments(x0 =c(0.25,0.75), x1 =c(0.25,0.75), y0 = df$LC, y1=df$UC)
segments(x0 =c(0.25), x1 =c(0.75), y0 = df$mean[1], y1=df$mean[2])
points(df$mean ~ c(0.25,0.75), cex = 2, pch =21, bg = 'gray' )




# let's as other questions 
#  is the relationship between body weight and height different between males and females?

# let's use only the data for people older than 18
data <- subset(data, age >= 18) 
data$weight_c =(data$weight) - 45 # center at 45 kg


# why do we center? because it help us to make sence of the data
op<-par(mfrow=c(2,1), mar = c(4, 5, 2, 1), oma = c(1, 1, 1, 1), cex = 1)
plot(data$height ~ data$weight)
abline(v=45)

# By centering at 45 Kg, we force the intercept to be at 45 Kg and not at a crazy 
summary(lm(height ~ weight, data)) # here the model predicts that a person with 0 Kg should be 113.87 cm, that just doesn't make sence
# additionally, it also says that by each 1 Kg she/he will grow 0.9cm.


plot(data$height ~ data$weight_c)
abline(v=0)
summary(lm(height ~ weight_c, data)) # here the model predicts that a 45 Kg person should be 154.6 cm, that makes more sence
# additionally, it also says that by each 1 Kg she/he gains will grow 0.9 cm.





m2 <- map2stan(
  alist(
    height ~ dnorm( mu , sigma ), # likelihood
    mu <- Intercept + b_weight*weight_c + b_male*male + b_WxM * (weight_c*male), # linear model, including an interaction term 
    Intercept ~ dnorm(134,100), # priors for intercept
    b_male ~ dnorm(0,10), # priors for the slople
    b_weight ~ dnorm(0,10), # priors for the slople
    b_WxM ~ dnorm(0,10), # priors for the slople
    sigma ~ dcauchy(0,10) # priors for model error
  ), data = data, chains = 4, cores = 4, iter = 3000, warmup = 1500, WAIC = TRUE
  
)

m2brms <- brm(height ~ weight_c*male, family = gaussian(), data = data)

tracerplot(m2)
precis(m2, digits = 5, prob = .95) # summary statistics with High Probability Density Intervals at 95% i.e. Confidence Interval

# here, the intercept represent a women (0) that weights 45Kg, 
# the average man is predicted to be between 5.4 and 7.48 cm taller with 95% certainty.
# in average a person is predicted to increase between 0.47 and 0.69 cm with 95% certainty, 
# men seem to grow 0.11 cm more than women, however this relationship is not different at 95% certainty.
post = extract.samples(m2) # get the posterior samples after the warming period
length(which(post$b_WxM > 0))/length(post$b_WxM) # Men are predicted to growth faster than women with each kilogram with  a probability of 91%, is that significant?



# let's model this effects through a user define function

p.link <- function(posterior_samples=NULL, weight = NULL, sex = NULL, center = 45){
  weight = weight -center
  mu <- with(posterior_samples,  Intercept + b_weight*weight + b_male*sex + b_WxM * (weight*sex) )
  return(mu)
}


# is a 45Kg man taller than a 45Kg woman?
F45 = p.link(posterior_samples = post, weight = 45, sex = 0)
mean(F45)
HPDI(F45, prob = .95)

M45 = p.link(posterior_samples = post, weight = 45, sex = 1)
mean(M45)
HPDI(M45, prob = .95)

# Posterior probability that Males are larger than females at 30 Kg
100 * length(which(M45 -F45 > 0)) / length(M45)

(HPDI((M45/F45), prob = .95) -1) * 100 # a 45Kg man is predicted to be among 3.57 to 4.95% taller than a 45Kg women with 100% certainty.


# Average Probability across a range of weights

x_weights = seq(from=min(data$weight), to=max(data$weight), length.out = 100) # get a range of weights

Males_heights = sapply(1:100, function(i) p.link(posterior_samples = post,     # run the p.link function for all weights
                                 weight = x_weights[i], sex = 1,center = 45))


str(Males_heights) # the result is a matrix, with the rows representing the results for each interaction of the posterior distribution
                  # and the columns each weight from the x_weights 


Females_heights = sapply(1:100, function(i) p.link(posterior_samples = post, 
                                                 weight = x_weights[i], sex = 0, center = 45))

graphics.off()



# Now, let's plot these relationships
plot(height ~ weight, data, pch='',  ylab = "Height (cm)", xlab = "Weight (Kg)")
points(height ~ weight, subset(data, male == 1), pch=21, bg = col.alpha('tomato', 0.3), cex = 1, col= 'red') # Male points
p.mean_M <- apply(Males_heights, 2, mean ) # male mean per weight
p.HPDI_M <- apply(Males_heights, 2, HPDI, prob =.95 ) # male 95% HPDI per weight
lines(x = x_weights, y = p.mean_M, col='tomato') # plot the men's mean as a line
shade(object = p.HPDI_M, x_weights, col = col.alpha('tomato', 0.2))# plot the men's HPDI as shades 


points(height ~ weight, subset(data, male == 0), pch=21, bg = col.alpha('cyan', 0.3), cex = 1, col= 'blue')
p.mean_F <- apply(Females_heights, 2, mean )
p.HPDI_F <- apply(Females_heights, 2, HPDI, prob =.95 )
lines(x = x_weights, y = p.mean_F, col='blue')
shade(object = p.HPDI_F, x_weights, col = col.alpha('cyan', 0.2))
legend('topleft', legend = c("Male","Female"), pch = 21, pt.bg = c(col.alpha('tomato',.2),col.alpha('cyan',.2)),  bty = 'n', pt.cex = 2)

# Our plot supports the results from the summary, the interactions is not "significant"


# Now let's test the fit of our model graphically


# using the same methods as above, simulate get the predicted data from the posterior distribution
Pred <-  sapply(1:dim(data)[1], function(i) p.link(posterior_samples = post, 
                                                   weight = data$weight[i], sex = data$male[i]))

str(Pred)

# let's make a function to calculate the residuals (i.e., predicted - observe)
Residuas_fun = function(Pred =NULL, Obsv.data = NULL){
  
  E1 = Pred - Obsv.data
return(E1)
  
}

E1 = sapply(1:dim(data)[1], function(i) Residuas_fun(Pred = Pred[,i], Obsv.data = data$height[i])) # apply this function for all the predictors
str(E1)

hist(E1, main = "Residuals (Predicted - Observed)") # are the residuals normally distruted?


# are the predicted values close to the observed values
plot(data$height ~ apply(Pred, 2, mean), ylab= "Observed Height (cm)", xlab="Predicted Height (cm)")
ci = t(apply(Pred, 2, HPDI, prob=.95))
segments(x0 = ci[,1], x1 = ci[,2], y0 = data$height, y1 = data$height)
abline(0,1) # add a 1:1 line, that represents the perfect fit among  predicted and observed values




###############
############## --- With another package (brms)

# let's analysed a randomized factorial experiment

rm(list=ls())

getwd() # get my working directory
# setwd() # in case you have to change the directory "my_path/Muesnter_EE2020"

data <- read_excel("Data/Fish_and_TankData.xls", sheet = "Fish")
head(data)


data$Origin = factor(data$Origin) # fish ecotype
levels(data$Origin) # 
levels(data$Origin) <- c(1,0) # recode the variables to make easier the interpredations lake==1 and stream == 0
data$Origin = as.numeric(as.character(data$Origin))

data$Nutrients = factor(data$Nutrients)
levels(data$Nutrients)
levels(data$Nutrients) <- c(1,0)
data$Nutrients = as.numeric(as.character(data$Nutrients))

data$Exposure = factor(data$Exposure)
levels(data$Exposure) 
levels(data$Exposure) <- c(0,1)
data$Exposure = as.numeric(as.character(data$Exposure))


# Now we are going to use another package that do the same but in a slighly different way
# Here, we are going to model the differences in parasite load (Gyrodactylus count) between lake and stream stickelbacks, and the effects of 
# the exposure to this parasite. We use a negbinomial error family to model the count data, it is an alternative to Poisson distribution.

# the experiment was done in 40 tanks, each tank with multiple fish, and those 40 tanks representing 5 randomized blocks.
# so, here, we use Tank id and Block id as random effects.



m1_brms <- brm(Gyrocount ~ Origin*Exposure + (1|Tank) + (1|Block), family = negbinomial(), 
               data = data, iter = 3000, warmup = 1500, cores = 4, chains=4,  
               control = list( adapt_delta = 0.9, max_treedepth = 13)) # this control part, allows you to fine tune the model, it will run slower but 
                                                                        # it will work harder to get good results

plot(m1_brms) # we have some divergent transitions after the warm up, but in general the model looks good
summary(m1_brms) # Here, the results are in a log scale, so if you want to interpret them in counts you have to transform.

# the intercept here represents stream fish (0) and no exposed to the parasite G- (0)
exp(0.13) # 1.13 parasites in average


# we can use the same strategy as above to model the predictions and test hypothesis
post <- posterior_samples(m1_brms)

str(post)


p.link = function(posterior_samples =NULL, Origin =NULL, Exposure = NULL){
  
  
  p <- posterior_samples$b_Intercept + posterior_samples$b_Origin* Origin  + 
    posterior_samples$b_Exposure* Exposure + posterior_samples$`b_Origin:Exposure` *  (Origin*Exposure)   
  
  exp(p)   # we transform to the exponential scale
  
}


Lake_noG = p.link(posterior_samples = post, Origin = 1, Exposure = 0) # Lake:G-
Lake_G = p.link(posterior_samples = post, Origin = 1, Exposure = 1) # Lake:G+
Stream_noG = p.link(posterior_samples = post, Origin = 0, Exposure = 0) #Stream:G-
Stream_G = p.link(posterior_samples = post, Origin = 0, Exposure = 1) # Stream:G+


df <- data.frame(Origin = c("Lake", "Lake", 'Stream', "Stream"), Exposure = c(0,1,0,1) , 
                 mean = c(mean(Lake_noG), mean(Lake_G),mean(Stream_noG), mean(Stream_G)),
                 LC = c(HPDI(Lake_noG, prob = .95)[1], HPDI(Lake_G, prob = .95)[1],HPDI(Stream_noG, prob = .95)[1], HPDI(Stream_G, prob = .95)[1]),
                 UC = c(HPDI(Lake_noG, prob = .95)[2], HPDI(Lake_G, prob = .95)[2],HPDI(Stream_noG, prob = .95)[2], HPDI(Stream_G, prob = .95)[2]))

df$Treatment = c(1:4)
df
# 

plot(mean ~ Treatment, df, pch='', xlim = c(0.5,4.5), xaxt='n', ylim = c(min(df$LC), max(df$UC)), ylab = "Parasite load")
segments(x0 = df$Treatment, x1=df$Treatment, y0 = df$LC, y1 = df$UC )
points(mean ~ Treatment, df, pch=21, cex = 2, bg = c("gray", 'black'))
axis(side = 1, at = c(1.5,3.5), labels = c("Lake", "Stream"))
legend('topleft', legend = c("G-","G+"), pch = 21, pt.bg = c('gray', 'black'), bty = 'n', pt.cex = 2)
pp = 100 * length(which(log(Lake_G/Lake_noG) > 0)) / length(Lake_G) # Probability of Lake:G+ having more parasites than Lake:G-
text(x = 1.5, y = 50, labels = paste(round(pp,2),'%', sep=''))
pp = 100 * length(which(log(Stream_G/Stream_noG) > 0)) / length(Stream_G)
text(x = 3.5, y = 50, labels = paste(round(pp,2),'%', sep=''))  # Probability of Stream:G+ having more parasites than Stream:G-
abline(v = 2.5)

ppA = 100 * length(which(log(Lake_G/Stream_G) > 0)) / length(Lake_G) # Probability of Lake:G+ having more parasites than Stream:G+
ppB = 100 * length(which(log(Lake_noG/Stream_noG) > 0)) / length(Lake_G) # Probability of Lake:G- having more parasites than Stream:G-

(ppA + ppB) / 2 # Average probability of Lake fish being more infected than stream fish




