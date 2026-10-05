SELECT
	 employee_name,
    concat(
    LOWER(replace(employee_name," ",".")),'@ndogowater.gov') AS  new_email
   	
FROM 
 md_water_services.employee;


CREATE table 
           employee_coby
            AS (
            SELECT *
            FROM employee
            );
  

UPDATE 
     md_water_services.employee_coby
SET
     email= concat(LOWER(replace(employee_name," ",".")),'@ndogowater.gov');
    
select
      employee_name,email
from
     employee_coby;   
    
UPDATE 
     md_water_services.employee
SET
     email= concat(LOWER(replace(employee_name," ",".")),'@ndogowater.gov');    
    
select
     employee_name ,email
from
    employee ;
    
drop table  employee_coby ;  
  
  
  
  
SELECT  
   phone_number,
   length(phone_number) AS PHONE_NUMBER_LENGTH
FROM
    employee;
    
SELECT  
   phone_number,
 LENGTH(LTRIM(RTRIM(phone_number))) AS PHONE_NUMBER_LENGTH
FROM
    employee;  
    
CREATE table 
           employee_coby
            AS (
            SELECT *
            FROM employee
            );
 
 UPDATE 
        employee_coby
      SET
      phone_number=LTRIM(RTRIM(phone_number));
      
SELECT  
  phone_number,
 LENGTH(LTRIM(RTRIM(phone_number))) AS PHONE_NUMBER_LENGTH
FROM
   employee_coby;  
   
   
 UPDATE 
        employee
      SET
    phone_number =LTRIM(RTRIM(phone_number));  


SELECT  
  phone_number,
 LENGTH(LTRIM(RTRIM(phone_number))) AS PHONE_NUMBER_LENGTH
FROM
   employee;   
   
SELECT 
   town_name,
   count(distinct employee_name) AS  num_employees
FROM  
     employee 
group by      
	town_name;
    


SELECT 
 assigned_employee_id,
 COUNT( visit_count ) AS NUMBER_OF_VISITS
FROM 
    visits
GROUP BY assigned_employee_id 
ORDER BY NUMBER_OF_VISITS desc
LIMIT 3 ; 

SELECT 
employee_name, assigned_employee_id,phone_number,email
FROM 
    employee
WHERE     
assigned_employee_id IN (1,30,34) ;


SELECT 
      town_name,
	  COUNT(town_name) AS number_of_records
from
      location
group by town_name;



SELECT 
       province_name,
	  COUNT(province_name) AS number_of_records
from
      location
group by province_name;


select 
     province_name,town_name,
     count(town_name) AS records_per_town
from
    location
GROUP BY  province_name, town_name 
ORDER BY province_name,records_per_town DESC;



SELECT 
      location_type ,
	  COUNT(location_type) AS number_of_sources
from
      location
group by location_type;


SELECT 23740 / (15910 + 23740) * 100;


SELECT
*
FROM
   water_source ;
   
   
SELECT
sum(number_of_people_served) AS total_surveyed_people
from
 water_source;
 
 
 
 select
       type_of_water_source,
       count(type_of_water_source) AS total_number
from       
   water_source
group by type_of_water_source
order by total_number desc ;  



select
       type_of_water_source,
	   round(AVG(number_of_people_served)) AS avg_people_served
from       
   water_source
group by type_of_water_source
order by avg_people_served desc ;  



SELECT
type_of_water_source,
sum(number_of_people_served) AS total_served_people
from
 water_source
 GROUP BY type_of_water_source
 order by total_served_people DESC ;



SELECT
type_of_water_source,
round((sum(number_of_people_served)/27628140)*100) AS pct_served_people
from
 water_source
 GROUP BY type_of_water_source
 order by pct_served_people DESC ;
 
 
 
 SELECT
type_of_water_source,
sum(number_of_people_served) AS total_served_people
from
 water_source
 GROUP BY type_of_water_source
 order by total_served_people DESC ;
 
 
 
 
 SELECT 
    type_of_water_source, 
    SUM(number_of_people_served) AS total_people_served, 
    RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) AS ranks
FROM 
     water_source
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;
 
 
 
 SELECT 
    type_of_water_source, 
    SUM(number_of_people_served) AS total_people_served, 
    RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) AS ranks
FROM water_source
where type_of_water_source in ('shared_tap','well','river','tap_in_home_broken')
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;




/*So create a query to do this, and keep these requirements in mind:
1. The sources within each type should be assigned a rank.
2. Limit the results to only improvable sources.
3. Think about how to partition, filter and order the results set.
4. Order the results to see the top of the list*/



SELECT 
	source_id,
    type_of_water_source, 
    number_of_people_served,
    row_number() OVER (PARTITION BY type_of_water_source ORDER BY number_of_people_served DESC) AS priority_rank
FROM water_source
where type_of_water_source in ('shared_tap','well','river','tap_in_home_broken')
ORDER BY number_of_people_served DESC;



select
max(time_of_record),
min(time_of_record),
datediff(max(time_of_record),min(time_of_record)) as survey_duration
from
visits;



select
round(avg(nullif(time_in_queue,0)))as average_queue_time
from
visits;


select
dayname(time_of_record)as week_day,
round(avg(nullif(time_in_queue,0))) as average_queue_time
from
visits
group by week_day
order by average_queue_time desc ;



select
hour(time_of_record) as hour_OF_day,
round(avg(nullif(time_in_queue,0))) as average_queue_time
from
visits
group by hour_OF_day
order by average_queue_time desc ;


select
time_format(time_of_record,'%H :00') AS HOUR_OF_DAY,
round(avg(nullif(time_in_queue,0))) as average_queue_time
from
visits
group by hour_OF_day
order by average_queue_time desc ;




select
time_format(time_of_record,'%H :00'),
date_format(time_of_record,'%D-%M-%Y')
from
visits;
