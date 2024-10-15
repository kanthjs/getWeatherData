library(tidyverse)
library(lubridate)
library(tibble)
library(nplyr)

# Domain 1 : ข้อมูลพยากรณ์ราย 3 ชั่วโมงล่วงหน้า 10 วัน รายละเอียดเชิงพื้นที่ 9 กิโลเมตร
# Domain 2 : ข้อมูลพยากรณ์ราย 1 ชั่วโมงล่วงหน้า 72 ชั่วโมง รายละเอียดเชิงพื้นที่ 3 กิโลเมตร


### 1. Here is for retrieve the data ####
main.domain = "https://hpc.tmd.go.th/static/csv/"
# we need to specify the data you want to retrieve data
#format 20240422"
this.time = "20241015"
#time at 1am in that day
when = "00"
# select factor, t2m  = temp, rhum = humidity, p3h = precipitation
var = "t2m"

vars <- c("t2m", "rhum", "p3h")

#(vars)

tmd.data.list <- list()

for (i in 1:length(vars)) {
  tmd.data.list[i] <- paste0(main.domain,
                             this.time,
                             when,
                             "/",
                             vars[i],
                             ".d01." ,
                             this.time,
                             when,
                             ".csv")
}


tmd.list <- tmd.data.list %>% map(read_csv)
names(tmd.list) <- vars

list_rbind(tmd.list, names_to = "var")


list_rbind(tmd.list, names_to = "var") |> 
  gather(key = "time", value = "value", c(-lat, -lon, -var)) 

tesxt <- list_rbind(tmd.list, names_to = "var") |> 
  gather(key = "time", value = "value", c(-lat, -lon, -var)) |>
  pivot_wider(names_from = var, values_from = value) |>
  nest(weather_data = c(-lat, -lon)) |>
  nest_mutate(weather_data, tc = t2m - 273.15) |>
  nest_mutate(weather_data, date = dmy(time))
  




list_rbind(tmd.list, names_to = "var") |> pivot_wider(names_from = var,
                                                      values_from = starts_with("20"))
#  nest(weather_data = c(-lat, -lon)) |>
#  nest

## Here is the data that I deal with ####
save(tmd.list, file = "tmd2.RDS")


## load the data ####
load("tmd.RDS")


### Reference ####
# http://jenrichmond.rbind.io/post/use-map-to-read-many-csv-files/

tmd.list[1] |> head() 

tmd.list |> maps::map()

#|> as.tibble() |> tmd.date.gather() |> head()


test <- tmd.list %>% map_dfr(as_tibble) |> slice_sample(n = 5)

tbb = tmd.list |> enframe()

tbb |>
  rowwise() |>
  mutate( = length(c(vehicles, starships)))

rownames(tbb)
class(tbb)
# to minimize data in to small data set
temp_cut <- head(dat1)
rhum_cut <- head(rhum1)
p3h_cut <- head(p3h1)
# write function
# gather date in tmd dataset


# the function ####
tmd.date.gather <- function(dataset) {
  gather(data = dataset,
         key = date,
         value = value,
         c(-lat, -lon)) %>%
    separate(date, c("time", "day"), "Z ") %>%
    mutate(day = dmy(day), time = hm(time))
}

tmd.date.gather(temp_cut)
tmd.date.gather(rhum_cut)
tmd.date.gather(p3h_cut)

long_temp <- temp_cut %>% gather(key = date, value = temp, c(-lat, -lon))

long_temp %>% mutate(year = year(date))


long_temp %>% separate(date, c("time", "day"), "Z ") %>% mutate(day = dmy(day), time = hm(time))


#

sdat <- dat[c(1, 2, 4)]
names(sdat) <- c("x", "y", "val")

sdat %>% ggplot(aes(lat, lon, color = val)) + geom_point()


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

r <- matrix(rnorm(100), 10, 10)
r <- raster(r)
sdat <- raster(sdat)
extent(r) <- c(-20, 20, 30, 70)

names(sdat) <- c("y", "x", "val")

sdat.r <- rasterFromXYZ(sdat)

sdat_m <- mask(sdat_ras, th_shp)

sdat_sf <- st_as_sf(x = sdat,
                    coords = c("x", "y"),
                    crs = 4326)

sdat_ras <- terra::rast(sdat_sf)

r_df <- sdat_ras %>%
  rasterToPoints() %>%
  as.data.frame()

sdat.crop <- st_crop(th_shp, sdat_ras)

final_raster <- terra::rasterize(sdat_ras, th_shp)

ggplot() +
  geom_stars(data = sdat_ras) +
  scale_fill_viridis_c() +
  geom_sf(data = th_shp, fill = "transparent")
terra::crop(sdat_sf, th_shp)

e <- ext(6.15, 6.3, 49.7, 49.8)
