# 🔎 Part 1: Data Exploration & Cleaning

[⬅ Back to Project Overview](./README.md) | [Next: Part 2 ➡](../Part-2-Water-Access-Analysis/README.md)

## 📌 Overview
The first stage focuses on understanding the database, exploring its core datasets, and identifying data-quality issues before deeper analysis begins.

> **Understand and validate the data before using it to make decisions.**

## 🔍 Database Exploration
```sql
SHOW TABLES;
SELECT * FROM location LIMIT 5;
SELECT * FROM visits LIMIT 5;
SELECT * FROM water_source LIMIT 5;
```

## 🚰 Exploring Water Sources
```sql
SELECT DISTINCT type_of_water_source
FROM water_source;
```

The main source types used throughout the project include wells, rivers, shared taps, household taps, and broken household taps.

## ⏱️ Exploring Survey Visits
The `visits` table is explored to understand field visits and queue-time records, including observations where `time_in_queue = 0`.

## 🧪 Investigating Water Quality
A key validation check searches for wells classified as clean despite elevated biological readings:

```sql
SELECT *
FROM well_pollution
WHERE results = 'Clean'
  AND biological > 0.01;
```

## 🧹 Data Cleaning
Suspicious pollution descriptions are identified using patterns such as:

```sql
WHERE description LIKE 'Clean_%';
```

The affected descriptions and contamination classifications are corrected with `UPDATE` statements before later analysis.

## 👥 Employee Data Exploration
Employee records are explored to establish the people dimension used later in the audit investigation, including employee name, position, phone number, and assigned employee ID.

## 💡 Key Takeaways
- Data validation comes before analysis.
- Multiple relational tables describe different parts of the same water-service system.
- Cleaning water-quality classifications is important because later infrastructure decisions depend on contamination status.

## 🛠️ SQL Skills Demonstrated
`SELECT` • `DISTINCT` • `WHERE` • `IN` • `LIKE` • `AND / OR` • `UPDATE` • Data Validation • Data Cleaning

---

## 🧭 Navigation
[⬅ Project Overview](./README.md) | [Next: Part 2 ➡](../Part-2-Water-Access-Analysis/README.md)
