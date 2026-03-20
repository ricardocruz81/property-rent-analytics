-- ============================================================
-- 04_stored_procs.sql
-- Property Rent Analytics — reporting stored procedures
-- ============================================================

-- -------------------------------------------------------
-- usp_GetPropertyRentHistory
-- Full rent history for a single property
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.usp_GetPropertyRentHistory
    @PropertyID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.PropertyName,
        p.Town,
        r.RentDate,
        r.RentAmount,
        r.PaymentStatus,
        LAG(r.RentAmount) OVER (ORDER BY r.RentDate)        AS PreviousRent,
        r.RentAmount
            - LAG(r.RentAmount) OVER (ORDER BY r.RentDate)  AS ChangeAmount,
        SUM(r.RentAmount) OVER (ORDER BY r.RentDate
            ROWS UNBOUNDED PRECEDING)                       AS RunningTotal
    FROM dbo.Rent r
    INNER JOIN dbo.Properties p ON r.PropertyID = p.PropertyID
    WHERE r.PropertyID = @PropertyID
    ORDER BY r.RentDate;
END;
GO

-- -------------------------------------------------------
-- usp_GetPortfolioSummary
-- Annual summary for all properties — for Power BI
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.usp_GetPortfolioSummary
    @Year INT = NULL   -- NULL = current year
AS
BEGIN
    SET NOCOUNT ON;

    SET @Year = ISNULL(@Year, YEAR(GETDATE()));

    SELECT
        p.PropertyID,
        p.PropertyName,
        p.PropertyType,
        p.Town,
        p.Bedrooms,
        p.IsVoid,
        SUM(r.RentAmount)                                   AS AnnualIncome,
        COUNT(r.RentID)                                     AS PaymentsReceived,
        12 - COUNT(r.RentID)                                AS MissedPayments,
        AVG(r.RentAmount)                                   AS AvgMonthlyRent,
        MAX(r.RentAmount)                                   AS CurrentRent,
        SUM(CASE WHEN r.PaymentStatus = 'Late'  THEN 1 ELSE 0 END) AS LatePayments,
        SUM(CASE WHEN r.PaymentStatus = 'Missed' THEN 1 ELSE 0 END) AS MissedCount
    FROM dbo.Properties p
    LEFT JOIN dbo.Rent r
        ON p.PropertyID = r.PropertyID
        AND YEAR(r.RentDate) = @Year
    GROUP BY
        p.PropertyID, p.PropertyName, p.PropertyType,
        p.Town, p.Bedrooms, p.IsVoid
    ORDER BY AnnualIncome DESC;
END;
GO

-- -------------------------------------------------------
-- usp_GetVoidSummary
-- All void periods with income loss calculation
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.usp_GetVoidSummary
    @ActiveOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        v.VoidID,
        p.PropertyRef,
        p.PropertyName,
        p.Town,
        v.VoidStartDate,
        v.VoidEndDate,
        DATEDIFF(DAY, v.VoidStartDate,
            ISNULL(v.VoidEndDate, CAST(GETDATE() AS DATE)))     AS VoidDays,
        ROUND(
            DATEDIFF(DAY, v.VoidStartDate,
                ISNULL(v.VoidEndDate, CAST(GETDATE() AS DATE)))
            / 30.44
            * ISNULL(avg_rent.AvgRent, 0), 2)                   AS EstIncomeLost,
        v.VoidReason,
        CASE WHEN v.VoidEndDate IS NULL THEN 'Current' ELSE 'Historical' END AS VoidStatus
    FROM dbo.VoidHistory v
    INNER JOIN dbo.Properties p ON v.PropertyID = p.PropertyID
    LEFT JOIN (
        SELECT PropertyID, AVG(RentAmount) AS AvgRent
        FROM dbo.Rent
        GROUP BY PropertyID
    ) avg_rent ON p.PropertyID = avg_rent.PropertyID
    WHERE (@ActiveOnly = 0 OR v.VoidEndDate IS NULL)
    ORDER BY v.VoidStartDate DESC;
END;
GO

PRINT 'Reporting stored procedures created.';
