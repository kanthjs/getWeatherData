
library(tidyverse)
library(nplyr)
library(data.table)
# read RDS data in working directory 
weather <- readRDS("weather_forecast_d01_20241105.rds")


result <- weather %>% process_weather_data()

dummy <- result %>% select(lat, lon) %>% group_by(lat, lon) %>% 
  summarise(n = n()) %>% 
  select(lat, lon) %>% 
  ungroup()

dummy$index_BUS <- sample(0:1, size = 26880, replace=TRUE)






## call province latlon and shp
THprovince_latlon <- readRDS("THprovince_latlon.rds")
th_shp <- readRDS("THprovince_shpfile.rds")

ggplot(data = map1) +
  geom_sf(aes(fill = BUS_warning)) +
  coord_sf(datum = NA) +
  scale_fill_brewer(palette = "Dark2") +
  #  scale_color_brewer(palette = "Set1") +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_line(colour = "transparent")
  ) + labs(title = "Warning") + ggtitle(paste("Waring on", "Jun"))




#####

xdat <- dat2[c(1, 2, 4)]
names(xdat) <- c("lat", "lon", "val")

ggplot(xdat) + geom_point(aes(lat, lon, color = val)) +
  geom_sf(data = th_shp, aes(
    color = "white",
    fill = NA,
    size = 0.2
  ))

# work
ggplot(th_shp) + 
  geom_sf() + 
  geom_raster(data = as.data.frame(xdat, xy = TRUE), aes(x = lon, y = lat, fill = val))

ggplot() + 
  geom_raster(data = as.data.frame(sdat), aes(x = lon, y = lat, fill = val)) +  
  coord_equal() + geom_sf(data = th_shp, color = "white", fill = NA) + 
  coord_sf(xlim = c(96, 106), ylim = c(5, 20))


ggplot() +
  geom_raster(data = sdat, aes(fill = val), color = NA)
#  geom_sf(data=cn1, fill="transparent", color="white", size=0.2) + #lines
#  geom_sf(data=cn2, fill="grey80", color="white", size=0.2) + #missing Euro countries
#  coord_sf(crs = crsLAEA, xlim = c(b["xmin"], b["xmax"]), ylim = c(b["ymin"], b["ymax"]))


ggplot(THprovince_latlon) + geom_sf()
## call province latlon and shp
THprovince_latlon <- readRDS("THprovince_latlon.rds")
th_shp <- readRDS("THprovince_shpfile.rds")

ggplot(data = map1) +
  geom_sf(aes(fill = BUS_warning)) +
  coord_sf(datum = NA) +
  scale_fill_brewer(palette = "Dark2") +
  #  scale_color_brewer(palette = "Set1") +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_line(colour = "transparent")
  ) + labs(title = "Warning") + ggtitle(paste("Waring on", "Jun"))