using Iterators
using DataFrames

colours = ["Black","Red","Blue", "Yellow", "Brown", "Green", "Purple","Withe", "Orange", "Pink", "Sky"]
positions = [1,2,3,4,5,6,7,8]
coms = collect(Base.product(positions, colours, positions, colours ))
df = DataFrame(coms)
df.Diff = df[:,1] .- df[:,3]
keep = findall(df.Diff .!= 0)
df = df[keep, :]

