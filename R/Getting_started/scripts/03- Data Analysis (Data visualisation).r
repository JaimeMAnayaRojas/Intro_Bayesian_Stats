# Plotting with ggplot2
# data
# Make as many anotations as necessary
rm(list=ls())

# load the libraries

library(ggplot2)
library(dplyr)

data <- read.csv("datasets-master/compensation.csv")

glimpse(data)


## ggplot2 grammar:
ggplot(data, aes(y=Fruit, x=Root))+
geom_point()

# Change the size of the points
ggplot(data, aes(y=Fruit, x=Root))+
geom_point(size= 3)

# Change the size of the points
# color the points by groups, e.g. Grazing
ggplot(data, aes(y=Fruit, x=Root, colour= Grazing))+
geom_point(size = 3)

# Change the size of the points
# color the points by groups, e.g. Grazing
# remove the gray background
ggplot(data, aes(y=Fruit, x=Root, colour= Grazing))+
geom_point(size = 3) + 
theme_bw() # add at the end

# Change the size of the points
# color the points by groups, e.g. Grazing
# remove the gray background
# change axis names
ggplot(data, aes(y=Fruit, x=Root, colour= Grazing))+
geom_point(size = 3) + 
xlab(label = "Root biomass") +
ylab("Fruit Production") +
theme_bw()

# compare the fruit production between grazed and ungrazed plants
ggplot(data, aes(y=Fruit, x=Grazing))+
geom_boxplot() + 
theme_bw() + 
ylab("Fruit Production")

# compare the fruit production between grazed and ungrazed plants
# get more information about the box-plot
ggplot(data, aes(y=Fruit, x=Grazing))+
geom_boxplot() + 
geom_point(size = 5, colour= "gray", alpha =0.5)+
theme_bw() + 
ylab("Fruit Production")

# compare the fruit production between grazed and ungrazed plants
# get more information about the box-plot
ggplot(data, aes(y=Fruit, x=Grazing))+
geom_boxplot() + 
geom_jitter(size = 5, colour= "gray", alpha =0.8) +
theme_bw() + 
ylab("Fruit Production")

# compare the fruit production between grazed and ungrazed plants
# get more information about the box-plot
ggplot(data, aes(y=Fruit, x=Grazing))+
geom_boxplot() + 
geom_jitter(size = 5, colour= "gray", alpha =0.8, width = 0.25) +
theme_bw() + 
ylab("Fruit Production")


# Making histogram

ggplot(data, aes(x=Fruit)) +
geom_histogram()

ggplot(data, aes(x=Fruit)) +
geom_histogram(binwidth= 13)

## Facet for panels

ggplot(data, aes(x=Fruit)) +
geom_histogram(binwidth = 13)+
facet_wrap(.~ Grazing)

ggsave("MyHistogram.png", dpi = 800)
ggsave("MyHistogram.pdf")
