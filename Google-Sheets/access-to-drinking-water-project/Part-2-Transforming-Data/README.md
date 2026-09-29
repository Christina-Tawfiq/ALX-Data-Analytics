# Access to Drinking Water – Part 2: Transforming Data

## Overview
In this second part, we transformed the dataset to investigate changes in access to drinking water between 2000 and 2020.  
We engineered new features, calculated **Annual Rates of Change (ARC)**, and compared progress across national, rural, and urban populations, as well as regions.  
We also examined how **Gross National Income (GNI)** interacts with ARC to highlight the relationship between economic growth and improvements in water access.

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

## Insights
- **Year Representation**: Data is not collected annually for every country; average gaps vary but often ~5 years.  
- **ARC Trends**: Rural populations show higher ARC values, meaning faster improvements, but they still lag behind urban populations in absolute access.  
- **Regional Differences**: Sub-Saharan Africa shows the slowest progress; at current rates, full access may not be achieved until ~2080.  
- **Urban vs Rural**: Urban areas often plateau at near 100% access, while rural areas continue to improve but remain behind.  
- **GNI Link**: Countries with higher GNI generally show faster improvements in ARC, reinforcing the connection between economic growth and service delivery.  

## Tools
- Google Sheets
- Excel (Formulas, Pivot Tables, Charts)

## Files
- 

## Glossary
- **ARC**: Annual Rate of Change  
- **GNI**: Gross National Income  
- **JMP**: Joint Monitoring Programme (WHO/UNICEF)  
- **SDG**: Sustainable Development Goal
