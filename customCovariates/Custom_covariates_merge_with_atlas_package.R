library(PatientLevelPrediction)
library(FeatureExtraction)
createCustomCovariateSettings <- function(useCustomCov =TRUE) {
  covariateSettings <- list(useCustomCov = useCustomCov)
  attr(covariateSettings, "fun") <- "getDbCustomCovariateData"
  class(covariateSettings) <- "covariateSettings"
  return(covariateSettings)
}


getDbCustomCovariateData <- function(connection,
                                     oracleTempSchema = NULL,
                                     cdmDatabaseSchema,
                                     cohortTable = schema_cohortTable,
                                     cohortId = -1,
                                     cdmVersion = "CDMVersion", # Set CDM Version
                                     rowIdField = rowIdField,
                                     covariateSettings,
                                     aggregated = FALSE) {
  writeLines("Constructing custom covariates")
  if (covariateSettings$useCustomCov == FALSE) {
    return(NULL)
  }
  if (aggregated)
    stop("Aggregation not supported")

  sql <-SqlRender::readSql ('PathToFolder')    #change folder
  print(cohortTable)
  print(cohortId)
  print(rowIdField)
  print(cdmDatabaseSchema)
  print(connection)
  
  
  
  sql <- SqlRender::render(sql,
                           cohort_table = cohortTable,
                           cohort_id = cohortId,
                           row_id_field = rowIdField,
                           cdm_database_schema = cdmDatabaseSchema)
  sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))
  # Retrieve the covariate:
  covariates <- DatabaseConnector::querySql(connection, sql, snakeCaseToCamelCase = TRUE)

  covariateRef <-read.csv('PathToCovariateRefs')      #change folder
  

  analysisRef <- read.csv('pathToAnalysisReg')        #change folder
  
  # Construct analysis reference:
  metaData <- list(sql = sql, call = match.call())
  result <- Andromeda::andromeda(covariates = covariates,
                                 covariateRef = covariateRef,
                                 analysisRef = analysisRef)
  attr(result, "metaData") <- metaData
  class(result) <- "CovariateData"
  return(result)
}




origCreatePlpModelSettings <- PatientLevelPrediction::createPlpModelSettings

newCreatePlpModelSettings <- function(modelList, 
                                      covariateSettingList, 
                                      populationSettingList){
  writeLines("Adding custom covariate settings!")
  
  customCovSet <- createCustomCovariateSettings(useCustomCov = TRUE)
  for(i in 1:length(covariateSettingList)
  ){
    covariateSettingList[[i]] <- list(covariateSettingList[[i]], customCovSet)

  }
  
  return(origCreatePlpModelSettings(modelList, covariateSettingList, populationSettingList))
}

assignInNamespace("createPlpModelSettings", newCreatePlpModelSettings, ns="PatientLevelPrediction")