library(countrycode)
library(tidyverse)
library(writexl)
library(tidymodels)
library(readxl)
library(dplyr)
library(snakecase)
library(stringr)


setwd("../")

# 1 - TAXA DE DESEMPREGO --------------------------------------------------
taxa_desemp <- read.csv("1_taxa_desemp.csv")
View(taxa_desemp)



df <- taxa_desemp |>
  filter(FREQUENCY == "A") |>
  select(LOCATION,TIME,Value) |>
  rename(code = LOCATION, year = TIME) |>
  mutate(country = countrycode(code, origin = "iso3c", destination = "country.name")) |>
  rename_all(tolower) |>
  select(country,code,year,value) |>
  rename(taxa_desemp = value) |>
  drop_na(country) |>
  mutate(across(c( "country", "code"), as.factor))

write_xlsx(df,"./Bases Tratadas/1_taxa_desemp_tratada.xlsx")

  
# testes
mutate(year = substr(year, start = 0, stop = 4))
range(df$year)
australia <- filter(taxa_desemp,LOCATION == "AUS") %>% 
  filter(FREQUENCY == "A")





