# Author: Servet Uluturk
# Analysis: Large and medium sized mammal species diversity in Agri Province
# Data: data/agri_province/agri_lm.xlsx
# Date: (2025.12.26)
# data <- readxl::read_excel("data/agri_province/agri_lm.xlsx")
install.packages(c("readxl", "vegan"))
library(readxl)
library(vegan)
agri_lm<- read_excel("C:\\Users\\servet.uluturk\\Documents\\agri_2\\data_source\\agri_lm.xlsx")
getwd()
agri_lm<- as.data.frame(agri_lm)
rownames(agri_lm) <- agri_lm[[1]]   
agri_lm<- agri_lm[,-1] 
dim(agri_lm)    
str(agri_lm)
shannon <- diversity(agri_lm, index = "shannon")
richness <- specnumber(agri_lm)
simpson  <- diversity(agri_lm, index = "simpson")
evenness <- shannon / log(richness)
div_res <- data.frame(Lokalite = rownames(agri_lm),Richness = richness,Shannon = shannon,Simpson = simpson,Evenness = evenness)
library(vegan)
pooled_abundance <- colSums(agri_lm)
H_gamma <- diversity(pooled_abundance, index = "shannon")
H_alpha <- diversity(agri_lm, index = "shannon")
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

