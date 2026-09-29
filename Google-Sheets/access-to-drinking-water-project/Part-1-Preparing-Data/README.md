# Access to Drinking Water – Part 1: Preparing Data

## Overview
In this first part, we cleaned and prepared WHO/UNICEF JMP data to make it suitable for analysis.  
The dataset includes population estimates, urban/rural distribution, service levels (safely managed, basic, limited, unimproved, surface water), and economic indicators such as **Gross National Income (GNI)**.

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

## Insights
- **Population vs Dataset**: Small island nations often have incomplete service-level data, while large countries like China and India have consistent records.  
- **Urban vs Rural**: Urban populations consistently show higher access to safe water compared to rural populations.  
- **Spread of Features**: High-income countries approach 100% safe water access, while low-income countries remain below 50–60%.  
- **National vs Urban vs Rural Access**: Countries with higher urbanisation (e.g., Gulf states) show stronger water access compared to rural-heavy nations.  
- **Effect of GNI**: Higher GNI correlates strongly with improved water access, confirming the link between economic development and basic services.

## Tools
- Google Sheets
- Excel (Data Cleaning, Formulas)

## Files
-## Project File

[View Part 1 – Preparing Data]((https://docs.google.com/spreadsheets/d/1hnKiyyvtD9Fu4pFC99G-85hFez5bv7qaPcxG6alWCwQ/edit?usp=sharing)
-[Raw Data](./Raw-Data/)
## Glossary
- **JMP**: Joint Monitoring Programme (WHO/UNICEF)  
- **GNI**: Gross National Income  
- **SDG**: Sustainable Development Goal  
- **ARC**: Annual Rate of Change
