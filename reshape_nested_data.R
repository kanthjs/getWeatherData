weather_d02$var %>% unique()

library(tidyverse)
library(nplyr)

weather.tidy <- weather_d01 |> 
  gather(key = "time", value = "value", c(-lat, -lon, -var)) |>
  pivot_wider(names_from = var, values_from = value) |>
  nest(weather_data = c(-lat, -lon)) |>
  nest_mutate(weather_data, tc = t2m - 273.15)

small.weather <- weather.tidy %>% head()

test1 <- small.weather %>% nest_mutate(weather_data, dat = substr(time, 1, regexpr("_", time) - 1),
                                                     time_n = substr(time, regexpr("_", time) + 1, nchar(time)-1)
                                       )
