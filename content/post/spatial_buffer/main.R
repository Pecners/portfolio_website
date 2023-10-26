library(tidyverse)
library(MetBrewer)
library(colorspace)
library(magick)
library(glue)
library(sf)

c_pal <- met.brewer("Hiroshige", n = 14)
swatchplot(c_pal)

bg <- c_pal[12]

mke |> 
  ggplot() +
  geom_sf(fill = c_pal[5], color = c_pal[1]) +
  geom_sf(data =  st_buffer(i43, -20000, singleSide = TRUE),
          color = NA, fill = NA) +
  theme_void()

tmp1 <- "../000_data_temp/frame1.png"
ggsave(tmp1, bg = bg, w = 7, h = 10)

cap <- "SPATIAL TRICK\nwith R"
img <- image_read(tmp1)

tmp0 <- "../000_data_temp/frame2.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 200) |> 
  image_write(tmp0)


cap <- "Start with a spatial polygon\n(this is Milwaukee, WI)"
img <- image_read(tmp1)

tmp10 <- "../000_data_temp/frame3.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp10)


mke |> 
  ggplot() +
  geom_sf(fill = c_pal[5], color = c_pal[1]) +
  geom_sf(data = i43) +
  geom_sf(data =  st_buffer(i43, -20000, singleSide = TRUE),
          color = NA, fill = NA) +
  theme_void()

tmp2 <- tempfile(fileext = ".png")
ggsave(tmp2, bg = bg, w = 7, h = 10)

cap <- "Bisect it with a spatial line\n(the line is I-43)"
img <- image_read(tmp2)

tmp20 <- "../000_data_temp/frame4.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp20)


mke |> 
  ggplot() +
  geom_sf(fill = c_pal[5], color = c_pal[1]) +
  geom_sf(data = i43) +
  geom_sf(data =  st_buffer(i43, -20000, singleSide = TRUE),
          color = NA, fill = alpha("black", .25)) +
  theme_void()

tmp02 <- tempfile(fileext = ".png")
ggsave(tmp02, bg = bg, w = 7, h = 10)

cap <- "Use a single-sided buffer\nto cover the polygon on one side"
img <- image_read(tmp02)

tmp020 <- "../000_data_temp/frame5.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp020)


se_mke |> 
  ggplot() +
  # geom_sf(data = mke, fill = NA, color = NA) +
  geom_sf(fill = c_pal[5], color = c_pal[1]) +
  geom_sf(data =  st_buffer(i43, -20000, singleSide = TRUE),
          color = NA, fill = alpha("black", .25)) +
  geom_sf(data = i43) +
  theme_void()

tmp3 <- tempfile(fileext = ".png")
ggsave(tmp3, bg = bg, w = 7, h = 10)

cap <- "Use a spatial intersection\nto crop the polygon to this area"
img <- image_read(tmp3)

tmp30 <- "../000_data_temp/frame6.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp30)

se_mke |> 
  ggplot() +
  geom_sf(data = mke, fill = c_pal[2], color = c_pal[1]) +
  geom_sf(fill = c_pal[5], color = c_pal[1]) +
  geom_sf(data =  st_buffer(i43, -20000, singleSide = TRUE),
          color = NA, fill = NA) +
  # geom_sf(data = i43) +
  theme_void()

tmp4 <- tempfile(fileext = ".png")
ggsave(tmp4, bg = bg, w = 7, h = 10)

cap <- "Now you have\ntwo new polygons!"
img <- image_read(tmp4)

tmp40 <- "../000_data_temp/frame7.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp40)



se_mke |> 
  ggplot() +
  geom_sf(data = mke, fill = c_pal[2], color = c_pal[1]) +
  geom_sf(fill = c_pal[5], color = c_pal[1]) +
  geom_sf(data = se_polls |> 
            filter(!is.na(ind)), color = c_pal[14]) +
  geom_sf(data =  st_buffer(i43, -20000, singleSide = TRUE),
          color = NA, fill = NA) +
  # geom_sf(data = i43) +
  theme_void()

tmp6 <- tempfile(fileext = ".png")
ggsave(tmp6, bg = bg, w = 7, h = 10)

cap <- "Use this to identify\npoints on one side of the line"
img <- image_read(tmp6)

tmp60 <- "../000_data_temp/frame8.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp60)


se_mke |> 
  ggplot() +
  geom_sf(data = mke, fill = c_pal[2], color = c_pal[1]) +
  geom_sf(fill = c_pal[5], color = c_pal[1]) +
  geom_sf(data = se_polls |> 
            filter(is.na(ind)), color = c_pal[14]) +
  geom_sf(data =  st_buffer(i43, -20000, singleSide = TRUE),
          color = NA, fill = NA) +
  # geom_sf(data = i43) +
  theme_void()

tmp06 <- tempfile(fileext = ".png")
ggsave(tmp06, bg = bg, w = 7, h = 10)

cap <- "Or the other"
img <- image_read(tmp06)

tmp060 <- "../000_data_temp/frame9.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp060)


cap <- "Blog post with code available:\nwww.spencerschien.info"

tmp70 <- "../000_data_temp/frame10.png"
img |> 
  image_annotate(text = cap, 
                 gravity = "center",
                 location = "-100-750",
                 font = "El Messiri", 
                 boxcolor = alpha("white", .75),
                 weight = 900,
                 size = 100) |> 
  image_write(tmp70)




vec <- c(rep(tmp1, 10), 
         rep(tmp0, 30),
         rep(tmp10, 30), 
         rep(tmp20, 30), 
         rep(tmp020, 30), 
         rep(tmp30, 30),
         rep(tmp40, 30),
         rep(tmp60, 30),
         rep(tmp060, 30),
         rep(tmp70, 30))

av::av_encode_video(vec, "../../desktop/output.mp4", framerate = 17)


 # Featured img in blog post
# se_mke |> 
#   ggplot() +
#   geom_sf(data = mke, fill = c_pal[2], color = c_pal[1]) +
#   geom_sf(fill = c_pal[5], color = c_pal[1]) +
#   geom_sf(data = se_polls |> 
#             filter(!is.na(ind)), color = c_pal[14]) +
#   geom_sf(data = i43) +
#   theme_void()
# 
# ggsave("content/post/spatial_buffer/featured.png", bg = "transparent")
