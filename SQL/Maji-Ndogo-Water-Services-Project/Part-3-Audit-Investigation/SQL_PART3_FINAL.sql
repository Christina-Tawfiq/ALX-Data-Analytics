/*
  Maji Ndogo Water Services - Part 3
  Auditor comparison and data-integrity investigation
  Corrected and documented version

  The auditor_report data dictionary states that the auditor re-visited
  a randomly selected subset of 1,620 records to re-record quality scores.
*/

-- ============================================================
-- MAJI NDOGO WATER SERVICES
-- Database Schema: md_water_services
-- ============================================================
USE md_water_services;

-- ============================================================
-- 1. Compare auditor and surveyor scores
-- Goal: Compare the auditor's water quality scores with the
-- surveyors' scores for the first visit to each location.
-- ============================================================

SELECT
ar.location_id,
v.record_id,
ar.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
FROM auditor_report AS ar
JOIN visits AS v
ON ar.location_id = v.location_id
JOIN water_quality AS wq
ON v.record_id = wq.record_id
WHERE ar.true_water_source_score = wq.subjective_quality_score
AND v.visit_count = 1;


-- ============================================================
-- 2. Investigate score mismatches
-- Goal: Identify records where the auditor and surveyor scores
-- differ and compare the recorded water-source types.
-- ============================================================

SELECT
ar.location_id,
v.record_id,
ar.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score,
ws.type_of_water_source AS survey_source,
ar.type_of_water_source AS auditor_source
FROM auditor_report AS ar
JOIN visits AS v
ON ar.location_id = v.location_id
JOIN water_quality AS wq
ON v.record_id = wq.record_id
JOIN water_source AS ws
ON v.source_id = ws.source_id
WHERE ar.true_water_source_score != wq.subjective_quality_score
AND v.visit_count = 1;


-- ============================================================
-- 3. Create a view for incorrect water quality records
-- Goal: Store the mismatched records together with the employee
-- responsible for the visit and the auditor's statements so they
-- can be investigated further.
-- ============================================================

CREATE OR REPLACE VIEW Incorrect_records AS (
SELECT
ar.location_id,
v.record_id,
ar.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score,
v.assigned_employee_id,
em.employee_name,
ar.statements
FROM auditor_report AS ar
JOIN visits AS v
ON ar.location_id = v.location_id
JOIN water_quality AS wq
ON v.record_id = wq.record_id
JOIN employee AS em
ON em.assigned_employee_id = v.assigned_employee_id
WHERE ar.true_water_source_score != wq.subjective_quality_score
AND v.visit_count = 1
);


-- Goal: Review the incorrect records stored in the view.

SELECT *
FROM Incorrect_records;


-- ============================================================
-- 4. Count mistakes per employee
-- Goal: Count the number of incorrect water quality records
-- associated with each employee.
-- ============================================================

WITH error_count AS (
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM Incorrect_records
GROUP BY employee_name
),


-- ============================================================
-- 5. Calculate the average number of mistakes
-- Goal: Calculate the average number of mistakes among employees
-- appearing in the incorrect records.
-- ============================================================

avg_error_count_per_empl AS (
SELECT
AVG(number_of_mistakes) AS avg_number_of_mistakes
FROM error_count
),


-- ============================================================
-- 6. Identify employees with above-average mistakes
-- Goal: Identify employees whose number of incorrect records is
-- higher than the average for further investigation.
-- ============================================================
 
suspect_list AS (
SELECT
employee_name,
number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (
SELECT
avg_number_of_mistakes
FROM avg_error_count_per_empl
)
)


-- ============================================================
-- 7. Review auditor statements
-- Goal: Review statements associated with employees who have an
-- above-average number of incorrect records and check for references
-- to cash that may require further investigation.
-- ============================================================

SELECT
employee_name,
location_id,
statements
FROM Incorrect_records
WHERE employee_name IN (
SELECT
employee_name
FROM suspect_list
)
AND statements LIKE '%cash%';