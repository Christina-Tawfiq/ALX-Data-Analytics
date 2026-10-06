# 💧 Maji Ndogo Water Services Analysis

## 📌 Project Overview

This project presents an end-to-end SQL analysis of water services in Maji Ndogo, moving from database exploration and data cleaning to water-access analysis, audit investigation, and infrastructure planning.

The project is organized into four connected analytical stages:

1. **Data Exploration & Cleaning**
2. **Water Access & Queue Analysis**
3. **Data Integrity & Audit Investigation**
4. **Infrastructure Improvement Strategy**

The overall workflow is:

**Explore → Clean → Analyze → Validate → Prioritize → Act**

---

## 🎯 Project Objectives

The analysis focuses on the following questions:

- What water-source types are represented in the database?
- How many people depend on each type of water source?
- Where do queue times create additional accessibility pressure?
- Which wells have water-quality problems?
- How consistent are surveyor water-quality scores with independent auditor scores?
- Which problematic sources should be prioritized for improvement?
- Which intervention is appropriate for each type of problem?

---

## 🧭 Project Roadmap

| Part | Focus | Documentation |
|---|---|---|
| **01** | 🔎 Data Exploration & Cleaning | [View Part 1](../Part-1-Data-Exploration-and-Cleaning) |
| **02** | 📊 Water Access & Queue Analysis | [View Part 2](../Part-2-Water-Access-Analysis) |
| **03** | 🕵️ Data Integrity & Audit Investigation | [View Part 3](../Part-3-Audit-Investigation) |
| **04** | 🚧 Infrastructure Improvement Strategy | [View Part 4](../Part-4-Infrastructure-Planning) |

---

## 🔎 Part 1: Data Exploration & Cleaning

The first stage explores the main database tables, water-source categories, survey visits, water-quality information, well-pollution records, and employee data.

A key cleaning task checks wells recorded as `Clean` against biological measurements and corrects inconsistent pollution descriptions and classifications before deeper analysis.

**Core SQL:** `SELECT`, `DISTINCT`, `WHERE`, `LIKE`, `IN`, `UPDATE`

📖 [Detailed Part 1 README](../Part-1-Data-Exploration-and-Cleaning/README.md)

---

## 📊 Part 2: Water Access & Queue Analysis

The second stage investigates how water infrastructure serves the population.

The analysis covers:

- Geographic distribution by town and province
- Water-source counts
- Average population served per source
- Total population served by source type
- Ranking high-impact, improvable water sources
- Average queue time
- Queue patterns by day and hour

Window functions such as `RANK()` and `ROW_NUMBER()` are used to create a systematic prioritization framework.

📖 [Detailed Part 2 README](../Part-2-Water-Access-Analysis/README.md)

---

## 🕵️ Part 3: Data Integrity & Audit Investigation

The third stage compares original surveyor water-quality scores with independent auditor assessments.

The investigation connects audit records with visits, water-quality records, and employee information. Records where the two scores disagree are isolated, and discrepancies are counted by employee.

The analysis then identifies employees with above-average discrepancy counts and reviews associated auditor statements for additional investigation signals.

One SQL filter searches those statements for:

```sql
statements LIKE '%cash%'
```

> **Important:** Score discrepancies and references to `cash` are treated as investigation flags only. They do not establish misconduct on their own.

📖 [Detailed Part 3 README](../Part-3-Audit-Investigation/README.md)

---

## 🚧 Part 4: Infrastructure Improvement Strategy

The final stage combines important information into a reusable analysis layer containing location, source type, population served, queue time, and well-pollution results.

The analysis evaluates access at province and town level and translates different water problems into specific proposed interventions.

| Problem | Proposed Intervention |
|---|---|
| Biological contamination | Install UV and RO filter |
| Chemical contamination | Install RO filter |
| River dependence | Drill well |
| Shared tap with excessive queue time | Install additional nearby taps |
| Broken household tap | Diagnose local infrastructure |

A `Project_progress` table is also designed to track selected sources from backlog through implementation and completion.

📖 [Detailed Part 4 README](../Part-4-Infrastructure-Planning/README.md)

---

## 💡 Key Analytical Takeaways

### 1. Water-source count and population impact are different measures
A source type can have fewer physical sources while still serving a large population, so infrastructure decisions benefit from considering both measures.

### 2. Queue time adds an accessibility dimension
For shared taps, availability alone does not fully describe access. Waiting time provides additional operational context.

### 3. Infrastructure presence does not guarantee functionality
The distinction between `tap_in_home` and `tap_in_home_broken` makes it possible to separate household connections from working household connections.

### 4. Water quality must be considered alongside physical access
Well-pollution results identify biological and chemical contamination, so safe access requires more than simply having a nearby source.

### 5. Independent audit data provides an additional validation layer
Auditor scores make it possible to identify survey records that require closer review.

### 6. SQL can connect analysis to implementation
The final stage converts identified problems into intervention rules and creates a project-tracking structure for implementation.

---

## 🛠️ SQL Skills Demonstrated

- Data exploration
- Data cleaning and validation
- Aggregations
- String manipulation
- Date and time analysis
- Multi-table joins
- Common Table Expressions (CTEs)
- Subqueries
- Views
- Temporary tables
- Window functions
- Conditional aggregation
- `CASE WHEN` business logic
- Table creation and constraints
- `INSERT INTO ... SELECT`

---

## 📂 Repository Structure

```text
SQL/
└── Maji-Ndogo-Water-Services-Project/
    │
    ├── Overview/
    │   └── README.md
    │
    ├── Raw-Data/
    │   ├── Md_water_services_data.xlsx
    │   ├── Data_dictionary.pdf
    │   ├── Auditor_report.csv
    │   └── Data dictionary_ auditor_report.pdf
    │
    ├── Part-1-Data-Exploration-and-Cleaning/
    │   ├── README.md
    │   └── SQL_PART1_FINAL.sql
    │
    ├── Part-2-Water-Access-Analysis/
    │   ├── README.md
    │   └── SQL_PART2_FINAL.sql
    │
    ├── Part-3-Audit-Investigation/
    │   ├── README.md
    │   └── SQL_PART3_FINAL.sql
    │
    └── Part-4-Infrastructure-Planning/
        ├── README.md
        └── SQL_PART4_FINAL.sql
```

---

## 🚀 Conclusion

The Maji Ndogo Water Services project demonstrates a complete SQL analytical workflow that begins with raw operational data and progresses through cleaning, exploration, population and queue analysis, audit validation, geographic analysis, prioritization, and infrastructure planning.

The final result is a structured data-analysis project that connects technical SQL work with practical decision-making.

---

## 👩‍💻 Author

**Christina Tawfiq**  
SQL Data Analysis Portfolio Project
