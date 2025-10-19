################################################################################
# EVR628
################################################################################
#
# Jeynaliz Ortiz Gonzalez
#
# October 19, 2025
#
# Graph and content development for data portrayal using cleaned, processed
# data of sea turtle disorientations in Miami-Dade County (2025).

################################################################################

#Load libraries
library(tidyverse)
library(ggplot2)

#Load clean, processed data
dis2025_clean <- read_rds(file = "data/processed/disorientations2025_clean.rds")

#Developing a plot that demonstrates how many total disorientations have ocurred
#per site. Find dis_per_site on Analysis.R file.

dis_per_site_plot <- ggplot(data = dis_per_site,
                            aes(x = sites,
                                y = nests,
                                fill = nests)) +
  geom_col() +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  labs(
    title = "Disorientation Count by Site",
    x = "Site",
    y = "Disorientation Count",
    fill = "Nest count") +
  theme_minimal()

#Creating a heat map that demonstrates nest per site while simultaneously comparing
#sea turtle species. Find species_dispersite on Analysis.R file.

species_dispersite_plot <- ggplot(data = species_dispersite,
                                  aes(x = sites,
                                      y = species,
                                      fill = nests_species)) +
  geom_tile(color = "white") +
  labs(title = "Heat Map of Nests by Site and Species",
       x = "Site",
       y = "Species",
       fill = "Nest Count") +
  theme_minimal()

#Save your plot

ggsave(filename = "results/img/dispersiteplot.png",
  plot = dis_per_site_plot)

ggsave(filename = "results/img/speciesdispersiteplot.png",
  plot = species_dispersite_plot)
