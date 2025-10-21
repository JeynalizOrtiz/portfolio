################################################################################
# EVR628
################################################################################
#
# Jeynaliz Ortiz Gonzalez
#
# October 19, 2025
#
# Data cleanup of sea turtle disorientations in Miami-Dade County (2025).
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

#Addressing a GPS error in the dataset at the moment of export
#Manually substituting correct value with base R function.

dis2025[139, "latitude"] <- 25.8382267

#Change the latitude and longitude to a consistent number of decimal points.
#This has been applied because methods include two different GPS systems:
#Trimble and Google Earth, which both yield differing decimal points.
#Need to convert to character function to be able to round.

latmin_decimals <- dis2025 |>
  mutate(dec = nchar(sub("^[^.]*\\.?","", as.character(latitude)))) |>
  summarize(min(dec, na.rm = TRUE)) |>
  pull()

lonmin_decimals <- dis2025 |>
  mutate(dec = nchar(sub("^[^.]*\\.?","", as.character(longitude)))) |>
  summarize(min(dec, na.rm = TRUE)) |>
  pull()

#Converting back to numeric function to be able to complete mathematical function.

dis2025 <- dis2025 %>%
  mutate(
    latitude = as.numeric(latitude),
    longitude = as.numeric(longitude)) |>
  mutate(
    latitude = round(latitude, latmin_decimals),
    longitude = round(longitude, lonmin_decimals))

#Inspect data table to confirm code has worked.
dis2025

# Filter out the NA's in the nest column (That means that these disorientations
#were not from hatches but from adult nesters, therefore irrelevant to our
#current question.)

dis2025 <- dis2025 |>
  filter(!is.na(nest))

# Create a new column for sites

dis2025 <- dis2025 %>%
  mutate(
    sites = case_when(
      str_detect(nest, "^KB-N") ~ "key biscayne",
      str_detect(nest, "^HO-N") ~ "haulover",
      str_detect(nest, "^FI-N") ~ "fisher island",
      str_detect(nest, "^MB-N") ~ "miami beach",
      str_detect(nest, "^GB-N") ~ "golden beach",
      str_detect(nest, "MNGB") ~ "golden beach",
      str_detect(nest, "MNMB") ~ "miami beach",
      str_detect(nest, "MNKB") ~ "key biscayne",
      str_detect(nest, "C0") ~ "miami beach",
      TRUE ~ NA_character_))

#Manually correcting a date mistake on the date column, row 66
dis2025[66, "date"] <- "6/30/2025"

# Step 2: convert my date column into an actual date object, overwrite
dis2025 <- dis2025 |>
  mutate(date = mdy(date))

#Export clean data file
write_rds(
  x = dis2025,
  file = "data/processed/disorientations2025_clean.rds")

################################################################################



