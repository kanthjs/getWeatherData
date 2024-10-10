# load: shp file: https://data.humdata.org/dataset/cod-ab-tha
# ref: yt: https://www.youtube.com/watch?v=fdOriwtVyT8
# mapshp website: https://mapshaper.org/
# load data in each area
library(readxl)

location_th <- read_excel("location_th.xlsx")

base.url <- "https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/place?"

json <- request(base.url) |> 
  req_auth_bearer_token(token) |>
  req_url_query(province = location_th$province.th[1], 
                amphoe = location_th$amphoe.th[1],
                fields = 'cond,tc,rh,rain',
                date = "2024-10-11",
                hour = 0,
                duration = 24, .multi = "explode") |>
  req_throttle(rate = 10/60) |>
  req_perform() |>
  resp_body_json()


weath <- json |> pluck(1, 1) |> pluck("forecasts") |> map_dfr(
  \(x){
    tibble(
      time = x |> pluck("time"),
      tc = x |> pluck("data", "tc"),
      rh = x |> pluck("data", "rh"),
      rain = x |> pluck("data", "rain"),
      cond = x |> pluck("data", "cond"),
    )
  }
)
weath$lat <- json |> pluck(1, 1) |> pluck("location", "lat")
weath$lon <- json |> pluck(1, 1) |> pluck("location", "lon")

weath %>% relocate(lat, lon)
