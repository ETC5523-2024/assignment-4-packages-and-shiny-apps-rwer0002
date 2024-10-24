## code to prepare `analysis_data` dataset goes here

library("tidyverse")
library("readxl")
library("lubridate")

raw_data_2021 <- read.csv("data-raw/PFW_all_2021_2024_May2024_Public.csv")
raw_data_2016 <- read.csv("data-raw/PFW_all_2016_2020_May2024_Public.csv")
raw_data_2011 <- read.csv("data-raw/PFW_all_2011_2015_May2024_Public.csv")
raw_data_2006 <- read.csv("data-raw/PFW_all_2006_2010_May2024_Public.csv")
raw_data_2001 <- read.csv("data-raw/PFW_all_2001_2005_May2024_Public.csv")
raw_data_1996 <- read.csv("data-raw/PFW_all_1996_2000_May2024_Public.csv")
raw_data_1988 <- read.csv("data-raw/PFW_all_1988_1995_May2024_Public.csv")

raw_data_combined <- rbind(raw_data_1996, raw_data_1988, raw_data_2001, raw_data_2006, raw_data_2011, raw_data_2016, raw_data_2021)

bird_data <- raw_data_combined %>%
  filter(SPECIES_CODE == c("sprpip", "henspa", "graspa", "lecspa", "savspa", "savspa4",
                           "ipsspa", "bldspa", "savspa3", "labspa", "wesmea", "mcclon", "grpchi",
                           "greprc1", "baispa", "chclon", "shtgro", "lobcur", "larbun", "horlar",
                           "horlar3", "horlar1", "sedwre1", "easmea", "easmea2", "dickci", "norbob",
                           "norbob1", "x00688", "ferhaw", "burowl", "logshr", "y00620", "casspa",
                           "fiespa", "aplfal", "lilmea2", "comnig", "sonspa", "sonspa2", "swaspa")) %>%
  group_by(Year) %>%
  count(Year) %>%
  ungroup(Year) %>%
  rename("population" = "n") %>%
  filter(Year > 1999)

agriculture_data <- read_xls("data-raw/FAOSTAT_data_en_9-6-2024.xls") %>%
  filter(Year > 1999) %>%
  select("Year", "Value")

analysis_data <- merge(bird_data, agriculture_data, by = "Year", all = TRUE) %>%
  rename("Bird_Population" = "population",
         "Production" = "Value")

usethis::use_data(analysis_data, overwrite = TRUE)
