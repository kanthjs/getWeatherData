
library(nplyr)
library(lubridate)


rowbind[1, ]$data |> map_df(~ .x) |>
  mutate(RH2 = if_else(rh > 90, 1, 0), WT = if_else(rain >= 0.1, 1, 0)) |>
  summarise(Tbar = mean(tc),
            cum_RH2 = sum(RH2),
            cum_WT = sum(WT)) |>
  mutate(
    BUS1 = if_else(Tbar > 14, cum_WT / 4, 0),
    BUS2 = if_else(cum_RH2 >= 16, BUS1 + ((cum_RH2 - 12) / 6), BUS1),
    BUS3 = if_else(Tbar < 23 &
                     Tbar > 26, BUS2 - 2, BUS2),
    BUS4 = if_else(Tbar < 19 &
                     Tbar > 29, BUS3 - 2, BUS2)
  ) |>
  summarise(index = if_else(BUS4 >= 2.25, 1, 0),
            BUS_warning = if_else(index >= 1, "YES", "NO"))



#WeatherAtLocation <- 

test <- list_DF |> list_rbind(names_to = "id") |> 
  tidyr::nest(weather_data = -tambon.code) %>% 
  nest_mutate(weather_data, 
              )



WeatherAtLocation %>%
  nest_mutate(weather_data,
              RH2 = if_else(rh > 90, 1, 0),
              WT = if_else(rain >= 0.1, 1, 0)) %>%
  nest_summarize(
    weather_data,
    Tbar = mean(tc),
    cum_RH2 = sum(RH2),
    cum_WT = sum(WT)
  ) %>%
  nest_mutate(
    BUS = if_else(Tbar > 14, cum_WT / 4, 0),
    if_else(cum_RH2 >= 16, BUS1 + ((cum_RH2 - 12) / 6), BUS1),
    if_else(Tbar < 23 &
              Tbar > 26, BUS2 - 2, BUS2),
    if_else(Tbar < 19 &
              Tbar > 29, BUS3 - 2, BUS2)
    if_else(BUS4 >= 2.25, 1, 0
    )
            )
              
              #,
              BUS1 = if_else(Tbar > 14, cum_WT / 4, 0),
              BUS2 = if_else(cum_RH2 >= 16, BUS1 + ((cum_RH2 - 12) / 6), BUS1),
              BUS3 = if_else(Tbar < 23 &
                               Tbar > 26, BUS2 - 2, BUS2),
              BUS4 = if_else(Tbar < 19 &
                               Tbar > 29, BUS3 - 2, BUS2),
              index = if_else(BUS4 >= 2.25, 1, 0)
              ) %>% nest_summarise(weather_data, BUS_w = if_else(index >= 1, "YES", "NO"))
  
  
  #summarise(BUS_warning = map(weather_data, if_else(index >= 1, "YES", "NO")))
  

BUS1 = if_else(Tbar > 14, cum_WT / 4, 0),
BUS2 = if_else(cum_RH2 >= 16, BUS1 + ((cum_RH2 - 12) / 6), BUS1),
BUS3 = if_else(Tbar < 23 &
                 Tbar > 26, BUS2 - 2, BUS2),
BUS4 = if_else(Tbar < 19 &
                 Tbar > 29, BUS3 - 2, BUS2),
index = if_else(BUS4 >= 2.25, 1, 0)
  
  
  #mutate(weather_data, index = if_else(BUS4 >= 2.25, 1, 0),
                       BUS_warning = if_else(index >= 1, "YES", "NO"))
