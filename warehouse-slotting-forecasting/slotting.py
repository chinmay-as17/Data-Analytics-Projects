# 📦 Warehouse Slotting & 7-Day Demand Forecast Optimizer

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA

# -------------------------------
# STEP 1: Load & Explore Data
# -------------------------------
df = pd.read_csv('data/warehouse_inventory.csv')

print("\n🔍 Preview of Data:")
print(df.head())

print(f"\n📏 Rows: {df.shape[0]}, Columns: {df.shape[1]}")
print("\n🧱 Column Names:", df.columns.tolist())
print("\n📊 Statistics:")
print(df.describe(include='all'))
print("\n🚨 Missing Values:")
print(df.isnull().sum())

# -------------------------------
# STEP 2: Classify SKUs (Fast / Medium / Slow)
# -------------------------------
high = df['Daily_Picks'].quantile(0.7)
low = df['Daily_Picks'].quantile(0.3)

def classify(picks):
    if picks >= high:
        return 'Fast Mover'
    elif picks <= low:
        return 'Slow Mover'
    else:
        return 'Medium Mover'

df['Movement_Class'] = df['Daily_Picks'].apply(classify)
print("\n✅ Movement Classification:")
print(df[['SKU', 'Daily_Picks', 'Movement_Class']])

df.to_csv('output/slotting_classification.csv', index=False)

# -------------------------------
# STEP 3: Visualize Movement Classes
# -------------------------------
counts = df['Movement_Class'].value_counts()

# Bar Chart
plt.figure(figsize=(6,4))
counts.plot(kind='bar', color=['green','orange','red'])
plt.title('SKU Movement Classification')
plt.xlabel('Class')
plt.ylabel('Number of SKUs')
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()
plt.savefig('output/bar_chart.png')
plt.show()

# Pie Chart
plt.figure(figsize=(5,5))
counts.plot(kind='pie', autopct='%1.1f%%', startangle=140, colors=['green','orange','red'])
plt.title('SKU Movement Distribution')
plt.ylabel('')
plt.tight_layout()
plt.savefig('output/pie_chart.png')
plt.show()

# -------------------------------
# STEP 4: Assign Warehouse Zones
# -------------------------------
def assign_zone(movement):
    if movement == 'Fast Mover':
        return 'Front'
    elif movement == 'Medium Mover':
        return 'Middle'
    else:
        return 'Back'

df['Storage_Zone'] = df['Movement_Class'].apply(assign_zone)
print("\n🏷️ Slotting Sample:")
print(df[['SKU','Movement_Class','Storage_Zone']])

# -------------------------------
# STEP 5: 7-Day Forecast using ARIMA
# -------------------------------
# Simulate Sales if not present
if 'Sales' not in df.columns:
    np.random.seed(42)
    df['Sales'] = df['Daily_Picks'] + np.random.randint(-5,5,len(df))

def forecast_7_days(series):
    try:
        model = ARIMA(series, order=(1,1,1))
        fit = model.fit()
        return list(fit.forecast(7))
    except:
        return [series.iloc[-1]]*7

df['7_Day_Forecast'] = df['Sales'].apply(lambda x: forecast_7_days(df['Sales']))

# Save final CSV
df.to_csv('output/final_slotting_forecast.csv', index=False)
print("\n✅ Final slotting + forecast saved: output/final_slotting_forecast.csv")
