# Introduction to Bayesian Statistic for Experimental Ecology

In this repository, you can find a short introduction to Bayesian statistical inference using `Stan` via `R`. If you are familiar with `Jupyter Notebooks` you can follow the examples done in the lecture in the "Introduction Notebook.ipynb" file. Otherwise, you can find the `R code` in the `\R` folder. 

For an introduction to **Jupyter Notebooks** and how to install it togeter with `R` follow instruction in the next link ([Click here](https://www.youtube.com/watch?v=gwRhPojbINI)) .


The easiest way to use this reoisutiry it is to clone (download) it and run it on your local machine, if you want to clone it via GitHub go ahead, [here](https://www.youtube.com/watch?v=E2d91v1Twcc&t=351s)
 you can find a nice tutorial on how to do it. 

# Are you new to R?
## Don’t worry there is a lot of help out there, you can start with any of the following tutorials:

[tutorial 1](https://www.youtube.com/watch?v=fDRa82lxzaU)
[tutorial 2](https://www.youtube.com/watch?v=_V8eKsto3Ug)

If you want to learn more about Bayesian statistics, I recommend [Richard McElreath ‘s lectures](https://github.com/rmcelreath/statrethinking_winter2019) and [amazing book](https://www.amazon.de/Statistical-Rethinking-Bayesian-Examples-Chapman/dp/036713991X/ref=sr_1_1?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2U80GHSYN6SXD&dchild=1&keywords=statistical+rethinking&qid=1593046024&sprefix=statistical+re%2Caps%2C337&sr=8-1).


I also recommend to  [Paul Buerkner’s amazing package and his tutorials](https://github.com/paul-buerkner/brms)


## More about Stan, [click here](https://www.youtube.com/watch?v=4t6niM6sksI)
 

# Assignments
I have taken the liberty to create a folder for each one of you in the [Assignments folder](https://github.com/JaimeMAnayaRojas/Muenster_EE2020/tree/master/Assigments). Each one of you have to re-run some of the analyses of the papers associated with the data that is provided for each of you. The basics of how to do it have been covered in class, but do not hesitate to contact me. 

Each one of you must also write a small report of want you have found and submit your code to me, to check.

## some things to keep in mind:

You will be working with published data and they belong to well plan experiments, so be aware of which are the replicates and the experimental block.
Also, be aware of using the right family distribution, if you want to know when to use them see [Ben Bolker’s paper on GLMMs](https://www.sciencedirect.com/science/article/abs/pii/S0169534709000196). 
Gaussian or normal (most linear regressions)
Poisson and negative binomial (most GLMs with count data)
Binomial or Bernulli (binomial data, 1 or 0, survival or death, etc)
Include random effects to avoid pseudo-replications [link](http://lbs2011.lbsconference.org/cartography.tuwien.ac.at/drupalmultisite/sites/lbs2011.org/files/presentations/54_1.pdf)



