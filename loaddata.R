lat.lon.subdi <- read_csv(file ="https://raw.githubusercontent.com/spicydog/thailand-province-district-subdistrict-zipcode-latitude-longitude/master/output.csv",
                          col_types = "cccnnn")

all.marks <- lat.lon.subdi[c("latitude", "longitude")]


library(rvest)
loc <- read_html("https://data.tmd.go.th/nwpapi/doc/common/location_list1.html")

css_selector_paragraph  <- "#book-search-results > div.search-noresults > section"

loc.tble <- loc %>% 
  html_element(css = css_selector_paragraph) %>% 
  html_text() |>
  readr::read_table(, skip = 1, col_names= c("code", "-" ,"loc_name"))



loc %>% minimal_html() %>%
  html_nodes(div id="book-search-results")



#%>%
  html_elements("li") %>% 
  html_text2()
#write the function to

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
    req_perform() |>
    resp_body_json()
  
  error = function(e){
    message(paste("An error occurred for item", i, stuff[[i]],":\n"), e)
  }
  
  weath <- json |> pluck(1, 1) |> pluck("forecasts") |> map_dfr(
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
}

mark.df <- tribble(~ lat.n, ~ lon.n, 
                   13.10, 100.10, 
                   12.10, 100.20)

# retrieve
list_DF <- list()
#for (i in 60:nrow(all.marks)){
for (i in 60:65){
  print(i)
  list_DF[[i]] <- getWeather(lat.n = all.marks$latitude[i], 
                             lon.n = all.marks$longitude[i])
  error <- function(e) return(NA)
}

rowbind <- list_DF |> list_rbind(names_to = "id") |> nest_by(id)


# this code and reach to the limit

