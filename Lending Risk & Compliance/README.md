# PROJECT 3 - Lending Risk & Compliance

![ECL RISK](/Images/Lending%20Risk%20&%20Compliance.png)

## Overview

Consumer unsecured book 255,347 loans, $32.58B exposure. Book default 11.61% (29,653 defaults). Finance + Risk/Compliance need IFRS 9 / CECL-style monitoring: who defaults, expected loss, breach flags, stress buffer.

## Objectives

 calculate PD by segment, estimate ECL = PD x LGD x EAD, flag breach cohorts, stress for Adverse, build Risk Committee pack with reconciled SQL -> Excel -> Power BI.

## Results

* ECL $1,702,998,936 @45% LGD. Poor 12.47% -> Very Good 10.18%. DTI Very High 12.14% vs Low 10.36%. No CoSigner 12.87% vs Yes 10.36% (-2.5pts).
* Top loss: Poor + Very High Income + Very High DTI $147.7M (24,518 loans, PD 10.51%, EAD $3.12B) — EAD drives loss, not PD alone.
* 3 Actions: 1. Require co-signer for Poor + Very High DTI 2. Cap DTI>50% for high-income large tickets 3. Hold $511M buffer for Adverse (+30% PD -> $2.21B).

## What I did with each tool:
1. **SQL:**
    * Objective clean book + PD/ECL. 
    * Approach raw_loans untouched, clean_loans bands, CTE book, GROUP BY Credit/DTI/Income/CoSigner/Purpose, risk_summary 64 rows. 
    * **Files:**
        * [raw data file imported](/Lending%20Risk%20&%20Compliance/raw_loans.sql)
        * [Cleaned File](/Lending%20Risk%20&%20Compliance/clean_loans.sql)
        * [Summary Cleaned File used primarily](/Lending%20Risk%20&%20Compliance/risk_summary.sql)

2. **Excel:** 
    * Objective auditable model + stress. Approach Risk_Summary 64, ECL_Model H calc + RAG, Stress_Test Base/Adverse/Buffer, G68=1702998936, H68 gap -711k 0.04% tolerance.
    * **File:**
        * [Excel Clean File](/Lending%20Risk%20&%20Compliance/Project3-Risk-ECL.xlsx)

3. **Power BI:** 
    * Objective Committee pack. 
    * Approach 64-row feed, measures, KPI 255347/11.61%/1.70B, Bar, Matrix RAG 0.12/0.11, Power Query Credit_Sort/DTI_Sort fix, slicers.
    * **File:**
        * [Power BI File](/Lending%20Risk%20&%20Compliance/ECL_Risk.pbix)