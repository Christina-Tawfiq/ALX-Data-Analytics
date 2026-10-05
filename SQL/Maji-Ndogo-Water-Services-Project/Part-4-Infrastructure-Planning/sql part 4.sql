
CREATE VIEW combined_analysis_table AS      -- This view assembles data from different tables into one to simplify analysis
select
loc.province_name,
loc.town_name,
ws.type_of_water_source,
ws.number_of_people_served,
loc.location_type,
v.time_in_queue,
well_P.results
from 
visits as v
left JOIN
well_pollution as well_P
ON well_p.source_id = v.source_id
inner join 
location as loc
on
v.location_id=loc.location_id
inner join 
water_source as ws
on
ws.source_id=v.source_id
 WHERE v.visit_count= 1;
 
 select
 * 
 from 
 combined_analysis_table;
 
 
 
 
 
 WITH province_totals AS (-- This CTE calculates the population of each province
SELECT
province_name,
SUM(number_of_people_served) AS total_ppl_serv
FROM
combined_analysis_table
GROUP BY
province_name
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
FROM
combined_analysis_table ct
JOIN
province_totals pt ON ct.province_name = pt.province_name
GROUP BY
ct.province_name
ORDER BY
ct.province_name;






 WITH province_totals AS (-- This CTE calculates the population of each province
SELECT
province_name,
SUM(number_of_people_served) AS total_ppl_serv
FROM
combined_analysis_table
GROUP BY
province_name
)
SELECT
*
FROM
province_totals;
 
-- province_totals is a CTE that calculates the sum of all the people surveyed grouped by province 


CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT province_name, town_name, SUM(number_of_people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
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
FROM
combined_analysis_table ct
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY -- We group by province first, then by town.
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;
 
 
 select *
 from town_aggregated_water_access;
 
 
 
 SELECT
province_name,
town_name,
ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) *
100,0) AS Pct_broken_taps
FROM
town_aggregated_water_access;
 
 
 
 
 
--  This query creates the Project_progress table:
CREATE TABLE Project_progress (
Project_id SERIAL PRIMARY KEY,
/* Project_id −− Unique key for sources in case we visit the same
source more than once in the future.
*/
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
/* source_id −− Each of the sources we want to improve should exist,
and should refer to the source table. This ensures data integrity.
*/
Address VARCHAR(50), -- Street address
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50), -- What the engineers should do at that place
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
/* Source_status −− We want to limit the type of information engineers can give us, so we
limit Source_status.
− By DEFAULT all projects are in the "Backlog" which is like a TODO list.
− CHECK() ensures only those three options will be accepted. This helps to maintain clean data.
*/
Date_of_completion DATE, -- Engineers will add this the day the source has been upgraded.
Comments TEXT -- Engineers can leave comments. We use a TEXT type that has no limit on char length
);




-- Here is a less commented one so it is easier to see how we design the Project_progress table:
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
      else 'null'
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
visits.visit_count = 1 -- This must always be true
AND ( -- AND one of the following (OR) options must be true as well.
results!= 'Clean'
OR type_of_water_source IN ('tap_in_home_broken','river')
OR (type_of_water_source = 'shared_tap' AND time_in_queue >=30)
);




insert into project_progress(
			                  source_id,
                              Address,
                              Town,
                              Province,
                              Source_type,
                              Improvement
                              )
select 
       source_id,
       address,
       town_name,
       province_name,
       type_of_water_source,
       improvement
from (
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
      else 'null'
 end as Improvements   
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id
WHERE
visits.visit_count = 1 -- This must always be true
AND ( -- AND one of the following (OR) options must be true as well.
results!= 'Clean'
OR type_of_water_source IN ('tap_in_home_broken','river')
OR (type_of_water_source = 'shared_tap' AND time_in_queue >=30)
)) as SELECT
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
      else 'null'
 end as Improvements   
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id
WHERE
visits.visit_count = 1 -- This must always be true
AND ( -- AND one of the following (OR) options must be true as well.
results!= 'Clean'
OR type_of_water_source IN ('tap_in_home_broken','river')
OR (type_of_water_source = 'shared_tap' AND time_in_queue >=30)
));       