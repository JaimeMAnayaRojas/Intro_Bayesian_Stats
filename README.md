## Install `R` and the necessary packages
This is something you have to do only once.

- to install `R` go to this webpage, download it and follow the instructions [click](https://www.r-project.org/)


- Installing `R-studio`

The best way to develop R code in your computer is using R-studio, it is a nice interface that help you a lot in the process of writing the code, interacting with R, and so many more things...

[https://rstudio.com/products/rstudio/](https://rstudio.com/products/rstudio/)


# Are you new to R?
## Don't worry, there is a lot of help out there. You can start with any of the following tutorials:

[tutorial 1](https://www.youtube.com/watch?v=fDRa82lxzaU)
[tutorial 2](https://www.youtube.com/watch?v=_V8eKsto3Ug)


# Jupyter Notebooks AND `R`, install python3 and Anaconda in your computer

Follow the instructions in this page

[https://www.anaconda.com/products/individual](https://www.anaconda.com/products/individual)

- After installing anaconda, you will have Jupyter notebooks installed. Now you need to make `R` available to Jupyter notebooks. To do that follow the instructions in the website bellow:
https://www.datacamp.com/community/blog/jupyter-notebook-r

You can learn more about Jupyter Notebooks  in this video [click](https://www.youtube.com/watch?v=jZ952vChhuI) 


# Introduction to Bayesian Statistics for Experimental Ecology

You can find a short introduction to Bayesian statistical inference using `Stan` via `R` in this repository. If you are familiar with `Jupyter Notebooks,` you can follow the lecture's examples in the "Introduction Notebook.ipynb" file. Otherwise, you can find the `R code` in the `\R` folder. 

If you want to learn more about Bayesian statistics, I recommend [Richard McElreath's lectures](https://github.com/rmcelreath/statrethinking_winter2019) and [amazing book](https://www.amazon.de/Statistical-Rethinking-Bayesian-Examples-Chapman/dp/036713991X/ref=sr_1_1?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2U80GHSYN6SXD&dchild=1&keywords=statistical+rethinking&qid=1593046024&sprefix=statistical+re%2Caps%2C337&sr=8-1).


I also recommend [Paul Buerkner's amazing package and his tutorials](https://github.com/paul-buerkner/brms)


## More about Stan, [click here](https://www.youtube.com/watch?v=4t6niM6sksI)
 

## some things to keep in mind:

You will be working with published data. They belong to well plan experiments, so be aware of the replicates and the experimental block.
Also, be aware of using the right family distribution; if you want to know when to use them, see [Ben Bolker's paper on GLMMs](https://www.sciencedirect.com/science/article/abs/pii/S0169534709000196). 
Gaussian or normal (most linear regressions)
Poisson and negative binomial (most GLMs with count data)
Binomial or Bernoulli (binomial data, 1 or 0, survival or death, etc)
Include random effects to avoid pseudo-replications [link](http://lbs2011.lbsconference.org/cartography.tuwien.ac.at/drupalmultisite/sites/lbs2011.org/files/presentations/54_1.pdf)


# Using this repository
The easiest way to use this repository is to clone (download) it and run it on your local machine; if you want to clone it via GitHub go ahead and help this tutorials to improve feel free, [here](https://www.youtube.com/watch?v=E2d91v1Twcc&t=351s)
 you can find a nice tutorial on how to do it. 