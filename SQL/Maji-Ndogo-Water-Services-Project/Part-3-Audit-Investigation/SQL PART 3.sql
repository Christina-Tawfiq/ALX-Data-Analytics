
select 
ar.location_id,
v.record_id,
ar.true_water_source_score as  auditor_score,
wq.subjective_quality_score as surveyor_score
from
auditor_report as ar
join
visits as v
on
ar.location_id=v.location_id
join
water_quality as wq
on v.record_id=wq.record_id
where ar.true_water_source_score=wq.subjective_quality_score 
and
v.visit_count=1;



select 
ar.location_id,
v.record_id,
ar.true_water_source_score as  auditor_score,
wq.subjective_quality_score as surveyor_score,
ws.type_of_water_source as survey_source,
ar.type_of_water_source as auditor_source
from
auditor_report as ar
join
visits as v
on
ar.location_id=v.location_id
join
water_quality as wq
on v.record_id=wq.record_id
join
water_source as ws
on
v.source_id=ws.source_id
where ar.true_water_source_score!=wq.subjective_quality_score 
and
v.visit_count=1;



create view Incorrect_records as (
select 
ar.location_id,
v.record_id,
ar.true_water_source_score as  auditor_score,
wq.subjective_quality_score as surveyor_score,
v.assigned_employee_id,
em.employee_name,
ar.statements AS statements
from                                                  -- location_id, record_id, employee_name, auditor_score, surveyor_score, statements .. those record for the 102 surveyor water quality scores that differs from the auditor water quality score
auditor_report as ar
join
visits as v
on
ar.location_id=v.location_id
join
water_quality as wq
on v.record_id=wq.record_id
join
employee as em
on
em.assigned_employee_id=v.assigned_employee_id
where ar.true_water_source_score!=wq.subjective_quality_score 
and
v.visit_count=1);

with
error_count as (
select 
distinct employee_name,
count(employee_name) as number_of_mistakes
from                                            -- number of mistakes per employee 
Incorrect_records
group by employee_name),

avg_error_count_per_empl as(
select 
avg(number_of_mistakes)              -- average no_of_mistakes for the employees
from
error_count),

suspect_list as(
SELECT
employee_name,
number_of_mistakes
FROM
error_count
WHERE
number_of_mistakes > (select 
                             avg(number_of_mistakes)   -- subquery inside where clause
					   from
                                 error_count
))



SELECT
employee_name,
location_id,
statements
FROM
Incorrect_records
WHERE
employee_name in (SELECT employee_name FROM suspect_list)
and statements like '%cash%';



SELECT * FROM Incorrect_records ;



/*create view Incorrect_records as (
select 
ar.location_id,
v.record_id,
ar.true_water_source_score as  auditor_score,
wq.subjective_quality_score as surveyor_score,
v.assigned_employee_id,
em.employee_name,
ar.statements AS statements
from                                                  -- location_id, record_id, employee_name, auditor_score, surveyor_score, statements .. those record for the 102 surveyor water quality scores that differs from the auditor water quality score
auditor_report as ar
join
visits as v
on
ar.location_id=v.location_id
join
water_quality as wq
on v.record_id=wq.record_id
join
employee as em
on
em.assigned_employee_id=v.assigned_employee_id
where ar.true_water_source_score!=wq.subjective_quality_score 
and
v.visit_count=1);*/



SELECT
    auditorRep.location_id,
    visitsTbl.record_id,
    Empl_Table.employee_name,
    auditorRep.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS employee_score
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
JOIN employee as Empl_Table
ON Empl_Table.assigned_employee_id = visitsTbl.assigned_employee_id;







WITH Incorrect_records AS (      -- This CTE fetches all of the records with wrong scores
SELECT
    auditorRep.location_id,
    visitsTbl.record_id,
    Empl_Table.employee_name,
    auditorRep.true_water_source_score AS auditor_score,
    wq.subjective_quality_score AS employee_score
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
JOIN employee as Empl_Table
ON Empl_Table.assigned_employee_id = visitsTbl.assigned_employee_id
WHERE visitsTbl.visit_count =1 AND auditorRep.true_water_source_score != wq.subjective_quality_score)

SELECT
    employee_name,
    count(employee_name)
FROM Incorrect_records
GROUP BY Employee_name;






SELECT
auditorRep.location_id,
visitsTbl.record_id,
auditorRep.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS employee_score,
wq.subjective_quality_score - auditorRep.true_water_source_score  AS score_diff
FROM auditor_report AS auditorRep
JOIN visits AS visitsTbl
ON auditorRep.location_id = visitsTbl.location_id
JOIN water_quality AS wq
ON visitsTbl.record_id = wq.record_id
WHERE (wq.subjective_quality_score - auditorRep.true_water_source_score) > 9;       

