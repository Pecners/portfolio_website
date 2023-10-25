---
title: Getting Creative with Spatial Buffers
author: admin
date: '2023-10-25'
slug: 
categories:
tags:
  - RStats
  - Spatial
subtitle: ''
summary: 'Use spatial buffering to create new spatial objects.'
lastmod: '2023-10-25 09:43:55'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
draft: false
---



## Introduction

Have you ever used a function in R for such a long time that you're sure you know how its capabilities, and then you find out you missed a key bit of functionality? This happened to me recently with the `sf::st_buffer()` function--I didn't realize you could limit a buffer to a single side.

The purpose of this post is threefold:
1. Explain the basic usage of the `sf::st_buffer()` function
1. Introduce the functionality that I missed (limiting a buffer to one side)
1. Show usage of that functionality and why it's handy

This post is going to assume you have basic familiarity with the `sf` package. This is a fantastic package that makes it pretty simple to work with spatial data in your tidy workflows--learn more about the package on its website [here]().

## Data prep

I'm going to load the data we'll be using in this post now so we can use it in examples throughout. The examples are going to be based on polling locations in the city of Milwaukee, Wisconsin, and we're also going to make use of road locations. The next few code chunks will get us set up for the rest of the post.

### Load packages


```r
# Code in this post will be using these packages, 
# let's load them now
library(tidyverse)
library(sf)
library(glue)
library(tigris)
```

### Get polling locations


```r
# download polling places for Milwaukee
url <- "https://data.milwaukee.gov/dataset/3c87875e-cf75-4736-a01b-fbf3e889d0b0/resource/a039829e-b578-4ce1-92cc-5ded8bc38c71/download/pollingplace.zip"

destdir <- tempdir()
utils::download.file(file.path(url), zip_file <- tempfile())
utils::unzip(zip_file, exdir = destdir)

# list files in `destdir` to see file name
list.files()
```

```
## [1] "featured.png"          "index_files"           "index.markdown"       
## [4] "index.Rmarkdown"       "index.Rmarkdown.lock~"
```

```r
# read in file
polls <- st_read(glue("{destdir}/pollingplace.shp")) 
```

```
## Reading layer `pollingplace' from data source 
##   `/private/var/folders/91/qhfp3fn13f9411wvjnhhszxc0000gn/T/RtmpIfPMI4/pollingplace.shp' 
##   using driver `ESRI Shapefile'
## Simple feature collection with 180 features and 7 fields
## Geometry type: POINT
## Dimension:     XY
## Bounding box:  xmin: 2517465 ymin: 348252.8 xmax: 2567484 ymax: 440084.2
## Projected CRS: NAD27 / Wisconsin South
```

### Milwaukee city limits


```r
# Milwaukee city limits
wi_places <- tigris::places(state = "wisconsin")
```

```
## 
Downloading: 16 kB     
Downloading: 16 kB     
Downloading: 16 kB     
Downloading: 16 kB     
Downloading: 16 kB     
Downloading: 16 kB     
Downloading: 33 kB     
Downloading: 33 kB     
Downloading: 34 kB     
Downloading: 34 kB     
Downloading: 34 kB     
Downloading: 34 kB     
Downloading: 34 kB     
Downloading: 34 kB     
Downloading: 34 kB     
Downloading: 34 kB     
Downloading: 49 kB     
Downloading: 49 kB     
Downloading: 49 kB     
Downloading: 49 kB     
Downloading: 65 kB     
Downloading: 65 kB     
Downloading: 65 kB     
Downloading: 65 kB     
Downloading: 82 kB     
Downloading: 82 kB     
Downloading: 82 kB     
Downloading: 82 kB     
Downloading: 97 kB     
Downloading: 97 kB     
Downloading: 97 kB     
Downloading: 97 kB     
Downloading: 110 kB     
Downloading: 110 kB     
Downloading: 130 kB     
Downloading: 130 kB     
Downloading: 150 kB     
Downloading: 150 kB     
Downloading: 150 kB     
Downloading: 150 kB     
Downloading: 160 kB     
Downloading: 160 kB     
Downloading: 160 kB     
Downloading: 160 kB     
Downloading: 180 kB     
Downloading: 180 kB     
Downloading: 190 kB     
Downloading: 190 kB     
Downloading: 190 kB     
Downloading: 190 kB     
Downloading: 220 kB     
Downloading: 220 kB     
Downloading: 240 kB     
Downloading: 240 kB     
Downloading: 280 kB     
Downloading: 280 kB     
Downloading: 300 kB     
Downloading: 300 kB     
Downloading: 330 kB     
Downloading: 330 kB     
Downloading: 370 kB     
Downloading: 370 kB     
Downloading: 410 kB     
Downloading: 410 kB     
Downloading: 460 kB     
Downloading: 460 kB     
Downloading: 480 kB     
Downloading: 480 kB     
Downloading: 540 kB     
Downloading: 540 kB     
Downloading: 560 kB     
Downloading: 560 kB     
Downloading: 600 kB     
Downloading: 600 kB     
Downloading: 620 kB     
Downloading: 620 kB     
Downloading: 640 kB     
Downloading: 640 kB     
Downloading: 670 kB     
Downloading: 670 kB     
Downloading: 690 kB     
Downloading: 690 kB     
Downloading: 740 kB     
Downloading: 740 kB     
Downloading: 810 kB     
Downloading: 810 kB     
Downloading: 830 kB     
Downloading: 830 kB     
Downloading: 880 kB     
Downloading: 880 kB     
Downloading: 880 kB     
Downloading: 880 kB     
Downloading: 910 kB     
Downloading: 910 kB     
Downloading: 930 kB     
Downloading: 930 kB     
Downloading: 940 kB     
Downloading: 940 kB     
Downloading: 970 kB     
Downloading: 970 kB     
Downloading: 1,000 kB     
Downloading: 1,000 kB     
Downloading: 1 MB     
Downloading: 1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2.1 MB     
Downloading: 2.1 MB     
Downloading: 2.1 MB     
Downloading: 2.1 MB     
Downloading: 2.1 MB     
Downloading: 2.1 MB     
Downloading: 2.2 MB     
Downloading: 2.2 MB     
Downloading: 2.2 MB     
Downloading: 2.2 MB     
Downloading: 2.2 MB     
Downloading: 2.2 MB     
Downloading: 2.3 MB     
Downloading: 2.3 MB     
Downloading: 2.3 MB     
Downloading: 2.3 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.4 MB     
Downloading: 2.5 MB     
Downloading: 2.5 MB     
Downloading: 2.5 MB     
Downloading: 2.5 MB     
Downloading: 2.5 MB     
Downloading: 2.5 MB     
Downloading: 2.5 MB     
Downloading: 2.5 MB     
Downloading: 2.6 MB     
Downloading: 2.6 MB     
Downloading: 2.7 MB     
Downloading: 2.7 MB     
Downloading: 2.7 MB     
Downloading: 2.7 MB     
Downloading: 2.7 MB     
Downloading: 2.7 MB     
Downloading: 2.8 MB     
Downloading: 2.8 MB     
Downloading: 2.8 MB     
Downloading: 2.8 MB     
Downloading: 2.9 MB     
Downloading: 2.9 MB     
Downloading: 2.9 MB     
Downloading: 2.9 MB     
Downloading: 2.9 MB     
Downloading: 2.9 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3 MB     
Downloading: 3.1 MB     
Downloading: 3.1 MB     
Downloading: 3.1 MB     
Downloading: 3.1 MB     
Downloading: 3.1 MB     
Downloading: 3.1 MB     
Downloading: 3.2 MB     
Downloading: 3.2 MB     
Downloading: 3.2 MB     
Downloading: 3.2 MB     
Downloading: 3.3 MB     
Downloading: 3.3 MB     
Downloading: 3.3 MB     
Downloading: 3.3 MB     
Downloading: 3.3 MB     
Downloading: 3.3 MB     
Downloading: 3.3 MB     
Downloading: 3.3 MB     
Downloading: 3.4 MB     
Downloading: 3.4 MB     
Downloading: 3.4 MB     
Downloading: 3.4 MB     
Downloading: 3.4 MB     
Downloading: 3.4 MB     
Downloading: 3.4 MB     
Downloading: 3.4 MB
```

```r
mke <- wi_places |> 
  filter(NAME == "Milwaukee")
```

### Milwaukee roads


```r
# Download roads in Milwaukee using the `tigris` package
mke_roads <- roads("wisconsin", county = "Milwaukee")
```

```
## 
Downloading: 73 kB     
Downloading: 73 kB     
Downloading: 73 kB     
Downloading: 73 kB     
Downloading: 190 kB     
Downloading: 190 kB     
Downloading: 220 kB     
Downloading: 220 kB     
Downloading: 250 kB     
Downloading: 250 kB     
Downloading: 270 kB     
Downloading: 270 kB     
Downloading: 320 kB     
Downloading: 320 kB     
Downloading: 380 kB     
Downloading: 380 kB     
Downloading: 410 kB     
Downloading: 410 kB     
Downloading: 450 kB     
Downloading: 450 kB     
Downloading: 510 kB     
Downloading: 510 kB     
Downloading: 530 kB     
Downloading: 530 kB     
Downloading: 560 kB     
Downloading: 560 kB     
Downloading: 580 kB     
Downloading: 580 kB     
Downloading: 650 kB     
Downloading: 650 kB     
Downloading: 670 kB     
Downloading: 670 kB     
Downloading: 710 kB     
Downloading: 710 kB     
Downloading: 750 kB     
Downloading: 750 kB     
Downloading: 780 kB     
Downloading: 780 kB     
Downloading: 800 kB     
Downloading: 800 kB     
Downloading: 840 kB     
Downloading: 840 kB     
Downloading: 910 kB     
Downloading: 910 kB     
Downloading: 970 kB     
Downloading: 970 kB     
Downloading: 1 MB     
Downloading: 1 MB     
Downloading: 1.1 MB     
Downloading: 1.1 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.2 MB     
Downloading: 1.3 MB     
Downloading: 1.3 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.4 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.5 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.6 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.7 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.8 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 1.9 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB     
Downloading: 2 MB
```

```r
# Filter for interstates
mke_int <- mke_roads |> 
  filter(str_detect(FULLNAME, "^I- ")) 
```

### Review


```r
# Plot the data to get a visual of our data
mke |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = mke_int) +
  geom_sf(data = polls, size = .75, color = "red") +
  theme_void()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />

## Usage

The `st_buffer()` function creates a buffer around a spatial object. You provide a spatial object, specify the distance of the buffer, and `st_buffer()` adds your specified space between the bounds of the original object to create counts of a new spatial object. This is easy to understand with a couple examples.


