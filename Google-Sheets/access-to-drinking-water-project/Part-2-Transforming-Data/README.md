# Access to Drinking Water | Part 2: Transforming the Data

## Overview
Part 2 transforms the JMP country-year dataset to investigate how at-least-basic drinking-water access changes over time. The analysis calculates Annual Rates of Change (ARC) for national, rural, and urban populations and compares progress across countries and regions.

## Purpose
The objective is to move beyond a single-year access snapshot and determine whether drinking-water access is improving, stagnating, or declining, while accounting for unequal observation intervals and countries already at full access.

## Part 2 Files

- [View Part 2 – TRANSFORMING DATA – Google Sheets](https://docs.google.com/spreadsheets/d/14j_BLFagojlPHK0S3b5W8C0IQHYjBErq_cFmQGQQTJo/edit?usp=sharing)
  
- [Raw Data](./Raw-Data/)  WHO/UNICEF JMP Estimates on the Use of Water time-series dataset.
- [Analyzed Data](./Analyzed-Data/) TRANSFORMING DATA
- [Screenshots](./Screenshots/)  Visualisations are stored separately in the project screenshots folder.

## Analytical Workflow
1. Imported the JMP time-series dataset.
2. Sorted observations by `name` and `year`.
3. Created `y_diff` to calculate the interval between observations from the same country.
4. Used `y_diff = 0` as the project check for duplicate country-year observations.
5. Calculated:
   - `ARC_n` for national at-least-basic access
   - `ARC_r` for rural at-least-basic access
   - `ARC_u` for urban at-least-basic access
6. Preserved missing service observations rather than converting them into false zero-change values.
7. Created rounded basic-access fields and `ARC_n_full`, `ARC_r_full`, and `ARC_u_full` flags to distinguish full access from zero ARC below full access.
8. Calculated `ARC_diff = ARC_r - ARC_u` to compare rural and urban progress.
9. Added the workbook region classification and summarised ARC by region.
10. Created population-size measures for examining ARC across national population groups.

## ARC Definition
ARC is the average annual change in at-least-basic drinking-water access:

`ARC_x = (wat_bas_x at later year - wat_bas_x at earlier year) / year difference`

where `x` represents national (`n`), rural (`r`), or urban (`u`) access.

ARC is measured in **percentage points per year**, not percentage growth.

## Key Questions
- Which years are represented in the analytical workbook?
- How large are the intervals between country observations?
- What is the ARC for national, rural, and urban populations?
- Is basic-water access improving or declining?
- Is rural access changing faster than urban access?
- How does ARC vary across regions?
- How does national population size relate to ARC patterns?

## Time Coverage
The analytical workbook contains **462 country-year rows**, corresponding to **231 country comparisons** in the ARC workflow.

Years represented in the workbook are:

- 2015
- 2016
- 2017
- 2018
- 2019
- 2020

There are **231 observations in 2015** and **213 in 2020**, with fewer observations in the intermediate years.

### Year-Difference Summary
- Mean: **4.80 years**
- Median: **5 years**
- Minimum: **1 year**
- Maximum: **5 years**

### Insight
Most country comparisons cover five years, but some cover shorter intervals. Dividing by the actual `y_diff` is therefore essential. Using a fixed five-year denominator for every country would distort the annual rate for countries with shorter intervals.

## Annual Rates of Change

| ARC metric | Valid observations | Mean | Median | Minimum | Maximum |
|---|---:|---:|---:|---:|---:|
| National ARC | 229 | +0.277 | +0.079 | -1.022 | +2.750 |
| Rural ARC | 167 | +0.484 | +0.290 | -1.227 | +2.668 |
| Urban ARC | 181 | +0.155 | +0.030 | -1.620 | +2.668 |

### Insight 1: Access is improving on average
The mean ARC is positive for national, rural, and urban populations. This indicates overall improvement among the observations with valid ARC values.

### Insight 2: Rural access is improving fastest on average
Average rural ARC is approximately **0.484 percentage points per year**, compared with **0.155 in urban areas**.

This does not mean rural access is higher. Part 1 shows that rural populations begin from a much lower access level. The stronger rural ARC is therefore better interpreted as evidence of **catch-up from a lower baseline**.

### Insight 3: Median ARC is much lower than mean ARC
The national mean ARC is **0.277**, while the median is only **0.079**. Rural and urban ARCs show similar mean-median gaps.

This indicates that a smaller group of faster-improving observations raises the average. Improvement is therefore positive overall but unevenly distributed.

## Full Access vs Stagnation
The workbook flags:

- **62 national** full-access cases
- **29 rural** full-access cases
- **55 urban** full-access cases

### Insight
A zero or near-zero ARC is not automatically a poor outcome. Countries already at or near full access have little room for additional improvement. Separating full-access observations from below-full-access stagnation prevents mature, high-access systems from being misclassified as underperforming.

## Direction of Change
Excluding observations flagged as full access:

| Area | Positive ARC | Zero ARC | Negative ARC |
|---|---:|---:|---:|
| National | 135 | 16 | 16 |
| Rural | 116 | 5 | 17 |
| Urban | 93 | 7 | 26 |

### Insight
Positive ARC observations outnumber declining observations in all three areas. However, negative ARC values remain present, showing that global progress is not universal.

Urban access has more negative-ARC observations than rural access in this workbook even though urban access levels are much higher overall. This reinforces the need to analyse **level and change separately**.

## Rural vs Urban ARC
`ARC_diff` is calculated as:

`ARC_diff = ARC_r - ARC_u`

For **165 valid rural/urban comparisons**:

- Mean: **+0.321 percentage points/year**
- Median: **+0.212**
- Minimum: **-2.489**
- Maximum: **+2.329**

### Insight
Both the mean and median are positive, showing that rural ARC exceeds urban ARC for the typical comparable observation in this dataset.

The spread from negative to positive values also demonstrates substantial country-level variation. Rural catch-up is an overall pattern, not a universal rule.

### Largest Absolute Rural-Urban ARC Gaps
1. **South Sudan:** approximately **2.489 percentage points/year**
2. **Morocco:** approximately **2.329 percentage points/year**

These cases demonstrate how strongly rural and urban trajectories can diverge within individual countries.

## Regional ARC Summary

| Region | National ARC | Rural ARC | Urban ARC |
|---|---:|---:|---:|
| East Asia & Pacific | 0.278 | 0.508 | 0.233 |
| Europe & Central Asia | 0.112 | 0.224 | 0.047 |
| Latin America & Caribbean | 0.144 | 0.680 | 0.072 |
| Middle East & North Africa | 0.346 | 0.737 | 0.124 |
| North America | 0.017 | 0.142 | 0.002 |
| South Asia | 0.480 | 0.559 | 0.266 |
| Sub-Saharan Africa | 0.558 | 0.604 | 0.270 |

### Regional Insights
- The highest mean **national ARC** in the workbook is recorded for **Sub-Saharan Africa** at approximately **0.558 percentage points/year**.
- The highest mean **rural ARC** is recorded for **Middle East & North Africa** at approximately **0.737**.
- The highest mean **urban ARC** is recorded for **Sub-Saharan Africa** at approximately **0.270**.

These results describe speed of improvement, not absolute access. Regions with faster ARC may still have lower starting access levels, while mature high-access regions may show slower change because they are closer to saturation.

## Combined Analytical Story
Part 1 and Part 2 complement each other:

- **Part 1 shows the access gap:** rural populations have lower basic-water access and much wider variation.
- **Part 2 shows the direction of travel:** rural access is improving faster on average.

Together, the results suggest partial convergence. The rural gap remains substantial, but the higher average rural ARC indicates that some of the largest access deficits are improving more quickly than already high-access urban systems.

## Data-Quality Considerations
- Rural and urban histories contain more missing values than national histories, reducing valid rural and urban ARC samples.
- ARC is calculated only when comparable country observations and valid water-access values are available.
- Full-access flags should be considered when interpreting zero or very small ARC values.
- Regional averages use the classifications contained in the workbook and should be interpreted with their differing valid sample sizes.
- Historical ARC describes observed change between available years. It should not be mechanically extrapolated into a predicted date of universal access.

## Final Takeaway
The time-based analysis shows **overall improvement in access to at-least-basic drinking water**, but the pace of progress is uneven.

Rural access improves faster on average than urban access, supporting a catch-up interpretation, while country and regional differences remain substantial. The strongest interpretation combines **starting access level, ARC, full-access status, missingness, population context, and region** rather than relying on a single rate or ranking.

