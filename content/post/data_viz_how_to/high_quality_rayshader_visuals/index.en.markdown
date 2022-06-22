---
title: Creating High-Quality 3D Visuals with Rayshader
author: admin
date: '2022-06-20'
slug: high_quality_rayshader_visuals
categories: [Data Viz, RStats]
tags: []
subtitle: ''
summary: 'Use `rayshader` and `rayrender` to make high-quality 3D graphics.'
authors: []
lastmod: '2022-06-20T11:44:11-05:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

# Introduction

This post walks through how to create graphics like the one above using `rayshader` and `rayrender`. Tyler Morgan-Wall -- the author of these packages -- has written pretty extensive reference material, but I still struggled quite a bit when I left the confines of the pre-written examples. 

# Clarifying the basics

I spent a lot of time reviewing the package documentation, and I struggled because there were certain concepts that were taken as given but were definitely new to me.

## Data requirements

At a basic level, `rayshader` takes a matrix of elevation data and plots it. If you're more accustomed to dataframes than matrices, this might not be intuitive at first. 

Consider the matrix below. This is a 5x5 matrix, i.e. 5 rows by 5 columns, and each cell has a value. In our `rayshader` context, each cell would represent the x-y location of a point, and the value would be the elevation or z axis.


```r
matrix(c(1:5, 5:1), nrow = 5, ncol = 5)
```

```
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    1    5    1    5    1
## [2,]    2    4    2    4    2
## [3,]    3    3    3    3    3
## [4,]    4    2    4    2    4
## [5,]    5    1    5    1    5
```

This is how `rayshader` interprets data, so we need to feed it a matrix. You probably won't find data in raw matrix form in the wild, though -- more likely you'll find elevation or similar data in raster form. Rasters are similar to the matrix format above, where there are `x` and `y` coordinates that make up a grid (or matrix), and the value of cells represents the `z` axis.

If this still isn't clear, think of an image made up of pixels. Pixels are arranged in a grid with rows and columns, and the pixel color is determined by the value of the respective cell. The image below illustrates this concept

<figure>
<img src="img/raster_example.png" alt="Example raster" style="width:75%">
<figcaption align = "center"><b>Source: <a href='https://desktop.arcgis.com/en/arcmap/latest/manage-data/raster-and-images/what-is-raster-data.htm#:~:text=In%20its%20simplest%20form%2C%20a,pictures%2C%20or%20even%20scanned%20maps.'>ArcGIS</a></b></figcaption>
</figure>

Okay, so to recap, we need data to be in matrix form for `rayshader`, but we're more likely to find elevation data and the like in raster form -- luckily, it's easy to convert raster to matrix (as we'll see below). Therefore, when hunting for data to make a graphic with `rayshader`, we should look for raster data. If you're downloading files, look for TIF, TIFF, or GeoTiff files. If you're downloading via API, you might just need to specify raster, though it's probably the default format.

## Where to find data

There are tons of resources out there to download elevation or water body depth. Here are a few resources I've gone to:

* [Bathymetry of the Great Lakes](https://www.ngdc.noaa.gov/mgg/greatlakes/) (Download the GeoTiff file)
* [Bathybase: bathymetry of numerous US lakes](http://www.bathybase.org/)
* [General Bathymetric Chart of the Oceans](https://www.gebco.net/data_and_products/gridded_bathymetry_data/)
* [AWS Terrain Tiles](https://registry.opendata.aws/terrain-tiles/)

Local governments often provide this data as well, so if there is a particular park or lake, it's worth looking on their
websites. For our purposes here, we'll be using the AWS Terrain Tiles to access elevation data. Lucky for us, the [`elevatr` R package developed by Jeffrey W. Hollister](https://cran.r-project.org/web/packages/elevatr/vignettes/introduction_to_elevatr.html) makes downloading this data a breeze.

## Rendering and shading
