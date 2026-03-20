-- ============================================================
-- 02_sample_data.sql
-- Insert demo data for Property Rent Analytics
-- ============================================================

-- Properties
INSERT INTO dbo.Properties VALUES (1,'Maple House','Terraced','London','E1 6RF',3,0,'2018-01-01');
INSERT INTO dbo.Properties VALUES (2,'Oak Apartments','Flat','Manchester','M1 2AB',1,0,'2019-03-01');
INSERT INTO dbo.Properties VALUES (3,'Birch Cottage','Detached','Birmingham','B2 4CD',4,1,'2017-06-01');
INSERT INTO dbo.Properties VALUES (4,'Cedar Court','Flat','Leeds','LS1 1EF',2,0,'2020-01-01');
INSERT INTO dbo.Properties VALUES (5,'Elm Rise','Semi-Detached','Bristol','BS1 5GH',3,0,'2016-09-01');

-- Tenants
INSERT INTO dbo.Tenants VALUES (1,'James Thompson','j.thompson@email.com',1,'2023-01-01','2025-12-31',1);
INSERT INTO dbo.Tenants VALUES (2,'Sarah Patel','s.patel@email.com',2,'2023-03-01','2025-02-28',1);
INSERT INTO dbo.Tenants VALUES (3,'Michael Roberts','m.roberts@email.com',4,'2023-06-01','2025-05-31',1);
INSERT INTO dbo.Tenants VALUES (4,'Emma Williams','e.williams@email.com',5,'2022-09-01','2025-08-31',1);

-- Rent payments (2 years of monthly data)
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-01-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-02-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-03-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-04-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-05-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-06-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-07-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-08-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-09-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-10-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-11-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1200.00,'2023-12-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1300.00,'2024-01-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1300.00,'2024-02-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1300.00,'2024-03-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1300.00,'2024-04-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1300.00,'2024-05-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (1,1,1300.00,'2024-06-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (2,2,850.00,'2023-03-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (2,2,850.00,'2023-04-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (2,2,850.00,'2023-05-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (2,2,900.00,'2024-01-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (2,2,900.00,'2024-02-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (4,3,1100.00,'2023-06-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (4,3,1100.00,'2023-07-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (4,3,1150.00,'2024-01-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (5,4,1350.00,'2022-09-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (5,4,1350.00,'2022-10-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (5,4,1400.00,'2023-09-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (5,4,1400.00,'2023-10-01');
INSERT INTO dbo.Rent (PropertyID,TenantID,RentAmount,RentDate) VALUES (5,4,1450.00,'2024-09-01');

-- Void history
INSERT INTO dbo.VoidHistory (PropertyID,VoidStartDate,VoidEndDate,VoidReason)
VALUES (3,'2024-01-01',NULL,'Tenant departed, awaiting refurbishment');
INSERT INTO dbo.VoidHistory (PropertyID,VoidStartDate,VoidEndDate,VoidReason)
VALUES (1,'2022-06-01','2022-12-31','Major repairs required');
