################################################################################
# EVR628
################################################################################
#
# Jeynaliz Ortiz Gonzalez
#
# November 15,2025, edited November 16, 2025
#
# Spatial Analysis:
# Create maps for data portrayal using cleaned, processed
# data of sea turtle disorientations in Miami-Dade County (2025).

################################################################################

#Load libraries
library(tidyverse)
library(ggplot2)
library(patchwork)
library(sf)
library(ggspatial)
library(rnaturalearth)
install.packages("rnaturalearthdata")
library(rnaturalearthdata)
library(terra)
library(tidyterra)
library(mapview)

#Load data

dis2025_clean <- read_rds(file = "data/processed/disorientations2025_clean.rds")

# Working with spatial data

#Converting data to spatial data. Creates a new geometry column
dis2025_sf <- st_as_sf(dis2025_clean,
  coords = c("longitude", "latitude"),
  crs    = 4326,
  remove = FALSE)

#Quick check
plot(st_geometry(dis2025_sf))

#Add the United States coastlines

world_coast <- ne_download(scale = 10,
                        type = "land",
                        category = "physical",
                        returnclass = "sf")

mapview(world_coast)

data_crs <- st_crs(world_coast)

# Crop to Florida bounding box
fl_crop <- st_bbox(c(xmin = -87.8,
                    xmax = -79.8,
                    ymin = 24.0,
                    ymax = 31.2),
                  crs = data_crs)

fl_coast <- st_crop(world_coast, fl_crop)

# Quick check

mapview(list(dis2025_sf, fl_coast))

#Crop to Miami-Dade County

miami_crop <- st_bbox(c(xmin = -80.300,
                        ymin = 25.65,
                        xmax = -80.10,
                        ymax = 26.05),
                      crs = data_crs)

miami_coast <- st_crop(world_coast, miami_crop)

#Create a map view of Florida coastline that narrows down to the site coastline
#and disorientation data

mapview(list(dis2025_sf, fl_coast, miami_coast))

#Showcasing Florida coastline in ggplot

fl_ggplot <- ggplot() +
  geom_sf(data = fl_coast,
          fill = "gray95",
          color = "black",
          size = 0.3)

#Adding disorientation data and relevant aesthetics

fl_ggplot <- ggplot() +
  geom_sf(data = miami_coast,
          fill = "gray95",
          color = "black",
          size = 0.3) +
  geom_sf(data = dis2025_sf) +
  coord_sf(crs  = 4326,
    xlim = c(miami_crop["xmin"], miami_crop["xmax"]),
    ylim = c(miami_crop["ymin"], miami_crop["ymax"])) +
  annotation_scale(location  = "bl",
    width_hint = 0.3,
    bar_cols  = c("black", "white")) +
  annotation_north_arrow(
    location   = "tl",
    which_north = "true",
    style = north_arrow_fancy_orienteering()) +
  xlab("longitude") +
  ylab("latitude") +
  theme_classic() +
  theme(legend.position = "left",
    plot.title = element_blank(),
    plot.subtitle = element_blank())

fl_ggplot

# Filter by site to start building maps by using patchwork

kb_sf <- dis2025_sf |>
  filter(sites == "key biscayne")

mb_sf <- dis2025_sf |>
  filter(sites == "miami beach")

ha_sf <- dis2025_sf |>
  filter(sites == "haulover")

fi_sf <- dis2025_sf |>
  filter(sites == "fisher island")

gb_sf <- dis2025_sf |>
  filter(sites == "golden beach")

#Create function to create site map

make_site_map <- function(site_sf, title_label, base_layer, pad = 0.2) {
  stopifnot(inherits(site_sf, "sf"), nrow(site_sf) > 0)
  bb <- st_bbox(site_sf)
  bb["xmin"] <- bb["xmin"] - pad
  bb["xmax"] <- bb["xmax"] + pad
  bb["ymin"] <- bb["ymin"] - pad
  bb["ymax"] <- bb["ymax"] + pad
  land_crop <- st_crop(fl_coast, bb)
  ggplot() +
    geom_sf(data = land_crop, fill = "gray95", color = "black") +
    geom_sf(data = site_sf, aes(color = species), size = 2.5) +
    coord_sf(xlim = c(bb["xmin"], bb["xmax"]),
             ylim = c(bb["ymin"], bb["ymax"]), expand = FALSE) +
    annotation_scale(location = "bl", width_hint = 0.25) +
    annotation_north_arrow(location = "tl",
                           style = north_arrow_fancy_orienteering()) +
    labs(
      title = title_label,
      caption = "2025 disorientation data provided by the Miami-Dade County
       Parks Sea Turtle Conservation Program",
      x = "Longitude",
      y = "Latitude",
      color = "Species") +
    theme_classic() +
    theme(
      legend.position = "right",
      legend.title = element_text(size = 10),
      legend.text  = element_text(size = 9))
      }

p_kb <- make_site_map(kb_sf, "key biscayne")
p_mb <- make_site_map(mb_sf, "miami beach")
p_ha <- make_site_map(ha_sf, "haulover")
p_fi <- make_site_map(fi_sf, "fisher island")
p_gb <- make_site_map(gb_sf, "golden beach")

# Individual maps to showcase sites individually

p_kb
p_mb
p_ha
p_fi
p_gb

# Trying shaoefile

fl_shp <- st_read("Detailed_Florida_State_Boundary/Detailed_Florida_State_Boundary.shp")


# Make sure shapefile and points have the same CRS

fl_shp <- st_transform(fl_shp, st_crs(dis2025_sf))

#Key biscayne map using shapefile

pad <- 0.05

kb_bb <- st_bbox(kb_sf)

kb_map <- ggplot() +
  geom_sf(data = fl_shp,
          fill = "gray95",
          color = "black",
          linewidth = 0.3) +
  geom_sf(data = kb_sf,
          aes(color = species),
          size = 2.5) +
  coord_sf(xlim   = c(kb_bb["xmin"] - pad,
                      kb_bb["xmax"] + pad),
    ylim   = c(kb_bb["ymin"] - pad,
               kb_bb["ymax"] + pad),
    expand = FALSE) +
  annotation_scale(location = "bl",
                   width_hint = 0.25) +
  annotation_north_arrow(location = "br",
                         style = north_arrow_fancy_orienteering()) +
  labs(title = "key biscayne",
       x = "longitude",
       y = "latitude",
       color = "species") +
  theme_classic()

kb_map

# haulover map

ha_bb <- st_bbox(ha_sf)

ha_map <- ggplot() +
  geom_sf(data = fl_shp,
          fill = "gray95",
          color = "black",
          linewidth = 0.3) +
  geom_sf(data = ha_sf,
          aes(color = species),
          size = 2.5) +
  coord_sf(xlim   = c(ha_bb["xmin"] - pad,
                      ha_bb["xmax"] + pad),
    ylim   = c(ha_bb["ymin"] - pad,
               ha_bb["ymax"] + pad),
    expand = FALSE) +
  annotation_scale(location = "bl",
                   width_hint = 0.25) +
  annotation_north_arrow(location = "br",
                         style = north_arrow_fancy_orienteering()) +
  labs(title = "Haulover",
       x = "longitude",
       y = "latitude",
       color = "species") +
  theme_classic()

ha_map

# fisher island map

fi_bb <- st_bbox(fi_sf)

fi_map <- ggplot() +
  geom_sf(data = fl_shp,
          fill = "gray95",
          color = "black",
          linewidth = 0.3) +
  geom_sf(data = fi_sf,
          aes(color = species),
          size = 2.5) +
  coord_sf(xlim   = c(fi_bb["xmin"] - pad,
                      fi_bb["xmax"] + pad),
    ylim   = c(fi_bb["ymin"] - pad,
               fi_bb["ymax"] + pad),
    expand = FALSE) +
  annotation_scale(location = "bl",
                   width_hint = 0.25) +
  annotation_north_arrow(location = "br",
                         style = north_arrow_fancy_orienteering()) +
  labs(title = "Fisher island",
       x = "longitude",
       y = "latitude",
       color = "species") +
  theme_classic()

fi_map

# miami beach map

mb_bb <- st_bbox(mb_sf)

mb_map <- ggplot() +
  geom_sf(data = fl_shp,
          fill = "gray95",
          color = "black",
          linewidth = 0.3) +
  geom_sf(data = mb_sf,
          aes(color = species),
          size = 2.5) +
  coord_sf(xlim   = c(mb_bb["xmin"] - pad,
                      mb_bb["xmax"] + pad),
    ylim   = c(mb_bb["ymin"] - pad,
               mb_bb["ymax"] + pad),
    expand = FALSE) +
  annotation_scale(location = "bl",
                   width_hint = 0.25) +
  annotation_north_arrow(location = "br",
                         style = north_arrow_fancy_orienteering()) +
  labs(title = "Miami beach",
       x = "longitude",
       y = "latitude",
       color = "species") +
  theme_classic()

mb_map

# golden beach map

gb_bb <- st_bbox(gb_sf)

gb_map <- ggplot() +
  geom_sf(data = fl_shp,
          fill = "gray95",
          color = "black",
          linewidth = 0.3) +
  geom_sf(data = gb_sf,
          aes(color = species),
          size = 2.5) +
  coord_sf(xlim   = c(gb_bb["xmin"] - pad,
                      gb_bb["xmax"] + pad),
    ylim   = c(gb_bb["ymin"] - pad,
               gb_bb["ymax"] + pad),
    expand = FALSE) +
  annotation_scale(location = "bl",
                   width_hint = 0.25) +
  annotation_north_arrow(location = "br",
                         style = north_arrow_fancy_orienteering()) +
  labs(title = "Golden beach",
       x = "longitude",
       y = "latitude",
       color = "species") +
  theme_classic()

gb_map

# Combining maps using patchwork - NOT FINAL FIGURE

combined_maps <- (kb_map | mb_map | ha_map) /
                 (fi_map | gb_map | plot_spacer()) +
  plot_annotation(title = "Sea turtle disorientations (2025)",
                  theme = theme(plot.title = element_text(hjust = 0.5,
                                                          face = "bold")))

combined_maps

# For easier visuals - Added captions to final visuals

south_maps <- (kb_map | fi_map) +
  plot_annotation(title = "Sea turtle disorientations (2025)",
    theme = theme(plot.title = element_text(hjust = 0.5, face = "bold"))) +
  labs(caption = "2025 disorientation data provided by the Miami-Dade County
       Parks Sea Turtle Conservation Program")


miamibeach_map <- (mb_map) +
  labs(title = "Sea turtle disorientations (2025)",
       subtitle = "Miami beach",
       caption = "2025 disorientation data provided by the Miami-Dade County
       Parks Sea Turtle Conservation Program")

north_maps <- (ha_map | gb_map) +
  plot_annotation(title = "Sea turtle disorientations (2025)",
    theme = theme(plot.title = element_text(hjust = 0.5, face = "bold"))) +
  labs(caption = "2025 disorientation data provided by the Miami-Dade County
       Parks Sea Turtle Conservation Program")

south_maps
miamibeach_map
north_maps

#Save your plot

ggsave(filename = "results/img/p_kb.png",
  plot   = p_kb,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/p_mb.png",
  plot   = p_mb,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/dp_ha.png",
  plot   = p_ha,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/p_fi.png",
  plot   = p_fi,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/p_gb.png",
  plot   = p_bg,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/disshp_patchwork.png",
  plot   = combined_maps,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/southmaps_patchwork.png",
  plot   = south_maps,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/miamibeach.png",
  plot   = miamibeach_map,
  width  = 11,
  height = 6,
  dpi    = 300)

ggsave(filename = "results/img/northmaps_patchwork.png",
  plot   = north_maps,
  width  = 11,
  height = 6,
  dpi    = 300)

#Future directions: Crop into the sites more. Add polygons for properties relevant
#to disorientation events.
