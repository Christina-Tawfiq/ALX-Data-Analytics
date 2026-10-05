SHOW TABLES;
SELECT
      *
  FROM
      LOCATION
  LIMIT 5;
  
  SELECT
      *
  FROM
      VISITS
  LIMIT 5;
  
  SELECT
      *
  FROM
     water_source 
  LIMIT 5;
  
  SELECT
      *
  FROM
  data_dictionary;
  
  SELECT DISTINCT
   type_of_water_source   
  FROM
  water_source;
  
  SELECT
        *
	FROM
        visits 
	WHERE
        time_in_queue =0;
SELECT 
        *
FROM
       water_source
WHERE 
     source_id IN (
                'AkKi00881224',
                'SoRu37635224',
			    'SoRu36096224',
                'AkRu05234224',
				'HaZa21742224'
              );


SELECT
     *
 FROM
     water_quality
 WHERE 
      subjective_quality_score=10
      AND
      visit_count=2;
 
CREATE TABLE QUALITY_10_VISIT_2(
COL1 INT,
COL2 INT,
COL3 int
);

INSERT INTO quality_10_visit_2 (
COL1,
COL2,
COL3
)
SELECT 
record_id,
subjective_quality_score,
visit_count
FROM
water_quality 
WHERE
subjective_quality_score=10
      AND
      visit_count=2;
      
  SELECT DISTINCT
  *
  FROM
  quality_10_visit_2;
  
  SELECT
  *
  FROM
  well_pollution
  LIMIT 5;
  
  SELECT
  *
  FROM
       well_pollution
  WHERE 
       results='clean'
       AND
          biological>0.01
          LIMIT 5;
          
	  SELECT
      *
      FROM
      well_pollution
      WHERE description LIKE 'Clean_%';
      
      
      SET SQL_SAFE_UPDATES=0;
      
      UPDATE well_pollution
      SET 
      description= 'Bacteria: Giardia Lamblia'
      WHERE description= 'Clean Bacteria: Giardia Lamblia';
      
       UPDATE well_pollution
      SET description= ' Bacteria: E. coli'
      WHERE description='Clean Bacteria: E. coli';
      
      UPDATE well_pollution
      SET results= 'Contaminated: Biological'
      WHERE biological>0.01;
      
      SELECT 
      *
      FROM
            well_pollution
		WHERE 
      description LIKE 'CLEAN_%'
      OR 
      (results='CLEAN' AND biological>0.01);
      
      
      
     SELECT  
     address,
     employee_name
     FROM
     employee
     WHERE 
     employee_name='Bello Azibo';
     
      SELECT  
     phone_number,
     employee_name
     FROM
     employee
     WHERE position='Micro biologist';
     
     
     SELECT
     *
     FROM
     employee;
 
 SELECT
 *
 FROM
     water_source
     WHERE type_of_water_source IN(
     'well',
'shared_tap',
 'river')
	GROUP BY source_id
ORDER BY COUNT(number_of_people_served) DESC
LIMIT 1;

SELECT
*
FROM
water_source
WHERE source_id IN(
'AkHa00036224',
'AkRu04862224',
'AkRu05603224',
'AmAs10911224'
);


SELECT
*
FROM
   location;
    
     
 SELECT
*
 FROM
 global_water_access
 where name='maji ndogo';
 
SELECT
*
 FROM
 data_dictionary
  WHERE 
      description LIKE '%population%';
      
      
      
    /*The employee’s phone number contained the digits 86 or 11. 
The employee’s last name started with either an A or an M. 
The employee was a Field Surveyor.
Which option is correct?*/

select 
*
from
employee
where
(phone_number like '%86%'or phone_number like '%11%')
  and (employee_name like '%M%' or employee_name like '%A%')
    and  (position='Field Surveyor');
    
    
SELECT distinct 
*
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological > 0.01;
      
      SELECT
*
FROM
well_pollution
WHERE
description LIKE "Clean_%"
OR (results = "Clean" AND biological > 0.01);



SET SQL_SAFE_UPDATES=0;
      
      UPDATE well_pollution
      SET 
      description= 'Bacteria: Giardia Lamblia'
      WHERE description= 'Clean Bacteria: Giardia Lamblia';
      
       UPDATE well_pollution
      SET description= ' Bacteria: E. coli'
      WHERE description='Clean Bacteria: E. coli';
      
      UPDATE well_pollution
      SET results= 'Contaminated: Biological'
      WHERE biological>0.01 and results='clean';
      
      SELECT 
      *
      FROM
            well_pollution
		WHERE 
      description LIKE 'CLEAN_%'
      OR 
      (results='CLEAN' AND biological>0.01);
      
      
      
      SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;




SELECT * 
FROM well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);

SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;


