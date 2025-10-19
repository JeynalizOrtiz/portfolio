################################################################################
# EVR628
################################################################################
#
# Jeynaliz Ortiz Gonzalez
#
# October 19, 2025
#
# Analysis portion of cleaned, procesed data of sea turtle disorientations in
# Miami-Dade County (2025).
#
################################################################################

#Load libraries
library(tidyverse)
library(ggplot2)

#Load cleaned, processed data

dis2025_clean <- read_rds(file = "data/processed/disorientations2025_clean.rds")

#How many disoriented nests (hatches) per site are there?

dis_per_site <- dis2025_clean |>
   group_by(sites) |>
   summarize(nests = n_distinct(nest))

dis_per_site

#Miami beach seems to have the highest count,
#How can we demonstrate overall percentage per site?

MBdis_percentage <- dis_per_site |>
  summarize(
    total_nests = sum(nests,
                      na.rm = TRUE),
    miami_beach_nests = sum(nests[sites == "miami beach"],
                            na.rm = TRUE),
    percent_miami_beach = (miami_beach_nests / total_nests) * 100)

MBdis_percentage

#Create a tibble that shows count by species, per site.

species_summary <- dis2025_clean |>
  group_by(sites,
           species) |>
  summarize(nests = n_distinct(nest), .groups = "drop")

species_summary

species_dispersite <- species_summary |>
  left_join(dis_per_site,
            by = "sites",
            suffix = c("_species", "_total")) |>
  mutate(percent = round((nests_species / nests_total) * 100, 1))

species_dispersite
