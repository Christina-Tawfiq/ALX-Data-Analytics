# Access to Drinking Water | Part 1: Understanding the Data

## Overview
Part 1 prepares and investigates the WHO/UNICEF JMP 2020 drinking-water dataset. The analysis moves from data cleaning and population validation to descriptive analysis of water-service access across national, rural, urban, population-size, and income-group dimensions.

## Purpose
The objective is to build a reliable 2020 analytical snapshot and identify the main inequalities hidden behind global access averages.

## Part 1 Files

- [View Part 1 – PREPARING DATA – Google Sheets](https://docs.google.com/spreadsheets/d/1hnKiyyvtD9Fu4pFC99G-85hFez5bv7qaPcxG6alWCwQ/edit?usp=sharing)

- [Raw Data](./Raw-Data/) WHO/UNICEF JMP Estimates on the Use of Water (2020)
- [Analyzed Data](./Analyzed_Data/)
- [Screenshots](./Screenshots/)  Visualisations are stored separately in the project screenshots folder.

## Analytical Workflow
1. Imported the raw 2020 JMP dataset.
2. Repaired inconsistent separators so the original 16 variables were correctly separated.
3. Used `value_cnt` with `COUNTA()` to identify rows that did not contain the expected 16 populated cells during the import-cleaning process.
4. Handled missing values represented by `NAN` without treating them as zeros.
5. Created derived population features, including:
   - `pop_n_actual`
   - `pop_u_val`
   - `pop_r%`
   - `pop_n (m)`
   - rounded population and access fields used in grouped analysis
6. Built the Global 2020 Report to compare dataset population coverage with the project world-population reference.
7. Summarised the central tendency and spread of the 12 national, rural, and urban service-level variables.
8. Compared drinking-water access by area, population size, and income group.

## Key Questions
- How does the dataset population compare with the estimated world population?
- How does the urban population share compare with the rural population?
- What are the central tendency and spread of the water-access variables?
- How does water access differ between national, rural, and urban areas?
- How does access vary across population-size groups?
- How does access vary across income groups?

## Dataset Snapshot
The analytical workbook contains **213 country/area observations**.

Of these, **197** have a named income-group classification and **16** contain `NAN` in the income-group field.

## Population Coverage
- Dataset national population total: **7.787 billion**
- Project world-population reference: **7.821 billion**
- Absolute difference: approximately **34.3 million people**
- Symmetric percentage difference: approximately **0.44%**
- Dataset urban population: approximately **4.375 billion**
- Dataset population-weighted urban share: **56.19%**
- Project reference urban share: **55%**, equivalent to approximately **4.302 billion people**

### Insight
The dataset is very close to the project world-population reference, supporting global-level analysis while still leaving a small coverage difference. The weighted urban share is also slightly above the 55% reference.

## Access by Area

| Measure | National | Rural | Urban |
|---|---:|---:|---:|
| Mean at-least-basic access | 89.86% | 81.34% | 94.69% |
| Median | 97.35% | 90.73% | 98.11% |
| Q1 | 85.64% | 64.83% | 92.56% |
| Q3 | 99.89% | 99.12% | 99.95% |
| Minimum | 37.20% | 21.98% | 49.66% |

### Insight 1: The largest access disadvantage is rural
Average at-least-basic access is approximately **13.35 percentage points lower in rural areas than in urban areas**. National access falls between the two measures, as expected for a population-level aggregate.

### Insight 2: Rural access is much less consistent
The rural basic-access interquartile range is approximately **34.29 percentage points**, compared with approximately **7.39 points** in urban areas.

This is an important inequality finding. Urban access is not only higher on average, it is also much more concentrated near universal access. Rural outcomes vary substantially more across countries.

### Insight 3: Lower-quality service categories are more concentrated in rural areas
Average service shares show larger rural exposure to lower service levels:

| Service level | Rural mean | Urban mean |
|---|---:|---:|
| Limited | 5.84% | 3.28% |
| Unimproved | 8.73% | 1.72% |
| Surface water | 4.22% | 0.31% |

Surface-water dependence shows the clearest disparity. Although its average urban share is very small, the rural average is materially higher.

## Distribution Insights
National at-least-basic access has a **median of 97.35%** but a lower **mean of 89.86%**.

### Insight
Most observations are concentrated at high access levels, while a smaller group of countries with much lower access pulls the mean downward. The median therefore represents the typical observation better than the mean when describing the centre of this skewed distribution.

The reverse pattern appears in limited, unimproved, and surface-water access. Their medians are generally low, but a smaller group of countries records much higher values, creating long upper tails.

## Income-Group Analysis

| Income group | Mean national basic access | Median national basic access |
|---|---:|---:|
| Low income | 62.82% | 61.44% |
| Lower middle income | 82.21% | 85.50% |
| Upper middle income | 96.43% | 97.06% |
| High income | 99.56% | 100.00% |

### Insight
The relationship is strongly ordered across the four income categories in this dataset. Average national basic access rises from approximately **62.82% in the low-income group to 99.56% in the high-income group**, a difference of approximately **36.74 percentage points**.

This is a descriptive association. The analysis shows that higher-income groups have higher water access in the dataset, but it does not establish income as the sole cause of the difference.

## Combined Analytical Story
Three patterns reinforce each other:

1. **Urban populations have higher access than rural populations.**
2. **Rural outcomes are much more dispersed across countries.**
3. **Lower-income groups have substantially lower national basic-water access.**

Together, these results show that a high global average can hide concentrated access problems. The populations most exposed to lower service levels are not evenly distributed across the dataset.

## Data-Quality Considerations
- National basic access has **211 numeric observations**, compared with **164 rural** and **175 urban** observations.
- Rural/urban comparisons therefore use smaller valid samples than national comparisons.
- `NAN` values are missing data and should not be interpreted as zero access.
- Some source percentages marginally exceed 100 because of numerical precision. Rounded derived fields help prevent these precision artefacts from affecting full-access interpretation.
- Income-group `NAN` observations should remain separate unless a verified external classification is added.

## Final Takeaway
The 2020 snapshot shows broadly high at-least-basic drinking-water access, but the aggregate picture masks a substantial **rural disadvantage**, much greater **rural variation**, and a pronounced **income-group gradient**.

The main issue is therefore not simply whether global access is high. It is **where the remaining access deficit is concentrated and which populations continue to depend on limited, unimproved, or surface-water services**.

