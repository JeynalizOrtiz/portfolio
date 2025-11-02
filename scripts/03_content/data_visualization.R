################################################################################
# EVR628
################################################################################
#
# Jeynaliz Ortiz Gonzalez
#
# October 19, 2025, edited on November 2, 2025
#
# Graph and content development for data portrayal using cleaned, processed
# data of sea turtle disorientations in Miami-Dade County (2025).

################################################################################

#Load libraries
library(tidyverse)
library(ggplot2)
library(patchwork)

#Load clean, processed data
dis2025_clean <- read_rds(file = "data/processed/disorientations2025_clean.rds")

#Developing a plot that demonstrates how many total disorientations have ocurred
#per site. Find original dis_per_site on Analysis.R file.

dis_per_site <- dis2025_clean |>
   group_by(sites) |>
   summarize(nests = n_distinct(nest))

dis_per_site

dis_per_site_plot <- ggplot(data = dis_per_site,
                            aes(x = sites,
                                y = nests)) +
  geom_col(fill = "steelblue1") +
  labs(
    title = "Disorientation count by site",
    x = "Site",
    y = "Disorientation count",
    fill = "Nest count",
    caption = "Source: Miami-Dade County Parks Sea Turtle Conservation Program (2025)") +
  theme_minimal() +
  theme(
    plot.title.position = "plot",
    axis.text.x = element_text(angle = 0, hjust = 0.75))

dis_per_site_plot

#Creating a heat map that demonstrates nest per site while simultaneously comparing
#sea turtle species. Find original species_dispersite on Analysis.R file.

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

species_dispersite_plot <- ggplot(data = species_dispersite,
                                  aes(x = sites,
                                      y = species,
                                      fill = nests_species)) +
  geom_tile(color = "white") +
  labs(title = "Heat map of nests by site and species",
       subtitle = "Cell values represent nest counts (n)",
       x = "Site",
       y = "Species",
       caption = "Source: Miami-Dade Sea Turtle Conservation Porgram (2025)",
       fill = "Nest Count") +
  theme_minimal() +
  theme(plot.title.position = "plot")

species_dispersite_plot

#Facet plot comparing sea turtle species nest counts per site.

#Frst, determine the maximum value represented for all of the plots based on nest count.
max_nests <- max(species_dispersite$nests_species, na.rm = TRUE)

max_nests

species_facets_plot1 <- ggplot(
  data = species_dispersite,
  aes(x = sites, y = nests_species, group = species)) +
  geom_point(size = 3, color = "red") +
  geom_line(aes(group = 1), color = "black") +
  facet_wrap(~ species, nrow = 1, scales = "free_y") +
  expand_limits(y = 0:max_nests) +
  labs(
    title = "Nest Counts by Site",
    subtitle = "Each panel shows site-level nest counts (n)",
    x = "Site",
    y = "Nest count (n)",
    caption = "Source: Miami-Dade Sea Turtle Conservation Porgram (2025)") +
  theme_minimal() +
  theme(
    plot.title.position = "plot",
    axis.text.x = element_text(angle = 35, hjust = 1),
    strip.text = element_text(face = "bold"))

#Same as above but showcased with geom_col()

species_facets_plot2 <- ggplot(
  data = species_dispersite,
  aes(x = sites, y = nests_species, group = species)) +
  geom_col(color = "black", fill = "steelblue") +
  facet_wrap(~ species, nrow = 1, scales = "free_y") +
  expand_limits(y = 0:max_nests) +
  labs(
    title = "Nest Counts by Site",
    subtitle = "Each panel shows site-level nest counts (n)",
    x = "Site",
    y = "Nest count (n)",
    caption = "Source: Miami-Dade Sea Turtle Conservation Program (2025)") +
  theme_minimal() +
  theme(
    plot.title.position = "plot",
    axis.text.x = element_text(angle = 35, hjust = 1),
    strip.text = element_text(face = "bold"))

species_facets_plot1
species_facets_plot2


patchwork_figure <- (dis_per_site_plot | species_dispersite_plot) +
  plot_annotation(
    title = "Sea turtle Nesting and Disorientation Patterns by Site",
    caption = "Source: Miami-Dade Sea Turtle Conservation Program (2025)")

patchwork_figure

#Save your plot

ggsave(filename = "results/img/dispersiteplot.png",
  plot = dis_per_site_plot)

ggsave(filename = "results/img/speciesdispersiteplot.png",
  plot = species_dispersite_plot)

ggsave(filename = "results/img/species_facets_plot1.png",
  plot = species_facets_plot1)

ggsave(filename = "results/img/species_facets_plot2.png",
  plot = species_facets_plot2)

ggsave(filename = "results/img/patchwork_figure.png",
  plot = patchwork_figure)

