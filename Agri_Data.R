install.packages("vegan")
install.packages("tidyverse")

library(vegan)
library(tidyverse)

df <- read.csv("D:/MDPI_Agri/Agri_Analyses/Data_Agri/Agri_data.csv", sep = ",")
head(df)

comm_data <- df %>% group_by(zone, species_name) %>% summarise(Abundance = sum(sample_size), .groups = 'drop') %>%
  pivot_wider(names_from = species_name, values_from = Abundance, values_fill = 0) %>%
  column_to_rownames("zone")
print(comm_data)

richness_val <- S 
shannon_val <- H
simpson_val <- D

S <- specnumber(comm_data)
H <- diversity(comm_data, index = "shannon")
D <- diversity(comm_data, index = "simpson")
alpha_results <- data.frame(Richness = S,Shannon = H,Simpson = D)
print(alpha_results)

tiff("D:/MDPI_Agri/Rarefaction.tiff", width = 18, height = 14, units = 'cm', 
     res = 300, compression = "lzw")
rarecurve(comm_data, step = 1, sample = min(rowSums(comm_data)), 
          col = "blue", lwd = 2, main = "Rarefaction Curve",
          xlab = "Number of Individuals (N)", 
          ylab = "Number of Species (S)")
grid()
dev.off()

pdf("D:/MDPI_Agri/Rarefaction.pdf", width = 7, height = 5.5) 
rarecurve(comm_data, step = 1, sample = min(rowSums(comm_data)), col = "blue", lwd = 2, main = "Rarefaction Curve",
          xlab = "Number of Individuals (N)", ylab = "Number of Species (S)")
grid()
dev.off()

species_density <- df %>% group_by(species_name) %>% summarise(Total_Abundance = sum(sample_size)) %>%
  mutate(Percentage = (Total_Abundance / sum(Total_Abundance)) * 100) %>%
  arrange(desc(Total_Abundance))
print(species_density)

library(ggplot2)
library(dplyr)
library(scales) 

species_density$species_name <- trimws(species_density$species_name)
species_density$species_name <- gsub("_", " ", species_density$species_name)

species_plot_data <- species_density %>% group_by(species_name) %>%
  summarise(Total_Abundance = sum(Total_Abundance)) %>%
  mutate(Percentage = (Total_Abundance / sum(Total_Abundance)) * 100) %>%
  arrange(desc(Total_Abundance))
p <- ggplot(species_plot_data, aes(x = reorder(species_name, Total_Abundance), y = Total_Abundance)) +
  geom_bar(stat = "identity", fill = "steelblue", color = "black", width = 0.7) +
  geom_text(aes(label = paste0(Total_Abundance, " (", round(Percentage, 1), "%)")), 
            hjust = -0.1, size = 3.5, fontface = "bold") + coord_flip() + theme_minimal() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2))) + labs(title = "Species Abundance Distribution",
                                                                  subtitle = "A??r?? Province | Total Individuals: 705", x = "Species Name", y = "Total Number of Individuals") +
  theme( axis.text.y = element_text(face = "italic", size = 11), plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
         plot.subtitle = element_text(hjust = 0.5, size = 11, color = "gray30"), panel.grid.minor = element_blank(),
         panel.grid.major.y = element_blank())
print(p)

ggsave("Figure_Agri_Abundance.tiff", plot = p, device = "tiff", width = 10, height = 7, 
       units = "in", dpi = 300, compression = "lzw")
dev.off()
getwd()

ggsave("Figure_Agri_Abundance.pdf", plot = p, width = 10, height = 7)
getwd()

library(vegan)
rad <- radfit(comm_data)
plot(rad, main="Rank-Abundance Curve (38S)", xlab="Species Rank", ylab="Abundance")
print(rad)

plot(rad, main = "Rank-Abundance Models for Agri Mammals",xlab="Species Rank",
     ylab = "Abundance (log scale)", pch = 19, col = "black")
legend("topright", legend = c("Observed", "Fitted Models"), 
       pch = c(19, NA), lty = c(NA, 1), col = c("black", "red"))

tiff("D:/MDPI_Agri/RAD_Plot.tiff", 
     width = 15, height = 12, units = 'cm', res = 300, compression = "lzw")
plot(rad, main = "Rank-Abundance Models", pch = 19)
dev.off()

tiff("D:/MDPI_Agri/RAD_Plot.pdf", 
     width = 15, height = 12, units = 'cm', res = 300, compression = "lzw")
plot(rad, main = "Rank-Abundance Models", pch = 19)
dev.off()

estimate <- estimateR(comm_data)
print(estimate)

H <- diversity(comm_data, index = "shannon")
S <- specnumber(comm_data)
J <- H / log(S)
print(paste("Pielou's Evenness (J):", round(J, 3)))


