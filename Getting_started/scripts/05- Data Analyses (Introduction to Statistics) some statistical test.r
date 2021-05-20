# My first chi-square 
# Make as many anotations as necessary
rm(list=ls())

# load the libraries


library(ggplot2)
library(dplyr)

# Get the data

# in R studio
# lady <- read.csv("file path/datasets-master/ladybirds_morph_colour.csv")

lady <- read.csv("datasets-master/ladybirds_morph_colour.csv")
glimpse(lady)

# pipe to sumarise and get the total number of ladybirds
totals <- lady %>%
    group_by(Habitat, morph_colour) %>%
        summarise(total.number = sum(number))
totals

# plot the data

ggplot(totals, aes(x = Habitat, y =total.number, fill = morph_colour )) +
    geom_bar(stat="identity", position = 'dodge')

# plot the data

ggplot(totals, aes(x = Habitat, y =total.number, fill = morph_colour )) +
    geom_bar(stat="identity", position = 'dodge') + 
    scale_fill_manual(values = c(black ="black", red = "red"))

lady.mat <- xtabs(number~ Habitat + morph_colour, data = lady)
lady.mat

chisq.test(lady.mat)

test <- chisq.test(lady.mat)
names(test)

test$expected

# Ozone data

ozone <- read.csv("datasets-master/ozone.csv")
glimpse(ozone)

ggplot(ozone, aes(x = Ozone)) + 
    geom_histogram(binwidth = 10) + 
    facet_wrap(~ Garden.location, ncol = 1) + 
    theme_bw()

# let's calculate some stats mean and sd 
summary <- ozone %>%
    group_by(Garden.location) %>%
        summarise(mean = mean(Ozone), sd=sd(Ozone))
summary


# two t-test

t.test(Ozone ~ Garden.location, data = ozone)

# var test
var.test(Ozone ~ Garden.location, data = ozone)

plant_gr <- read.csv("datasets-master/plant.growth.rate.csv")
glimpse(plant_gr)

# Plot the data ( Plant growth vs soil moisture)

ggplot(plant_gr, aes(x= soil.moisture.content, y = plant.growth.rate)) + 
    geom_point()



# Model plant growth rate as a function of soil moisture 

model_pgr <- lm(plant.growth.rate ~ soil.moisture.content, data = plant_gr)
summary(model_pgr)

# What does it mean biologically?

# model inspection
#install.packages("ggfortify")
library(ggfortify)
autoplot(model_pgr, smooth.colour = NA)

anova(model_pgr)

str(plant_gr)

summary(model_pgr)

# Plot the regression line
ggplot(plant_gr, aes(x = soil.moisture.content, y = plant.growth.rate)) + 
    geom_point() + geom_smooth(method = 'lm') + 
    ylab("Plant Growth Rate (mm/week)") +
    xlab("Soil Moisture") + 
    theme_bw()

# waterflies data set

daphnia <- read.csv("datasets-master/Daphniagrowth.csv")
glimpse(daphnia)



# plot

ggplot(daphnia, aes(x= parasite, y= growth.rate)) + 
    geom_boxplot()

daphnia$parasite <- factor(daphnia$parasite)
levels(daphnia$parasite)

daphnia$Metschnikowia <- ifelse(daphnia$parasite == 'Metschnikowia bicuspidata', 1, 0 )
daphnia$Pansporella <- ifelse(daphnia$parasite == 'Pansporella perplexa', 1, 0 )
daphnia$Pasteuria <- ifelse(daphnia$parasite == 'Pasteuria ramosa', 1, 0 )
daphnia$control <- ifelse(daphnia$parasite == 'control', 1, 0 )
head(daphnia)


daph_mod <- lm(growth.rate ~ parasite, data = daphnia)

daph_mod2 <- lm(growth.rate ~ control + Pansporella + Pasteuria, data = daphnia)

autoplot(daph_mod)

# interpredation
anova(daph_mod)

model.matrix(~parasite, data = daphnia)



summary(daph_mod)


((1.21391 + (-0.73171))/1.21391   ) * 100 

# plot

ggplot(daphnia, aes(x= parasite, y= growth.rate)) + 
    geom_boxplot()

#summary(daph_mod2)

growth.moo <- read.csv('datasets-master/growth.csv')
glimpse(growth.moo)

growth.moo$diet <- factor(growth.moo$diet)
levels(growth.moo$diet)

growth.moo$supplement <- factor(growth.moo$supplement)
levels(growth.moo$supplement)

3*4 # treatment levels

growth.moo <- mutate(growth.moo, 
                    supplement = relevel(supplement, ref = "control"))

growth.moo$supplement <- factor(growth.moo$supplement)
levels(growth.moo$supplement)

growth.moo <- mutate(growth.moo, 
                    diet = relevel(diet, ref = "oats"))

growth.moo$diet <- factor(growth.moo$diet)
levels(growth.moo$diet)

ggplot(growth.moo, aes(x=supplement, y= gain, colour = diet)) + 
geom_boxplot()


mod.full <- lm(gain ~ diet * supplement, data= growth.moo)

mod.main <- lm(gain ~ diet + supplement, data= growth.moo)

mod.diet <- lm(gain ~ diet, data= growth.moo)

mod.supl <- lm(gain ~ diet * supplement, data= growth.moo)


anova(mod.full)
summary(mod.full)

anova(mod.main)

summary(mod.main)

# Model selection

mod.full <- lm(gain ~ diet * supplement, data= growth.moo) # interaction

mod.main <- lm(gain ~ diet + supplement, data= growth.moo) # main effects

mod.diet <- lm(gain ~ diet, data= growth.moo)

mod.supl <- lm(gain ~  supplement, data= growth.moo)


anova(mod.full, mod.main, mod.diet, mod.supl)

AIC(mod.full, mod.main, mod.diet, mod.supl)



drop1(mod.full)

mod.up1 <- update(mod.full, .~.  -diet:supplement)

anova(mod.up1)

com <- read.csv('datasets-master/compensation.csv')
# compare the fruit production between grazed and ungrazed plants
# get more information about the box-plot
ggplot(com, aes(y=Fruit, x=Grazing))+
geom_boxplot() + 
geom_jitter(size = 5, colour= "gray", alpha =0.8, width = 0.25) +
theme_bw() + 
ylab("Fruit Production")

ggplot(com, aes(y=Fruit, x=Root, colour= Grazing))+
geom_point(size = 3) + 
xlab(label = "Root biomass") +
ylab("Fruit Production") +
geom_smooth(method = "lm") +
#ylim(-50, 120) +  xlim(0, 15) + 
#geom_hline(yintercept = -41.286) +
theme_bw()

ancova.1 <- lm(Fruit ~ Grazing * Root, data = com)
anova(ancova.1)

summary(ancova.1)

com$Root_c <- com$Root - 7
ancova.2 <- lm(Fruit ~ Grazing * Root_c, data = com)
anova(ancova.2)
summary(ancova.2)
