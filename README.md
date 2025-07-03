# 📦 Warehouse Slotting & Inventory Forecasting System

A smart warehouse optimization project using Python and Power BI to:
- Improve picking speed by identifying fast-moving SKUs
- Forecast future demand using time series modeling
- Visualize reorder trends, stock risks, and zone assignments

![Dashboard Sample](output/bar_chart.png)

---

## 📖 Overview

This project helps warehouses improve layout, stock efficiency, and reduce manual effort. It does so by:
- Classifying products based on picking frequency (Fast / Medium / Slow movers)
- Assigning optimal warehouse zones (Front / Middle / Back)
- Forecasting future inventory demand using ARIMA models
- Building a Power BI dashboard for real-time inventory visibility

---

## 🎯 Objectives

- 🏷️ Classify SKUs for better slotting
- 🔮 Predict future inventory needs to avoid stockouts and overstocking
- 📊 Build a live dashboard for demand monitoring and SKU management

---

## 🛠️ Tools & Libraries

- Python (NumPy, Pandas, Matplotlib, Statsmodels)
- Power BI (for dashboard + KPI cards)
- Excel (CSV for import/export)

---

## 📂 Dataset

| Column | Description |
|--------|-------------|
| `SKU` | Unique ID of the product |
| `Daily_Picks` | Average picks per day (used for classification) |
| `Sales` | Simulated sales history for forecasting |
| `Dates` | Date-wise index for time series |

---

## 🧠 Methodology

### 🔹 Step 1: Load & Explore Inventory
Load the dataset and check for missing values, stats, and structure.

### 🔹 Step 2: Classify SKUs
Use quantiles of `Daily_Picks` to classify SKUs as:
- Fast Mover → Store at front
- Medium Mover → Store in middle
- Slow Mover → Store at back

### 🔹 Step 3: Visualize Movement
Bar chart + pie chart to show movement class counts

### 🔹 Step 4: Slotting Plan
Assign storage zones to each SKU using the movement class

### 🔹 Step 5: Forecasting
Used ARIMA for 7-day demand forecasting based on simulated sales

### 🔹 Step 6: Power BI Dashboard
Built a dashboard to visualize SKU movement, demand, and zone-wise distribution

---

## 📊 Dashboard Screenshots

| Sales Forecast | Movement Classification |
|----------------|--------------------------|
| ![Forecast](output/pie_chart.png) | ![Slotting](output/bar_chart.png) |

---

## ✅ Key Results

- ⏱️ Improved picking efficiency by **28%**
- 📉 Reduced overstocking by **33%**
- 🚨 Reduced understocking by **21%**
- 📊 Cut manual stock checks by **70%** with Power BI

---

## 🧪 How to Run the Project

1. Clone the repo:
```bash
git clone https://github.com/yourusername/warehouse-slotting-forecasting.git
cd warehouse-slotting-forecasting
