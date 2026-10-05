# 🕵️ Part 3: Data Integrity & Audit Investigation

[⬅ Part 2](../Part-2-Water-Access-Analysis/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 4 ➡](../Part-4-Infrastructure-Planning/README.md)

## Overview
Part 3 is a data-quality investigation. The survey team's water-quality scores are compared with an independent auditor's re-checks, mismatches are isolated, linked back to the responsible employees, and then investigated for unusual error patterns and supporting citizen statements.

The auditor report contains a randomly selected re-visit sample of **1,620 records**.

### SQL used
```sql
select
    ar.location_id,
    v.record_id,
    ar.true_water_source_score as auditor_score,
    wq.subjective_quality_score as surveyor_score
from auditor_report as ar
join visits as v
  on ar.location_id=v.location_id
join water_quality as wq
  on v.record_id=wq.record_id
where ar.true_water_source_score=wq.subjective_quality_score
  and v.visit_count=1;
```

## Audit Outcome
| Audit metric | Result |
|---|---:|
| Auditor re-checked records | 1,620 |
| Matching survey records | 1,518 |
| Incorrect survey scores | 102 |
| Agreement rate | 93.70% |
| Disagreement rate | 6.30% |

**Insight:** Most survey scores were validated by the independent audit, but 102 discrepancies are still large enough to justify a targeted investigation rather than treating them as isolated errors.

## 1. Reconstructing the Audit Comparison
The analysis joins four important sources of information:

- `auditor_report` provides the auditor's independently recorded score.
- `visits` connects audited locations to survey records and employees.
- `water_quality` provides the original subjective quality score.
- `water_source` is used to check whether mismatches could instead be explained by source-type differences.

The comparison is restricted to `visit_count = 1` so the first survey visit is compared consistently with the auditor's assessment.

### SQL used
```sql
create view Incorrect_records as (
select
    ar.location_id,
    v.record_id,
    ar.true_water_source_score as auditor_score,
    wq.subjective_quality_score as surveyor_score,
    v.assigned_employee_id,
    em.employee_name,
    ar.statements AS statements
from auditor_report as ar
join visits as v on ar.location_id=v.location_id
join water_quality as wq on v.record_id=wq.record_id
join employee as em on em.assigned_employee_id=v.assigned_employee_id
where ar.true_water_source_score!=wq.subjective_quality_score
  and v.visit_count=1);
```

## 2. Isolating the 102 Incorrect Records
A reusable view, `Incorrect_records`, captures the mismatches together with:

- `location_id`
- `record_id`
- auditor score
- surveyor score
- assigned employee
- employee name
- citizen statement

This converts an audit discrepancy into an investigation-ready dataset.

### SQL used
```sql
with error_count as (
select distinct employee_name,
       count(employee_name) as number_of_mistakes
from Incorrect_records
group by employee_name),
avg_error_count_per_empl as(
select avg(number_of_mistakes)
from error_count),
suspect_list as(
SELECT employee_name, number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (select avg(number_of_mistakes) from error_count)
)
SELECT employee_name, location_id, statements
FROM Incorrect_records
WHERE employee_name in (SELECT employee_name FROM suspect_list)
  and statements like '%cash%';
```

## 3. Employee-Level Error Analysis
The errors are aggregated by employee using a CTE called `error_count`. A second step calculates the average error count, then a `suspect_list` filters employees whose number of mismatches is above that average.

The course investigation identifies **four employees with above-average error counts** for closer review.

**Insight:** An above-average error count is a screening criterion, not proof of misconduct. Its analytical value is that it narrows 102 mismatches to a much smaller set that deserves closer inspection.

## 4. Adding Qualitative Evidence
The investigation then filters the statements attached to incorrect records for the word `cash`.

This is an important analytical shift. The workflow no longer relies on score discrepancies alone. It combines:

1. independent quantitative disagreement,
2. concentration of errors by employee,
3. qualitative statements from people near the water sources.

**Insight:** The combination of independent audit discrepancies and repeated narrative signals is stronger evidence for investigation than either source on its own. It should still be treated as a flag for review rather than a definitive finding about any individual.

## 5. Why the Data Model Matters
Part 3 demonstrates the analytical value of relational design. No single table contains the full story. The investigation becomes possible only after joining the audit, visit, water-quality and employee records through their shared keys.

```sql
JOIN visits
  ON auditor_report.location_id = visits.location_id
JOIN water_quality
  ON visits.record_id = water_quality.record_id
JOIN employee
  ON employee.assigned_employee_id = visits.assigned_employee_id
```

## SQL Skills Demonstrated
- Multi-table `JOIN` analysis
- Aliasing for readable analytical queries
- Validation using equality and inequality filters
- Reusable database objects with `CREATE VIEW`
- Layered analysis with multiple CTEs
- Aggregation with `COUNT()` and `AVG()`
- Subqueries inside filtering logic
- Pattern matching with `LIKE '%cash%'`
- Employee-level anomaly screening
- Combining quantitative and qualitative evidence

## Takeaway
Part 3 is the quality-control layer of the project. The audit validates 1,518 of 1,620 checked records, isolates 102 mismatches, traces those mismatches back through the relational model, and uses above-average error frequency plus citizen statements to focus the investigation. It is a strong example of using SQL not only to summarize data, but to test its credibility.


---

## 🧭 Navigation
[⬅ Part 2](../Part-2-Water-Access-Analysis/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 4 ➡](../Part-4-Infrastructure-Planning/README.md)
