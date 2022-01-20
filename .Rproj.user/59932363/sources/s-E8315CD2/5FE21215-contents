---
title: Getting Started with R for Nonprofits
author: admin
date: '2020-08-07'
slug: getting_set_up
categories:
  - R for Nonprofits
tags:
  - RStats
  - Nonprofit
subtitle: ''
summary: 'Recommendations for getting started with R, including basic installations, learning resources, and workflows.'
authors: []
lastmod: '2020-08-07T15:25:32-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: yes
projects: []
draft: false
---

### Goals for this Post

I do not intend for the *R for Nonprofits* series to be a resource for learning the basics of R -- there are plenty of resources out there for that, and also, no matter what learning resources you use, you won't truly become a proficient R programmer without working on your own projects.  

In this post, I intend to offer recommendations and resources so the reader can accomplish the following:

1. Successfully download R and RStudio.
1. Get started down an effective learning path.

For the more experienced useR, these will be pretty basic recommendations.  For those totally new to R and those who have just started to get their feet wet, I hope this post will speed up the learning and implementation process while helping to avoid some pitfalls that tripped me up when I was just getting started.

### R and RStudio

###### Download R

If you are just getting started with R, your first step is to download R from the organization that maintains it -- the [R Foundation](https://www.r-project.org/).  From the homepage, you can navigate to the download page by clicking the *download R* link at the top of the page (or [click here](http://cran.r-project.org/mirrors.html)).

You will now find a page called *CRAN Mirrors*.  Basically, the *mirrors* are exact copies, so it doesn't really matter which mirror you choose to download, but you might as well follow the advice at the top of the page and download from a mirror close to your physical location.

That link will take you to a page that has links for Linux, Mac, and Windows machines.  Click on the *base* link (or *install R for the first time*), and then click the download R for Windows link. Complete the installation process as you would for any other program as appropriate for your system.

R does come with a graphical user interface (GUI), but I'm not going to get into that at all because we won't be using it at all.  Instead, we will work with R in an Integrated Development Environment, or IDE.

##### Download RStudio

[RStudio](https://rstudio.com) is a company that produces both open-source and commercial products for data science applications. Most notably, it produces the most popular R IDE and has authored some of the most popular R packages (more on that later) -- both the RStudio IDE and the open-source packages are free to download.

Taking a step back for a minute, you might be wondering, What exactly is an IDE?  In computer programming, an IDE is an interface that facilitates software development. For R, a statistical and graphical programming langugage, an IDE such as RStudio makes it easier to write and debug code, create visualizaitons, write reports, and provide user-friendly features like code highlighting, code completion, etc.  This might not mean a lot to you now, but a programmer's life MUCH easier.

{{% alert note %}}
There are many IDE's out there, some tailored to specific programming languages, and others that serve many languages.  I use RStudio for R, but I also use [Atom](https://atom.io) for most other development purposes, notably web development with HTML, CSS, and JavaScript. The choice of IDE is yours, of course, but I will use RStudio for posts in my *R for Nonprofits* series.
{{% /alert %}}

To download RStudio, navigate to [https://rstudio.com/](https://rstudio.com/) and click the *Download* at the top of the page (which takes you [here](https://rstudio.com/products/rstudio/download/)). From this page, you will see a table with the available RStudio products, one of which is the RStudio Desktop with an open source license -- that's the one you want to download.  If you click the *Download* button below that option, it will take you farther down on the page to the recommended version to download for your system (i.e. Windows version, Mac version, etc.).

Click the provided download link, and follow the necessary process to install the software for your system.

**PRO TIP**: Once you've downloaded and opened RStudio for the first time, change your theme by going to Tools > Global Options > Appearance.  Even if you're new to coding, you've undoubtedly seen the screen of software developers where text is highlighted and the background is dark.  You can play around with different settings to find one you like.  It's easier on the eyes and helps you follow your own code more easily.

### Recommended Learning Resources

There are A LOT of both free and paid learning resources out there offered through services such as EdX, Udemy, Coursera, etc., as well as the targeted data science shops like Dataquest and DataCamp.  It's easy enough to find advice on these resources -- instead of provided specific  recommendations, I think the more valuable advice I can offer is around the general learning path that I found most effective in my journey of going from minimal computer science background to R proficiency.

##### Start with the Tidyverse

For anyone just getting started in R, my first piece of advice is to start with the Tidyverse.  

When you initially download R, you get what is known as *base R* -- the standard set of functions, data types, syntax, etc. that make up the language.  To avoid getting lost in the weeds, suffice it to say base R is powerful, but it is not particularly easy to learn, especially if you are unfamiliar with standard programming conventions.  Furthermore, many introductory R courses are statistics courses that use R (i.e. base R), and as such they focus more on the statistics than the language.  The result is a language that is not particularly learner-friendly both in the way it's written and the conventional way it's taught.

Enter the [Tidyverse](https://www.tidyverse.org/) suite of packages. Per it's own documentation, "The tidyverse is an opinionated collection of R packages designed for data science.  All packages share an underlying design philosophy, grammar, and data data structures." In my experience, the process of data cleaning and transformation was maddeningly enigmatic in base R, and it was difficult to find solutions to problems I encountered. Conversely, the tidyverse packages are intended to be more intuitive for the coder, and there is ample documentation for how to use the packages.

The tidyverse's original author was Hadley Wickham, and you would do well to remember the name as you will undoubtedly run into references to Hadley in Stack Overflow solutions as his [tidy data](https://vita.had.co.nz/papers/tidy-data.pdf) philosophy and R programming conventions have become fairly standard practice.

Practically speaking, to get started learning R with the Tidyverse, you could either search out online learning modules that the teach you the packages, or you work your way through Hadley's book, [R for Data Science](https://r4ds.had.co.nz/).

Once you are feeling more comfortable and confident, you will probably start branching out with your own projects, and your learning will snowball organically.  If you want to continue a more formal approach to your R learning journey and you enjoyed *R for Data Science*, you can move on to one of Hadley's other books, such as [Advanced R](https://adv-r.hadley.nz/index.html) or [R Packages](https://r-pkgs.org/).

You'll know you're getting somewhere when this genuinely makes you laugh:

{{< figure src="img/hadley_meme.png" width="50%" >}}

##### Build Your Computer Science Foundation

Once you've gotten your feet wet with R, you will most likely find it beneficial to learn some computer science basics. R is a high-level programming language, which means a lot is abstracted to make it easier for you the human to write commands and interact with the computer.  Learning data structures, syntax, and conventions of lower-level languages (e.g. C) will give you a more intuitive understanding of how R works. For instance, navigating the file systems, understanding data structures, and learning concepts such as object oriented design will make you a more productive and skilled programmer in general.

Personally, I have found Harvard's [CS50](https://cs50.harvard.edu/x/2020/) course to be a great resource in this area.  Full disclosure, if you look to complete 100% of the course by watching all the videos and earning 100% on all the assignements, it will be a massive investment of time and energy.  My own approach has been to slowly work my way through the lectures and problem sets at my own pace without pressuring myself to be totally thorough -- anything I've taken from the course has been icing on the cake and helped me improve my own code.

### Conclusion

I hope this post is instructive for those without much of a computer science background but who are nonetheless interested in leveraging the power of R in their work. All of my advice and guidance herein is presented as I believe would have helped me when I was just getting started, and I certainly understand that it might not be for everyone.

If you have any feedback, questions, or suggestions, feel free to email me.  Otherwise, stay tuned for more posts in my *R for Nonprofits* series.
