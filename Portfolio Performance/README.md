# Investment / Wealth Management: Portfolio Performance & Risk Monitoring

![Portfolio Performance](/Images/Portfolio%20Performance.png)

## Overview:

We manage 3 model client portfolios (Balanced, Growth, Conservative) against market prices 2013-2018. With $209k total AUM in Feb-18, advisors needed to prove outperformance and explain risk taken. Workflow: SQL for prices + valuation → Excel for risk validation → Power BI for advisor pack.

**Note on source:** Yahoo Finance download wall + Stooq region block, so market data switched to Kaggle Cam Nugent all_stocks_5yr.csv (real daily 2013-2018). Holdings are synthetic 12-row internal book aligned to available tickers. Noted as analyst source decision.

## Business Questions:

* What is AUM per client over time?
* Which ticker/sector drove return?
* What was volatility / Sharpe (did risk pay?)?
* Where is allocation drift / concentration risk?

## Key Findings:

* Latest AUM Feb-18: $209,064 (C002 $129,259.8 Growth on top)
* C002 Growth beat Balanced/Conservative via AMZN + AAPL concentration
* AAPL: Avg 1.67%/mo, Ann Vol 19.11%, Sharpe 1.05 = risk paid off
* Volatility -5% to +6% monthly — single-stock ride is bumpy.

## What I did with each tool:

1. **SQL (DBeaver + SQLite - wealth_portfolio.db):**

    * **Objective:** Build month-end price book + portfolio valuation.

    * **Approach:**
        * Kept raw_prices (~600k rows) untouched as audit extract
        * Built clean_monthly (305 rows: 5 tickers x ~61 months) with substr(date,1,7) AS MonthID, AVG(close), SUM(volume)
        * Built monthly_returns (305 rows) with LAG(AvgClose) OVER (PARTITION BY Ticker) for MoM % — first month NULL correct
        * Built raw_holdings (12 rows) aligned to AAPL/MSFT/AMZN/GOOGL/IBM
        * Built portfolio_monthly_value (427 rows) via JOIN clean_monthly ON Ticker WHERE MonthID >= purchase month, MarketValue = Shares*AvgClose, UnrealizedGain
         
    * **Files:**
        * [raw prices sql file](/Portfolio%20Performance/raw_prices.sql)
        * [raw sql file of holdings](/Portfolio%20Performance/raw_holdings.sql)
        * [Cleaned monthly sql file](/Portfolio%20Performance/clean_monthly.sql)
        * [Monthly Returns sql file (cleaned) ](/Portfolio%20Performance/monthly_returns.sql)
        * [Portfolio Monthly value sql file (clean)](/Portfolio%20Performance/portfolio_monthly_value.sql)

2. **Excel (Project2-Portfolio-Performance.xlsx):**

    * **Objective:** Reconcile SQL + calculate risk (bank control).

    * **Approach:**
        * Sheets: Prices_Monthly (305), Returns (305), Portfolio_Value (427) from CSVs
        * Sheet Validation: COUNTA, SUMIFS for 305/427/129259.8 — all OK
        * Sheet Risk_Calc: Per-ticker extracts (~60 rows each, AAPL in A10:A70 etc), =AVERAGE, =STDEV.P, =B*SQRT(12), Sharpe = Avg/Vol*SQRT(12) — AAPL 1.67%/19.11%/1.05
        * Sheet AUM_Check: Pivot MonthID x ClientID Sum of MarketValue, Feb-18 matches SQL 26466.5/129259.8/53338
        * Dividend note: file has no dividend column, so income contribution proxied via total return; flagged as limitation

    * **Files:**
        * [Excel file](/Portfolio%20Performance/Project2-Portfolio-Performance.xlsx)

3. **Power BI (Project2-Advisor-Dashboard.pbix):**

    * **Objective:** 1-page Advisor pack.

    * **Approach:**
       * Connected 3 Excel sheets, created        MonthID_Text = FORMAT(MonthEndDate,"yyyy-MM") to fix auto-date hierarchy
        * Measures: Total AUM = SUM(MarketValue), Latest AUM = VAR MaxDate=MAX(MonthEndDate) RETURN CALCULATE([Total AUM], MonthEndDate=MaxDate) (~209k) — avoids text mismatch
        * Visuals: 3 KPI Cards (Total check/Latest 209k/Sharpe Text), Line AUM Over Time by ClientID (C002 on top), Bar Feb-18 by Ticker (AMZN largest, filtered to 7-Feb-2018), Column Monthly Returns % by Ticker (Returns table), Slicers ClientID/Ticker/MonthID_Text
        * Title + insight text box
    * **Files:**
        * [Power BI file](/Portfolio%20Performance/Portfolio%20Performance.pbix)