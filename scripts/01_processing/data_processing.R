################################################################################
# EVR628
################################################################################
#
# Jeynaliz Ortiz Gonzalez
#
# October 19, 2025
#
# Sea turtle disorientations in Miami-Dade County (2025).
#
################################################################################

#Load libraries
library(tidyverse)
library(ggplot2)
library(janitor)

#Load data

dis2025 <- read.csv(file = "data/raw/disorientations2025.csv")

#Clean column names

dis2025 <- dis2025 |>
  clean_names()

dis2025 <- dis2025 |>
  rename(
    nest = nest_number,
    direction = disorientation_direction,
    disoriented = turtles_disoriented)

#Check column names

colnames(dis2025)

#Change the latitude and longitude to a consistent number of decimal points
#Need to convert to character functon to be able to round

latmin_decimals <- dis2025 |>
  mutate(dec = nchar(sub("^[^.]*\\.?","", as.character(latitude)))) |>
  summarise(min(dec, na.rm = TRUE)) |>
  pull()

lonmin_decimals <- dis2025 |>
  mutate(dec = nchar(sub("^[^.]*\\.?","", as.character(longitude)))) |>
  summarise(min(dec, na.rm = TRUE)) |>
  pull()

dis2025 <- dis2025 |>
  mutate(
    latitude = round(latitude, latmin_decimals),
    longitude = round(longitude, lonmin_decimals))

#Convert back to numeric function to be able to complete mathematical function

dis2025 <- dis2025 %>%
  mutate(
    latitude = as.numeric(latitude),
    longitude = as.numeric(longitude)) |>
  mutate(
    latitude = round(latitude, latmin_decimals),
    longitude = round(longitude, lonmin_decimals))

