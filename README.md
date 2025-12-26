Mammal diversity analyses (Ağrı Province and multi-province comparison)
This repository contains data and R scripts used to analyse mammal diversity patterns in Türkiye, focusing on a Ağrı Province, and a comparison across nine provinces. Analyses include diversity metrics Shannon, Simpson, Richness, Occupancy, SD,CI and CV for Ağrı Province, and community similarity (Jaccard), ordination (NMDS), and clustering, bootstrap CI for comparing sites applied to different mammal size groups.
Repository structure
mammal-diversity-jaccard-nmds/
├── data/
│ ├── agri_province/
│ │ ├── agri_a.xlsx
│ │ ├── agri_lm.xlsx
│ │ └── agri_s.xlsx
│ └── comparison_sites/
│ ├── comp_a.xlsx
│ ├── comp_lm.xlsx
│ └── comp_s.xlsx
├── scripts/
│ ├── agri_province/
│ │ ├── agri_a.R
│ │ ├── agri_lm.R
│ │ └── agri_s.R
│ └── comparison_sites/
│ ├── comp_a.R
│ ├── comp_lm.R
│ └── comp_s.R
└── README.md
All analysis scripts used in the study are located under the scripts/ directory. Any similarly named files or nested folders outside this structure are deprecated and not used.
Data description
All datasets are provided as Excel files (.xlsx). Each file contains a species-by-site matrix used by the corresponding R script.
Single province (Ağrı)
•	agri_a.xlsx: all mammal species
•	agri_lm.xlsx: large and medium-sized mammals
•	agri_s.xlsx: small mammals
Multi-province comparison (nine provinces)
•	comp_a.xlsx: all mammal species
•	comp_lm.xlsx: large and medium-sized mammals
•	comp_s.xlsx: small mammals
Each Excel file contains a single worksheet.
Scripts
Scripts are organised by analysis scope and species group:
scripts/agri_province/
Analyses for the single-province dataset (Ağrı Province), calculating diversity metrics such as Shannon diversity, CI, CV, and SD.
scripts/comparison_sites/
Analyses comparing mammal assemblages across nine provinces, including Jaccard similarity, NMDS ordination, and cluster analysis.
Each script explicitly states the data file it uses and can be run independently.
Software and packages
Analyses were conducted in R Studio from posit. Version 2025.09.2+418. Required packages are loaded within each script (e.g. readxl, vegan, ggplot2). Reproducibility
To reproduce the analyses:
1.	Clone or download this repository.
2.	Open R and set the working directory to the repository root.
3.	Run the desired script from the scripts/ directory.
All data paths in the scripts are relative to the repository root.

Citation and data availability
This repository accompanies a manuscript submitted to a journal. Upon publication, the repository will be archived in a public repository and assigned a DOI.

Author
Servet Uluturk

