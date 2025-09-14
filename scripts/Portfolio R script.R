library(EVR628tools)
library(ggplot2)
create_dirs()

#Plot
milton <- data_milton
miltonplot<- ggplot(milton, aes(x = lon,
                   y = lat,
                   color = wind_speed)) +
  geom_point(size = 3) +
  scale_color_viridis_c() +
  labs(title = "Hurricane Milton: Wind Speed by Location",
       x = "Longitude",
       y = "Latitude") +
  theme_minimal()

#Plot name
miltonplot

#Save plot as image
ggsave("results/img/milton_plot.png", plot = miltonplot)

