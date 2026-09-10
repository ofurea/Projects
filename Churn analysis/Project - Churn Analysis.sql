-- Create clean, business-ready table from raw extract
CREATE TABLE clean_churn AS
SELECT
    CustomerId,
    Surname,
    CreditScore,
    Geography,
    Gender,
    Age,
    Tenure,
    Balance,
    NumOfProducts,
    HasCrCard,
    IsActiveMember,
    EstimatedSalary,
    Exited AS IsChurned,
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS AgeBand,
    CASE
        WHEN CreditScore < 580 THEN 'Poor (<580)'
        WHEN CreditScore < 670 THEN 'Fair (580-669)'
        WHEN CreditScore < 740 THEN 'Good (670-739)'
        WHEN CreditScore < 800 THEN 'Very Good (740-799)'
        ELSE 'Excellent (800+)'
    END AS CreditBand,
    CASE
        WHEN Balance = 0 THEN 'Zero Balance'
        WHEN Balance < 50000 THEN 'Low (<50k)'
        WHEN Balance < 100000 THEN 'Mid (50-100k)'
        WHEN Balance < 150000 THEN 'High (100-150k)'
        ELSE 'Very High (150k+)'
    END AS BalanceTier,
    CASE
        WHEN Tenure <= 2 THEN 'New (0-2 yrs)'
        WHEN Tenure <= 5 THEN 'Developing (3-5 yrs)'
        WHEN Tenure <= 8 THEN 'Established (6-8 yrs)'
        ELSE 'Loyal (9-10 yrs)'
    END AS TenureBucket,
    CASE WHEN NumOfProducts = 1 THEN 'Single Product' ELSE 'Multi Product' END AS ProductGroup
FROM raw_churn
WHERE CustomerId IS NOT NULL;

-- 1. Overall churn rate: baseline KPI for Head of Retail
-- Why *1.0: forces decimal division in SQLite, else 2037/10000 = 0
SELECT
    COUNT(*) AS total_customers,
    SUM(IsChurned) AS churned_customers,
    ROUND(SUM(IsChurned) *1.0 / COUNT(*)*100, 2) AS churn_rate_pct
FROM clean_churn;

-- 2. Churn by Geography: which market is losing deposits?
SELECT
    Geography,
    COUNT(*) AS customers,
    SUM(IsChurned) AS churned,
    ROUND(SUM(IsChurned)*1.0/COUNT(*)*100,2) AS churn_rate_pct,
    ROUND(AVG(Balance),2) AS avg_balance
FROM clean_churn
GROUP BY Geography
ORDER BY churn_rate_pct DESC;

-- 3. Churn by ProductGroup + Active Member: classic drivers
-- Hypothesis: Single Product + Inactive = highest churn
SELECT
    ProductGroup,
    IsActiveMember,
    COUNT(*) AS customers,
    ROUND(SUM(IsChurned)*1.0/COUNT(*)*100,2) AS churn_rate_pct
FROM clean_churn
GROUP BY ProductGroup, IsActiveMember
ORDER BY churn_rate_pct DESC;

-- 4. Churn by AgeBand, BalanceTier, TenureBucket, CreditBand
-- Run each separately, same pattern - builds your segment table
SELECT AgeBand, COUNT(*) AS customers, ROUND(SUM(IsChurned)*1.0/COUNT(*)*100,2) AS churn_rate_pct
FROM clean_churn GROUP BY AgeBand ORDER BY churn_rate_pct DESC;

SELECT BalanceTier, COUNT(*) AS customers, ROUND(SUM(IsChurned)*1.0/COUNT(*)*100,2) AS churn_rate_pct, ROUND(AVG(Balance),2) AS avg_balance
FROM clean_churn GROUP BY BalanceTier ORDER BY churn_rate_pct DESC;

SELECT TenureBucket, COUNT(*) AS customers, ROUND(SUM(IsChurned)*1.0/COUNT(*)*100,2) AS churn_rate_pct
FROM clean_churn GROUP BY TenureBucket ORDER BY churn_rate_pct DESC;

-- 5. Revenue at Risk: balances held by churned customers
-- This is what gets leadership attention - $ at risk
SELECT
    COUNT(*) AS churned_customers,
    ROUND(SUM(Balance),2) AS total_balance_at_risk,
    ROUND(AVG(Balance),2) AS avg_balance_churned
FROM clean_churn
WHERE IsChurned = 1;






















