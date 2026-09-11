# PROJECT 1 - Retail Banking: Customer Churn & Retention Analytics

![churn analysis](/Images/Project%20-%20Churn%20Analysis.png)

## Overview:
Our retail bank is losing deposit customers to fintech competitors. With 20.37% churn (2,037 of 10,000 customers) and $185.6M in balances walked out the door, leadership needed to know who is churning, why, and where to intervene to protect deposits.

This project follows a realistic bank workflow: SQL for extraction & cleaning → Excel for validation & intermediate analysis → Power BI for executive dashboard.

## Business Questions Answered:

* What is our overall churn rate?

* Which market / segment churns most?

* What drives churn (products, activity, balance, tenure, age)?

* How much revenue is at risk and who should we save first?

* What 3 retention actions should we take?

## Key Findings:

* **Overall churn: 20.37% (2,037 / 10,000)**

* **Germany 32.44% churns at 2x France (16.15%) and Spain (16.67%)**

* **Single Product + Inactive: 36.65% vs Multi Product + Active: 9.66% (~4x risk)**

* **$185,588,094.63 total balance at risk, avg $91,108 per churner**

* **1,211 PRIORITY SAVE customers (churned with balance ≥ $100k) - 10% save = ~$18.5M deposits protected**

## 3 Priority Actions:

* **Germany save campaign - targeted outreach + service review**
* **Single-Inactive bundle nudge - 2nd product + activation incentive**

* **RM outreach to 1,211 high-value churners**

## What I did with each tool:
* **SQL (DBeaver + SQLite - retail_churn.db):**

    **Objective:** Create audit-safe, business-ready base table.

    **Approach:** 
    
   * Kept raw_churn untouched as audit extract (10,000 rows)Built clean_churn with business logic: IsChurned, AgeBand, CreditBand, BalanceTier, TenureBucket, ProductGroup. 
    
   * Calculated churn rates with SUM(IsChurned)*1.0/COUNT(*) pattern to avoid integer division. 
   
  * Aggregated by Geography, ProductGroup x IsActiveMember, AgeBand, BalanceTier, TenureBucket.
  
  * Quantified revenue at risk with SUM(Balance) WHERE IsChurned=1

* **Excel (Project1-Churn-Analysis.xlsx):**

    **Objective:** Reconcile SQL outputs (bank control) + build save-list business case.

    **Approach:**
    
   * Sheet Data: 10,000 rows imported from clean_churn.csv (1.3MB)
    
   * Sheet Validation: Used COUNTA, SUM, SUMIF, IF checks - all show OK vs SQL (10000 / 2037 / 20.37% / 185.6M)

   * Sheet Cohort_Analysis: PivotTables for Geography (Germany 32.44% verified) + Product x Activity matrix (36.65% vs 9.66%)

   * Added Save_Flag column: =IF(AND(M2=1,H2>=100000),"PRIORITY SAVE","") + COUNTIF = 1,211 priority customers

   * Built what-if: 10% save = ~$18.5M deposits protected

* Power BI (Project1-Retention-Dashboard.pbix):

    **Objective:** 1-page Executive Dashboard for Head of Retail.

    **Approach:**

   * Connected to Excel Data sheet, renamed to Churn (single source).

   * Created DAX measures: Total Customers = COUNTROWS, Churned Customers = SUM, Churn Rate % = DIVIDE, Balance at Risk = CALCULATE(SUM...)

   * Validated KPI cards match SQL/Excel: 10,000 / 2,037 / 20.37% / $185.6M

   * Built 5 visuals: 4 KPI Cards, Geography Bar, Product x Activity Matrix, BalanceTier Column, AgeBand Bar + Tenure/Geography slicers

   * Added header title + Key Findings & 3 Actions text box for executive story

   ## Files included in this Project

   * [Raw Csv Data](/Churn%20analysis/Churn_Modelling.csv)
   * [Sql Cleaned File](/Churn%20analysis/Project%20-%20Churn%20Analysis.sql)
   * [Excel Validation File](/Churn%20analysis/Project1-Churn-Analysis.xlsx)
   * [Power BI File](/Churn%20analysis/Project-%20Churn%20Analysis.pbix)