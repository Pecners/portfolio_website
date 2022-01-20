---
title: "Milwaukee Traffic Accident Tracking"
author: Spencer Schien
date: '2019-10-02'
slug: accident-tracking
categories: 
  - Milwaukee Traffic Accidents
tags:
  - RStats
  - Milwaukee
subtitle: "Loading and Cleaning the Data"
summary: ''
authors: ["admin"]
lastmod: '2019-10-02T18:38:03-05:00'
featured: no
image: 
  placement: 1
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
reading_time: false
share: false
draft: false
commentable: true
---


This past summer, the Milwaukee Journal Sentinel reported that the Milwaukee Police Department was undertaking an initiative to reduce traffic accidents in Milwaukee by deploying more units to high-risk areas.

To the data nerds out there (oh, hi!), this was a great opportunity to set up a small project to track the success of MPD's initiative.  For our purposes here, we will make a determination as to whether MPD is having an impact based on whether there is a difference in the number of reported accidents during the period in question when compared to previous comparable periods.

We can further evaluate whether any subgroups of the data showed any change (e.g. was there a decrease in accident reports during rush hour?) and whether weather (homonym!) shows any predictive value.

*Note: The `milwaukeer` package developed by [John Johnson](https://johndjohnson.info) facilitates downloading this data and performing some of the data cleaning tasks I'm going to be covering below.  I've opted not to use the `milwaukeer` package here so I can more explicitly explain my process.*

## Loading and Assessing the Data

First things first, we need to get the data into R.


```r
library(tidyverse)

raw <- read_csv("https://data.milwaukee.gov/dataset/5fafe01d-dc55-4a41-8760-8ae52f7855f1/resource/8fffaa3a-b500-4561-8898-78a424bdacee/download/trafficaccident.csv")
```

Now that we have our data loaded, let's take a look at its structure.


```r
glimpse(raw)
```

```
## Observations: 160,784
## Variables: 3
## $ CASENUMBER  <chr> "M5L0GD2Z4Q", "J9L0K2BCJQ", "J9L01R2L2P", "J9L014K17L",...
## $ CASEDATE    <dttm> 2020-03-11 16:10:00, 2020-03-10 19:38:00, 2020-03-10 1...
## $ ACCIDENTLOC <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
```

With only three variables, this is a pretty simple dataset.  It would seem that `CASENUMBER` is a unique identifier, `CASEDATE` is a timestamp, and `ACCIDENTLOC` is a rough address of the accident.  The addresses are not in a plottable format, nor are they easily coerceable to a Coordinate Reference System (CRS), so effectively, this variable is useless for our purposes.

It would seem to be a safe assumption that each observation represents a different accident report, in which case we could count each observation as an accident.  We need to be sure that there aren't duplicates, though, so lets take a look at this `CASENUMBER` variable.  

If the difference between the number of observations in the data (obtained by using `nrow()`) and the number of unique `CASENUMBER`s is zero, then each observation is in fact a single accident.


```r
unique_cases <- length(
  unique(raw$CASENUMBER)
)

nrow(raw) - unique_cases
```

```
## [1] 10
```

What we find is that the dataset is 10 rows longer than the number of unique `CASENUMBER`s, so there are duplicates.  Let's take a look at these duplicates to figure out what is going on.


```r
duplicates <- raw %>%
  group_by(CASENUMBER) %>%
  summarise(total = n()) %>%
  filter(total > 1)

raw %>%
  filter(CASENUMBER %in% duplicates$CASENUMBER) %>%
  arrange(CASENUMBER)
```

```
## # A tibble: 20 x 3
##    CASENUMBER CASEDATE            ACCIDENTLOC                                   
##    <chr>      <dttm>              <chr>                                         
##  1 9G7FQMQ    2007-09-16 06:57:00 4022 W OKLAHOMA AV - 100 Feet E of S 41ST ST ~
##  2 9G7FQMQ    2007-09-16 06:57:00 4022 W OKLAHOMA AV - 100 Ft from [S 41ST ST &~
##  3 J9L086WD7H 2017-05-06 04:25:00 1815 N 17TH ST                                
##  4 J9L086WD7H 2017-05-06 04:25:00 ON 1815 N 17TH ST227 FT S OF W VINE ST(HOUSE/~
##  5 J9L0CGFB0G 2017-03-30 02:52:00 W FOND DU LAC AV & W WALNUT ST - 439 Feet N o~
##  6 J9L0CGFB0G NA                  *F* ON 1306 W FOND DU LAC AVE/ STH145 NB439 F~
##  7 J9L0CJWD7M 2017-04-23 11:40:00 S 6TH ST & W LINCOLN AV                       
##  8 J9L0CJWD7M NA                  S 6TH ST & W LINCOLN AV                       
##  9 J9L0CS9LVV 2017-04-09 14:59:00 4613 N 42ND ST - 143 Feet N of W COURTLAND AV~
## 10 J9L0CS9LVV NA                  4613 N 42ND ST - 143 Feet N of W COURTLAND AV~
## 11 J9L0GPZ7TC 2017-03-20 01:45:00 *F* ON 3433 W LINCOLN AVE65 FT E OF S 35TH ST~
## 12 J9L0GPZ7TC 2017-03-20 01:45:00 S 35TH ST & W LINCOLN AV - 65 Feet E of S 35T~
## 13 J9L0LS5WRF 2017-04-18 10:33:00 *F* INTERSECTION ON W OKLAHOMA AVEAT S 47TH ST
## 14 J9L0LS5WRF 2017-04-18 10:33:00 S 47TH ST & W OKLAHOMA AV                     
## 15 J9L0MFXHKW 2017-04-30 12:30:00 INTERSECTION ON W FOREST HOME AV/ STH24 EB AT~
## 16 J9L0MFXHKW 2017-04-30 12:30:00 S 60TH ST & W FOREST HOME AV                  
## 17 J9L0WZH5K9 2017-04-28 23:00:00 *F* ON 5202 N TEUTONIA AVE, 0 FT N OF W VILLA~
## 18 J9L0WZH5K9 2017-04-28 23:00:00 N TEUTONIA AV & W VILLARD AV - 0 Feet N of N ~
## 19 J9L15QT5KC 2017-05-13 22:20:00 S 13TH ST & W ARTHUR AV - 369 Feet N of S 13T~
## 20 J9L15QT5KC NA                  S 13TH ST & W ARTHUR AV - 369 Feet N of S 13T~
```

It's clear that two things are happening here: first, there were some bad observations that were assigned a `CASENUMBER` without a `CASEDATE`, and second, there were observations that were entered twice with the exact same `CASENUMBER` AND `CASEDATE` but a different `ACCIDENTLOC`.  

## Cleaning the Data

This is definitely not a major issue since it's only ten duplicates out of 150,000 observations, but we can still take care of it in a couple easy steps.  

First, since we aren't going to be using the `ACCIDENTLOC` field anyway, we don't care about having two different locations for the same accident.  Dropping that field, we can then call `unique()` on the dataset to eliminate the second case of duplicates listed above.  To eliminate the first case, we can simply filter out `NA` values since they aren't useful to us without a date anyway.  

These steps are quickly achieved with a little `tidyverse` magic:


```r
clean <- raw %>%
  filter(!is.na(CASEDATE)) %>%
  select(-ACCIDENTLOC) %>%
  unique()
```

Just to make sure we did what we wanted, we can rerun our code from earlier on our `clean` data, as follows:


```r
unique_clean <- length(
  unique(clean$CASENUMBER)
)

nrow(clean) - unique_clean
```

```
## [1] 0
```

Et voilà! Every row now represents a unique observation of an accident report.

Next, we are going to want to explore trends over the time, and we're going to want to look at it a few different ways.  For instance, we will definitely want to determine what time of day is most accident-prone, what time of year, etc.  This could easily be achieved with the data as it is, but we will want to have some grouping variables to help with sorting and comparison.

The code below creates new fields for `year` and `rush_hour`.  Also, we will load the `lubridate` package to ease our work with datetime data.


```r
library(lubridate)

labeled <- clean %>%
  mutate(year = year(CASEDATE),
         rush_hour = ifelse(hour(CASEDATE) > 7 & hour(CASEDATE) < 9, "Morning",
                            ifelse(hour(CASEDATE) > 16 & hour(CASEDATE) < 18, "Evening",
                                   "Not Rush Hour")))
```

Alright, it's time to get to the good stuff--let's visualize this bad boy.  First, let's take a look at daily total accidents over time.


```r
d_hist_v <-labeled %>%
  group_by(day = floor_date(CASEDATE, "day")) %>%
  summarise(total = n()) %>%
  ggplot(aes(day, total)) +
  geom_histogram(stat = "identity")
d_hist_v
```

<img src="/post/mke_traffic_accidents/index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

I like to assign my visuals with a name ending in `_v` so I can easily search them--this can be super helpful on larger projects where you are creating a lot of visuals.

I also like to format my visuals beyond the `ggplot` defaults, as with the code below:


```r
d_hist_v +
  theme_minimal() +
  labs(x ="", y= "Daily Count of Accidents", title = "Milwaukee Traffic Accident Reports")
```

<img src="/post/mke_traffic_accidents/index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

There seems to be positive trend in the number of accident reports, and there also seem to be a few pretty extreme spikes, but the histogram bars are so thin that it's difficult to make out.  

Plotting with `geom_point` makes it easier to identify individual data points, and it will make it a little easier ot evaluate general trends.  We can also add a trend line using `geom_smooth`.

```r
max_label <- labeled %>%
              group_by(day = floor_date(CASEDATE, "day")) %>%
              summarise(total = n()) %>%
              filter(total == max(total))

d_point_v <-labeled %>%
  group_by(day = floor_date(CASEDATE, "day")) %>%
  summarise(total = n()) %>%
  ggplot(aes(day, total)) +
  
  # set alpha below 1 to show overplotting
  
  geom_point(alpha = 0.5) +
  geom_text(data = max_label,
            aes(label = format(date(day), "%b %d, %Y"), y = total, x = day), nudge_y = 7) +
  geom_smooth(se = FALSE, color = "red", size = 0.5) +
  
  # geom_smooth will extend below zero if we don't set limits
  
  scale_y_continuous(limits = c(0, 130)) +
  theme_minimal() +
  labs(x ="", y = "Daily Count of Accidents", title = "Milwaukee Traffic Accident Reports",
       subtitle = "Each point represents a daily total",
       caption = "Source: data.milwaukee.gov.")
d_point_v
```

<img src="/post/mke_traffic_accidents/index_files/figure-html/unnamed-chunk-10-1.png" width="672" />

