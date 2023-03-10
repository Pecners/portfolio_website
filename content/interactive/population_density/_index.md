---
cms_exclude: true
header:
  caption: ""
  image: ""
title: Texas Population Density
summary: This app allows you to explore Kontur Population Density data for Texas.
date: 2023-03-10
---

<style>
  @import url('https://fonts.googleapis.com/css2?family=Marhey&display=swap');
  iframe {
    height:500px;
    width:100%;
    border:none;
    margin:0 0 50px 0;
    padding:0;
    left: 0; 
    right: 0; 
    bottom: 20px; 
    top: 70px;
  }
  h1 {
    font-family: 'Marhey';
  }
</style>

![](albums/pd/titled_tx_pop_small.png)

The app below contains two interactive map windows. The left window shows the population density encoded to 3D hexagons, similar to the static image above. You can drag the map to move it, and hold shift while you drag to rotate. 

The right window will show the location of the hexagon you click on. You can use this to see exactly where those peaks are located. 

All data is from Kontur, read about the data and their methodology [here](https://data.humdata.org/dataset/kontur-population-dataset).

<span style='width:100% !important'>
<iframe src="https://spencerschien.shinyapps.io/shiny_mapdeck/" title="Texas Population Density"></iframe>
</span>
