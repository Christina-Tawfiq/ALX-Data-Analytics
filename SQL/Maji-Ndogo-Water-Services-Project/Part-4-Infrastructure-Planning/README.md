# 🚧 Part 4: Infrastructure Planning

[⬅ Part 3](../Part-3-Audit-Investigation/README.md) | [Project Overview](../Overview/README.md)

## Overview
Part 4 moves from analysis to implementation. The SQL combines geography, water-source access, queue pressure and well-pollution results, then translates those conditions into specific infrastructure actions and a project-tracking table.

### SQL used
```sql
CREATE VIEW combined_analysis_table AS
select
loc.province_name,
loc.town_name,
ws.type_of_water_source,
ws.number_of_people_served,
loc.location_type,
v.time_in_queue,
well_P.results
from visits as v
left JOIN well_pollution as well_P ON well_p.source_id = v.source_id
inner join location as loc on v.location_id=loc.location_id
inner join water_source as ws on ws.source_id=v.source_id
WHERE v.visit_count= 1;
```

## 1. Building a Unified Analysis Layer
A `combined_analysis_table` view joins `visits`, `location`, `water_source`, and `well_pollution` for first visits only.

The view brings together:
- province and town,
- source type,
- population served,
- rural/urban location type,
- queue time,
- well-pollution result.

**Insight:** Creating a reusable analytical view reduces repeated joins and provides a consistent base for province-level, town-level and intervention analysis.

### SQL used
```sql
WITH province_totals AS (
SELECT province_name,
SUM(number_of_people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name
)
SELECT
ct.province_name,
ROUND((SUM(CASE WHEN type_of_water_source = 'river' THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN type_of_water_source = 'shared_tap' THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home' THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN type_of_water_source = 'tap_in_home_broken' THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN type_of_water_source = 'well' THEN number_of_people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
FROM combined_analysis_table ct
JOIN province_totals pt ON ct.province_name = pt.province_name
GROUP BY ct.province_name
ORDER BY ct.province_name;
```

## 2. Province-Level Water Access
CTEs calculate the population served in each province, while conditional aggregation converts each source type into a percentage of provincial water access.

The project findings highlight several geographic priorities:

- **Sokoto** has the highest reliance on river water and is identified as the first province for well-drilling interventions.
- In **Amanzi**, the town of **Amina** has only **3%** of residents with functioning taps in their homes, while more than half have household taps that are not working.
- Broken infrastructure is also highlighted across towns in Akatsi and Hawassa.

**Insight:** National averages hide local infrastructure failures. Province and town segmentation is necessary because the appropriate intervention differs sharply by place.

### SQL used
```sql
SELECT
province_name,
town_name,
ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100,0) AS Pct_broken_taps
FROM town_aggregated_water_access;
```

## 3. Town-Level Access and Broken-Tap Ratio
Because town names are not necessarily unique, town analysis uses a composite key of `province_name` + `town_name`.

A temporary table, `town_aggregated_water_access`, stores the percentage mix of water-source types for each town. The analysis then calculates:

```sql
ROUND(
  tap_in_home_broken /
  (tap_in_home_broken + tap_in_home) * 100,
  0
) AS pct_broken_taps
```

**Insight:** Looking at broken taps as a proportion of all household taps is more informative than counting broken taps alone. It identifies places where infrastructure exists but is failing to deliver water.

### SQL used
```sql
SELECT
location.address,
location.town_name,
location.province_name,
water_source.source_id,
water_source.type_of_water_source,
well_pollution.results,
case
      when results ='Contaminated: Biological' then 'Install UV and RO filter'
      when results ='Contaminated: Chemical' then 'Install RO filter'
      when type_of_water_source='river' then 'Drill well'
      WHEN type_of_water_source = 'shared_tap' AND time_in_queue >=30 THEN CONCAT("Install ", FLOOR(time_in_queue / 30), " taps nearby")
      when type_of_water_source= 'tap_in_home_broken' then 'Diagnose local infrastructure'
      else 'null'
end as Improvement
FROM water_source
LEFT JOIN well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN visits ON water_source.source_id = visits.source_id
INNER JOIN location ON location.location_id = visits.location_id
WHERE visits.visit_count = 1
AND (results!= 'Clean'
OR type_of_water_source IN ('tap_in_home_broken','river')
OR (type_of_water_source = 'shared_tap' AND time_in_queue >=30));
```

## 4. From Findings to Interventions
The SQL converts source conditions directly into recommended engineering actions.

| Condition | Recommended improvement |
|---|---|
| Biological well contamination | Install UV and RO filter |
| Chemical well contamination | Install RO filter |
| River source | Drill well |
| Shared tap with queue >= 30 min | Install additional taps nearby |
| Broken household tap | Diagnose local infrastructure |

For overloaded shared taps, the number of proposed taps is derived from queue time using `FLOOR(time_in_queue / 30)`.

### Operational priorities
The project strategy prioritises:
1. **River communities:** temporary supply support followed by well drilling, with Sokoto first.
2. **Contaminated wells:** filtration based on contamination type.
3. **Busy shared taps:** short-term water support and additional taps to reduce queue pressure.
4. **Broken household infrastructure:** repairs in places where one intervention can restore access for many residents.

The project materials identify **Bello, Abidjan and Zuri** as towns with substantial shared-tap pressure, and **Amina, Lusaka, Zuri, Djenne and rural Amanzi** as places where broken infrastructure is a priority.

## 5. Why Shared Taps Deserve Immediate Attention
Part 2 showed that shared taps serve **11,945,272 people**, or **43.24%** of the represented population, with approximately **2,071 people per shared tap** on average. Positive queue times average **123.26 minutes**, and Saturday is the worst day at roughly **246 minutes**.

**Insight:** Shared-tap improvements can affect the largest population group while directly addressing one of the clearest service problems in the dataset: long waiting times.

## 6. Creating the Project Tracker
The `Project_progress` table turns recommendations into trackable work.

Its design includes:
- a primary project ID,
- source ID with referential integrity,
- address, town and province,
- source type,
- recommended improvement,
- controlled project status,
- completion date,
- comments.

`Source_status` defaults to `Backlog` and is restricted to:
- `Backlog`
- `In progress`
- `Complete`

**Insight:** This is the point where the SQL project becomes operational. Analysis outputs are structured so engineering teams can manage interventions as projects rather than leaving recommendations in a report.

## 7. Decision Rules Embedded in SQL
The improvement query uses a `CASE` expression to make recommendations repeatable. Instead of manually choosing fixes row by row, the intervention logic is encoded directly in the database query.

```sql
CASE
  WHEN results = 'Contaminated: Biological' THEN 'Install UV and RO filter'
  WHEN results = 'Contaminated: Chemical' THEN 'Install RO filter'
  WHEN type_of_water_source = 'river' THEN 'Drill well'
  WHEN type_of_water_source = 'shared_tap'
       AND time_in_queue >= 30
    THEN CONCAT('Install ', FLOOR(time_in_queue / 30), ' taps nearby')
  WHEN type_of_water_source = 'tap_in_home_broken'
    THEN 'Diagnose local infrastructure'
END
```

## SQL Skills Demonstrated
- Analytical views with `CREATE VIEW`
- Multi-table `INNER JOIN` and `LEFT JOIN`
- CTEs for reusable totals
- Conditional aggregation with `SUM(CASE WHEN...)`
- Percentage calculations
- Composite-key joins for non-unique town names
- Temporary tables
- `CASE` expressions for business rules
- String construction with `CONCAT()`
- Numeric logic with `FLOOR()`
- Table design with primary keys, foreign keys, defaults and `CHECK` constraints
- `INSERT INTO ... SELECT` workflow for operationalising analysis

## Takeaway
Part 4 closes the analytical loop: it combines multiple datasets, exposes geographic differences in water access, converts service problems into intervention rules, and creates a project table for implementation. The strongest feature is the transition from descriptive SQL to decision-oriented SQL, where source type, water quality and queue conditions directly determine the recommended action.


---

## 🧭 Navigation
[⬅ Part 3](../Part-3-Audit-Investigation/README.md) | [Project Overview](../Overview/README.md)
