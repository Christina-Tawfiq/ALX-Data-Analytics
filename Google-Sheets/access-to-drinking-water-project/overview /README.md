# Access to Drinking Water | Project Overview

## Project objective
This project investigates access to safe and affordable drinking water using WHO/UNICEF JMP data and frames the work around UN Sustainable Development Goal SDG 6. The analysis focuses on inequality in service levels across countries, rural and urban areas, income groups, and regions.

## Project Files
- [Part 1 – Preparing Data](../Part-1-Preparing-Data/)
  
- [Part 2 – Transforming Data](../Part-2-Transforming-Data/)

## Analytical roadmap
The project has two analytical parts:

1. **Part 1, Understanding the data:** prepare the 2020 snapshot, validate population coverage, create derived population features, summarize water-service distributions, compare national/rural/urban access, examine population-size patterns, and evaluate income-group differences.
2. **Part 2, Transforming the data:** compare country observations across time, quantify year gaps, calculate Annual Rates of Change (ARC), distinguish full-access cases from stagnation, compare rural versus urban progress, and summarize change by region.

## Service levels
The JMP service ladder includes safely managed, basic, limited, unimproved, and surface water. In the project spreadsheets, `wat_bas_*` represents **at least basic** access, combining safely managed and basic services. The suffixes `n`, `r`, and `u` represent national, rural, and urban populations.

## Key Questions Addressed
- How do population estimates compare to dataset values?
- How does urbanisation affect water access?
- What inequalities exist between rural and urban populations?
- How does national population size and **Gross National Income (GNI)** influence water access?
- How do **Annual Rates of Change (ARC)** differ across regions and population groups?

## Executive insights
- The 2020 workbook contains **213 country/area rows**. Its population total is approximately **7.787 billion**, compared with the project reference of **7.821 billion**, a difference of roughly **0.44%** using the requested percentage-difference convention.
- The dataset's population-weighted urban share is approximately **56.19%**, versus the project reference of **55%**. This shows that the workbook is close to the external world estimate while not matching it exactly.
- Basic-water access has a clear area gradient in the 2020 data: mean access is **94.69% urban**, **89.86% national**, and **81.34% rural**. The corresponding medians are **98.11%**, **97.35%**, and **90.73%**, respectively.
- Rural areas also show materially wider dispersion. For rural basic access, Q1 is **64.83%** and Q3 is **99.12%**, compared with **92.56% to 99.95%** for urban access. The gap is therefore not only about average levels, but also about consistency across countries.
- Income-group stratification is pronounced. Mean national basic access rises from **62.82%** in low-income economies to **82.21%** in lower-middle-income, **96.43%** in upper-middle-income, and **99.56%** in high-income economies.
- In Part 2, the average ARC is positive for all three area types: **0.277 percentage points/year nationally**, **0.484 rural**, and **0.155 urban** among non-missing observations. Rural access is improving faster on average, but this must be interpreted alongside the larger rural starting deficit and the number of observations already at full access.
- The mean rural-minus-urban ARC difference is **+0.321 percentage points/year**. Its median is **+0.212**, suggesting that rural improvement exceeds urban improvement for a typical comparable country, though there are important country-level exceptions.

## Interpretation
The strongest overall story is **progress with persistent inequality**. At least-basic access is already very high in many urban and higher-income settings, leaving less room for additional annual gains. Rural and lower-income populations start from substantially lower access levels, so faster rural ARC can indicate catch-up rather than parity. The analysis should therefore consider both **level** and **change**: high access with a low ARC can represent saturation, while high ARC from a low baseline can represent meaningful but incomplete convergence.

## Important data-quality notes
- Missing service values are present, especially in rural and urban breakdowns, so area-level statistics use different valid sample sizes.
- Some raw percentages marginally exceed 100 because of source-data precision. The project workflow therefore creates rounded features for full-access logic.
- ARC should be calculated only between observations for the same country and must account for the actual year difference.
- Region labels in the workbook should be treated as data values, not independently corrected or reclassified unless an authoritative mapping is supplied.

## Sources
- WHO/UNICEF Joint Monitoring Programme data as supplied in the project workbooks.

## Tools
- Google Sheets
- Excel (Data Cleaning, Formulas, Pivot Tables, Charts)

## Glossary
- **SDG**: Sustainable Development Goal  
- **JMP**: Joint Monitoring Programme (WHO/UNICEF)  
- **GNI**: Gross National Income  
- **ARC**: Annual Rate of Change
