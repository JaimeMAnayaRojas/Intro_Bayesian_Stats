# Working with DataFrames

#load the necessary modules
using Distributions
using CSV
using DataFrames
using LinearAlgebra
using Statistics
using StatsPlots
using Plots
using RCall

pwd() # print working directory
cd("$(homedir())") # change the working directory to the home directory.
cd("Dropbox/Projects_JM/Muenster/Intro_Bayesian_Stats") # change the working directory to my folder of interest


readdir() # read the files of the working directory.

# get the data
data = CSV.read("R/Getting_started/datasets-master/compensation.csv", DataFrame)

describe(data) # describe my data

# see the first values of the data DataFrame
first(data,6)

# see the last values of the data DataFrames
last(data, 5)


### Accessing values from the DataFrame

data.Root
data[!, 1]

data[!, :Fruit]

data[1:5, "Fruit"]

data[!, [:Root, :Fruit]]

# error
data[50, [:Root, :Fruit]]


## summary statistics
combine(data, :Root => mean)

combine(groupby(data, :Grazing), :Root => mean)


# Let's make an histogram
histogram(data.Root, bins = 6)
xlabel!("Root")
ylabel!("Frequency (N)")

describe(data)
# let's make an scatter plot

using CategoricalArrays
data.Grazing = categorical(data.Grazing)

df1 = filter(:Grazing => x-> x == "Grazed", data )
df2 = filter(:Grazing => x-> x == "Ungrazed", data )

scatter(df1.Root, df1.Fruit, label = "Grazed")
scatter!(df2.Root, df2.Fruit, label = "Ungrazed")
xlabel!("Root")
ylabel!("Fruits")

savefig("My_firstPlot.png")


scatter(data.Root, data.Fruit, group = data.Grazing)