library(tidyverse)
library(rvest)


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
                  date = "2024-10-09",
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



