# Access to Drinking Water | Project Overview

## Project Objective
This project investigates access to safe and affordable drinking water using WHO/UNICEF Joint Monitoring Programme (JMP) data, framed around Sustainable Development Goal 6: clean water and sanitation.

The analysis focuses on inequalities in water-service access across countries, national/rural/urban populations, income groups, population sizes, and regions.


## Project Files
- [Part 1 – Preparing Data](../Part-1-Preparing-Data/)
  
- [Part 2 – Transforming Data](../Part-2-Transforming-Data/)

## Project Structure
The project is divided into two analytical parts:

1. **Part 1: Understanding the Data**  
   Prepares and validates the 2020 snapshot, creates population features, explores service-level distributions, and compares drinking-water access across national, rural, urban, and income-group categories.

2. **Part 2: Transforming the Data**  
   Examines change across country-year observations, calculates Annual Rates of Change (ARC), separates full-access cases from stagnation, compares rural and urban progress, and evaluates regional patterns.

## Service Levels
The JMP service ladder defines five drinking-water service levels:

- Safely managed
- Basic
- Limited
- Unimproved
- Surface water

In the supplied analytical datasets, `wat_bas_*` represents **at least basic access**, which combines safely managed and basic services. The suffixes `n`, `r`, and `u` refer to national, rural, and urban populations.

## Key Questions Addressed
- How closely does the 2020 dataset represent the estimated world population?
- How do urban and rural population shares compare?
- How do drinking-water service levels differ between national, rural, and urban populations?
- How does access vary across income groups and population sizes?
- How quickly is access changing over time?
- Is rural access catching up with urban access?
- How do ARC patterns differ across regions?

## Executive Insights
- The 2020 analytical dataset contains **213 country/area observations** and represents approximately **7.787 billion people**, close to the project reference of **7.821 billion**.
- The population-weighted urban share in the dataset is approximately **56.19%**, compared with the project reference of **55%**.
- At-least-basic water access is highest in urban areas and lowest in rural areas. Mean basic access is approximately **94.69% urban**, **89.86% national**, and **81.34% rural**.
- Rural access is substantially more dispersed across countries than urban access, showing that the global inequality is not only a difference in average access but also in consistency.
- National basic-water access increases sharply across income groups, from approximately **62.82%** among low-income observations to **99.56%** among high-income observations.
- In the time-based analysis, average ARC is positive for national, rural, and urban access. Rural ARC is highest on average at approximately **0.484 percentage points per year**, compared with **0.277 nationally** and **0.155 in urban areas**.
- The mean rural-minus-urban ARC difference is approximately **+0.321 percentage points per year**, indicating faster rural improvement on average among observations where both rates can be compared.

## Overall Interpretation
The project tells a clear story of **progress with persistent inequality**.

Urban and higher-income populations generally have very high levels of at-least-basic drinking-water access. Rural and lower-income populations remain further behind, but rural access is improving more quickly on average in the time-based analysis.

This means that access level and rate of change should be interpreted together. A low ARC in a high-access setting may reflect saturation near universal access, while a high ARC in a low-access setting may indicate meaningful catch-up without implying that the access gap has already closed.

## Data Considerations
- Missing values are more common in rural and urban service-level fields than in national fields.
- Valid sample sizes therefore differ across national, rural, and urban comparisons.
- Some raw percentage values are marginally above 100 because of source precision, so rounded access features are used where full-access classification is required.
- ARC must only compare observations from the same country and must use the actual interval between recorded years.
- Regional analysis uses the region classifications contained in the project workbook.

## Tools
- Google Sheets
- Excel
- Data cleaning and transformation
- Formulas and derived features
- Pivot tables and summary statistics
- Exploratory data analysis

## Glossary
- **SDG:** Sustainable Development Goal
- **JMP:** WHO/UNICEF Joint Monitoring Programme
- **ARC:** Annual Rate of Change
- **GNI:** Gross National Income

## Source
WHO/UNICEF Joint Monitoring Programme data supplied with the integrated Access to Drinking Water project.
