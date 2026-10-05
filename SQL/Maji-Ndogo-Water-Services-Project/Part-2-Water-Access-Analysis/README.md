# 📊 Part 2: Water Access & Queue Analysis

[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)

## 📌 Overview
Part 2 moves from data preparation to understanding how water infrastructure serves the population, how sources are distributed, and where queue pressure appears.

## 👥 Preparing Employee Information
Email addresses are generated from employee names with string functions, while phone numbers are checked and trimmed.

```sql
CONCAT(
    LOWER(REPLACE(employee_name, ' ', '.')),
    '@ndogowater.gov'
)
```

## 🌍 Geographic Distribution
Water-service records are aggregated across towns, provinces, and location types to provide geographic context for the analysis.

## 🚰 Water Source Distribution
The analysis evaluates three complementary measures:

```sql
COUNT(type_of_water_source)
AVG(number_of_people_served)
SUM(number_of_people_served)
```

This separates infrastructure availability from the population depending on that infrastructure.

## 🏆 Ranking Water Sources
Source categories and individual improvable sources are prioritized using window functions.

```sql
RANK() OVER (
    ORDER BY SUM(number_of_people_served) DESC
)
```

```sql
ROW_NUMBER() OVER (
    PARTITION BY type_of_water_source
    ORDER BY number_of_people_served DESC
)
```

The prioritization focuses on shared taps, wells, rivers, and broken household taps.

## ⏱️ Queue-Time Analysis
Average queue time excludes zero values:

```sql
ROUND(AVG(NULLIF(time_in_queue, 0)))
```

Queue patterns are then explored by day of week and hour of day using date/time functions.

## 💡 Key Insights
- Population impact adds context beyond simply counting water sources.
- Source availability and population dependence answer different analytical questions.
- Queue time is an important accessibility measure for shared infrastructure.
- Window functions provide a systematic way to prioritize high-impact sources.

## 🛠️ SQL Skills Demonstrated
String Functions • `COUNT()` • `SUM()` • `AVG()` • `NULLIF()` • `GROUP BY` • Date/Time Functions • `RANK()` • `ROW_NUMBER()` • `PARTITION BY`

---

## 🧭 Navigation
[⬅ Part 1](../Part-1-Data-Exploration-and-Cleaning/README.md) | [Project Overview](../Overview/README.md) | [Next: Part 3 ➡](../Part-3-Audit-Investigation/README.md)
