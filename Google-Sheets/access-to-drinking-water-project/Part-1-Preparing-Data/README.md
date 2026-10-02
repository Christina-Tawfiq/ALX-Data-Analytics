# Access to Drinking Water | Part 1: Understanding the Data

## Overview
In this first part, we cleaned and prepared WHO/UNICEF JMP data to make it suitable for analysis.  
The dataset includes population estimates, urban/rural distribution, service levels (safely managed, basic, limited, unimproved, surface water), and economic indicators such as **Gross National Income (GNI)**.

## Purpose
Part 1 builds and validates the 2020 analytical snapshot, then explores how drinking-water access varies by area type, population characteristics, and income group.

## Part 1 Files

- [View Part 1 – PREPARING DATA – Google Sheets](https://docs.google.com/spreadsheets/d/1hnKiyyvtD9Fu4pFC99G-85hFez5bv7qaPcxG6alWCwQ/edit?usp=sharing)

- [Raw Data](./Raw-Data/)

## Required workflow covered
The project instructions require the following sequence:

1. Import and repair the dataset so the original 16 features are correctly separated.
2. Check row completeness with a `value_cnt` approach when repairing import problems.
3. Create population features such as actual national population, urban population value, rural share, and rounded population measures.
4. Compare the dataset population with the 2020 world-population reference in a Global 2020 Report.
5. Calculate central tendency and spread for the 12 national/rural/urban service-level measures.
6. Visualize urban versus rural population shares, water access by population size, and the five-number summaries.
7. Group countries by income category and compare population, urbanisation, and national water-access measures.

## What We Did
- Imported raw JMP dataset into Google Sheets.
- Cleaned missing values and handled inconsistencies.
- Created new features:
  - Rounded service levels (`wat_bas_n (rounded)`).
  - Population splits (urban vs rural).
  - Actual population values (`pop_n_actual`, `pop_u_val`).
- Integrated **GNI data** to explore how economic development influences water access.

## Key Questions Answered
- How do the world population estimates compare to the provided dataset populations?
- How does the urban population share compare to the rural population?
- What is the tendency and spread of the different water access features?
- How do these measures of water access compare across different types of areas?
- What does the national access to water look like based on national population size?
- What does the urban access to water look like based on urban population size?
- What does the rural access look like?
- What is the effect of national population size and urbanisation on **GNI** and water access?

## Dataset snapshot
The workbook contains **213 country/area rows**. Of these, 197 have a named income classification and 16 show `NAN` for income group.

### Population coverage
- Dataset national population total: **7.787 billion**.
- Project world-population reference: **7.821 billion**.
- Absolute gap: about **34.3 million people**.
- Percentage difference using the project's symmetric percentage-difference method: about **0.44%**.
- Dataset urban population: approximately **4.375 billion**.
- Dataset population-weighted urban share: **56.19%**.
- Project reference urban share: **55%**, equivalent to about **4.302 billion** people.

**Insight:** The dataset is close enough to the project world estimate to support global-scale interpretation, but it should not be described as an exact census of the world population.

## Access by area

| Measure | National | Rural | Urban |
|---|---:|---:|---:|
| Mean at-least-basic access | 89.86% | 81.34% | 94.69% |
| Median | 97.35% | 90.73% | 98.11% |
| Q1 | 85.64% | 64.83% | 92.56% |
| Q3 | 99.89% | 99.12% | 99.95% |
| Minimum | 37.20% | 21.98% | 49.66% |

### Insight 1: Urban access is highest, rural access is lowest
The mean rural-to-urban gap in at-least-basic access is approximately **13.35 percentage points**. The national mean sits between the two, which is consistent with a national measure reflecting the combined population.

### Insight 2: Rural inequality is much wider
The rural basic-access IQR is roughly **34.29 percentage points**, compared with only **7.39 points** for urban access. The typical urban observation is therefore both higher and more tightly concentrated near universal basic access.

### Insight 3: Lower service levels are concentrated in rural areas
Average rural shares are **5.84% limited**, **8.73% unimproved**, and **4.22% surface water**, versus urban averages of **3.28%**, **1.72%**, and **0.31%** respectively. Surface-water dependence is especially more pronounced in rural observations.

## Income-group pattern
Mean national at-least-basic access by income group is:

| Income group | Mean basic access | Median basic access |
|---|---:|---:|
| Low income | 62.82% | 61.44% |
| Lower middle income | 82.21% | 85.50% |
| Upper middle income | 96.43% | 97.06% |
| High income | 99.56% | 100.00% |

**Insight:** The gradient is strong and monotonic in this workbook. Higher income categories are associated with substantially higher national access to at-least-basic water services. This is descriptive association, not proof that income alone causes the difference.

## Distribution insight
National basic access has a **high median of 97.35%** but a lower mean of **89.86%**. This indicates a concentration near high access values with a smaller group of low-access countries pulling the average downward. Limited, unimproved, and surface-service distributions show the opposite concentration: their medians are low, with relatively fewer observations carrying much larger values.

## Visualisation interpretation guide
- **Urban vs rural share chart:** use it to inspect composition, not to imply that population size directly causes urbanisation.
- **100% stacked service charts:** compare the composition of service levels across population bins while retaining the fact that service shares form a whole.
- **Box/candlestick summaries:** emphasize median, quartiles, and range. The rural series should appear more dispersed than the urban series, particularly for basic, unimproved, and surface access.
- **Income-group pivot:** treat differences as associations across grouped economies and avoid causal claims.

## Data-quality cautions
- Valid counts differ across water features. National basic access has 211 numeric observations, rural has 164, and urban has 175. Direct comparisons should therefore note missingness.
- Raw `wat_bas_n` reaches slightly above 100 because of floating-point/source precision. The project explicitly handles this with a rounded derived field.
- `NAN` income categories should remain separate from the four ordered income groups unless their classifications are sourced independently.

## Final Part 1 takeaway
The 2020 snapshot shows broadly high access to at-least-basic drinking water, but the headline average hides a pronounced **rural disadvantage** and a strong **income-group gradient**. The main analytical gap is not simply whether access exists, but where low-access and higher-risk service categories remain concentrated.
