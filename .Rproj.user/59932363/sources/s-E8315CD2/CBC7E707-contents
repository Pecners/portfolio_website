---
title: Mapping Crime in Milwaukee
author: Spencer Schien
date: '2019-10-01'
slug: crime-in-milwaukee
categories: [Mapping]
tags: [R, Milwaukee Data]
subtitle: ''
summary: ''
authors: [Spencer Schien]
lastmod: '2019-10-01T21:03:26-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: yes
projects: []
share: false
reading_time: false
commentable: true
---

About a year ago in the fall of 2018, I stumbled across [data.milwaukee.gov](https://data.milwaukee.gov).  Suffice it to say, as a certified Data Nerd who  accesses publicly available data in both my day job and my free time, I was impressed with the quality of the resources being provided by a city the size of Milwaukee.  Maybe I'm easily impressed because I'm overly pessimistic about the capacity of our major cities, but we'll leave that for another time...

At the time, I was only just beginning to tread water in the R pool, and I thought it would be a fun / instructive challenge to try to come up with an interesting visual representing crime in Milwaukee.  Specifically, I had a vision of facet wrapping a map of crimes in Milwaukee by some characteristic of the data.  And with this exceedingly vague sense of direction, I was off!

## Accessing the Data

The first step is getting the data into R.  The code below will read the crime data in `.csv` format provided on the data portal.

**It should be noted that the city's data portal does provide API access, but this was beyond my awareness and abilities when I first completed this project.**


```r
library(tidyverse)
library(tmap)

# FYI this file is over 600,000 observations

crime <- read_csv("https://data.milwaukee.gov/dataset/e5feaad3-ee73-418c-b65d-ef810c199390/resource/87843297-a6fa-46d4-ba5d-cb342fb2d3bb/download/wibr.csv")
```

## Preparing Data for Visualization

Now that we have the data loaded into R, we can use the glimpse function to get a snapshot of the fields present in the data.


```r
glimpse(crime)
```

```
## Observations: 684,449
## Variables: 24
## $ IncidentNum      <dbl> 192700037, 192700013, 192700055, 192700006, 192…
## $ ReportedDateTime <dttm> 2019-09-27 05:30:00, 2019-09-27 00:30:00, 2019…
## $ ReportedYear     <dbl> 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019,…
## $ ReportedMonth    <dbl> 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,…
## $ Location         <chr> "2020 W STATE ST", "2442 W BOLIVAR AV", "2402 N…
## $ WeaponUsed       <chr> NA, "PERSONAL WEAPON", NA, "PERSONAL WEAPON", "…
## $ ALD              <dbl> 4, 13, 15, 7, 6, 14, 6, 5, 9, 15, 1, 8, 9, 7, 7…
## $ NSP              <dbl> 12, NA, 5, 5, 4, 17, 4, NA, NA, 11, 2, 15, NA, …
## $ POLICE           <dbl> 3, 6, 3, 7, 5, 2, 5, 7, 4, 3, 7, 2, 4, 7, 7, 3,…
## $ TRACT            <dbl> 14800, 21300, 9200, 4900, 6600, 186600, 6600, 3…
## $ WARD             <dbl> 192, 307, 158, 97, 112, 249, 112, 76, 14, 155, …
## $ ZIP              <dbl> 53233, 53221, 53210, 53216, 53206, 53207, 53206…
## $ RoughX           <dbl> 2551242, 2550358, 2541467, 2540729, 2551586, 25…
## $ RoughY           <dbl> 387032.0, 359082.2, 393807.2, 399889.5, 397315.…
## $ Arson            <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
## $ AssaultOffense   <dbl> 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0,…
## $ Burglary         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
## $ CriminalDamage   <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
## $ Homicide         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
## $ LockedVehicle    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
## $ Robbery          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,…
## $ SexOffense       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
## $ Theft            <dbl> 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,…
## $ VehicleTheft     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,…
```

Given my stated intention of creating a faceted map, the first set of fields I'm looking for are those that provide some sort of location information, and as luck would have it, the city provides this data in the form of `RoughX` and `RoughY`.  Without coordinates, the only way I knew to obtain plottable coordinates was to access the Google API and retrieve lat-long from physical address.  Google's API sets a limit, though, and at nearly 700K observations, this data exceeded that limit.  If that was the route I had to take, it would have complicated the process.

Since we are fortunate enough to already have the coordinates, our next step is to coerce the data into a simple features object using the `sf` package.  The greatest difficulty I had with this step was determining what *Coordinate Reference System* the city was using to plot these crimes--little did I know that the `sf` package also has a function (`st_crs`) to handle this task in a single line of code.  So I'll just consider the weeks (yes, this held me up for weeks until a kind user on Reddit pointed me in the right direction) I spent stuck on this chunk as a very hard earned lesson.



```r
library(sf)

# cleaning data for mapping ====

crime_location <- crime %>%
  filter(!is.na(RoughX) & !is.na(RoughY)) %>%
  st_as_sf(coords = c("RoughX", "RoughY"), crs = 32054)
```

Now we have our crime data converted to a simple features object.  If we want to map onto some representation of the city of Milwaukee--which we do--we need to also import those shapefiles and align everything to the same CRS.

```r
# Shapefiles can be found online
# or I have a repo here: https://github.com/Pecners/shapefiles
# Note that you will need all files located in a single folder

neighb <- read_sf("milwaukee_neighborhood/neighborhood.shp")

# align to the same CRS
crime_neighb <- st_transform(crime_location, crs = st_crs(neighb))
```

And just like that, we have all the data we need in a simple features format!  We just need to shift gears here and do a bit a ordinary data tidying.

With our stated goal of faceting by a certain characteristic, one immediately evident possibility is to choose the type of crime as the facet variable.  In order to facet a plot by the type of crime, though, we will need to bring all of the crimes under a single variable, as each separate crime is currently under a wide dummie format.

To clean this up, I chose to follow the `tidyverse` conventions and use `gather()`.  I also filtered the data to only include the year 2018--this is both to reduce over plotting of points, and to ease the data manipulation.

**These next few chunks can be a bit processor-heavy and take a while to run.**

```r
# this chunk takes a while
crime_neighb <- crime_neighb %>%
  filter(ReportedYear == 2018) %>%
  gather("Crime", "yn", -c(1:12, 23)) %>%
  # remove dummie `no` observations
  filter(yn != 0)

# this chunk takes a while longer
crime_neighb <- st_intersection(neighb, crime_neighb)
```

Whew, we're really sweating after those chunks!  I'm sure this still isn't optimized very well (I don't even want to know what `data.table` adherents would have to say), but it works!  Or at least, we think it will work.  There's only one way to know for sure, and that's to finally get to producing the map.

The final package we will need is the `tmap` package that follows the grammar of graphics and makes it fairly simple to produce highly customizable plots using spatial data.


```r
library(tmap)

# make the map ====

# add the neighborhood data aesthetic
tm_shape(neighb) +
  # add polygon layer with borders set to transparent
  # this plots the grey city outline
  tm_polygons(border.alpha = 0) +
  # add the crime data aesthetic
tm_shape(crime_neighb) +
  # add dot layer with 0.5 alpha to show overlap
  tm_dots(col = "red", alpha = 0.5) +
  # facet by our gathered `Crime` variable
  # free.coords = FALSE keeps each facet the same zoom
tm_facets(by = "Crime", free.coords = FALSE) +
tm_layout(main.title = "Reported Crimes in Milwaukee, 2018")
```

<img src="/post/2019-10-01-crime-in-milwaukee_files/figure-html/unnamed-chunk-7-1.png" width="672" />

And there we have it!  As I've tried to intimate throughout this post, I recognize that this might not be the optimal or most rigorous project of its kind, but I hope it is an instructive example for rapid prototyping from concept to minimal deliverable.

Any questions, comments, or suggestions are welcome--just shoot me an email.
