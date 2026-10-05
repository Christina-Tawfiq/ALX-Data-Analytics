# 📊 Part 2: Water Access & Queue Analysis

[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)

## Overview
Part 2 moves from initial exploration into data cleaning, geographic profiling, population coverage, prioritisation, and time-based queue analysis. The SQL also demonstrates string manipulation, updates, aggregation, ranking, window functions, and date/time functions.

## Key Findings

### 1. Cleaning employee contact data
The analysis standardises employee records by generating government email addresses from employee names and trimming unwanted spaces from phone numbers.

```sql
UPDATE employee
SET email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov');

UPDATE employee
SET phone_number = LTRIM(RTRIM(phone_number));
```

This improves consistency in fields that can later be used for communication, matching, and reporting.

### 2. Workload is concentrated among a few field employees
The three employees with the most recorded visits are:

| Employee ID | Recorded visits |
|---:|---:|
| 1 | 3,708 |
| 30 | 3,676 |
| 34 | 3,539 |

These results justify the follow-up query in Part 2 that retrieves employee details for IDs `1`, `30`, and `34`.

### 3. Most recorded locations are rural
The `location` table contains **39,650 locations**:

| Location type | Records | Share |
|---|---:|---:|
| Rural | 23,740 | 59.9% |
| Urban | 15,910 | 40.1% |

Nearly **60%** of locations are rural, showing that the project has a strong rural-service dimension.

### 4. Geographic concentration varies by province
Location records by province are:

| Province | Records |
|---|---:|
| Kilimani | 9,510 |
| Akatsi | 8,940 |
| Sokoto | 8,220 |
| Amanzi | 6,950 |
| Hawassa | 6,030 |

Kilimani contains the largest number of recorded locations, while Hawassa has the fewest among the five provinces.

### 5. The survey represents 27.63 million people
Summing `number_of_people_served` across all recorded sources gives **27,628,140 people**.

Population coverage by source type is:

| Water source | Sources | People served | Share of people | Avg. people/source |
|---|---:|---:|---:|---:|
| Shared tap | 5,767 | 11,945,272 | 43.24% | 2,071 |
| Well | 17,383 | 4,841,724 | 17.52% | 279 |
| Tap in home | 7,265 | 4,678,880 | 16.94% | 644 |
| Tap in home broken | 5,856 | 3,799,720 | 13.75% | 649 |
| River | 3,379 | 2,362,544 | 8.55% | 699 |

### 6. Shared taps are the highest-impact source category
Shared taps make up only **5,767 of 39,650 sources**, yet they serve **43.24% of the total recorded population**.

Their average load is approximately **2,071 people per source**, far above every other source type. By comparison, wells average only **279 people per source** despite being the most common source.

This is an important prioritisation insight: infrastructure should not be ranked only by how frequently a source type appears. Population impact matters much more.

### 7. Ranking sources makes prioritisation actionable
Part 2 uses a window function to rank improvable sources within each source type:

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
    'shared_tap', 'well', 'river', 'tap_in_home_broken'
)
ORDER BY number_of_people_served DESC;
```

This approach provides a practical intervention list because each source is compared against sources facing the same type of infrastructure problem.

### 8. The field survey spans 924 days
The earliest visit was recorded on **2021-01-01 09:10**, while the latest was recorded on **2023-07-14 13:53**.

Using `DATEDIFF(MAX(time_of_record), MIN(time_of_record))`, the survey duration is **924 days**.

### 9. Queue times reveal a serious access burden
Part 2 correctly excludes zero queue times using `NULLIF(time_in_queue, 0)` when measuring the experience of people who actually waited.

The resulting average positive queue time is approximately **123.26 minutes**, rounded by the SQL query to **123 minutes**.

That means a typical non-zero wait in the surveyed data exceeds **two hours**.

### 10. Saturday is the most severe queue day
Average positive queue time by weekday:

| Day | Avg. queue time (minutes) |
|---|---:|
| Saturday | 246 |
| Monday | 137 |
| Friday | 120 |
| Tuesday | 108 |
| Thursday | 105 |
| Wednesday | 97 |
| Sunday | 82 |

Saturday stands out dramatically at about **246 minutes**, approximately **4 hours and 6 minutes** on average among records with a positive wait.

This suggests that interventions at high-pressure sources could have especially strong value on Saturdays.

### 11. Early morning and late afternoon are queue pressure points
The hourly analysis of positive queue times shows several high-wait periods:

| Hour | Avg. queue time (minutes) |
|---|---:|
| 07:00 | 149 |
| 08:00 | 149 |
| 17:00 | 149 |
| 06:00 | 149 |
| 18:00 | 147 |

The dataset also contains a **19:00** average of about **168 minutes**, but it is based on only **37 positive-queue records**, so it should be interpreted cautiously compared with the much larger samples around 06:00-08:00 and 17:00-18:00.

The broader pattern points to pronounced queue pressure in the **early morning and late afternoon/early evening**.

## SQL Quality Improvements

### Avoid hardcoding the surveyed population
The original percentage query uses the literal value `27628140` as its denominator. The value is correct for this dataset, but deriving it directly is safer and easier to maintain.

```sql
SELECT
    type_of_water_source,
    ROUND(
        100.0 * SUM(number_of_people_served)
        / (SELECT SUM(number_of_people_served) FROM water_source),
        2
    ) AS pct_served_people
FROM water_source
GROUP BY type_of_water_source
ORDER BY pct_served_people DESC;
```

### Calculate rural share dynamically
Instead of:

```sql
SELECT 23740 / (15910 + 23740) * 100;
```

use:

```sql
SELECT
    ROUND(
        100.0 * SUM(location_type = 'Rural') / COUNT(*),
        2
    ) AS rural_percentage
FROM location;
```

This keeps the result correct if the underlying data changes.

### Fix the province aggregation typo
The Part 2 script contains `fro` instead of `FROM` in the province-count query. The corrected version is:

```sql
SELECT
    province_name,
    COUNT(*) AS number_of_records
FROM location
GROUP BY province_name
ORDER BY number_of_records DESC;
```

### Make visit counts clearer
Because each row in `visits` represents a recorded visit, `COUNT(*)` communicates the intent more clearly than `COUNT(visit_count)`:

```sql
SELECT
    assigned_employee_id,
    COUNT(*) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3;
```

## Analytical Insights

### Population impact changes the priority order
A source category can be relatively uncommon but operationally critical. Shared taps demonstrate this clearly: they represent about **14.5% of water sources** but serve **43.24% of the recorded population**.

### Queue analysis identifies when access is hardest
The positive-wait average of **123.26 minutes** shows a significant access burden. Breaking this metric down by weekday and hour makes the result more actionable: Saturday and the morning/evening periods emerge as particularly important pressure points.

### Rural coverage should remain central to planning
With **59.9%** of locations classified as rural, solutions should be evaluated not only for total population reach but also for their suitability across dispersed rural locations.

### Ranking within source type supports fairer interventions
Partitioning rankings by `type_of_water_source` avoids comparing fundamentally different infrastructure problems as if they were identical. It creates separate priority queues for broken home taps, wells, rivers, and shared taps while still emphasising population served.

--- 

## 🛠️ SQL Skills Demonstrated

- **Data Cleaning** using `LOWER()`, `REPLACE()`, `LTRIM()`, and `RTRIM()` to standardize employee contact information.
- **String Manipulation** with `CONCAT()` to generate standardized employee email addresses.
- **Data Modification** using `UPDATE`, `CREATE TABLE`, and `DROP TABLE`.
- **Aggregation** with `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`.
- **Grouping & Segmentation** using `GROUP BY` to analyze employees, locations, provinces, towns, and water-source types.
- **Conditional Filtering** with `WHERE` and `IN`.
- **Window Functions** using `RANK()` and `ROW_NUMBER()`.
- **Partitioned Ranking** with `PARTITION BY` to prioritize water sources within each source type.
- **Sorting & Prioritization** using `ORDER BY` and `LIMIT`.
- **NULL Handling** with `NULLIF()` to exclude zero waiting times from queue averages.
- **Date & Time Analysis** using `DATEDIFF()`, `DAYNAME()`, `HOUR()`, `TIME_FORMAT()`, and `DATE_FORMAT()`.
- **Analytical SQL** to calculate population coverage, geographic distributions, workload, survey duration, and queue patterns.
  
---

## Part 2 Takeaway
Part 2 turns the exploratory work into a clearer prioritisation framework. The data shows that the survey covers **27.63 million people**, most recorded locations are rural, shared taps carry the largest population burden, and queue pressure is strongly concentrated at particular times. Combining geographic aggregation, population served, time analysis, and within-type rankings creates a much stronger basis for deciding where water-service improvements can have the greatest impact.

---

## 🧭 Navigation
[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)
