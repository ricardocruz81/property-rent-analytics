# Property Rent Analytics Dashboard

A SQL-based analytics solution for housing data, featuring window functions, rent trend analysis, void property tracking, and a Power BI dashboard for reporting.

---

## Architecture

```
┌─────────────────────┐
│   SQL Server        │
│   (Source Tables)   │
│   dbo.Properties    │
│   dbo.Tenants       │
│   dbo.Rent          │
│   dbo.VoidHistory   │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   SQL Views         │
│  vw_RentSummary     │
│  vw_RentTrends      │
│  vw_VoidAnalysis    │
│  vw_YearOnYear      │
│  vw_PortfolioKPIs   │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   Power BI          │
│   Dashboard         │
│  - Rent Overview    │
│  - Trend Charts     │
│  - Void Tracker     │
│  - KPI Cards        │
└─────────────────────┘
```

---

## Project Structure

```
3-property-rent-analytics
├── README.md
├── sql
│   ├── 01_tables.sql           # Table definitions
│   ├── 02_sample_data.sql      # INSERT statements for demo data
│   ├── 03_views.sql            # Analytics views
│   └── 04_stored_procs.sql     # Reporting stored procedures
├── sample-data
│   └── rent-data.csv
└── powerbi
    └── dashboard-design.md     # Dashboard design spec
```

---

## Key SQL Views

### vw_RentSummary
- Current rent per property
- Total income per property per year
- Average rent across portfolio

### vw_RentTrends (Window Functions)
- Year-on-year rent increase per property
- Cumulative rent income using `SUM() OVER`
- Running 12-month average using `AVG() OVER`

### vw_VoidAnalysis
- Void start and end dates per property
- Void duration in days
- Income lost during void periods
- Current void status

### vw_YearOnYear
- Percentage rent increase per property
- Portfolio-wide annual comparison
- Properties with zero increase flagged

### vw_PortfolioKPIs
- Total portfolio annual income
- Average yield per property type
- Occupancy rate
- Total void days this year

---

## Window Functions Used

```sql
-- Running total of rent income
SUM(RentAmount) OVER (PARTITION BY PropertyID ORDER BY RentDate)

-- Rank properties by annual income
RANK() OVER (ORDER BY AnnualRent DESC)

-- Year-on-year rent change
LAG(RentAmount, 12) OVER (PARTITION BY PropertyID ORDER BY RentDate)

-- Identify void gaps
LEAD(LeaseStartDate) OVER (PARTITION BY PropertyID ORDER BY LeaseStartDate)
```

---

## Power BI Dashboard Pages

| Page | Visuals |
|------|---------|
| Portfolio Overview | KPI cards, map of properties |
| Rent Trends | Line chart by year, bar chart by property |
| Void Analysis | Table of void periods, timeline |
| Income Comparison | Year-on-year bar chart |

---

## Skills Demonstrated
- SQL window functions (LAG, LEAD, RANK, SUM OVER)
- Complex view design
- Data modelling for reporting
- Power BI data model connections
- Property sector domain knowledge
