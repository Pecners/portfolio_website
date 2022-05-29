---
title: Dense Word Clouds in R
author: R package build
date: '2022-05-29'
slug: dense_word_clouds
categories:
  - Data Viz
  - RStats
tags:
  - Word Cloud
subtitle: ''
summary: 'Use R to create dense word clouds in custom shapes.'
authors: []
lastmod: '2022-05-29T16:52:26-05:00'
featured: no
toc: true
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

# Introduction

This post explains how I created the word cloud above, which was my submission to week 20 (2022) of the [TidyTuesday project](https://github.com/rfordatascience/tidytuesday). There are plenty of how-to articles out there about creating word clouds in R (e.g. [here](https://towardsdatascience.com/create-a-word-cloud-with-r-bde3e7422e8a)), so what I want to highlight here is what I learned myself that I didn't find explained in the other posts.

In particular, I want to highlight the following:

* How word clouds are created in R, and how we can create one in a custom shape
* How to manipulate raw SVG in R
* How to manipulate the word cloud with ggplot once we make it

## Resources

If you'd like to work along with this post yourself, here is where you can download the data and the packages we'll be using. I'll explain the packages as we go, but I'm providing them to you here for your convenience.


```r
# Get data from the TidyTuesday repo

eurovision <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-17/eurovision.csv')

# Packages we'll need

library(tidyverse)
library(svgparser)
library(grid)
library(wordcloud2)
library(tidytext)
library(stopwords)
library(showtext)
library(MetBrewer)
library(glue)
library(png)
library(ggtext)
```


# Making the word cloud

## Prepping the data

We've already loaded the data to the `eurovision` object above. Our next step is to transform the data to the proper format for the word cloud. This format provides a vector of unique words that appear in the corpus along with their frequency. We're creating a word cloud of song titles of Eurovision-performed songs, so the song titles are our corpus. We'll also want to exclude what are known as stopwords, which are words such as pronouns and conjunctions that are common but are more structural than meaningful for text analysis.

The `tidytext` and `stopwords` packages makes this process easy. Since this is Eurovision, there are many lanugages included. Therefore, we might as well load the stopwords for all languages included in the `stopwords` package. Then, we'll do an `anti_join()` to remove those words from our corpus. Finally, 
we're left with a dataframe that contains a column with the words and another column with their frequency.



```r
# We're invoking the {tidytext} and {stopwords} packages here
# You'll need to install/load them if you haven't already

# Get countries for stop words
all_countries <- stopwords_getlanguages(source = "snowball")

# Get stop words for all languages available
stops <- map_df(all_countries, function(x) get_stopwords(language = x))

# Get words from titles, remove stop words
t <- eurovision %>%
  transmute(line = 1:nrow(eurovision),
            text = song) %>%
  unnest_tokens(word, text) %>%
  anti_join(stops) %>%
  # this final step removes a leading apostrophe in words like l'amour
  mutate(word = str_remove(word, "^\\w'"))

# Get frequencies by grouping by word and tallying
tidy <- t %>%
  group_by(word) %>%
  summarise(freq = n()) %>%
  arrange(desc(freq))
```

## Choosing the word cloud library

First things first, how can we make a basic word cloud in R? The `wordcloud` package in R is an easy way to make a basic word cloud, as shown below. 


```r
library(wordcloud)

wordcloud(tidy$word, tidy$freq)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-3-1.png" width="672" />

This word cloud isn't quite what I'm looking for, though. Mainly, I'd like to make it in the shape of the Eurovision heart, and this isn't possible with the `wordcloud` package. Also, the word packing algorithm doesn't result in the density I'd like.

The `wordcloud` package uses base R plotting capabilities (as opposed to `grid`, which is what underlies `ggplot2`). For each word, it calculates the width and the height of the word to create a bounding box of space occupied by the word. The algorithm then places words based on this definition of occupied space.

For instance, I've plotted "word" below, along with its bounding box in red. By the method described above, no other word will overlap with the red box. This creates a limit on the density of the resulting word cloud.


```r
word <- "word"
plot.new()
str_w <- strwidth(word, cex = 10)
str_h <- strheight(word, cex = 10)

rect(xleft = .5 - str_w/2, xright = .5 + str_w/2, 
     ybottom = .5 - str_h/2, ytop = .5 + str_h/2, 
     col = "red", border = "red")
text(x = .5, y = .5, label = word, cex = 10)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-1.png" width="672" />

The `wordcloud2` package does not use this methodology. Instead, it uses a method that defines which pixels are occupied by a word, as opposed to the bounding box occupied by the whole word. This allows for a word to be placed in between letters, or even inside the loop created by a letter, such as with 'o' or 'd' (as seen in this post's featured image above). The result is a much denser wordcloud. 

Further, `wordcloud2` allows for custom masking of the cloud (i.e. using custom shapes), which is what we want to do with the Eurovision heart. The tricky part is that `wordcloud2` is built on the [wordcloud2.js](https://github.com/timdream/wordcloud2.js/) JavaScript library, and the product is built in HTML via the `htmlwidgets` R package. So, the plot ends up in a web page instead of an R graphical device. This means we can't export the plot as we usually would with `ggsave()` or `png()`, let alone adding it to our ggplot workflow. 

I'll address these issues a bit later. Now that we have decided on `wordcloud2`, we need to prep for the mask by finding an image of the Eurovision heart we can use.

## Getting the mask

The `wordcloud2` package creates masks based on black and white images, where the black defines the shape of the cloud. So, if we can find an image of the Eurovision heart in black, we're set! 

With non-vector images (i.e. PNG or JPG), though, I worry about resolution and scalability. My preference is usually to work with SVG objects, which also allow for easy manipulation, too. A quick Google search led me [here](https://commons.wikimedia.org/wiki/File:Wiki_Eurovision_Heart_(Infobox).svg).

<img src = "https://upload.wikimedia.org/wikipedia/commons/e/ed/Wiki_Eurovision_Heart_%28Infobox%29.svg">
