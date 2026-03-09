install.packages("tidyverse")
install.packages("sf")
install.packages("ggspatial")
install.packages("maps")

library(tidyverse)
library(sf)
library(ggspatial)
library(maps)

obs_data <- read.csv("D:/Ekoloji/Ecology_Data/Agri_Map.csv")

obs_sf <- st_as_sf(obs_data, coords = c("latitude", "longitude"), 
          crs = 32638) %>% st_transform(crs = 4326)
obs_data_deg <- cbind(obs_data, st_coordinates(obs_sf))
turkiye_map <- st_as_sf(map("world", "Turkey", plot = FALSE, fill = TRUE))

study_area_map <- ggplot() +  geom_sf(data = turkiye_map, fill = "#fdfdfd", color = "gray70", linewidth = 0.5) +
          geom_point(data = obs_data_deg, aes(x = X, y = Y), color = "black", size = 1.2, alpha = 0.7) +
          coord_sf(xlim = c(42.0, 45.0), ylim = c(38.5, 40.5), expand = FALSE) +
          scale_x_continuous(breaks = seq(42, 45, by = 0.5), labels = function(x) paste0(x, "??E")) +
          scale_y_continuous(breaks = seq(38.5, 40.5, by = 0.5), labels = function(y) paste0(y, "??N")) +
          annotation_scale(location = "br", width_hint = 0.3, style = "ticks") +
          annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_minimal()) +
          theme_bw() + theme( panel.grid.major = element_line(color = "gray90", linetype = "dashed", linewidth = 0.2),
          axis.text = element_text(color = "black", size = 10), axis.title = element_blank(),
          panel.border = element_rect(colour = "black", fill = NA, 
          linewidth = 1.5))
print(study_area_map)

sf::sf_use_s2(FALSE)

library(tidyverse)
library(sf)
library(ggspatial)
library(maps)
library(magrittr)


obs_data <- read.csv("D:/Ekoloji/Ecology_Data/Agri_Map.csv")
obs_sf <- st_as_sf(obs_data, coords = c("latitude", "longitude"), 
          crs = 32638) %>% st_transform(4326)
obs_data_deg <- cbind(obs_data, st_coordinates(obs_sf))

gol_url <- "https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_lakes.geojson"
        dogu_golleri <- read_sf(gol_url) %>% st_make_valid() %>% 
        st_crop(xmin = 42, xmax = 45, ymin = 38, ymax = 41)
final_map <- ggplot() + borders("world", regions = "Turkey", fill = "#f9f9f9", colour = "gray80") +
        geom_sf(data = dogu_golleri, fill = "skyblue1", color = "deepskyblue3", size = 0.3) +
        geom_point(data = obs_data_deg, aes(x = X, y = Y), color = "black", size = 1.5, alpha = 0.8) +
        coord_sf(xlim = c(42.1, 44.9), ylim = c(38.2, 40.3), expand = FALSE) + 
        scale_x_continuous(breaks = seq(42.5, 44.5, by = 0.5), labels = function(x) paste0(x, "\u00b0E")) +
        scale_y_continuous(breaks = seq(38.5, 40.0, by = 0.5), labels = function(y) paste0(y, "\u00b0N")) +
        annotation_scale(location = "br", width_hint = 0.3) + annotation_north_arrow(location = "tr", 
        style = north_arrow_minimal()) + theme_bw() + theme(panel.grid = element_blank(), 
        axis.title = element_blank())
print(final_map)
final_plot <- last_plot()
ggsave( filename = "D:/Ekoloji/Ecology_Data/Agri_Map.tiff", 
       plot = final_plot, device = "tiff", dpi = 600, width = 18, height = 12,           
       units = "cm", compression = "lzw")
dev.off()








