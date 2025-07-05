create database Sales;
create table SalesData( 
  Order_ID INT,
  Product_Name VARCHAR(50),
  Region VARCHAR(20),
  Sales_Manager VARCHAR(50),
  Quantity INT,
  Unit_Price FLOAT,
  Discount FLOAT,
  Sales FLOAT,
  Order_Date DATE

);

select * from salesdata limit 10;

CREATE TABLE Employees (
  Employee_ID VARCHAR(10) PRIMARY KEY,
  Sales_Manager VARCHAR(50),
  Region VARCHAR(20),
  Joining_Date DATE,
  Department VARCHAR(50),
  Target_Revenue FLOAT
);

CREATE TABLE Products (
  Product_ID VARCHAR(10) PRIMARY KEY,
  Product_Name VARCHAR(50),
  Category VARCHAR(50),
  Cost_Price FLOAT,
  Launch_Date DATE
  
);



-- 1. Total Revenue
SELECT SUM(Sales) AS Total_Revenue FROM SalesData;

-- 2. Orders by Region
SELECT Region, COUNT(*) AS Total_Orders FROM SalesData GROUP BY Region;

-- 3. Unique Products Sold
SELECT DISTINCT Product_Name FROM SalesData;

-- 4. Discount by Manager
SELECT Sales_Manager, SUM(Discount) AS Total_Discount FROM SalesData GROUP BY Sales_Manager;

-- 5. Average Price per Product
SELECT Product_Name, AVG(Unit_Price) AS Avg_Unit_Price FROM SalesData GROUP BY Product_Name;

-- 1. Revenue vs Target per Manager
SELECT e.Employee_ID, e.Sales_Manager, e.Target_Revenue,
       SUM(s.Sales) AS Actual_Revenue,
       (SUM(s.Sales) - e.Target_Revenue) AS Difference
FROM SalesData s
JOIN Employees e ON s.Sales_Manager = e.Sales_Manager
GROUP BY e.Employee_ID, e.Sales_Manager, e.Target_Revenue;

-- 2. Product Profitability
SELECT p.Product_ID, p.Product_Name,
       SUM(s.Sales) AS Total_Sales,
       SUM(s.Quantity * p.Cost_Price) AS Total_Cost,
       SUM(s.Sales - s.Quantity * p.Cost_Price) AS Total_Profit
FROM SalesData s
JOIN Products p ON s.Product_Name = p.Product_Name
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Total_Profit DESC;

-- 3. 7-Day Rolling Revenue
SELECT Order_Date,
       SUM(Sales) OVER (ORDER BY Order_Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Rolling_7_Day_Revenue
FROM SalesData;

-- 4. Top 3 Managers by Region
SELECT Region, Sales_Manager, Total_Revenue FROM (
    SELECT Region, Sales_Manager, SUM(Sales) AS Total_Revenue,
           RANK() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS ranks
    FROM SalesData
    GROUP BY Region, Sales_Manager
) AS Ranked
WHERE ranks <= 3;

-- 5. Monthly Discount & Sales Trend
SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS Month,
       AVG(Discount) AS Avg_Discount,
       SUM(Sales) AS Total_Sales
FROM SalesData
GROUP BY Month
ORDER BY Month;

-- 6. Underperforming Products (Below Average Revenue)
WITH product_revenue AS (
  SELECT Product_Name, SUM(Sales) AS Total_Revenue
  FROM SalesData
  GROUP BY Product_Name
),
avg_revenue AS (
  SELECT AVG(Total_Revenue) AS Avg_Revenue FROM product_revenue
)
SELECT p.Product_Name, pr.Total_Revenue
FROM product_revenue pr, avg_revenue ar
JOIN Products p ON pr.Product_Name = p.Product_Name
WHERE pr.Total_Revenue < ar.Avg_Revenue;

-- 7. Manager Performance Year-wise
SELECT Sales_Manager, YEAR(Order_Date) AS Year,
       SUM(Sales) AS Yearly_Revenue
FROM SalesData
GROUP BY Sales_Manager, YEAR(Order_Date)
ORDER BY Sales_Manager, Year;

-- 8. Product Launch Delay Analysis
SELECT s.Product_Name, MIN(s.Order_Date) AS First_Sale_Date, p.Launch_Date,
       DATEDIFF(MIN(s.Order_Date), p.Launch_Date) AS Days_To_First_Sale
FROM SalesData s
JOIN Products p ON s.Product_Name = p.Product_Name
GROUP BY s.Product_Name, p.Launch_Date
ORDER BY Days_To_First_Sale;

-- 9. Employee Experience vs Sales
SELECT e.Employee_ID, e.Sales_Manager, e.Joining_Date,
       TIMESTAMPDIFF(YEAR, e.Joining_Date, CURDATE()) AS Years_Served,
       SUM(s.Sales) AS Total_Sales
FROM Employees e
JOIN SalesData s ON e.Sales_Manager = s.Sales_Manager
GROUP BY e.Employee_ID, e.Sales_Manager, e.Joining_Date
ORDER BY Years_Served DESC, Total_Sales DESC;

-- 10. Seasonal Sales Pattern
SELECT QUARTER(Order_Date) AS Quarter,
       Product_Name,
       SUM(Sales) AS Total_Sales
FROM SalesData
GROUP BY QUARTER(Order_Date), Product_Name
ORDER BY Quarter, Total_Sales DESC;





