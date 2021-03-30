# This is my first R script.
# 29 March 2021
# Here, we are learning how to use R. 

# install.packages("ggplot2")
library("ggplot2")

# Clear R's memory 
rm(list=ls())


# 1. basic math operations

4 + 5 # this is an addition, we use the + symbol

9*5 # this is a multiplication, we use *

452684556565 / 4564866151 # we use / for division

10 < 7


# assign values

x <- 25 
y <- 50

x + y

x * 2


x <- seq(1,10000, by=0.25)

length(x)

# Functions and packages

y <- x^3

plot(y ~ x)
plot(y ~ x, type = "l")

# use ggplot

qplot(x, y, geom = "line" )
qplot(log10(x), log10(y), geom = "line" )

