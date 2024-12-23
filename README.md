# Aid-Surg
Companion GitHub repo for: **Development, external validation and clinical implementation of an AI-based prediction model based on four national registries in patients undergoing colorectal cancer surgery**

This repository contains custom definitions for covariates ([cohort covariates](http://ohdsi.github.io/FeatureExtraction/articles/CreatingCovariatesBasedOnOtherCohorts.html)), based upon data transformed to the [Observational Medical Outcomes Partnership Common Data Model](https://ohdsi.github.io/CommonDataModel/index.html) and code for custom defined covariatest to develop the prediction model Aid-Surg.

## Custom code
The custom code is organized in two folders:

- cohortCovarriatesSql: Contains cohort definitions used for creating covariates for the prediction model
- customCovariates: Contains custom sql definitions for covariates and code to add the covariates to the PatientLevelPrediction framework

## Packages used
Analyses were performed using R version (v4.2.0), using packages: PatientLevelPrediction (v6.3.6), CohortGenerator (v0.8.1), DatabaseConnector (v6.3.2), SqlRender (v1.17.0), FeatureExtraction (v3.4.0), Andromeda (v0.6.6), reticulate (v1.40.0), survival (v3.4-0), stringr (v1.5.1), tidyverse (v2.0.0), tidymodels (v1.0.0), table1 (v1.4.2), boot (v1.3-28), viridis (v0.6.5), pROC (v.1.18.5), ggpubr (v0.6.0), grid (v4.2.0), gridExtra (v2.3), ggsurvfit (v0.3.1), data.table (v1.16.4), cowplot (v1.1.3), ggcorrplot (v0.1.4), broom (v1.0.6), purrr (v1.0.2), scales (v1.3.0), models (v2.18.1.1), glue v(1.8.0), fitdistrplus (v1.2-1), MASS (v7.3-58.1), lubridate (v1.9.3), zoo (v1.8-12), expm (v0.999-6), rlang (v1.1.4), gtools (v3.9.5).
