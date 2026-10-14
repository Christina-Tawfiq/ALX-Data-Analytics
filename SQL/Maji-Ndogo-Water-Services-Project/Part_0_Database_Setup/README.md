# Part 0: Database Setup & Environment Preparation

## Overview

This section contains all resources required to initialize the Maji Ndogo database environment before starting the analysis workflow. It provides the database schema, source data, supporting documentation, and audit files used throughout the project.

## Included Files

- `md_water_services.sql`
- `Auditor_report.csv`
- `Maji_Ndogo_ERD.png`

## Database Initialization

### Step 1: Create and Populate the Database

Open MySQL Workbench and execute:

```sql
md_water_services.sql
```

This script will:

- Create the `md_water_services` database
- Create all project tables
- Define primary and foreign key relationships
- Populate tables with the project dataset
- Configure the database environment required for analysis

### Step 2: Review the Database Schema

Open:

```text
Maji_Ndogo_ERD.png
```

to understand the database structure and relationships between tables before beginning the analysis.

### Step 3: Import the Auditor Report

Import:

```text
Auditor_report.csv
```

This dataset is introduced later in the project and is used during the audit investigation phase to identify potential inconsistencies and corruption within the water services records.

## Core Database Tables

- employee
- visits
- water_source
- water_quality
- well_pollution
- location
- global_water_access
- data_dictionary

## Entity Relationship Diagram (ERD)

The ERD illustrates the relationships between operational, quality, pollution, location, and employee datasets used throughout the project.

## Project Workflow

```text
Part 0 → Database Setup & Environment Preparation

Part 1 → Data Exploration

Part 2 → Data Cleaning & Analysis

Part 3 → Audit Investigation & Corruption Detection

Part 4 → Strategic Recommendations & Action Planning
```

## Prerequisites

- MySQL Workbench
- MySQL Server
- Maji Ndogo Project Files

## Outcome

After completing this setup, the database environment is fully prepared and ready for the analytical tasks performed in Parts 1–4 of the project.
