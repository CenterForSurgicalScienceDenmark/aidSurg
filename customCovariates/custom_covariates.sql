--ALCOHOL CONSUMPTION GROUPPED
select * from(
SELECT DISTINCT (row_id),
CASE
WHEN value_as_number is null then -11
END AS covariate_id,
1 AS covariate_value
FROM @cohort_table c
LEFT JOIN @cdm_database_schema.measurement
ON c.subject_id = measurement.person_id
AND cohort_start_date >= measurement_date
AND measurement_concept_id IN (2147483463) 
AND provider_id = 1 
{@cohort_id != -1 } ? {WHERE cohort_definition_id = @cohort_id}
) df_ac  where covariate_id is not null


--------------------------------------------------------------------------------

UNION
-- ASA SCORE GROUPPED
select * from(
SELECT DISTINCT (row_id),
CASE
WHEN value_as_number is null then -21
END AS covariate_id,
1 AS covariate_value
FROM @cohort_table c
LEFT JOIN @cdm_database_schema.measurement
ON c.subject_id = measurement.person_id
AND cohort_start_date >= measurement_date
AND measurement_concept_id IN (4159411) 
AND provider_id = 1
{@cohort_id != -1 } ? {WHERE cohort_definition_id = @cohort_id}
) df_asa  where covariate_id is not null

--------------------------------------------------------------------------------

--BMI GROUPPED
--NOTE: THIS SHOULD BE REVIWED IF > 1 measurement per person per concept is met in data
UNION
select DISTINCT (row_id),
CASE
WHEN ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) <= 18.5 THEN -31
WHEN ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) > 18.5 AND ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) <= 25 THEN -32
WHEN ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) >25 AND ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) <=30 THEN -33
WHEN ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) >30 AND ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) <= 35 THEN -34
WHEN ROUND((m1.value_as_number*10000) /(m2.value_as_number*m2.value_as_number),2) > 35 THEN -35
ELSE -36
END AS covariate_id,
1 AS covariate_value
FROM @cohort_table c
LEFT JOIN @cdm_database_schema.measurement m1
ON c.subject_id = m1.person_id
AND m1.measurement_concept_id IN (3025315)
AND m1.provider_id = 1
AND cohort_start_date >= m1.measurement_date
left JOIN @cdm_database_schema.measurement m2
ON c.subject_id = m2.person_id
AND m2.measurement_concept_id IN (3036277) 
AND m2.provider_id = 1
AND cohort_start_date >= m2.measurement_date
{@cohort_id != -1 } ? {WHERE cohort_definition_id = @cohort_id}

--------------------------------------------------------------------------------

--Smoking
UNION
SELECT  DISTINCT (row_id),
CASE
WHEN observation_concept_id = 4298794 THEN -81
WHEN observation_concept_id = 4092281 THEN -82
WHEN observation_concept_id = 4144272 THEN -83
ELSE -84
END AS covariate_id,
1 AS covariate_value

FROM @cohort_table c
LEFT JOIN @cdm_database_schema.observation as o
ON c.subject_id = o.person_id
AND c.cohort_start_date >= o.observation_date
AND o.observation_concept_id IN (4092281, 4144272, 4298794) 
AND provider_id = 1 
{@cohort_id != -1 } ? {WHERE cohort_definition_id = @cohort_id}

--------------------------------------------------------------------------------


--WHO PERFORMANCE STATUS
UNION
select * from(
SELECT DISTINCT (row_id),
       CASE
       WHEN value_as_number is null then -41
       END AS covariate_id,
       1 AS covariate_value
FROM @cohort_table c
  LEFT JOIN @cdm_database_schema.measurement
          ON c.subject_id = measurement.person_id
         AND cohort_start_date >= measurement_date
         AND measurement_concept_id IN (4162588) 
         AND provider_id = 1
         AND value_as_number IS NOT NULL
               {@cohort_id != -1 } ? {WHERE cohort_definition_id = @cohort_id}
) df_who  where covariate_id is not null

--------------------------------------------------------------------------------


--  Clinical T
UNION
select row_id, covariate_id, covariate_value from(
select ROW_NUMBER() OVER (partition BY subject_id) AS s_id, row_id, covariate_id, covariate_value from (
SELECT DISTINCT (row_id),
CASE
WHEN (condition_source_concept_id = 2000041002) OR (condition_source_concept_id = 2000041003) OR (condition_source_concept_id = 2000073002) OR (condition_source_concept_id =  2000073003) OR (condition_source_concept_id = 2000076002) OR (condition_source_concept_id = 2000041004) OR (condition_source_concept_id = 2000073004) OR (condition_source_concept_id = 2000076003) THEN -51
WHEN (condition_source_concept_id = 2000041005) OR (condition_source_concept_id = 2000073005) OR (condition_source_concept_id = 2000076004) OR (condition_source_concept_id = 2000041006) OR (condition_source_concept_id = 2000076005) THEN -52
WHEN (condition_source_concept_id = 2000041007) OR (condition_source_concept_id = 2000073006) THEN -53
ELSE -54
END AS covariate_id, 
1 AS covariate_value, subject_id 
FROM @cohort_table c
LEFT JOIN @cdm_database_schema.condition_occurrence p
ON c.subject_id = p.person_id
AND condition_source_concept_id in (2000041002, 2000041003, 2000073002, 2000073003, 2000076002, 2000041004, 2000073004, 2000076003, 2000041005, 2000073005, 2000076004, 2000041006, 2000076005, 2000041007, 2000073006)
AND provider_id = 1
AND cohort_start_date >= p.condition_start_date
{@cohort_id != -1 } ? {WHERE cohort_definition_id = @cohort_id}
)df)df2 where s_id = 1


--------------------------------------------------------------------------------

-- Clinical M
UNION
SELECT DISTINCT (row_id),
CASE
WHEN condition_source_concept_id = 2000047001 THEN -71
WHEN condition_source_concept_id = 2000047002 THEN -72
WHEN condition_source_concept_id = 2000047003 THEN -73
ELSE -74
END AS covariate_id,
1 AS covariate_value
FROM @cohort_table c
left JOIN @cdm_database_schema.condition_occurrence p
ON c.subject_id = p.person_id
AND condition_source_concept_id in (2000047001, 2000047002, 2000047003)
AND provider_id = 1
AND cohort_start_date >= p.condition_start_date
{@cohort_id != -1 } ? {WHERE cohort_definition_id = @cohort_id}

--------------------------------------------------------------------------------

