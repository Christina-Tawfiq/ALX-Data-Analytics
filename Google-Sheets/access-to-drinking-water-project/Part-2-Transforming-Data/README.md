# Access to Drinking Water – Part 2: Transforming Data

## Overview
In this second part, we transformed the dataset to investigate changes in access to drinking water between 2000 and 2020.  
We engineered new features, calculated **Annual Rates of Change (ARC)**, and compared progress across national, rural, and urban populations, as well as regions.  
We also examined how **Gross National Income (GNI)** interacts with ARC to highlight the relationship between economic growth and improvements in water access.

## Purpose
Part 2 shifts from a cross-sectional 2020 view to change over time. It calculates year differences and Annual Rates of Change (ARC), separates saturation from stagnation, compares rural and urban progress, and groups change by region.

## Part 2 Files

- [View Part 2 – TRANSFORMING DATA – Google Sheets](https://docs.google.com/spreadsheets/d/14j_BLFagojlPHK0S3b5W8C0IQHYjBErq_cFmQGQQTJo/edit?usp=sharing)
  
- [Raw Data](./Raw-Data/)

## Required workflow covered
1. Confirm the years represented and sort by country and year.
2. Calculate `y_diff` only for two observations belonging to the same country.
3. Remove true duplicate country-year observations if `y_diff = 0` under the project logic.
4. Calculate `ARC_n`, `ARC_r`, and `ARC_u` as the change in at-least-basic access divided by the actual year interval.
5. Handle missing service values without turning missingness into false zero change.
6. Create rounded basic-access features and full-access flags.
7. Count missing, full-access, positive, zero, and negative ARC cases.
8. Calculate `ARC_diff = ARC_r - ARC_u` and inspect its distribution.
9. Add region values and summarize national, rural, and urban ARC by region.

## What We Did
- Imported JMP dataset (2000–2020).
- Sorted data by country and year to ensure consistency.
- Created new features:
  - `y_diff` → Year difference per country.
  - `ARC_n`, `ARC_r`, `ARC_u` → Annual Rates of Change for national, rural, and urban populations.
  - `ARC_diff` → Difference between rural and urban ARC.
  - `ARC_full` → Flags for countries with full access (100%).
  - `region` → Added classification by region using lookup tables.
- Built summary sheets with averages, minimums, maximums, and distributions.
- Visualised ARC differences and regional progress.
- Linked ARC values with **GNI** to explore whether higher income levels correlate with faster improvements in water access.

## Key Questions Answered
- Which years are represented in the dataset?
- What is the average year difference per country?
- What is the **ARC** for national, rural, and urban areas?
- How does access to basic water change over time for different areas?
- How does ARC differ between rural and urban populations?
- How does ARC compare across regions?
- How does national population size influence ARC?
- How does **GNI** influence water access and ARC trends?
- Which regions show the greatest improvement in access to water services?
- What narrative can we build about global inequalities in water access?
  
## Time coverage
The workbook includes **462 country-year rows**, representing **231 paired country records** for the ARC workflow. Years present are **2015, 2016, 2017, 2018, 2019, and 2020**. There are 231 observations in 2015 and 213 in 2020, with smaller numbers in the intermediate years.

The calculated year differences have:
- Mean: **4.80 years**
- Median: **5 years**
- Minimum: **1 year**
- Maximum: **5 years**

**Insight:** Most comparisons span the full five-year interval, but not all do. Using the actual `y_diff` in the ARC denominator is therefore essential.

## Annual Rates of Change
ARC is expressed in **percentage points per year**.

| ARC metric | Valid observations | Mean | Median | Minimum | Maximum |
|---|---:|---:|---:|---:|---:|
| National ARC | 229 | +0.277 | +0.079 | -1.022 | +2.750 |
| Rural ARC | 167 | +0.484 | +0.290 | -1.227 | +2.668 |
| Urban ARC | 181 | +0.155 | +0.030 | -1.620 | +2.668 |

### Insight 1: Progress is positive on average
All three mean ARCs are positive. The average rural ARC is the largest, followed by national and then urban ARC.

### Insight 2: Faster rural change does not mean rural access is higher
Part 1 shows rural basic access starting from a much lower level. Part 2 shows rural access changing faster on average. Together, those findings support a **catch-up interpretation**: some rural populations have more room to improve, while many urban populations are already close to full access.

### Insight 3: Full access suppresses average ARC
The workbook flags **62 national**, **29 rural**, and **55 urban** paired cases as full access under its rounded two-year rule. A zero ARC can therefore mean either genuine stagnation below full access or already-saturated access. Those cases should be kept analytically separate.

## Direction of change excluding full-access flags
Using the workbook's ARC and full-access fields:

| Area | Positive ARC | Zero ARC | Negative ARC |
|---|---:|---:|---:|
| National | 135 | 16 | 16 |
| Rural | 116 | 5 | 17 |
| Urban | 93 | 7 | 26 |

**Insight:** Improving cases outnumber declining cases in each area among numeric, non-full-access observations. However, urban observations include more negative-ARC cases than rural observations in this workbook, despite urban access being much higher in level terms.

## Rural versus urban ARC difference
The workbook defines `ARC_diff` as rural ARC minus urban ARC.

- Valid comparisons: **165**
- Mean difference: **+0.321 percentage points/year**
- Median difference: **+0.212**
- Minimum: **-2.489**
- Maximum: **+2.329**

The two largest absolute gaps recorded are:
1. **South Sudan: 2.489 percentage points/year absolute gap**
2. **Morocco: 2.329 percentage points/year absolute gap**

A negative `ARC_diff` means urban ARC exceeded rural ARC, while a positive value means rural ARC exceeded urban ARC. The extremes show that national averages mask substantial country-level divergence.

## Regional ARC summary
Mean ARC values from the workbook's region field are:

| Region | National ARC | Rural ARC | Urban ARC |
|---|---:|---:|---:|
| East Asia & Pacific | 0.278 | 0.508 | 0.233 |
| Europe & Central Asia | 0.112 | 0.224 | 0.047 |
| Latin America & Caribbean | 0.144 | 0.680 | 0.072 |
| Middle East & North Africa | 0.346 | 0.737 | 0.124 |
| North America | 0.017 | 0.142 | 0.002 |
| South Asia | 0.480 | 0.559 | 0.266 |
| Sub-Saharan Africa | 0.558 | 0.604 | 0.270 |

### Regional insight
National ARC is highest in the workbook's **Sub-Saharan Africa** group, while rural ARC is highest in the workbook's **Middle East & North Africa** group. Urban ARC is highest in **Sub-Saharan Africa**. These averages should not be read as final development rankings because valid ARC counts differ by region and area, and starting access levels differ substantially.

## Data-quality cautions
- Missingness is much heavier for rural and urban service histories than for national values, which lowers the number of valid rural and urban ARC calculations.
- Region results use the region labels already present in the workbook. Any unexpected classification should be reviewed against the original region mapping before publication.
- Positive average ARC should not be extrapolated mechanically into a year of universal access. Such projections require explicit assumptions about whether the historical rate continues and how saturation affects the trajectory.
- ARC is a rate of change in percentage points, not a percent growth rate.

## Final Part 2 takeaway
The time-based analysis shows **net improvement in basic-water access, with rural access improving faster on average than urban access**, but progress is uneven. High-access settings often have small or zero ARC because they are near saturation, whereas lower-access settings can record larger gains and larger rural-urban differences. The most useful interpretation therefore combines **starting level, ARC, full-access status, missingness, and region** rather than ranking countries or regions by ARC alone.
