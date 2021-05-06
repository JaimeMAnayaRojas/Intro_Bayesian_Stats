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
