library(nplyr)
library(tidyverse)

weather_to_BUS_data <- function(data) {
  data %>%
    # Gather the data into key-value pairs, excluding lat and lon
    gather(key = "time", value = "value", c(-lat, -lon, -var)) %>%
    # Spread the key-value pairs into wider format
    pivot_wider(names_from = var, values_from = value) %>%
    # Nest the weather data by lat and lon
    nest(weather_data = c(-lat, -lon)) %>%
    # Convert temperature from Kelvin to Celsius
    nest_mutate(weather_data, tc = t2m - 273.15) %>%
    # Extract date and time components from the time string
    nest_mutate(weather_data, 
                dat = substr(time, 1, regexpr("_", time) - 1),
                time_n = substr(time, regexpr("_", time) + 1, nchar(time) - 1)) %>%
    # Create binary indicators for relative humidity thresholds
    nest_mutate(weather_data,
                RH2 = if_else(rhum > 90, 1, 0),
                WT = if_else(rhum >= 87, 1, 0)) %>%
    # Group by date
    nest_group_by(weather_data, dat) %>%
    # Summarize records per group
    nest_summarise(weather_data,
                   n_records = n(),
                   Tbar = mean(tc, na.rm = TRUE),
                   cum_RH2 = sum(RH2, na.rm = TRUE),
                   cum_WT = sum(WT, na.rm = TRUE)) %>%
    # Calculate BUS indices
    nest_mutate(weather_data,
                BUS1 = if_else(Tbar > 14, cum_WT / 4, 0),
                BUS2 = if_else(cum_RH2 >= 16, BUS1 + ((cum_RH2 - 12) / 6), BUS1),
                BUS3 = if_else(Tbar < 23 & Tbar > 26, BUS2 - 2, BUS2),
                BUS4 = if_else(Tbar < 19 & Tbar > 29, BUS3 - 2, BUS2),
                index_BUS = if_else(BUS4 >= 2.25, 1, 0),
                BUS_warning = if_else(index_BUS >= 1, "YES", "NO")) %>%
    # Unnest the weather data
    unnest(weather_data)
}

# Example usage:
# result <- process_weather_data(h.test)
# head(result)

# Example usage:
# result <- process_weather_data(h.test)
# head(result)