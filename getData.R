# TMD api connect and get the weather forecast data # 
# ref: https://data.tmd.go.th/nwpapi/doc/apidoc/location/forecast_hourly.html#%E0%B8%82%E0%B9%89%E0%B8%AD%E0%B8%A1%E0%B8%B9%E0%B8%A5%E0%B8%9E%E0%B8%A2%E0%B8%B2%E0%B8%81%E0%B8%A3%E0%B8%93%E0%B9%8C%E0%B8%AD%E0%B8%B2%E0%B8%81%E0%B8%B2%E0%B8%A8%E0%B8%A3%E0%B8%B2%E0%B8%A2%E0%B8%8A%E0%B8%B1%E0%B9%88%E0%B8%A7%E0%B9%82%E0%B8%A1%E0%B8%87

# call library function
library(httr2)
library(tidyverse)
library(purrr)


# kept my token
token <- "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjFhNmNjNTBlNzNlOWNiZTIzNjU2ZWMzZDc4NTkxYTQ2ZjQxMDVlNzk3YjY3MWMyZTU1M2U2OGM3Nzc3MDYyMjVkMzg4YWUzNDJiOWM0MWE5In0.eyJhdWQiOiIyIiwianRpIjoiMWE2Y2M1MGU3M2U5Y2JlMjM2NTZlYzNkNzg1OTFhNDZmNDEwNWU3OTdiNjcxYzJlNTUzZTY4Yzc3NzcwNjIyNWQzODhhZTM0MmI5YzQxYTkiLCJpYXQiOjE3MjgwMzI1MTksIm5iZiI6MTcyODAzMjUxOSwiZXhwIjoxNzU5NTY4NTE5LCJzdWIiOiIyMjk2Iiwic2NvcGVzIjpbXX0.ZPgwlFemQR6BnXxVh7yEqf3BgnyrEgyh8tk-HkNmiBWMTnjPnbUNKsJZVQOEeDj0Jr5r6DFgkhZOPrmM4cRK_IfbTNGhesAxk_qnMNH9kJqMB2yPIh6gEHLmY0XLUQKyGzauMVR4sFHgibRxasG4-UbpQrCcQon2lhj5O1MDVzcIOTf1WGFr_kWD4Qx1mN-MX8x2A1Zd0qV3PonSUqfMhUM1xP6Jz2Wc4cU6s2-RlUTghruuMtg5lZUxoO9b7iPtjfYqoJaHtHDwdGhUwkJP-jfKjidvhhAMHy3QyMLDRj8sw8c14lETJKpLtei9Z-6ucBLN7ioMRsNBMEdvKhcwBWlei9O7MM526ZDxLfC-Hquowmr9OjQvVQJCb2XnE2wI973Dr1vlG-ui65CaZI0AJ0PvWx-gVFkwBVQgMmveMBaWk5vdbpfVuwQfuaDVb0Hk3QlUvaWgXG5-zG8orXsRTVvaXAOrjfHls_Yn3EMcOd0rTPUqWrJzGQGJqLG_i2HZfJFuoSACMvb93YJ9Kk3j0P6yT8wxf4V0RCHkrxK3ALBleUx7kc4dcqqZ8f9P7BMR3GYqsAjfbrdDP3GmKe7trP0CE87NN4KS2zfLNPoZFczeXfdBI5XsIw88GJuyYvCUznIp6xcsn6iNIQxxCuW-SnmsFxg6tryePUsaT5YVWfQ"

# check the time window (the forecast times) #####

base.url.check <- "https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly"

test <- request(base.url.check) |>
  req_auth_bearer_token(token) |>
  req_perform() |>
  resp_body_json()|>
  pluck(1)
  
  
# get the data ####
base.url <- "https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at"



json <- request(base.url) |> 
  req_auth_bearer_token(token) |>
  req_url_query(lat = 13.10, 
                lon = 100.10,
                fields = 'cond,tc,rh,rain',
                date = "2024-10-10",
                hour = 0,
                duration = 24, .multi = "explode") |>
  req_perform() |>
  resp_body_json()

waeth <- json |> pluck(1, 1) |> pluck("forecasts") |> map_dfr(
  \(x){
    tibble(
      time = x |> pluck("time"),
      cond = x |> pluck("data", "cond"),
      rh = x |> pluck("data", "rh"),
      tc = x |> pluck("data", "tc"),
      rain = x |> pluck("data", "rain")
    )
  }
)




# titles of films
sharknados <- c(
  "Sharknado", "Sharknado 2", "Sharknado 3",
  "Sharknado 4", "Sharknado 5"
)

sharknados_df <- map(.x = sharknados, .f = omdb_api) |>
  list_rbind()




lat_element <- function(x) x[[1]]$location$lat
lon_element <- function(x) x[[1]]$location$lon
time_element <- function(x) x[[1]][[2]]$forecasts$time
cond_element <- function(x) x[]$
lat <- json |> pluck(1, lat_element)
lon <- json |> pluck(1, lon_element)
json |> pluck(1, 1) |> pluck("location", "lat")
json |> pluck(1, 1) |> pluck("location", "lon")
json |> pluck(1, 1) |> pluck("forecasts")
json |> pluck(1, 1, 2) |> pluck(1) |> pluck("time")
json |> pluck(1, 1, 2) |> pluck(1) |> pluck("data", "cond")
json |> pluck(1, 1, 2) |> pluck(1) |> pluck("data", "rh")
json |> pluck(1, 1, 2) |> pluck(1) |> pluck("data", "tc")
json |> pluck(1,1,2,5,2,1)
