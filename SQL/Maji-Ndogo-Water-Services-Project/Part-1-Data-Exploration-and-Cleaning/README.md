# 🔎 Part 1: Data Exploration & Cleaning

[⬅ Back to Project Overview](../Overview/README.md) | [Next: Part 2 ➡](../Part-2-Water-Access-Analysis/README.md)

## 📌 Overview

The first stage focuses on understanding the database, exploring its core datasets, validating data quality, and turning the initial queries into measurable insights before deeper analysis begins.

**Goal: understand and validate the data before using it to make decisions.**

## 🔍 Database Exploration

```sql
SHOW TABLES;
SELECT * FROM location LIMIT 5;
SELECT * FROM visits LIMIT 5;
SELECT * FROM water_source LIMIT 5;
SELECT * FROM well_pollution LIMIT 5;
```

The analysis begins by inspecting the core tables and their relationships across locations, visits, water sources, water quality, pollution tests, and employees.

## 🚰 Exploring Water Sources

```sql
SELECT DISTINCT type_of_water_source
FROM water_source
ORDER BY type_of_water_source;
```

The dataset contains **39,650 water sources** across five categories:

| Water source | Sources |
|---|---:|
| Well | 17,383 |
| Tap in home | 7,265 |
| Tap in home broken | 5,856 |
| Shared tap | 5,767 |
| River | 3,379 |

**Insight:** Wells are the most common source, representing approximately **43.8%** of recorded water sources.

However, source count alone does not describe population impact:

| Water source | People served |
|---|---:|
| Shared tap | 11,945,272 |
| Well | 4,841,724 |
| Tap in home | 4,678,880 |
| Tap in home broken | 3,799,720 |
| River | 2,362,544 |

A shared tap serves approximately **2,071 people on average**. Despite having fewer individual sources than wells, shared taps serve roughly **2.47x** as many people overall.

## 🎯 High-Impact Water Sources

Several sources investigated during Part 1 show how heavily communities can depend on a single shared tap.

The highest-impact improvable source is identified by sorting `number_of_people_served` directly:

```sql
SELECT *
FROM water_source
WHERE type_of_water_source IN ('well', 'shared_tap', 'river')
ORDER BY number_of_people_served DESC
LIMIT 1;
```

## ⏱️ Exploring Survey Visits & Queue Pressure

The `visits` table is explored to identify records where no queue was recorded:

```sql
SELECT *
FROM visits
WHERE time_in_queue = 0;
```

Queue-time analysis is developed further in Part 2 using averages by weekday and hour.

## 🧪 Investigating Water Quality

A key validation check identifies wells incorrectly classified as clean despite elevated biological contamination:

```sql
SELECT *
FROM well_pollution
WHERE results = 'Clean'
  AND biological > 0.01;
```

**Insight:** Water-source availability alone cannot be treated as evidence of safe water access. Water-source coverage and water quality must be evaluated together.

## 🧹 Data Cleaning

Suspicious pollution descriptions are identified and corrected before later analysis.

```sql
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean %';
```

The final validation query checks that contradictory pollution records no longer remain:

```sql
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean %'
   OR (results = 'Clean' AND biological > 0.01);
```

This cleaning step protects later infrastructure analysis from contradictory water-quality classifications.

## 👥 Employee Data Exploration

Employee records are explored to establish the people dimension used later in the audit investigation.

For a question requiring a **last name beginning with A or M**, the SQL extracts the final name component:

```sql
SELECT *
FROM employee
WHERE (phone_number LIKE '%86%' OR phone_number LIKE '%11%')
  AND (
      SUBSTRING_INDEX(TRIM(employee_name), ' ', -1) LIKE 'A%'
      OR SUBSTRING_INDEX(TRIM(employee_name), ' ', -1) LIKE 'M%'
  )
  AND position = 'Field Surveyor';
```

## 💡 Key Insights

- **Wells dominate source count.**
- **Shared taps dominate population impact.**
- **Queue burden adds an important accessibility dimension.**
- **Water quality is a major risk factor.**
- **Prioritization should be impact-based:** source type, population served, waiting time, and safety should be considered together.

## ✅ Part 1 Takeaway

The first stage establishes a clean, validated foundation for later water-access analysis, audit investigation, and infrastructure planning.

## 🛠️ SQL Skills Demonstrated

`SELECT` • `DISTINCT` • `WHERE` • `IN` • `LIKE` • `AND / OR` • `ORDER BY` • `UPDATE` • String Functions • Data Validation • Data Cleaning

---

## 🧭 Navigation

[⬅ Project Overview](../Overview/README.md) | [Next: Part 2 ➡](../Part-2-Water-Access-Analysis/README.md)
