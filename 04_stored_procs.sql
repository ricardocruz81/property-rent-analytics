# Power BI Dashboard Design — Property Rent Analytics

## Data Source Connection

- **Type:** SQL Server (DirectQuery or Import — Import recommended for performance)
- **Server:** Your SQL Server instance
- **Database:** PropertyETL
- **Objects to import:**
  - `dbo.vw_RentSummary`
  - `dbo.vw_RentTrends`
  - `dbo.vw_VoidAnalysis`
  - `dbo.vw_PortfolioKPIs`
  - `dbo.Properties` (for slicer/filter context)

---

## Data Model Relationships

```
vw_RentSummary ──── Properties (PropertyID)
vw_RentTrends  ──── Properties (PropertyID)
vw_VoidAnalysis ─── Properties (PropertyID)
```

---

## Dashboard Pages

---

### Page 1 — Portfolio Overview

**Purpose:** Executive summary — one glance view of the entire portfolio.

**Visuals:**

| Visual | Type | Data |
|--------|------|------|
| Total Properties | Card | COUNT(Properties.PropertyID) |
| Occupied Properties | Card | vw_PortfolioKPIs.OccupiedProperties |
| Void Properties | Card | vw_PortfolioKPIs.VoidProperties |
| Occupancy Rate % | Gauge | vw_PortfolioKPIs.OccupancyRatePct — Target: 95% |
| Current Year Income | Card | vw_PortfolioKPIs.CurrentYearIncome |
| YoY Income Change | Card | (CurrentYear - PriorYear) / PriorYear * 100 |
| Income by Town | Filled Map | SUM(AnnualRentIncome) by Town |
| Income by Property Type | Donut Chart | SUM(AnnualRentIncome) by PropertyType |

**Slicers:**
- Year (from vw_RentSummary.RentYear)
- Town
- Property Type

---

### Page 2 — Rent Trends

**Purpose:** Show how rent has moved over time per property and portfolio-wide.

**Visuals:**

| Visual | Type | Data |
|--------|------|------|
| Annual Income Over Time | Line Chart | AnnualRentIncome by RentYear, one line per Property |
| Year-on-Year % Change | Clustered Bar | YoYChangePct by PropertyName, coloured by positive/negative |
| Rent Change Table | Table | PropertyName, RentYear, AnnualTotal, PriorYearTotal, YoYChangePct |
| Properties with No Increase | Table | Filter: YoYChangePct = 0 or NULL |
| Income Rank by Year | Matrix | PropertyName rows, RentYear columns, IncomeRank values |

**Conditional Formatting:**
- YoYChangePct: Green if > 0, Red if = 0, Amber if < 0

---

### Page 3 — Void Analysis

**Purpose:** Track all void periods and visualise income loss.

**Visuals:**

| Visual | Type | Data |
|--------|------|------|
| Current Void Count | Card | COUNT where IsCurrentlyVoid = 1 |
| Total Void Days (YTD) | Card | SUM(VoidDays) where year = current year |
| Total Estimated Income Lost | Card | SUM(EstimatedIncomeLost) |
| Void Timeline | Gantt (custom) | VoidStartDate, VoidEndDate per Property |
| Void History Table | Table | PropertyName, VoidStartDate, VoidEndDate, VoidDays, EstimatedIncomeLost, VoidReason |
| Income Lost by Property | Bar Chart | SUM(EstimatedIncomeLost) by PropertyName |

---

### Page 4 — Property Detail (Drill-Through)

**Purpose:** Deep-dive on a single property — triggered by right-click drill-through from other pages.

**Visuals:**

| Visual | Type | Data |
|--------|------|------|
| Property Info | Card cluster | PropertyName, Town, PostCode, Bedrooms, Type |
| Monthly Rent History | Line Chart | RentAmount by RentDate |
| Annual Income | Bar Chart | AnnualRentIncome by RentYear |
| Void Periods | Table | VoidStartDate, VoidEndDate, VoidDays |
| Payment Status | Donut | Paid / Late / Missed split |

---

## Measures (DAX)

```dax
-- Occupancy Rate
Occupancy Rate % = 
DIVIDE(
    CALCULATE(COUNTROWS(Properties), Properties[IsVoid] = 0),
    COUNTROWS(Properties)
) * 100

-- YoY Income Change %
YoY Change % = 
VAR CurrentYear = MAX(vw_RentSummary[RentYear])
VAR CurrentIncome = CALCULATE(SUM(vw_RentSummary[AnnualRentIncome]), vw_RentSummary[RentYear] = CurrentYear)
VAR PriorIncome = CALCULATE(SUM(vw_RentSummary[AnnualRentIncome]), vw_RentSummary[RentYear] = CurrentYear - 1)
RETURN DIVIDE(CurrentIncome - PriorIncome, PriorIncome) * 100

-- Estimated Annual Income Lost to Voids
Annual Void Loss = 
CALCULATE(
    SUM(vw_VoidAnalysis[EstimatedIncomeLost]),
    YEAR(vw_VoidAnalysis[VoidStartDate]) = YEAR(TODAY())
)
```

---

## Colour Theme

| Element | Colour |
|---------|--------|
| Positive values | #2E7D32 (dark green) |
| Negative / alert | #C62828 (dark red) |
| Void / warning | #F57C00 (amber) |
| Neutral | #1565C0 (blue) |
| Background | #F5F5F5 (light grey) |
