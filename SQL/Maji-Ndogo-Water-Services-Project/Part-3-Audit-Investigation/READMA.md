# 🕵️ Part 3: Data Integrity & Audit Investigation

[⬅ Part 2](../Part-2-Water-Access-Analysis/README.md) | [Project Overview](../README.md) | [Next: Part 4 ➡](../Part-4-Infrastructure-Planning/README.md)

## 📌 Overview
Part 3 evaluates the reliability of the original field-survey results by comparing surveyor water-quality scores with independent auditor assessments.

## 🔗 Building the Audit Comparison
The investigation connects `auditor_report`, `visits`, `water_quality`, `water_source`, and `employee` records.

```sql
ar.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score
```

The main comparison focuses on first visits:

```sql
v.visit_count = 1
```

## ✅ Matching and Incorrect Records
Matching scores establish consistency, while discrepancies are isolated using:

```sql
ar.true_water_source_score != wq.subjective_quality_score
```

A reusable view is created:

```sql
CREATE VIEW Incorrect_records AS (...)
```

The view connects discrepancies with location, record, scores, assigned employee, employee name, and auditor statement.

## 👥 Measuring Errors by Employee
Discrepancies are counted by employee, then compared with the average error count to identify records requiring closer review.

```text
Incorrect Records
        ↓
Errors per Employee
        ↓
Average Error Count
        ↓
Employees Above Average
```

## 🔎 Investigation Flags
The associated auditor statements are searched for references to `cash`:

```sql
statements LIKE '%cash%'
```

> **Important:** A reference to `cash`, or a difference between auditor and surveyor scores, is treated as an investigation flag only. It is not proof of misconduct by itself.

## 📐 Score Differences
The analysis also calculates the numerical difference between the two scores:

```sql
wq.subjective_quality_score
- auditorRep.true_water_source_score AS score_diff
```

## 💡 Key Insights
- Independent audit data provides an additional layer of data-quality validation.
- Linking discrepancies to employees helps reveal patterns requiring investigation.
- CTEs and views create a structured investigation pipeline.
- Suspicious patterns should be interpreted in context rather than treated as standalone conclusions.

## 🛠️ SQL Skills Demonstrated
Multi-table `JOIN`s • Views • CTEs • Subqueries • `COUNT()` • `AVG()` • Conditional Filtering • `LIKE` • Data Auditing

---

## 🧭 Navigation
[⬅ Part 2](../Part-2-Water-Access-Analysis/README.md) | [Project Overview](../README.md) | [Next: Part 4 ➡](../Part-4-Infrastructure-Planning/README.md)
