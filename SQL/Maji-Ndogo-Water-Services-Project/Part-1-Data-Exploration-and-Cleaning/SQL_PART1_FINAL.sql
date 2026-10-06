/*
  Maji Ndogo Water Services - Part 1
  Data exploration, validation, and cleaning
  Corrected and documented version
*/

-- ============================================================
-- MAJI NDOGO WATER SERVICES
-- Database Schema: md_water_services
-- ============================================================
USE md_water_services;

-- ============================================================
-- 1. Explore the database
-- Goal: Inspect the core survey tables before analysis.
-- ============================================================
SHOW TABLES;

SELECT * FROM location LIMIT 5;
SELECT * FROM visits LIMIT 5;
SELECT * FROM water_source LIMIT 5;
SELECT * FROM well_pollution LIMIT 5;

-- Goal: Identify the water-source categories used by the survey.
SELECT DISTINCT type_of_water_source
FROM water_source
ORDER BY type_of_water_source;

-- ============================================================
-- 2. Investigate queue records and selected sources
-- Goal: Find visits where no queue was recorded.
-- ============================================================
SELECT *
FROM visits
WHERE time_in_queue = 0;

-- Goal: Inspect selected source IDs from the exercise.
SELECT *
FROM water_source
WHERE source_id IN (
    'AkKi00881224', 'SoRu37635224', 'SoRu36096224',
    'AkRu05234224', 'HaZa21742224'
);

-- ============================================================
-- 3. Water-quality checks
-- Goal: Find repeat visits that received the highest subjective score.
-- water_quality links to visits through record_id.
-- ============================================================
SELECT *
FROM water_quality
WHERE subjective_quality_score = 10
  AND visit_count = 2;
  
-- Create a separate table to store the water-quality records
-- that received a perfect score on the second visit.  
CREATE TABLE QUALITY_10_VISIT_2 (
COL1 INT,
COL2 INT,
COL3 INT
);

-- Populate the table with records where the subjective quality
-- score is 10 and the source was assessed for a second visit.
INSERT INTO QUALITY_10_VISIT_2 (
COL1,
COL2,
COL3
)
SELECT
record_id,
subjective_quality_score,
visit_count
FROM water_quality
WHERE subjective_quality_score = 10
AND visit_count = 2;

-- Review the stored records and confirm the resulting dataset.
SELECT DISTINCT *
FROM QUALITY_10_VISIT_2;

-- Goal: Validate biological contamination against a "Clean" result.
SELECT *
FROM well_pollution
WHERE results = 'Clean'
  AND biological > 0.01;

-- Goal: Find suspicious descriptions that begin with the word Clean.
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean %';

-- ============================================================
-- 4. Clean contradictory pollution records
-- Goal: Correct descriptions and classifications identified above.
-- Run the validation query before and after these updates.
-- ============================================================
SET SQL_SAFE_UPDATES = 0;

UPDATE well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

-- Important correction: only change rows still labelled Clean.
UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE results = 'Clean'
  AND biological > 0.01;

-- Goal: Confirm that contradictory records no longer remain.
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean %'
   OR (results = 'Clean' AND biological > 0.01);

SET SQL_SAFE_UPDATES = 1;

-- ============================================================
-- 5. Employee exploration
-- Goal: Retrieve information requested in the exercise.
-- ============================================================
SELECT address, employee_name
FROM employee
WHERE employee_name = 'Bello Azibo';

SELECT phone_number, employee_name
FROM employee
WHERE position = 'Micro biologist';

-- Goal: Find the Field Surveyor whose phone contains 86 or 11 and
-- whose LAST NAME starts with A or M.
-- Correction: check the final name component, not any letter in the full name.
SELECT *
FROM employee
WHERE (phone_number LIKE '%86%' OR phone_number LIKE '%11%')
  AND (
      SUBSTRING_INDEX(TRIM(employee_name), ' ', -1) LIKE 'A%'
      OR SUBSTRING_INDEX(TRIM(employee_name), ' ', -1) LIKE 'M%'
  )
  AND position = 'Field Surveyor';

-- ============================================================
-- 6. Find the highest-impact improvable source
-- Goal: Find the selected source serving the most people.
-- Correction: order by number_of_people_served directly. COUNT() per
-- unique source_id does not measure the population served.
-- ============================================================
SELECT *
FROM water_source
WHERE type_of_water_source IN ('well', 'shared_tap', 'river')
ORDER BY number_of_people_served DESC
LIMIT 1;
