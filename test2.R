"https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at?lat=13.10&lon=100.10&fields=tc,rh&date=2017-08-17&hour=8&duration=2"

get_weather_forecast <- function(lat.n, lon.n){
  str_c(
    "https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at?lat=",
    lat.n,
    "&lon=",
    lon.n,
    "&fields=tc,rh&date=2024-10-10&hour=0&duration=24") |>
    request() |>
    req_auth_bearer_token(token) |>
    req_perform() |>
    resp_body_json()
  
  weath <- json |> pluck(1, 1) |> pluck("forecasts") |> 
    map_dfr(\(x){
    tibble(
      time = x |> pluck("time"),
      cond = x |> pluck("data", "cond"),
      rh = x |> pluck("data", "rh"),
      tc = x |> pluck("data", "tc"),
      rain = x |> pluck("data", "rain")
      )
      }
}


lat.n <- 10
lon.n <- 9
mark.df <- tribble(~ lat.n, ~ lon.n, 
                   13.10, 100.10, 
                   12.10, 100.20)



list_DF <- list()

for (i in 1:length(mark.df)){
  print(i)
  list_DF[[i]] <- get_weather_forecast(lat.n = mark.df$lat.n[i], 
                               lon.n = mark.df$lat.n[i])
}

