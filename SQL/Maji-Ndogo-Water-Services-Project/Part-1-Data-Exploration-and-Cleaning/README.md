# 🔎 Part 1: Data Exploration & Cleaning

[⬅ Back to Project Overview](../Overview/README.md) | [Next: Part 2 ➡](../Part-2-Water-Access-Analysis/README.md)

### 📌 Overview
The first stage focuses on understanding the database, exploring its core datasets, validating data quality, and turning the initial queries into measurable insights before deeper analysis begins.

**Goal: understand and validate the data before using it to make decisions.**

### 🔍 Database Exploration
```sql
SHOW TABLES;
SELECT * FROM location LIMIT 5;
SELECT * FROM visits LIMIT 5;
SELECT * FROM water_source LIMIT 5;
```

The analysis begins by inspecting the core tables and their relationships across locations, visits, water sources, water quality, pollution tests, and employees.

### 🚰 Exploring Water Sources
```sql
SELECT DISTINCT type_of_water_source
FROM water_source;
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

### 🎯 High-Impact Water Sources
Several sources investigated during Part 1 show how heavily communities can depend on a single shared tap:

| Source ID | Source type | People served |
|---|---|---:|
| AkKi00881224 | shared_tap | 3,398 |
| SoRu37635224 | shared_tap | 3,920 |
| SoRu36096224 | shared_tap | 3,786 |
| AkRu05234224 | tap_in_home_broken | 496 |
| HaZa21742224 | well | 308 |

The highest-capacity source among wells, shared taps, and rivers is **AkRu05603224**, a shared tap serving **3,998 people**.

Other high-capacity shared taps checked in this stage include **AkRu04862224** and **AmAs10911224**, each serving **3,996 people**.

#### Query correction
To find the source serving the largest population, the population value should be sorted directly rather than counted:

```sql
SELECT *
FROM water_source
WHERE type_of_water_source IN ('well', 'shared_tap', 'river')
ORDER BY number_of_people_served DESC
LIMIT 1;
```

### ⏱️ Exploring Survey Visits & Queue Pressure
The `visits` table contains **60,146 visit records**.

- **30,504** visits recorded `time_in_queue = 0`.
- **105** visits recorded queue times above **500 minutes**.
- The maximum queue time is **539 minutes**, equivalent to **8 hours 59 minutes**.
- For visits with a positive queue time, the average wait is approximately **123.26 minutes**, just over two hours.

**Insight:** Physical access to a water source does not necessarily mean convenient access. Queue time reveals a substantial time burden at some locations, with a small group of extreme cases approaching nine hours.

A useful validation query is:

```sql
SELECT
    COUNT(*) AS records_over_500_minutes,
    MAX(time_in_queue) AS max_queue_time
FROM visits
WHERE time_in_queue > 500;
```

### 🧪 Investigating Water Quality
A key validation check identifies wells incorrectly classified as clean despite elevated biological contamination:

```sql
SELECT *
FROM well_pollution
WHERE results = 'Clean'
  AND biological > 0.01;
```

The current cleaned `well_pollution` dataset contains **17,383 records**:

| Pollution result | Records |
|---|---:|
| Contaminated: Chemical | 7,093 |
| Contaminated: Biological | 5,374 |
| Clean | 4,916 |

Combined biological and chemical contamination accounts for **12,467 records**, approximately **71.7%** of the pollution-test records, while about **28.3%** are classified as clean.

**Insight:** Wells are the most common source type, but the pollution results show that availability alone cannot be treated as evidence of safe water access. Water-source coverage and water quality must be evaluated together.

### 🧹 Data Cleaning
Suspicious pollution descriptions were identified and corrected before later analysis. The cleaned data currently contains **zero** records where `results = 'Clean'` and `biological > 0.01`.

For clearer logic, the anomaly check can be written as:

```sql
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean %'
   OR (results = 'Clean' AND biological > 0.01);
```

This cleaning step protects later infrastructure analysis from contradictory water-quality classifications.

### 👥 Employee Data Exploration
Employee records are explored to establish the people dimension used later in the audit investigation, including employee name, position, phone number, and assigned employee ID.

For a question requiring a **last name beginning with A or M**, names such as `Bello Azibo` and `Zuriel Matembo` show why searching the whole employee name is too broad. A more precise MySQL condition extracts the final name component:

```sql
SELECT *
FROM employee
WHERE (phone_number LIKE '%86%' OR phone_number LIKE '%11%')
  AND (
      SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'A%'
      OR SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'M%'
  )
  AND position = 'Field Surveyor';
```

### 💡 Key Insights
- **Wells dominate source count:** 17,383 wells represent about **43.8%** of all recorded sources.
- **Shared taps dominate population impact:** 5,767 shared taps serve approximately **11.95 million people**, more than any other source type.
- **Queue burden matters:** positive queue records average approximately **123 minutes**, while the maximum reaches **539 minutes**.
- **Extreme queues exist:** **105 records** exceed 500 minutes of waiting.
- **Water quality is a major risk factor:** approximately **71.7%** of pollution-test records are classified as biologically or chemically contaminated.
- **Prioritization should be impact-based:** source type, population served, waiting time, and safety should be considered together instead of relying only on the number of available sources.

### ✅ Part 1 Takeaway
The first stage reveals that Maji Ndogo's water challenge is multidimensional. Wells are widespread, but shared taps carry the largest population load. At the same time, queue extremes create serious accessibility burdens and pollution results show substantial water-quality risk. These findings establish a stronger basis for prioritizing interventions by **population impact, accessibility, and safety**.

### 🛠️ SQL Skills Demonstrated
`SELECT` • `DISTINCT` • `WHERE` • `IN` • `LIKE` • `AND / OR` • `ORDER BY` • `COUNT` • `MAX` • `UPDATE` • String Functions • Data Validation • Data Cleaning

---

## 🧭 Navigation
[⬅ Project Overview](../Overview/README.md) | [Next: Part 2 ➡](../Part-2-Water-Access-Analysis/README.md)
