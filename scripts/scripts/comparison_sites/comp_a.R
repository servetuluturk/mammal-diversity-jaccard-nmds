# Author: Servet Uluturk
# Analysis: All mammal species diversity in Comparison Sites
# Data: data/comparison_sites/comp_a.xlsx
# Date: (2025.12.26)
# data <- readxl::read_excel("data//comparison_sites/comp_a.xlsx")
library(readxl)
library(vegan)
comp_a_df <- as.data.frame(comp_a)
rownames(comp_a_df) <- comp_a_df[,1]
comp_a_df <- comp_a_df[,-1]
str(comp_a_df)
species_richness <- rowSums(comp_a_df)
species_richness
dist_jaccard <- vegdist(comp_a_df, method = "jaccard", binary = TRUE)
nmds <- metaMDS(comp_a_df,distance = "jaccard",binary = TRUE,k = 2,trymax = 100)
plot(nmds, type = "t")
hc <- hclust(dist_jaccard, method = "average")
plot(hc, main = "iller Arasi Tur Kompozisyonu (Jaccard)")
species_freq <- colSums(comp_a_df)
sort(species_freq, decreasing = TRUE)[1:10]
library(vegan)
set.seed(123)  
nmds <- metaMDS(
  comp_a_df,
  distance = "jaccard",
  binary = TRUE,
  k = 2,
  trymax = 100
)
nmds$stress
plot(nmds, type = "t")
plot(nmds, type = "n")
points(nmds, pch = 21, bg = "lightblue", cex = 1.5)
text(nmds, labels = rownames(comp_a_df), cex = 0.9, pos = 3)
png("NMDS_iller.png", width = 800, height = 600)
plot(nmds, type = "n")
points(nmds, pch = 21, bg = "lightblue", cex = 1.5)
text(nmds, labels = rownames(comp_a_df), cex = 0.9, pos = 3)
dev.off()
library(vegan)
jaccard_dist <- vegdist(comp_a_df,
                        method = "jaccard",
                        binary = TRUE)
jaccard_mat <- as.matrix(jaccard_dist)
jaccard_df <- as.data.frame(jaccard_mat)
