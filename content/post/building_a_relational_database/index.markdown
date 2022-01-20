---
title: Building a Relational Database of K-12 Schools in R
author: Spencer Schien
date: '2019-10-14'
slug: building-a-relational-database-in-r
categories:
  - Database Design
tags:
  - RStats
  - Database
  - Nonprofit
subtitle: ''
summary: 'Description of the problem.'
authors: []
lastmod: '2019-10-14T11:05:03-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
reading_time: false
share: false
draft: false
commentable: true
---

# The Problem

In my role of Manager of Data and Impact at a K-12 support organization in Milwaukee, I am constantly having to access publicly available school data.  Most commonly, I need the following information:

* Lists of schools, especially of subgroupings (e.g. high schools, elementary schools, charter schools, etc.)
* Enrollment and demographic information of students served by those schools
* Outcome data such as student test scores, graduation rates, etc.

The audience for which I am preparing this information varies -- it might be information to support a grant report (we're a nonprofit, after all), analysis to present to staff or school partners in the form of professional development, or a report evaluating the impact of our programming.  Given this range of needs with all the permutations of slices that can be taken of the data, and the varying needs of the audience for each type of deliverable, I quickly came to realize that the most important aspect of this work was to ensure the integrity of the data and the reproducibility of the results.

A part of the solution is to adopt a workflow that documents all the steps in the data manipulation and analysis (which for me is scripting everything out in *R* and reporting in *Rmarkdown*), but before that, the data sources need to be consistent.  And what makes this a particularly complicated process in Milwaukee is the fact that there are three sectors of schools for which the publicly available data does not align out of the box.  So, when data is released, it needs to be tidied and joined before meaningful analysis can be conducted across all Milwaukee schools.  Then, when the next round of the same data is released, it needs to be tidied and joined **in the same manner**.

# Failed Solutions

When I was doing this work as the de facto data manager a few years ago, I had no formal training or guidance.  I was doing everything in Excel, summarizing, pivoting, and calculating new sheets off existing sheets (I had zero coding knowledge at this point, and didn't know VBA).  When I accepted a role dedicated to Data Management, my first task was to set up dashboards in Power BI.  This elevated my game a bit, as Power BI necessitated an understanding of relational tables.  Intuitively, I started to develop a database, though I didn't know it at the time.

My problem at this point became scalability.  I had folders of `.csv` files downloaded from state websites that contained data on school enrollment, test scores, etc.  I had Power BI set up to process the data, but as I added more files, the processing became more and more computationally expensive.  At its height, it was taking my work computer 45 minutes to make edits. *(I should note here that I wasn't working with a top-of-the-line machine, but in any case, the situation became untenable.)*

It was around this time that I had started learning R, and as I became more proficient, I moved more and more of my work into R Studio.  The performance compared to anything Excel or Power BI, the ease of scripting, and the availability of resources to learn on my own what I needed to know made R an ideal tool for my work.  Oh, and it helped that everything I just mentioned was free.

# My SolutionR

It wasn't too long before I learned how to connect to a database with R, not only to access data, but also to write data.  So of course, this is when I came to the realization that I could use R to automate of the data cleaning in a consistent manner, and then I could write that data to a database.  The final hurdle was deciding what kind of database and where to host it.

I won't get too in-depth here, but suffice it to say that in the end I decided a true hosted database was too much of a back-end commitment.  Also, at least for the near-term, I wanted a database that could easily be edited, updated, and totally rewritten if necessary because I knew it would take me a bit of trial and error before I reached a truly stable state.

My ultimate decision was to write a SQLite database.  The full ETL process goes something like this:

1. Download data from the web  and save in a dedicated folder (e.g. school enrollment data `.csv`  files saved in an `enrollment` folder, separated for public/private where necessary).
2. Clean and join the data as necessary, maintaining relational fields in a single table
3. Write tables to a SQLite database.

Before the IT hawks swoop down and peck my eyes out for not setting up a SQL Server or similar server-hosted database, let me enumerate why this is an optimal solution for me:

* The data cleaning process is scripted out, meaning it will be both consistent and automated going forward
* The relational design facilitates complex analysis that requires a range of data inputs
* The database is contained within a single file, making it low-maintenance, portable, and easily rewritten if necessary
* The investment is almost nil, both in terms of set-up/management as well as dollars and cents

I view this database as in the alpha stage of development.  I am still testing through my own analysis and occasionally delete the whole database and rewrite it with updated scripts that tidy the data in a way that better facilitates the analysis.

# Conclusion

This database began as a personal tool to make my work easier, but I now realize it could have value with the general public as well.  For anyone who wants to look at the whole picture of education in Milwaukee, the task of finding the necessary data and making it comparable across the different school sectors is practically prohibitive.  At the very least, the required data manipulation is so involved that it is highly error prone.  It is my hope that this database will make information more accessible by both professionals working in education in Milwaukee and also the general public who simply want to know what's happening in schools.

The following posts in this category are meant to document the data cleaning process and the final database product that is created.  They will also serve as data dictionaries for the associated database tables.
