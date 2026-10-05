# 🚧 Part 4: Infrastructure Planning

[⬅ Part 3](../Part-3-Audit-Investigation/README.md) | [Project Overview](../Overview/README.md)

## 📌 Overview
The final stage transforms previous findings into an actionable infrastructure strategy by connecting geographic conditions, water quality, population served, and queue pressure with proposed interventions.

## 🧩 Building a Combined Analysis Layer
A reusable `combined_analysis_table` brings together province, town, water-source type, population served, location type, queue time, and well-pollution results.

## 🌍 Province-Level Water Access
Population totals are calculated by province, then conditional aggregation estimates the contribution of each water-source type.

```sql
SUM(
    CASE
        WHEN type_of_water_source = 'river'
        THEN number_of_people_served
        ELSE 0
    END
)
```

## 🏘️ Town-Level Water Access
Town-level analysis uses both `province_name` and `town_name`, and a temporary table named `town_aggregated_water_access` stores town-level source percentages.

## 🔧 Broken Household Infrastructure
The analysis evaluates broken household connections relative to total household tap infrastructure:

```sql
tap_in_home_broken /
(tap_in_home_broken + tap_in_home)
```

## 🚰 Translating Problems Into Actions
| Problem | Proposed Intervention |
|---|---|
| Biological contamination | Install UV and RO filter |
| Chemical contamination | Install RO filter |
| River dependence | Drill well |
| Shared tap with queue time ≥ 30 | Install additional nearby taps |
| Broken household tap | Diagnose local infrastructure |

Additional taps are estimated using:

```sql
FLOOR(time_in_queue / 30)
```

## 📋 Project Progress Tracking
A `Project_progress` table connects recommendations with implementation tracking. It includes source information, location, intervention, status, completion date, and comments.

Allowed status values are:

```text
Backlog
In progress
Complete
```

## 💡 Key Insights
- Different water-access problems require different interventions.
- Geographic aggregation supports targeted planning.
- Reusable views simplify repeated analysis.
- The final SQL layer connects analytical findings with trackable implementation actions.

## 🛠️ SQL Skills Demonstrated
Multi-table Joins • Views • CTEs • Temporary Tables • Conditional Aggregation • `CASE WHEN` • Percentage Calculations • Constraints • Foreign Keys • `INSERT INTO ... SELECT`

## 🏁 Final Outcome
```text
Explore → Clean → Analyze → Validate → Investigate → Prioritize → Recommend → Track
```

---

## 🧭 Navigation
[⬅ Part 3](../Part-3-Audit-Investigation/README.md) | [Project Overview](../Overview/README.md)
