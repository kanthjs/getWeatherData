# load: shp file: https://data.humdata.org/dataset/cod-ab-tha
# ref: yt: https://www.youtube.com/watch?v=fdOriwtVyT8
# mapshp website: https://mapshaper.org/
# load library
library(readxl)
library(tidyverse)
library(httr2)
# load data in each area
#Sys.getenv("tmd_token")

location_th <- read_excel("all_tambons.xlsx")

getWeather <- function(province.th, amphoe.th, tambon.th) {
  base.url <- "https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/place?"
  json <- request(base.url) |>
    req_auth_bearer_token(Sys.getenv("tmd_token")) |>
    req_url_query(
      province = province.th,
      amphoe = amphoe.th,
      tambon = tambon.th,
      fields = 'cond,tc,rh,rain',
      date = "2024-10-12",
      hour = 0,
      duration = 24,
      .multi = "explode"
    ) |>
    req_throttle(rate = 10 / 60) |>
    req_perform() |>
    resp_body_json()
  
  weath <- json |> pluck(1, 1) |> pluck("forecasts") |> map_dfr(\(x) {
    tibble(
      time = x |> pluck("time"),
      tc = x |> pluck("data", "tc"),
      rh = x |> pluck("data", "rh"),
      rain = x |> pluck("data", "rain"),
      cond = x |> pluck("data", "cond")
    )
  })
  weath$tambon.code <- location_th$ADM3_PCODE[i]
  weath$Date <- substr(weath$time, start = 1, stop = 10) |> ymd()
  weath %>% relocate(tambon.code, Date)
  
}


# retrieve
list_DF <- list()
#for (i in 60:nrow(all.marks)){
for (i in 1:10){
  print(i)
  list_DF[[i]] <- getWeather(province.th = location_th$ADM1_TH[i], 
                             amphoe.th = location_th$ADM2_TH[i],
                             tambon.th = location_th$ADM3_TH[i])
}

saveRDS(list_DF, file = "TMD10.rds")

rowbind <- list_DF |> list_rbind(names_to = "id") |> nest_by(tambon.code, Date)

# eos