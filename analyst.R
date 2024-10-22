

s_weather <- weather |> group_by(var, lat, lon) |> slice_head(n = 8)


list_rbind(tmd.list, names_to = "var") |> 
  gather(key = "time", value = "value", c(-lat, -lon, -var)) 

tesxt <- list_rbind(tmd.list, names_to = "var") |> 
  gather(key = "time", value = "value", c(-lat, -lon, -var)) |>
  pivot_wider(names_from = var, values_from = value) |>
  nest(weather_data = c(-lat, -lon)) |>
  nest_mutate(weather_data, tc = t2m - 273.15)|>
  nest_mutate(weather_data, date = dmy(time))


s.test <- s_weather |> 
  gather(key = "time", value = "value", c(-lat, -lon, -var)) |>
  pivot_wider(names_from = var, values_from = value) |>
  nest(weather_data = c(-lat, -lon)) |>
  nest_mutate(weather_data, tc = t2m - 273.15)


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

