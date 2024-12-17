library(tidyverse)
library(lubridate)

Date <-  Sys.Date() - 1 
Date <- Date |> as.Date(format = "%Y-%m-%d")
#as.Date("01-01-2016", format = "%m-%d-%Y") 
today <- paste0(format.Date(Date, "%Y"),
                format.Date(Date, "%m"),
                format.Date(Date, "%d"))

# --- Function to download and process weather data ---
get_tmd_weather <- function(domain, vars) {
  main.domain <- "https://hpc.tmd.go.th/static/csv/"
  Date <- Sys.Date() - 1
  today <- format(Date, "%Y%m%d")
  when <- "00" 
  
  urls <- paste0(
    main.domain, today, when, "/", vars, ".", domain, ".", today, when, ".csv"
  )
  
  data_list <- map(urls, read_csv)
  names(data_list) <- vars
  
  weather_data <- list_rbind(data_list, names_to = "var")
  return(weather_data)
}

# --- Download Domain 1 data ---
d01.vars <- c("t2m", "rhum", "p3h")
weather_d01 <- get_tmd_weather(domain = "d01", vars = d01.vars)
saveRDS(weather_d01, file = paste0("weather_forecast_d01_", today, ".rds"))

# --- Download Domain 2 data ---
d02.vars <- c("t2m", "rhum", "p1h")
weather_d02 <- get_tmd_weather(domain = "d02", vars = d02.vars)
saveRDS(weather_d02, file = paste0("weather_forecast_d02_", today, ".rds"))
# eos
