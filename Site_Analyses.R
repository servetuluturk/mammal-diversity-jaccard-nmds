install.packages("vegan")
install.packages("betapart")

library(vegan)
library(betapart)

data <- read.csv("D:/MDPI_Agri/Region_Analyses/Sites_Data/Sites_Data.csv", header=TRUE)
env_data <- data[,1:2]     
species <- data[,-c(1,2)]  
env_data$Group <- as.factor(env_data$Group)
rownames(species) <- env_data$Site

beta <- beta.pair(species, index.family="jaccard")
mean(beta$beta.jac)
mean(beta$beta.jtu)
mean(beta$beta.jne)
mean(beta$beta.jtu) / mean(beta$beta.jac)

adonis2(species ~ Group,data=env_data,method="jaccard",permutations=999)
disp <- betadisper(vegdist(species, method="jaccard"), env_data$Group)
anova(disp)

library(vegan)
nmds <- metaMDS(species, distance="jaccard", k=2)
site_scores <- scores(nmds, display="sites")
nrow(site_scores)
scores_df <- as.data.frame(site_scores)
scores_df$Group <- env_data$Group
scores_df$Site  <- env_data$Site
head(scores_df)

install.packages("ggrepel")
install.packages("ggplot2")

library(ggrepel)
library(ggplot2)

ggplot(scores_df, aes(NMDS1, NMDS2, color=Group)) + geom_point(size=4) +
       geom_text_repel(aes(label=Site), size=4, max.overlaps=100) + stat_ellipse(level=0.95, linewidth=1) +
       theme_classic(base_size=15) + labs(title="NMDS of Mammalian Assemblages",
       subtitle=paste("Stress =", round(nmds$stress,3)))
p_nmds <- ggplot(scores_df, aes(NMDS1, NMDS2, color=Group)) + geom_point(size=4) +
         geom_text_repel(aes(label=Site), size=4, max.overlaps=100) + stat_ellipse(level=0.95, linewidth=1) +
         theme_classic(base_size=15) + labs(title="NMDS of Mammalian Assemblages",
         subtitle=paste("Stress =", round(nmds$stress,3))) + theme(legend.position = "bottom", 
         plot.title = element_text(hjust = 0.5, face="bold"))
ggsave("D:/MDPI_Agri/Region_Analyses/Sites_Figure/NMDS.tiff", plot = p_nmds, device = "tiff", 
       width = 10, height = 8, units = "in", dpi = 300, compression = "lzw")
dev.off()
ggsave("D:/MDPI_Agri/Region_Analyses/Sites_Figure/NMDS.pdf", 
       plot = p_nmds, width = 10, height = 8)

install.packages("sf")
install.packages("elevatr")

library(elevatr)
library(sf)

Province_list <- rownames(species)

coords <- data.frame(city = Province_list,lon = c(43.05, 40.49, 43.38, 41.13, 42.10, 
       43.09, 41.84, 34.67, 35.15, 31.50, 27.14, 28.30, 27.35, 32.85, 33.61,31.91, 
       31.41, 31.79, 32.06, 33.22, 28.98, 27.48, 28.73)[1:length(Province_list)], 
       lat = c(39.72, 38.88, 38.50, 37.88, 38.40, 40.60, 41.18, 40.55, 41.42, 41.13, 
       38.42, 37.03, 36.55, 40.10, 40.60, 41.25, 40.73, 40.33, 41.20, 40.45, 41.01, 
       41.73, 37.13)[1:length(Province_list)])

Province_proj <- "+proj=longlat +datum=WGS84"
points_sf <- st_as_sf(coords, coords = c("lon", "lat"), crs = Province_proj)

elevation_data <- get_elev_point(points_sf, prj = Province_proj, src = "aws")
group_factor_clean <- as.factor(data$Group)
env_data <- data.frame(Elevation = elevation_data$elevation, 
          group = group_factor_clean)
rownames(env_data) <- Province_list

install.packages("elevatr")
install.packages("raster")

library(elevatr)
library(raster)

dem_area <- get_elev_raster(points_sf, z = 7, clip = "bbox")
slope_map <- terrain(dem_area, opt = "slope", unit = "degrees")
env_data$Slope <- extract(slope_map, points_sf)

print(env_data[is.na(env_data$Slope), ])
env_data$Slope[is.na(env_data$Slope)] <- mean(env_data$Slope, na.rm = TRUE)
env_data$Elevation[is.na(env_data$Elevation)] <- mean(env_data$Elevation,
                                                      na.rm = TRUE)


install.packages("ggrepel")
library(ggplot2)
library(ggrepel)
library(vegan)

site_scores <- as.data.frame(scores(cca_full, display = "sites"))
site_scores$City <- rownames(site_scores)
site_scores$Group <- env_data$group

species_scores <- as.data.frame(scores(cca_full, display = "species"))

vector_scores <- as.data.frame(scores(cca_full, display = "bp"))
vector_scores$Variable <- rownames(vector_scores)

ggplot() + geom_point(data = species_scores, aes(x = CCA1, y = CCA2), 
           shape = 3, color = "grey80", size = 1) + geom_segment(data = vector_scores, 
           aes(x = 0, y = 0, xend = CCA1*2, yend = CCA2*2), arrow = arrow(length = unit(0.2, "cm")), 
           color = "darkgreen", size = 0.8) + geom_text_repel(data = vector_scores, 
           aes(x = CCA1*2, y = CCA2*2, label = Variable),color = "darkgreen", 
           fontface = "bold", size = 5) + geom_point(data = site_scores, 
           aes(x = CCA1, y = CCA2, color = Group, shape = Group), size = 4) + 
           geom_text_repel(data = site_scores, aes(x = CCA1, y = CCA2, label = City), 
           size = 3.5, box.padding = 0.5, point.padding = 0.3) + scale_color_manual(values = c("East" = "#d95f02", 
           "West" = "#1f78b4")) + theme_minimal() + labs(title = "Mammal Community Composition & Anatolian Diagonal", 
           subtitle = paste0("PERMANOVA p = 0.005 | Elevation/Slope Controlled"),x = "CCA1 (8.8%)", y = "CCA2 (8.2%)") + 
           theme(legend.position = "right", panel.border = element_rect(color = "black", 
                                                               fill= NA))
ggsave("D:/MDPI_Agri/Region_Analyses/Sites_Figure/CCA.pdf", plot = last_plot(), width = 20, 
       height = 15, units = "cm", dpi = 300)
ggsave("D:/MDPI_Agri/Region_Analyses/Sites_Figure/CCA.tiff", plot = last_plot(), width = 20, 
       height = 15, units = "cm", dpi = 300)
dev.off()


install.packages("betapart")
library(betapart)

species_mat_clean <- as.matrix(data)
mode(species_mat_clean) <- "numeric"
species_mat_clean[is.na(species_mat_clean)] <- 0
species_mat_clean[species_mat_clean > 0] <- 1
library(betapart)
beta_comp <- beta.pair(species_mat_clean, index.family = "jaccard")

jtu <- mean(beta_comp$beta.jtu)
jne <- mean(beta_comp$beta.jne)
jac <- mean(beta_comp$beta.jac)


cat("Turnover (JTU):", jtu, "\nNestedness (JNE):", jne, "\nTotal Jaccard (JAC):", jac)

beta_comp <- beta.pair(species_mat_clean, index.family = "jaccard")
m_turnover <- mean(beta_comp$beta.jtu)
m_nestedness <- mean(beta_comp$beta.jne)

beta_df <- data.frame(Component = factor(c("Turnover (Jtu)", "Nestedness (Jne)")),
           Value = c(m_turnover, m_nestedness), Percent = c((m_turnover/(m_turnover+m_nestedness))*100,
           (m_nestedness/(m_turnover+m_nestedness))*100))

fig_beta <- ggplot(beta_df, aes(x = "", y = Value, fill = Component)) +
            geom_bar(stat = "identity", width = 0.6, color = "white") +
            geom_text(aes(label = paste0(round(Percent,1), "%")),
            position = position_stack(vjust = 0.5),
            fontface = "bold", size = 5, color = "white") +
            scale_fill_manual(values = c("Turnover (Jtu)" = "#1b9e77",
                               "Nestedness (Jne)" = "#d95f02")) +
            theme_minimal() +
            labs(y = "Mean Dissimilarity (Jaccard)",
            x = "",
            title = "Beta Diversity Partitioning (Jaccard Index)") +
            theme(plot.title = element_text(face = "bold", size = 14))
print(fig_beta)
ggsave ("D:/MDPI_Agri/Region_Analyses/Sites_Figure/Beta_Partitioning.pdf", 
       plot = fig_beta, width = 18, height = 8, units = "cm", dpi = 300)
ggsave("D:/MDPI_Agri/Region_Analyses/Sites_Figure/Beta_Partitioning.tiff", 
       plot = fig_beta, width = 18, height = 8, units = "cm", dpi = 300)
dev.off()


data <- read.csv("D:/MDPI_Agri/Region_Analyses/Sites_Data/Sites_Data.csv", header = TRUE)
head(data)
str(data)
comm_matrix <- as.matrix(data[, -c(1,2)])

library(vegan)

nodf_result <- nestednodf(comm_matrix, order = TRUE)
nodf_result


nodf_result$statistic["NODF"]

east_matrix <- as.matrix(data[data$Group == "East", -c(1,2)])
west_matrix <- as.matrix(data[data$Group == "West", -c(1,2)])

nestednodf(east_matrix)
nestednodf(west_matrix)


library(vegan)

nestednodf(comm_matrix, order = TRUE, weighted = FALSE)

