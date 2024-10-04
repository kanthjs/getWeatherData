library(httr)

url <- "https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly"

querystring <- list(lat = "13.10", lon = "100.10", fields = "tc,rh", date = "2024-10-04", hour = "8", duration = "2")

headers <- add_headers(
  accept = "application/json",
  authorization = bearer_token
)

response <- GET(url, headers, query = querystring)

GET(url, headers)
response

https://hpc.tmd.go.th/static/csv/2024100312/dwl.d01.2024100312.csv