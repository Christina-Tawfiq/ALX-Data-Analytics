/*
  Maji Ndogo Water Services - Part 4
  Combined analysis, geographic prioritisation, and project planning
  Corrected and documented version
*/

-- ============================================================
-- MAJI NDOGO WATER SERVICES
-- Database Schema: md_water_services
-- ============================================================
USE md_water_services;

-- ============================================================
-- 1. Create the combined analysis table
-- Goal: Combine the information needed from visits, locations,
-- water sources, and pollution results into one view to make
-- the following analysis easier.
-- ============================================================

CREATE OR REPLACE VIEW combined_analysis_table AS
SELECT
loc.province_name,
loc.town_name,
ws.type_of_water_source,
ws.number_of_people_served,
loc.location_type,
v.time_in_queue,
well_p.results
FROM visits AS v
LEFT JOIN well_pollution AS well_p
ON well_p.source_id = v.source_id
INNER JOIN location AS loc
ON v.location_id = loc.location_id
INNER JOIN water_source AS ws
ON ws.source_id = v.source_id
WHERE v.visit_count = 1;


-- Goal: Review the data stored in the combined analysis view.

SELECT *
FROM combined_analysis_table;


-- ============================================================
-- 2. Analyse water access by province
-- Goal: Calculate the total population represented in each
-- province and determine the percentage served by each type
-- of water source.
-- ============================================================

-- This CTE calculates the population of each province
WITH province_totals AS (
SELECT
province_name,
SUM(number_of_people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name
)
 
SELECT
ct.province_name,
 
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
ROUND((SUM(CASE WHEN type_of_water_source = 'river'
THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN type_of_water_source = 'shared_tap'
THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home'
THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home_broken'
THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN type_of_water_source = 'well'
THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
 
FROM combined_analysis_table AS ct
JOIN province_totals AS pt
ON ct.province_name = pt.province_name
 
GROUP BY
ct.province_name,
pt.total_ppl_serv
 
ORDER BY
ct.province_name;

-- province_totals is a CTE that calculates the sum of all the people surveyed grouped by province 


-- ============================================================
-- 3. Review the total population represented in each province
-- Goal: Check the province totals separately before moving
-- to the more detailed town-level analysis.
-- ============================================================

WITH province_totals AS (
SELECT
province_name,
SUM(number_of_people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name
)
 
SELECT *
FROM province_totals;


-- ============================================================
-- 4. Analyse water access by town
-- Goal: Calculate the percentage of people served by each water
-- source type within every town.
--
-- Province and town are grouped together because town names
-- are not necessarily unique across provinces.
-- ============================================================

CREATE TEMPORARY TABLE town_aggregated_water_access

WITH town_totals AS (         -- This CTE calculates the population of each town
							  -- Since there are two Harare towns, we have to group by province_name and town_name
SELECT
province_name,
town_name,
SUM(number_of_people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY
province_name,
town_name
)
 
SELECT
ct.province_name,
ct.town_name,
 
ROUND((SUM(CASE WHEN type_of_water_source = 'river'
THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN type_of_water_source = 'shared_tap'
THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home'
THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home_broken'
THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN type_of_water_source = 'well'
THEN number_of_people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
 
FROM combined_analysis_table AS ct
 
JOIN town_totals AS tt                    -- Since the town names are not unique, we have to join on a composite key
ON ct.province_name = tt.province_name
AND ct.town_name = tt.town_name
 
GROUP BY                                  -- We group by province first, then by town.
ct.province_name,
ct.town_name,
tt.total_ppl_serv
 
ORDER BY
ct.town_name;


-- Goal: Review the town-level water access results.

SELECT *
FROM town_aggregated_water_access;


-- ============================================================
-- 5. Calculate the percentage of broken home taps
-- Goal: Compare functional and broken household taps within
-- each town and identify areas with a high proportion of
-- broken household water infrastructure.
-- ============================================================

SELECT
province_name,
town_name,
ROUND(
tap_in_home_broken /
(tap_in_home_broken + tap_in_home) * 100,
0
) AS pct_broken_taps

FROM town_aggregated_water_access;


-- ============================================================
-- 6. Create the Project_progress table
-- Goal: Create a table that can be used to track water-source
-- improvement projects from the backlog through completion.
-- ============================================================


--  This query creates the Project_progress table:
CREATE TABLE Project_progress (
 
Project_id SERIAL PRIMARY KEY,                         /* Project_id −− Unique key for sources in case we visit the same
                                                          source more than once in the future.
													   */
 
-- Each improvement project is linked to an existing water source.

/* source_id −− Each of the sources we want to improve should exist,
and should refer to the source table. This ensures data integrity.
*/
source_id VARCHAR(20)                                    
NOT NULL
REFERENCES water_source(source_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
 
Address VARCHAR(50),        -- Street address
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
 
-- Describes the action engineers should take.
Improvement VARCHAR(50),
 
-- New projects are added to the backlog by default.

/* Source_status −− We want to limit the type of information engineers can give us, so we
limit Source_status.
− By DEFAULT all projects are in the "Backlog" which is like a TODO list.
− CHECK() ensures only those three options will be accepted. This helps to maintain clean data.
*/
Source_status VARCHAR(50)
DEFAULT 'Backlog'
CHECK (
Source_status IN (
'Backlog',
'In progress',
'Complete'
)
),
 
-- Engineers will add this the day the source has been upgraded.
Date_of_completion DATE,
 
-- Engineers can leave comments. We use a TEXT type that has no limit on char length
Comments TEXT
);


-- Here is a less commented one so it is easier to see how we design the Project_progress table:

/*
CREATE TABLE Project_progress (
Project_id SERIAL PRIMARY KEY,
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
Address VARCHAR(50),
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50),
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
Date_of_completion DATE,
Comments TEXT
);
*/

-- ============================================================
-- 7. Generate water-source improvement recommendations
-- Goal: Translate the identified water-access problems into
-- practical actions that can be assigned to engineers.
-- ============================================================

-- Project_progress_query

SELECT
location.address,
location.town_name,
location.province_name,
water_source.source_id,
water_source.type_of_water_source,
well_pollution.results,
case 
      when results ='Contaminated: Biological' then 'Install UV and RO filter'
      when results ='Contaminated: Chemical'   then 'Install RO filter'
      when type_of_water_source='river'        then 'Drill well'
      WHEN type_of_water_source = 'shared_tap' AND time_in_queue >=30  THEN CONCAT("Install ", FLOOR(time_in_queue / 30), " taps nearby")
      when type_of_water_source= 'tap_in_home_broken' then 'Diagnose local infrastructure'
      ELSE NULL
 end as Improvement 
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id
WHERE
visits.visit_count = 1                                  -- This must always be true
AND (                                                   -- AND one of the following (OR) options must be true as well.
results!= 'Clean'
OR type_of_water_source IN ('tap_in_home_broken','river')
OR (type_of_water_source = 'shared_tap' AND time_in_queue >=30)
);



-- ============================================================
-- 8. Add the recommended improvements to Project_progress
-- Goal: Insert the water sources that require improvement into
-- the project table together with their recommended actions.
-- ============================================================

INSERT INTO Project_progress (
source_id,
Address,
Town,
Province,
Source_type,
Improvement
)

SELECT
source_id,
address,
town_name,
province_name,
type_of_water_source,
improvement
 
FROM (
SELECT
location.address,
location.town_name,
location.province_name,
water_source.source_id,
water_source.type_of_water_source,

case 
      when results ='Contaminated: Biological' then 'Install UV and RO filter'
      when results ='Contaminated: Chemical'   then 'Install RO filter'
      when type_of_water_source='river'        then 'Drill well'
      WHEN type_of_water_source = 'shared_tap' AND time_in_queue >=30  THEN CONCAT("Install ", FLOOR(time_in_queue / 30), " taps nearby")
      when type_of_water_source= 'tap_in_home_broken' then 'Diagnose local infrastructure'
      ELSE NULL
 end as Improvement   

FROM water_source

LEFT JOIN well_pollution
ON water_source.source_id = well_pollution.source_id

INNER JOIN visits
ON water_source.source_id = visits.source_id

INNER JOIN location
ON location.location_id = visits.location_id

WHERE visits.visit_count = 1                            -- This must always be true
                
AND (                                                   -- AND one of the following (OR) options must be true as well.
results != 'Clean'

OR type_of_water_source IN (
'tap_in_home_broken',
'river'
)

OR (
type_of_water_source = 'shared_tap'
AND time_in_queue >= 30
)
)

) AS improvement_projects;