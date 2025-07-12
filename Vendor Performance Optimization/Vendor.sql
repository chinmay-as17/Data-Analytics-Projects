CREATE DATABASE VendorAnalytics;
USE VendorAnalytics;
-- product_master
CREATE TABLE product_master (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(255),
    Category VARCHAR(100),
    SubCategory VARCHAR(100),
    Brand VARCHAR(100),
    MSRP DECIMAL(10, 2),
    TargetGP_Percent INT
);

-- vendor_transactions
CREATE TABLE vendor_transactions (
    TransactionID VARCHAR(20) PRIMARY KEY,
    VendorID VARCHAR(10),
    VendorName VARCHAR(255),
    OrderDate DATE,
    ProductID VARCHAR(10),
    Quantity INT,
    UnitCost DECIMAL(10, 2),
    TotalCost DECIMAL(10, 2),
    PaymentTerms VARCHAR(20),
    DeliveryDays INT
);

-- inventory_movement
CREATE TABLE inventory_movement (
    MovementID VARCHAR(20) PRIMARY KEY,
    ProductID VARCHAR(10),
    Date DATE,
    Type VARCHAR(10),
    Quantity INT,
    Warehouse VARCHAR(50),
    VendorID VARCHAR(10)
);

-- sales_performance
CREATE TABLE sales_performance (
    SaleID VARCHAR(20) PRIMARY KEY,
    ProductID VARCHAR(10),
    SaleDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    TotalSale DECIMAL(10, 2),
    DiscountPercent VARCHAR(10),
    CustomerType VARCHAR(20),
    Region VARCHAR(20)
);

-- vendor_summary
CREATE TABLE vendor_summary (
    VendorID VARCHAR(10),
    VendorName VARCHAR(255),
    TotalPurchases DECIMAL(15, 2),
    AvgDeliveryDays DECIMAL(5, 2),
    ProductCount INT,
    AvgUnitCost DECIMAL(10, 2),
    TotalSales DECIMAL(15, 2),
    GrossProfit DECIMAL(15, 2),
    GP_Percent DECIMAL(5, 2)
);
-- 🧠 Vendor Performance Summary (Total Purchase, Sales, GP%)
SELECT 
    vt.VendorID,
    vt.VendorName,
    ROUND(SUM(vt.TotalCost), 2) AS TotalPurchases,
    ROUND(SUM(sp.TotalSale), 2) AS TotalSales,
    ROUND(SUM(sp.TotalSale) - SUM(vt.TotalCost), 2) AS GrossProfit,
    ROUND((SUM(sp.TotalSale) - SUM(vt.TotalCost)) / NULLIF(SUM(sp.TotalSale), 0) * 100, 2) AS GP_Percentage
FROM vendor_transactions vt
JOIN sales_performance sp ON vt.ProductID = sp.ProductID
GROUP BY vt.VendorID, vt.VendorName
ORDER BY GrossProfit DESC;

-- 🚚 Vendors with High Delivery Delays
SELECT 
    VendorID,
    VendorName,
    ROUND(AVG(DeliveryDays), 2) AS AvgDeliveryDays
FROM vendor_transactions
GROUP BY VendorID, VendorName
HAVING AVG(DeliveryDays) > 7
ORDER BY AvgDeliveryDays DESC;

-- 🎯 Top 10 Products with High Discounts & Low Revenue
SELECT 
    ProductID,
    AVG(CAST(REPLACE(DiscountPercent, '%', '') AS UNSIGNED)) AS AvgDiscount,
    SUM(TotalSale) AS TotalRevenue
FROM sales_performance
GROUP BY ProductID
ORDER BY AvgDiscount DESC, TotalRevenue ASC
LIMIT 10;

-- 🧾 Category-wise Sales Summary
SELECT 
    pm.Category,
    SUM(sp.TotalSale) AS TotalSales,
    COUNT(sp.SaleID) AS Transactions,
    ROUND(AVG(sp.UnitPrice), 2) AS AvgPrice
FROM sales_performance sp
JOIN product_master pm ON sp.ProductID = pm.ProductID
GROUP BY pm.Category
ORDER BY TotalSales DESC;

-- 🏬 Inventory IN vs OUT by Warehouse
SELECT 
    Warehouse,
    SUM(CASE WHEN Type = 'In' THEN Quantity ELSE 0 END) AS InQuantity,
    SUM(CASE WHEN Type = 'Out' THEN Quantity ELSE 0 END) AS OutQuantity,
    (SUM(CASE WHEN Type = 'In' THEN Quantity ELSE 0 END) -
     SUM(CASE WHEN Type = 'Out' THEN Quantity ELSE 0 END)) AS NetStock
FROM inventory_movement
GROUP BY Warehouse;

-- 🏆 Vendor Ranking from Vendor Summary
SELECT 
    VendorID,
    VendorName,
    TotalSales,
    TotalPurchases,
    GrossProfit,
    GP_Percent
FROM vendor_summary
ORDER BY GP_Percent DESC;


