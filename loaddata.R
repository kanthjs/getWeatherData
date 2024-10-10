library(tidyverse)
library(rvest)
library(httr2)

token <- "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImI1Y2Y4ODk4ZDYyZTUxMjc3YjgzYWJkNzViYTMxNzQ3N2EyOGU4N2RkYThkNWQ4MWU0NTc5YzQzYWNiZTFkMTA1NWYyMDJiOWM4ZDcwZTY0In0.eyJhdWQiOiIyIiwianRpIjoiYjVjZjg4OThkNjJlNTEyNzdiODNhYmQ3NWJhMzE3NDc3YTI4ZTg3ZGRhOGQ1ZDgxZTQ1NzljNDNhY2JlMWQxMDU1ZjIwMmI5YzhkNzBlNjQiLCJpYXQiOjE3MjgwMzA4NTksIm5iZiI6MTcyODAzMDg1OSwiZXhwIjoxNzU5NTY2ODU5LCJzdWIiOiIyMjk2Iiwic2NvcGVzIjpbXX0.UZKPGcezqCvXsgk5OvW86P2OouzMGJnLmP35ZT3QXoDUbnQE6iMHp7QZSCw9_fNMisAHEkl-qMbl7T7OE-fTrP2PmyCO2B-cYEIvIcdPo_vzOmt4wcx_r5qrKc2dSm_GNTAb9vgw7AoPz6ff74lQhr9iDLwFmw1lC1MqY7OdibsvOaB6W9IJwXQgbw8DmlEtTDhPJ7rPym-ewfuRMfja_09cpXVoeczLiY-kB7IT0YwsAiBd6TuwblIcJpRPJKr829xtdHGGEvQCAXi87EP0Da5j27pQRF7zzWYBg5bY9inBQ9BHHDV_-egZydzEvjHtGd5HcrNJQBT29Dz4DMXvk6CPkxh9qIwNVGNk4cOmTWaMGoxZZUS4tHl4JD01GosbgV2-ls1d_GKJ3gXFbiHF22jvBJCdCRkWrZ5Oqfepph_zXYxTc9uOU0wgn8VRwDqysPeO5DYU8Q1Dbilzg-4FlT1xjklBvHUAUp5X3ydJXcHHjIvbkV0WCeefCYqqY97ceZMKODcU52NN85IDsAB40QGqF9iBBU_q6Rk1qvATK2B3kCeCGJiTDIfKfdraeonqtVZQTBel9dPXFhCKGozkmJG3CyLbolj-4iphd6UK_0kOWQRMC_R1PP5nmUqpJPJwUfJpT0qsIjA73k8CHtQNO4ZMbmVg4iYQLisrBTI7Vto"

# get the area code and location
# i found the NULL data with in this dataset
lat.lon.subdi <- read_csv(file ="https://raw.githubusercontent.com/spicydog/thailand-province-district-subdistrict-zipcode-latitude-longitude/master/output.csv",
                          col_types = "cccnnn")

all.marks <- lat.lon.subdi[c("latitude", "longitude")]
all.marks <- all.marks[complete.cases(all.marks),]

# get the data ####

getWeather <- function(lat.n, lon.n){
  
  base.url <- "https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at"
  
  json <- request(base.url) |> 
    req_auth_bearer_token(token) |>
    req_url_query(lat = lat.n, 
                  lon = lon.n,
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
}

lat.n <- 13.10
lon.n <- 100.10

mark.df <- tribble(~ lat.n, ~ lon.n, 
                   13.10, 100.10, 
                   12.10, 100.20)

# retrieve
list_DF <- list()
#for (i in 60:nrow(all.marks)){
for (i in 1:10){
  print(i)
  list_DF[[i]] <- getWeather(lat.n = all.marks$latitude[i], 
                             lon.n = all.marks$longitude[i])
}

saveRDS(list_DF, file = "TMD10.rds")

rowbind <- list_DF |> list_rbind(names_to = "id") |> nest_by(id)


# this code and reach to the limit



