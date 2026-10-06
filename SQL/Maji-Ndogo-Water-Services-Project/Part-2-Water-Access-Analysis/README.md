# 📊 Part 2: Water Access & Queue Analysis

[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)

## Overview

Part 2 turns the cleaned survey database into an operational picture of Maji Ndogo: who collected the data, where the survey was concentrated, how residents access water, and when queues are worst.

## 1. Employee Data Cleaning

Employee email addresses were standardized from employee names using `LOWER()`, `REPLACE()` and `CONCAT()`. Phone numbers were checked with `LENGTH()` and cleaned with `LTRIM()` / `RTRIM()`.

A copy of the employee table was created before applying updates, providing a safer place to validate transformations before changing the main table.

## 2. Employee Workload

```sql
SELECT
    assigned_employee_id,
    COUNT(*) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;
```

## 3. Geographic Coverage

```sql
SELECT
    location_type,
    COUNT(location_type) AS number_of_locations
FROM location
GROUP BY location_type;

SELECT
    23740 / (15910 + 23740) * 100 AS rural_percentage;
```

Province-level records are counted with:

```sql
SELECT
    province_name,
    COUNT(*) AS number_of_records
FROM location
GROUP BY province_name
ORDER BY number_of_records DESC;
```

## 4. Water Access Profile

The analysis compares source counts, average population served, and total population served.

```sql
SELECT
    type_of_water_source,
    COUNT(type_of_water_source) AS total_number
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_number DESC;

SELECT
    type_of_water_source,
    ROUND(AVG(number_of_people_served)) AS avg_people_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY avg_people_served DESC;

SELECT
    type_of_water_source,
    SUM(number_of_people_served) AS total_served_people
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_served_people DESC;
```

The original percentage calculation uses the surveyed population total. The final script also includes a dynamic version that avoids hard-coding the denominator:

```sql
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
```

## 5. Prioritising Improvable Sources

`RANK()` ranks source categories by population served, while `ROW_NUMBER()` produces an independent priority list inside each improvable source type.

```sql
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
```

## 6. Survey Duration and Queue-Time Analysis

```sql
SELECT
    MAX(time_of_record) AS last_recorded_visit,
    MIN(time_of_record) AS first_recorded_visit,
    DATEDIFF(
        MAX(time_of_record),
        MIN(time_of_record)
    ) AS survey_duration
FROM visits;

SELECT
    ROUND(AVG(NULLIF(time_in_queue, 0))) AS average_queue_time
FROM visits;

SELECT
    DAYNAME(time_of_record) AS week_day,
    ROUND(AVG(NULLIF(time_in_queue, 0))) AS average_queue_time
FROM visits
GROUP BY week_day
ORDER BY average_queue_time DESC;

SELECT
    HOUR(time_of_record) AS hour_of_day,
    ROUND(AVG(NULLIF(time_in_queue, 0))) AS average_queue_time
FROM visits
GROUP BY hour_of_day
ORDER BY average_queue_time DESC;
```

Zero-minute queue records are excluded from waiting-time averages through `NULLIF(time_in_queue, 0)`.

## SQL Skills Demonstrated

- Data cleaning with `LOWER`, `REPLACE`, `LTRIM`, `RTRIM`, `LENGTH`
- Data modification with `CREATE TABLE`, `UPDATE`, `DROP TABLE`
- Aggregation with `COUNT`, `SUM`, `AVG`
- Geographic grouping with `GROUP BY`
- Filtering with `WHERE` and `IN`
- Window functions with `RANK()` and `ROW_NUMBER()`
- Partitioned ranking with `PARTITION BY`
- NULL handling using `NULLIF()`
- Date/time analysis with `DATEDIFF`, `DAYNAME`, `HOUR`, `TIME_FORMAT`, `DATE_FORMAT`

## Takeaway

Part 2 builds a systematic prioritisation framework by combining geographic aggregation, population served, source type, and time-based queue analysis.

---

## 🧭 Navigation

[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)
