-- ============================================================
-- 03_views.sql
-- Property Rent Analytics — reporting views
-- Uses window functions for trend and comparison analysis
-- ============================================================

-- -------------------------------------------------------
-- vw_RentSummary
-- Current rent and annual totals per property
-- -------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_RentSummary AS
SELECT
    p.PropertyID,
    p.PropertyName,
    p.PropertyType,
    p.Town,
    p.Bedrooms,
    p.IsVoid,
    YEAR(r.RentDate)                                        AS RentYear,
    SUM(r.RentAmount)                                       AS AnnualRentIncome,
    COUNT(r.RentID)                                         AS PaymentsReceived,
    AVG(r.RentAmount)                                       AS AvgMonthlyRent,
    MAX(r.RentAmount)                                       AS CurrentRent,
    -- Running total of all rent ever received per property
    SUM(SUM(r.RentAmount)) OVER (
        PARTITION BY p.PropertyID
        ORDER BY YEAR(r.RentDate)
        ROWS UNBOUNDED PRECEDING
    )                                                       AS CumulativeIncome
FROM dbo.Properties p
INNER JOIN dbo.Rent r ON p.PropertyID = r.PropertyID
GROUP BY p.PropertyID, p.PropertyName, p.PropertyType, p.Town, p.Bedrooms, p.IsVoid, YEAR(r.RentDate);
GO

-- -------------------------------------------------------
-- vw_RentTrends
-- Year-on-year rent increases using LAG
-- -------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_RentTrends AS
WITH AnnualRent AS (
    SELECT
        PropertyID,
        YEAR(RentDate)              AS RentYear,
        SUM(RentAmount)             AS AnnualTotal,
        AVG(RentAmount)             AS AvgMonthly
    FROM dbo.Rent
    GROUP BY PropertyID, YEAR(RentDate)
)
SELECT
    a.PropertyID,
    p.PropertyName,
    p.PropertyType,
    a.RentYear,
    a.AnnualTotal,
    a.AvgMonthly,
    -- Previous year's income
    LAG(a.AnnualTotal) OVER (
        PARTITION BY a.PropertyID ORDER BY a.RentYear
    )                                                       AS PriorYearTotal,
    -- Year-on-year change in £
    a.AnnualTotal - LAG(a.AnnualTotal) OVER (
        PARTITION BY a.PropertyID ORDER BY a.RentYear
    )                                                       AS YoYChangeAmount,
    -- Year-on-year percentage change
    CASE
        WHEN LAG(a.AnnualTotal) OVER (PARTITION BY a.PropertyID ORDER BY a.RentYear) IS NULL THEN NULL
        ELSE ROUND(
            (a.AnnualTotal - LAG(a.AnnualTotal) OVER (PARTITION BY a.PropertyID ORDER BY a.RentYear))
            / LAG(a.AnnualTotal) OVER (PARTITION BY a.PropertyID ORDER BY a.RentYear) * 100, 2)
    END                                                     AS YoYChangePct,
    -- Rank properties by annual income in each year
    RANK() OVER (
        PARTITION BY a.RentYear ORDER BY a.AnnualTotal DESC
    )                                                       AS IncomeRank
FROM AnnualRent a
INNER JOIN dbo.Properties p ON a.PropertyID = p.PropertyID;
GO

-- -------------------------------------------------------
-- vw_VoidAnalysis
-- Void periods with duration and income lost
-- -------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_VoidAnalysis AS
SELECT
    v.VoidID,
    v.PropertyID,
    p.PropertyName,
    p.Town,
    v.VoidStartDate,
    v.VoidEndDate,
    DATEDIFF(DAY, v.VoidStartDate, ISNULL(v.VoidEndDate, GETDATE())) AS VoidDays,
    -- Estimate income lost based on avg monthly rent
    ROUND(
        DATEDIFF(DAY, v.VoidStartDate, ISNULL(v.VoidEndDate, GETDATE()))
        / 30.44
        * ISNULL((
            SELECT AVG(RentAmount)
            FROM dbo.Rent r
            WHERE r.PropertyID = v.PropertyID
        ), 0), 2
    )                                                       AS EstimatedIncomeLost,
    v.VoidReason,
    CASE WHEN v.VoidEndDate IS NULL THEN 1 ELSE 0 END       AS IsCurrentlyVoid
FROM dbo.VoidHistory v
INNER JOIN dbo.Properties p ON v.PropertyID = p.PropertyID;
GO

-- -------------------------------------------------------
-- vw_PortfolioKPIs
-- Single-row summary of entire portfolio
-- -------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_PortfolioKPIs AS
SELECT
    COUNT(DISTINCT p.PropertyID)                            AS TotalProperties,
    SUM(CASE WHEN p.IsVoid = 1 THEN 1 ELSE 0 END)          AS VoidProperties,
    COUNT(DISTINCT p.PropertyID)
        - SUM(CASE WHEN p.IsVoid = 1 THEN 1 ELSE 0 END)    AS OccupiedProperties,
    ROUND(
        CAST(COUNT(DISTINCT p.PropertyID)
            - SUM(CASE WHEN p.IsVoid = 1 THEN 1 ELSE 0 END) AS FLOAT)
        / COUNT(DISTINCT p.PropertyID) * 100, 1
    )                                                       AS OccupancyRatePct,
    (SELECT SUM(RentAmount) FROM dbo.Rent
     WHERE YEAR(RentDate) = YEAR(GETDATE()))                AS CurrentYearIncome,
    (SELECT SUM(RentAmount) FROM dbo.Rent
     WHERE YEAR(RentDate) = YEAR(GETDATE()) - 1)            AS PriorYearIncome,
    (SELECT COUNT(*) FROM dbo.VoidHistory
     WHERE VoidEndDate IS NULL)                             AS CurrentVoids
FROM dbo.Properties p;
GO

PRINT 'Analytics views created successfully.';
