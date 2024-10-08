library(tidyverse)
library(readr)

lat.lon.subdi <- read_csv(file ="https://raw.githubusercontent.com/spicydog/thailand-province-district-subdistrict-zipcode-latitude-longitude/master/output.csv",
                          col_types = "cccnnn")


