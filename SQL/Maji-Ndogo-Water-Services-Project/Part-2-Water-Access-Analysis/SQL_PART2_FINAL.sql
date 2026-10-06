/*
  Maji Ndogo Water Services - Part 2
  Employee cleanup, geographic analysis, source prioritisation, and queues
  Corrected and documented version
*/

-- ============================================================
-- MAJI NDOGO WATER SERVICES
-- Database Schema: md_water_services
-- ============================================================
USE md_water_services;

-- ============================================================
-- 1. Standardise employee email addresses
-- Goal: Build a consistent government email from employee_name.
-- ============================================================

-- ============================================================
-- TESTING EMAIL STANDARDIZATION SAFELY
-- ============================================================
-- Goal:
-- Before modifying the original employee table, create a test
-- copy and apply the email transformation there first. This
-- allows the update logic to be validated without risking the
-- original employee data.
-- ============================================================

-- Preview the expected email format before making any changes.
SELECT
employee_name,
CONCAT(
LOWER(REPLACE(employee_name, ' ', '.')),
'@ndogowater.gov'
) AS new_email
FROM md_water_services.employee;

-- Create a temporary working copy of the employee table so the
-- update can be tested safely before changing the original data.
CREATE TABLE employee_coby AS
SELECT *
FROM employee;


-- Apply the email standardization to the test copy first.
UPDATE employee_coby
SET email = CONCAT(
LOWER(REPLACE(employee_name, ' ', '.')),
'@ndogowater.gov'
);


-- Validate the results of the test update.
SELECT
employee_name,
email
FROM employee_coby;


-- ============================================================
--  APPLYING THE VERIFIED UPDATE TO THE ORIGINAL TABLE
-- ============================================================
-- Goal:
-- After confirming that the generated email addresses are
-- correct, apply the same transformation to the employee table.
-- ============================================================

UPDATE employee
SET email = CONCAT(
LOWER(REPLACE(employee_name, ' ', '.')),
'@ndogowater.gov'
);


-- Verify the final update in the original table.
SELECT
employee_name,
email
FROM employee;


-- The test copy is no longer required after validation.
DROP TABLE employee_coby;


-- ============================================================
-- 2. Standardise phone numbers
-- Goal: Remove leading/trailing spaces before checking phone length.
-- ============================================================
-- ============================================================
-- CLEANING EMPLOYEE PHONE NUMBERS SAFELY
-- ============================================================
-- Goal:
-- Identify unwanted spaces in employee phone numbers, test the
-- cleaning logic on a copy of the employee table, validate the
-- result, and only then update the original data.
-- ============================================================


-- Step 1: Check the current length of the stored phone numbers.
-- This helps identify the extra character caused by whitespace.
SELECT
phone_number,
LENGTH(phone_number) AS phone_number_length
FROM employee;


-- Step 2: Preview the effect of trimming leading and trailing
-- spaces without changing the original data.
SELECT
phone_number,
LENGTH(LTRIM(RTRIM(phone_number))) AS phone_number_length
FROM employee;


-- Step 3: Create a working copy of the employee table.
-- The cleaning operation will be tested here first to protect
-- the original employee data from an unverified UPDATE.
CREATE TABLE employee_coby AS
SELECT *
FROM employee;


-- Step 4: Apply the cleaning operation to the test copy.
UPDATE employee_coby
SET phone_number = LTRIM(RTRIM(phone_number));


-- Step 5: Validate the cleaned phone numbers in the test copy
-- before applying the same transformation to the original table.
SELECT
phone_number,
LENGTH(phone_number) AS phone_number_length
FROM employee_coby;


-- Step 6: After validating the results, apply the verified
-- cleaning logic to the original employee table.
UPDATE employee
SET phone_number = LTRIM(RTRIM(phone_number));


-- Step 7: Verify that the original employee records were
-- successfully cleaned.
SELECT
phone_number,
LENGTH(phone_number) AS phone_number_length
FROM employee;

-- ============================================================
-- 3. Employee and survey workload
-- Goal: Count employees by home town.
-- ============================================================
SELECT town_name, COUNT(DISTINCT assigned_employee_id) AS num_employees
FROM employee
GROUP BY town_name
ORDER BY num_employees DESC;

-- Goal: Identify the three employees associated with the most visit records.
SELECT assigned_employee_id, COUNT(*) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;

-- Goal: Retrieve contact details for the top three employees.
SELECT
employee_name,
assigned_employee_id,
phone_number,
email
FROM employee
WHERE assigned_employee_id IN (1, 30, 34);

-- ============================================================
-- 4. Geographic distribution
-- Goal: Count surveyed location records by town and province.
-- ============================================================
-- Goal: Count location records by town.
SELECT
town_name,
COUNT(*) AS number_of_records
FROM location
GROUP BY town_name
ORDER BY number_of_records DESC;


-- Goal: Count location records by province.
SELECT
province_name,
COUNT(*) AS number_of_records
FROM location
GROUP BY province_name
ORDER BY number_of_records DESC;


-- Goal: Count location records by town within each province.
SELECT
province_name,
town_name,
COUNT(*) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town DESC;


-- Goal: Compare the number and percentage of locations by location type.
SELECT
location_type,
COUNT(location_type) AS number_of_locations
FROM location
GROUP BY location_type;


-- Goal: Calculate the percentage of rural locations
-- using the location counts returned by the previous query.

SELECT
23740 / (15910 + 23740) * 100 AS rural_percentage;


-- ============================================================
-- 5. Water Access and People Served
-- ============================================================

-- Goal: Calculate the total population served by all water sources.
SELECT
SUM(number_of_people_served) AS total_surveyed_people
FROM water_source;


-- Goal: Count the number of sources for each water-source type.
SELECT
type_of_water_source,
COUNT(type_of_water_source) AS total_number
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_number DESC;


-- Goal: Calculate the average number of people served by each water-source type.
SELECT
type_of_water_source,
ROUND(AVG(number_of_people_served)) AS avg_people_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY avg_people_served DESC;


-- Goal: Calculate the total number of people served by each water-source type.
SELECT
type_of_water_source,
SUM(number_of_people_served) AS total_served_people
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_served_people DESC;


-- Goal: Calculate the percentage of the surveyed population served
-- by each water-source type.

SELECT
type_of_water_source,
round((sum(number_of_people_served)/27628140)*100) AS pct_served_people
from
 water_source
 GROUP BY type_of_water_source
 order by pct_served_people DESC ;
 
-- The total population is calculated dynamically instead of using
-- the hard-coded value 27,628,140.

SELECT
type_of_water_source,
ROUND(
SUM(number_of_people_served) * 100.0 /
(SELECT SUM(number_of_people_served) FROM water_source),
2
) AS pct_served_people
FROM water_source
GROUP BY type_of_water_source
ORDER BY pct_served_people DESC;


-- Goal: Rank water-source types by the total population they serve.
SELECT
type_of_water_source,
SUM(number_of_people_served) AS total_people_served,
RANK() OVER (
ORDER BY SUM(number_of_people_served) DESC
) AS source_rank
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;


-- Goal: Rank only the water-source types that can be improved.
SELECT
type_of_water_source,
SUM(number_of_people_served) AS total_people_served,
RANK() OVER (
ORDER BY SUM(number_of_people_served) DESC
) AS source_rank
FROM water_source
WHERE type_of_water_source IN (
'shared_tap',
'well',
'river',
'tap_in_home_broken'
)
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;

-- ============================================================
-- 6. Prioritise Improvable Water Sources
-- ============================================================

-- Goal: Rank individual sources within each improvable source type
-- according to the number of people they serve.
SELECT
source_id,
type_of_water_source,
number_of_people_served,
ROW_NUMBER() OVER (
PARTITION BY type_of_water_source
ORDER BY number_of_people_served DESC
) AS priority_rank
FROM water_source
WHERE type_of_water_source IN (
'shared_tap',
'well',
'river',
'tap_in_home_broken'
)
ORDER BY number_of_people_served DESC;


-- ============================================================
-- 7. Survey Duration and Queue Analysis
-- ============================================================

-- Goal: Find the start date, end date, and duration of the survey.
SELECT
MAX(time_of_record) AS last_recorded_visit,
MIN(time_of_record) AS first_recorded_visit,
DATEDIFF(
MAX(time_of_record),
MIN(time_of_record)
) AS survey_duration
FROM visits;


-- Goal: Calculate the average queue time for people who actually waited.
-- NULLIF converts zero queue times to NULL so they are excluded from AVG().
SELECT
ROUND(
AVG(NULLIF(time_in_queue, 0))
) AS average_queue_time
FROM visits;


-- Goal: Compare average queue times across the days of the week.
SELECT
DAYNAME(time_of_record) AS week_day,
ROUND(
AVG(NULLIF(time_in_queue, 0))
) AS average_queue_time
FROM visits
GROUP BY week_day
ORDER BY average_queue_time DESC;


-- Goal: Compare average queue times by hour of the day.
SELECT
HOUR(time_of_record) AS hour_of_day,
ROUND(
AVG(NULLIF(time_in_queue, 0))
) AS average_queue_time
FROM visits
GROUP BY hour_of_day
ORDER BY average_queue_time DESC;


-- Goal: Display queue times using a readable hourly format.
SELECT
TIME_FORMAT(time_of_record, '%H:00') AS hour_of_day,
ROUND(
AVG(NULLIF(time_in_queue, 0))
) AS average_queue_time
FROM visits
GROUP BY hour_of_day
ORDER BY average_queue_time DESC;


-- Goal: Format survey timestamps into readable hour and date values.
SELECT
TIME_FORMAT(time_of_record, '%H:00') AS hour_of_day,
DATE_FORMAT(time_of_record, '%D-%M-%Y') AS survey_date
FROM visits;