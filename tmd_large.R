library(tidyverse)
library(lubridate)
library(tibble)
library(nplyr)

# Domain 1 : ข้อมูลพยากรณ์ราย 3 ชั่วโมงล่วงหน้า 10 วัน รายละเอียดเชิงพื้นที่ 9 กิโลเมตร
# Domain 2 : ข้อมูลพยากรณ์ราย 1 ชั่วโมงล่วงหน้า 72 ชั่วโมง รายละเอียดเชิงพื้นที่ 3 กิโลเมตร

### 1. Here is for retrieve the data ####
main.domain <- "https://hpc.tmd.go.th/static/csv/"
# we need to specify the data you want to retrieve data
#format 20240422"
#this.time = "20241016"
Date <- Sys.Date()
today <- paste0(year(Date), month(Date), day(Date))

#time at 1am in that day
when <- "00"

#### domain 1 ####
d01.vars <- c("t2m", "rhum", "p3h")

tmd.data.list <- list()

for (i in 1:length(vars)) {
  tmd.data.list[i] <- paste0(main.domain,
                             today,
                             when,
                             "/",
                             d01.vars[i],
                             ".d01." ,
                             today,
                             when,
                             ".csv")
}

tmd.list <- tmd.data.list %>% map(read_csv)

names(tmd.list) <- vars

weather <- list_rbind(tmd.list, names_to = "var")

saveRDS(weather, file = paste0("weather_forecast_d01_", today, ".rds"))

### domain 2 #####
tmd.data.list <- list()
d02.vars <- c("t2m", "rhum", "p1h")
for (i in 1:length(vars)) {
  tmd.data.list[i] <- paste0(main.domain,
                             today,
                             when,
                             "/",
                             d02.vars[i],
                             ".d02." ,
                             today,
                             when,
                             ".csv")
}

tmd.list <- tmd.data.list %>% map(read_csv)

names(tmd.list) <- d02.vars

weather <- list_rbind(tmd.list, names_to = "var")

saveRDS(weather, file = paste0("weather_forecast_d02_", today, ".rds"))

#eos