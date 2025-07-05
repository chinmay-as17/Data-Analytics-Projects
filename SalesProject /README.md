# 📊 Sales Performance Dashboard (SQL + Excel Project)

A complete SQL + Excel project analyzing over 1,000 sales transactions across 4 regions and 6 products. Built to extract actionable KPIs, automate reporting, and impress interviewers with advanced SQL and structured data modeling.

## 🔧 Tools Used
- MySQL
- Excel
- SQL (JOINs, CTEs, Window Functions)
- [Optional: Power BI / Tableau if added later]

## 📂 Project Structure

- `Sales_Data_1000.csv` → Raw sales data with 1000+ rows
- `Employee_and_Product_Data.xlsx` → Master data tables

## 🚀 What This Project Shows

- Real-world schema design with normalized tables
- Joins between Sales ↔ Employees ↔ Products
- Business-focused KPIs:
  - Revenue vs Target
  - Product profitability
  - Rolling revenue
  - Seasonal trends
  - Manager-wise analysis

## 📌 Sample Advanced Query

```sql
SELECT e.Employee_ID, e.Sales_Manager, e.Target_Revenue,
       SUM(s.Sales) AS Actual_Revenue,
       (SUM(s.Sales) - e.Target_Revenue) AS Revenue_Difference
FROM SalesData s
JOIN Employees e ON s.Sales_Manager = e.Sales_Manager
GROUP BY e.Employee_ID, e.Sales_Manager, e.Target_Revenue;
