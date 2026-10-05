# 📊 Part 2: Water Access & Queue Analysis

[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)

## Overview
Part 2 turns the cleaned survey database into an operational picture of Maji Ndogo: who collected the data, where the survey was concentrated, how residents access water, and when queues are worst. The emphasis is not just on SQL syntax, but on measurable findings that can guide prioritisation.

## Key Results
| Metric | Result |
|---|---:|
| Locations surveyed | 39,650 |
| Rural locations | 23,740 (59.9%) |
| Urban locations | 15,910 (40.1%) |
| Estimated people represented by water sources | 27,628,140 |
| Survey period | 1 Jan 2021 to 14 Jul 2023 |
| Survey duration | 924 days |
| Average positive queue time | 123.26 minutes |

## 1. Employee Data Cleaning
Employee email addresses were standardized from employee names using `LOWER()`, `REPLACE()` and `CONCAT()`. Phone numbers were checked with `LENGTH()` and cleaned with `LTRIM()` / `RTRIM()`.

A copy of the employee table was created before applying updates, providing a safer place to validate the transformation before changing the main table.

### SQL used
```sql
SELECT
 assigned_employee_id,
 COUNT( visit_count ) AS NUMBER_OF_VISITS
FROM
    visits
GROUP BY assigned_employee_id
ORDER BY NUMBER_OF_VISITS desc
LIMIT 3 ;
```

## 2. Employee Workload
The visit table was grouped by `assigned_employee_id` to identify the most active surveyors.

| Rank | Employee ID | Visits |
|---:|---:|---:|
| 1 | 1 | 3,708 |
| 2 | 30 | 3,676 |
| 3 | 34 | 3,539 |

**Insight:** The busiest surveyors each recorded more than 3,500 visits. This concentration makes employee-level validation important later in the project because individual data-quality issues could affect many records.

## 3. Geographic Coverage
### SQL used
```sql
SELECT
      location_type ,
      COUNT(location_type) AS number_of_sources
from
      location
group by location_type;

SELECT 23740 / (15910 + 23740) * 100;
```

### Rural vs Urban
| Location type | Records | Share |
|---|---:|---:|
| Rural | 23,740 | 59.9% |
| Urban | 15,910 | 40.1% |

The dataset is therefore weighted toward rural locations.

### SQL used
```sql
SELECT
       province_name,
       COUNT(province_name) AS number_of_records
from
      location
group by province_name;
```

### Records by Province
| Province | Location records |
|---|---:|
| Kilimani | 9,510 |
| Akatsi | 8,940 |
| Sokoto | 8,220 |
| Amanzi | 6,950 |
| Hawassa | 6,030 |

**Insight:** Kilimani has the largest geographic representation in the survey, while Hawassa has the smallest of the five provinces. These counts describe survey coverage, not population size.

### SQL used
```sql
select
       type_of_water_source,
       count(type_of_water_source) AS total_number
from water_source
group by type_of_water_source
order by total_number desc;

select
       type_of_water_source,
       round(AVG(number_of_people_served)) AS avg_people_served
from water_source
group by type_of_water_source
order by avg_people_served desc;

SELECT
type_of_water_source,
sum(number_of_people_served) AS total_served_people
from water_source
GROUP BY type_of_water_source
order by total_served_people DESC;

SELECT
type_of_water_source,
round((sum(number_of_people_served)/27628140)*100) AS pct_served_people
from water_source
GROUP BY type_of_water_source
order by pct_served_people DESC;
```

## 4. Water Access Profile
| Source type | Sources | People served | Share of people | Avg. people/source |
|---|---:|---:|---:|---:|
| shared_tap | 5,767 | 11,945,272 | 43.24% | 2,071 |
| well | 17,383 | 4,841,724 | 17.52% | 279 |
| tap_in_home | 7,265 | 4,678,880 | 16.94% | 644 |
| tap_in_home_broken | 5,856 | 3,799,720 | 13.75% | 649 |
| river | 3,379 | 2,362,544 | 8.55% | 699 |

### What this reveals
- **Shared taps are the largest population dependency:** 43.24% of the surveyed population relies on them, and each shared tap serves about 2,071 people on average.
- **Wells are numerous but individually small:** wells account for 17,383 of the 39,650 sources, yet serve about 279 people per source on average.
- **Broken household infrastructure is material:** broken home taps represent 13.75% of the people served, making infrastructure repair a potentially high-impact intervention.
- **River dependence remains significant:** more than 2.36 million people are represented by river sources.

## 5. Prioritising Improvable Sources
`RANK()` ranks source categories by total population served, while `ROW_NUMBER()` with `PARTITION BY` produces an independent priority list inside each improvable source type.

```sql
ROW_NUMBER() OVER (
  PARTITION BY type_of_water_source
  ORDER BY number_of_people_served DESC
) AS priority_rank
```

The prioritisation excludes functioning `tap_in_home` sources and focuses on `shared_tap`, `well`, `river`, and `tap_in_home_broken`.

**Insight:** Ranking by population served shifts the question from "how many sources exist?" to "where can an intervention affect the most people?" This is especially important for shared taps, where relatively few facilities serve a very large share of the population.

### SQL used
```sql
select
round(avg(nullif(time_in_queue,0))) as average_queue_time
from visits;

select
dayname(time_of_record) as week_day,
round(avg(nullif(time_in_queue,0))) as average_queue_time
from visits
group by week_day
order by average_queue_time desc;

select
hour(time_of_record) as hour_OF_day,
round(avg(nullif(time_in_queue,0))) as average_queue_time
from visits
group by hour_OF_day
order by average_queue_time desc;
```

## 6. Queue-Time Analysis
Zero-minute queue records were removed from the waiting-time average through `NULLIF(time_in_queue, 0)`.

### Average queue by weekday
| Day | Avg. positive queue time (min) |
|---|---:|
| Saturday | 246.3 |
| Monday | 136.6 |
| Friday | 119.7 |
| Tuesday | 107.9 |
| Thursday | 105.4 |
| Wednesday | 96.6 |
| Sunday | 81.5 |

**Insight:** Saturday is the clear pressure point, with an average positive wait of about 246 minutes, approximately double the overall positive-queue average of 123.26 minutes.

### Highest hourly averages
| Hour | Avg. positive queue time (min) |
|---|---:|
| 19:00 | 167.7 |
| 07:00 | 149.1 |
| 08:00 | 148.9 |
| 06:00 | 148.9 |
| 17:00 | 148.8 |
| 18:00 | 146.8 |

**Insight:** Queue pressure is concentrated around early morning and evening periods. Combined with the Saturday peak, this provides a useful basis for scheduling temporary water support or prioritising high-demand shared taps.

## SQL Skills Demonstrated
- Data cleaning with `LOWER`, `REPLACE`, `LTRIM`, `RTRIM`, `LENGTH`
- Data modification with `CREATE TABLE`, `UPDATE`, `DROP TABLE`
- Aggregation with `COUNT`, `SUM`, `AVG`
- Geographic grouping with multi-column `GROUP BY`
- Filtering with `WHERE` and `IN`
- Window functions with `RANK()` and `ROW_NUMBER()`
- Partitioned ranking with `PARTITION BY`
- NULL handling using `NULLIF()`
- Date/time analysis with `DATEDIFF`, `DAYNAME`, `HOUR`, `TIME_FORMAT`, `DATE_FORMAT`


## Takeaway
Part 2 establishes the scale of the water-access challenge. Shared taps serve the largest share of residents, nearly 60% of surveyed locations are rural, and positive queue times average more than two hours. The combination of population-based ranking and time-based queue analysis provides a defensible foundation for deciding which water sources should be improved first.

---

## 🧭 Navigation
[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)
