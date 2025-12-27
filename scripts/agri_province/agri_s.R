# Author: Servet Uluturk
# Analysis: Small sized mammal species diversity in Agri Province
# Data: data/agri_province/agri_s.xlsx
# Date: (2025.12.26)
# data <- readxl::read_excel("data/agri_province/agri_s.xlsx")
install.packages(c("readxl", "vegan"))
library(readxl)
library(vegan)
agri_s<- read_excel("C:\\Users\\servet.uluturk\\Documents\\agri_2\\data_source\\agri_s.xlsx")
getwd()
agri_s<- as.data.frame(agri_s)
rownames(agri_s) <- agri_s[[1]]   
agri_s<- agri_s[,-1] 
dim(agri_s)    
str(agri_s)
shannon <- diversity(agri_s, index = "shannon")
richness <- specnumber(agri_s)
simpson  <- diversity(agri_s, index = "simpson")
evenness <- shannon / log(richness)
div_res <- data.frame(Lokalite = rownames(agri_s),Richness = richness,Shannon = shannon,Simpson = simpson,Evenness = evenness)
library(vegan)
pooled_abundance <- colSums(agri_s)
H_gamma <- diversity(pooled_abundance, index = "shannon")
H_alpha <- diversity(agri_s, index = "shannon")
H_mean <- mean(H_alpha)
H_sd   <- sd(H_alpha)
H_cv   <- (H_sd / H_mean) * 100
n <- length(H_alpha)
H_se <- H_sd / sqrt(n)
CI_lower <- H_mean - qt(0.975, df = n - 1) * H_se
CI_upper <- H_mean + qt(0.975, df = n - 1) * H_se
cat("Gamma Shannon (H'):", round(H_gamma, 3), "\n")
cat("Alpha Shannon mean ?? SD:", round(H_mean, 3), "??", round(H_sd, 3), "\n")
cat("95% CI:", round(CI_lower, 3), "-", round(CI_upper, 3), "\n")
cat("CV (%):", round(H_cv, 1), "\n")

