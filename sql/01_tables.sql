-- ============================================================
-- 01_tables.sql
-- Property Rent Analytics — base table definitions
-- ============================================================

CREATE TABLE dbo.Properties (
    PropertyID      INT             PRIMARY KEY,
    PropertyName    NVARCHAR(200)   NOT NULL,
    PropertyType    NVARCHAR(50),   -- Flat, Terraced, Semi-Detached, Detached
    Town            NVARCHAR(100),
    PostCode        NVARCHAR(20),
    Bedrooms        TINYINT,
    IsVoid          BIT             DEFAULT 0,
    AcquiredDate    DATE
);

CREATE TABLE dbo.Tenants (
    TenantID        INT             PRIMARY KEY,
    FullName        NVARCHAR(200)   NOT NULL,
    Email           NVARCHAR(200),
    PropertyID      INT             REFERENCES dbo.Properties(PropertyID),
    LeaseStartDate  DATE            NOT NULL,
    LeaseEndDate    DATE,
    IsActive        BIT             DEFAULT 1
);

CREATE TABLE dbo.Rent (
    RentID          INT             IDENTITY(1,1) PRIMARY KEY,
    PropertyID      INT             NOT NULL REFERENCES dbo.Properties(PropertyID),
    TenantID        INT             REFERENCES dbo.Tenants(TenantID),
    RentAmount      DECIMAL(10,2)   NOT NULL,
    RentDate        DATE            NOT NULL,
    PaymentStatus   NVARCHAR(20)    DEFAULT 'Paid' -- Paid, Late, Missed
);

CREATE TABLE dbo.VoidHistory (
    VoidID          INT             IDENTITY(1,1) PRIMARY KEY,
    PropertyID      INT             NOT NULL REFERENCES dbo.Properties(PropertyID),
    VoidStartDate   DATE            NOT NULL,
    VoidEndDate     DATE,
    VoidReason      NVARCHAR(200)
);
