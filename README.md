Mammal diversity analyses (Ağrı Province and multi-province comparison)
This repository contains data and R scripts used to analyse mammal diversity patterns in Türkiye, focusing on a Ağrı Province, and a comparison across fourteen provinces. Analyses include diversity metrics Shannon, Simpson, Richness, Occupancy, SD,CI and CV for Ağrı Province, and community similarity (Jaccard), ordination (NMDS), and clustering, bootstrap CI for comparing sites applied to different mammal size groups.
Repository structure
mammal-diversity-jaccard-nmds/
├── data/
│ ├── agri_province/
│ │ ├── Agri_Data.csv
│ │ ├── Agri_Map.csv
│ └── comparison_sites/
│ ├── Site_Data.csv
│ ├── Site_Map.csv
├── scripts/
│ ├── agri_province/
│ │ ├── Agri_Data.R
│ │ ├── Agri_Map.R
│ └── comparison_sites/
│ ├── Site_Analyses.R
│ ├── Site_Map.R
└── README.md
All analysis scripts used in the study are located under the scripts/ directory. Any similarly named files or nested folders outside this structure are deprecated and not used.
Data description
All datasets are provided as Excel files (.xlsx). Each file contains a species-by-site matrix used by the corresponding R script.
Single province (Ağrı)
•	Agri_Data.csv
•	Agri_Map.csv
•	Agri_Map.R
•	Agri_Data.R
Multi-province comparison (15 provinces)
•	Site_Data.csv 
•	Site_Analyses.R
•	Site_Map.csv
•	Site_Map.R
Each Excel file contains a single worksheet.
Analyses for the single-province dataset (Ağrı Province), calculating diversity metrics such as Shannon diversity, CI, CV, and SD.
scripts/comparison_sites/
Analyses comparing mammal assemblages across fifteen provinces, including Jaccard similarity, NMDS ordination, and cluster analysis.
Each script explicitly states the data file it uses and can be run independently.
Software and packages
Analyses were conducted in Rv.4.5.2 (R Foundation for Statistical Computing, Vienna, Austria). Required packages are loaded within each script (e.g. readxl, vegan, ggplot2). Reproducibility
To reproduce the analyses:
1.	Clone or download this repository.
2.	Open R and set the working directory to the repository root.
3.	Run the desired script from the scripts/ directory.
All data paths in the scripts are relative to the repository root.

Citation and data availability
This repository accompanies a manuscript submitted to a journal. Upon publication, the repository will be archived in a public repository and assigned a DOI.

Author
Servet Uluturk

