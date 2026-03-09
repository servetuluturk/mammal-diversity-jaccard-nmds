install.packages("tidyverse")
install.packages("tidygeocoder")
install.packages("sf")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("ggspatial")
install.packages("ggplot2")

library(tidyverse)
library(tidygeocoder)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggspatial)
library(ggplot2)

df<-read.csv("D:/MDPI_Agri/Region_Analyses/Sites_Data/Sites_Map.csv",stringsAsFactors=FALSE)
df <- read.csv("D:/MDPI_Agri/Region_Analyses/Sites_Data/Sites_Map.csv", stringsAsFactors = FALSE, 
               fileEncoding = "latin1")
df$Site <- iconv(df$Site, from = "latin1", to = "ASCII//TRANSLIT")
df$Location <- iconv(df$Location, from = "latin1", to = "ASCII//TRANSLIT")
df_geo <- df %>% geocode(city = Site, country = Location, method = 'osm')

df_geo <- df_geo %>% mutate(lat = case_when(Site == "Bingol" ~ 38.88,Site == "Igdir" ~ 39.92,
          TRUE ~ lat),long = case_when(Site == "Bingol" ~ 40.50, 
          Site == "Igdir" ~ 44.04,TRUE ~ long))

turkiye <- ne_countries(scale = "medium", country = "turkey", returnclass = "sf")
df_geo$lat[df_geo$Site == "Agri"] <- 39.723
df_geo$long[df_geo$Site == "Agri"] <- 43.069

df_geo$lat[is.na(df_geo$lat)] <- 39.70
df_geo$long[is.na(df_geo$long)] <- 26.85
sum(is.na(df_geo$lat))

final_map <- ggplot(data = turkiye) + geom_sf(fill = "#fdfdfd", color = "gray60", linewidth = 0.2) + 
  geom_point(data = df_geo,aes(x = long, y = lat, fill = Group, shape = Group), 
  size = 4, color = "black", stroke = 0.8) +
  scale_fill_manual(values = c("East" = "red3", "West" = "dodgerblue4", "This_Study" = "yellow")) +
  scale_shape_manual(values = c("East" = 22, "West" = 22, "This_Study" = 24)) + 
  annotate("segment", x = 35.8, xend = 41.5, y = 36.4, yend = 41.5, linewidth = 1.2, color = "black") +
  coord_sf(xlim = c(26, 45), ylim = c(35.5, 42.5), expand = FALSE) +
  annotation_north_arrow(location = "tr", which_north = "true",style = north_arrow_minimal(line_col = "black")) +
  annotation_scale(location = "br", width_hint = 0.2, style = "ticks") +
  theme_bw() + theme(panel.grid.major = element_line(color = "gray90", linetype = "dashed", linewidth = 0.2),
                     axis.text = element_text(color = "black", size = 10), axis.title = element_blank(),
                     legend.position = "bottom",legend.title = element_blank(),legend.box.background = element_rect(colour = "black", linewidth = 0.5), # Lejant etraf??na ince kutu
                     panel.border=element_rect(colour="black",fill=NA,linewidth=1.2))
print(final_map)
ggsave(filename ="Turkey_Map.tiff",plot=final_map,device="pdf",dpi=600,             
       width = 20, height = 12, units = "cm", compression = "lzw")
ggsave(filename ="Turkey_Map.tiff",plot=final_map,device="tiff",dpi=600,             
       width = 20, height = 12, units = "cm", compression = "lzw")
dev.off()
getwd()
