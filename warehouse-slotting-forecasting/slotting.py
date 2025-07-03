# 📦 Warehouse Slotting Optimizer - Step 1: Load & Explore Data

import pandas as pd  # For working with data

# Load the CSV file
df = pd.read_csv('data/warehouse_inventory.csv')

# Show the first 5 rows
print("\n🔍 Preview of Data:")
print(df.head())

# Print shape of the data
print(f"\n📏 Total Rows: {df.shape[0]}, Columns: {df.shape[1]}")

# Show column names
print("\n🧱 Column Names:")
print(df.columns.tolist())

# Show basic stats
print("\n📊 Basic Statistics:")
print(df.describe(include='all'))

# Show if any data is missing
print("\n🚨 Null / Missing Values:")
print(df.isnull().sum())

# 🎯 STEP 2: Classify SKUs into Fast / Medium / Slow movers

# Get the thresholds
high_threshold = df['Daily_Picks'].quantile(0.7)
low_threshold = df['Daily_Picks'].quantile(0.3)

# Define a function to classify each row
def classify_movement(picks):
    if picks >= high_threshold:
        return 'Fast Mover'
    elif picks <= low_threshold:
        return 'Slow Mover'
    else:
        return 'Medium Mover'

# Apply the classification to the dataframe
df['Movement_Class'] = df['Daily_Picks'].apply(classify_movement)

# Print the results
print("\n✅ Movement Classification Added:")
print(df[['SKU', 'Daily_Picks', 'Movement_Class']])

# Optional: Save to output folder for Excel/opening later
df.to_csv('output/slotting_classification.csv', index=False)
print("\n📁 Output saved to: output/slotting_classification.csv")

import matplotlib.pyplot as plt

# 🎨 STEP 3: Visualize the Movement Classes

# Count how many SKUs fall in each category
movement_counts = df['Movement_Class'].value_counts()

# 📊 Bar Chart
plt.figure(figsize=(6,4))
movement_counts.plot(kind='bar', color=['green', 'orange', 'red'])
plt.title('SKU Movement Classification')
plt.xlabel('Movement Class')
plt.ylabel('Number of SKUs')
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()
plt.savefig('output/bar_chart.png')
print("📊 Bar chart saved to output/bar_chart.png")
plt.show()

# 🥧 Pie Chart
plt.figure(figsize=(5,5))
movement_counts.plot(kind='pie', autopct='%1.1f%%', startangle=140, colors=['green', 'orange', 'red'])
plt.title('SKU Movement Distribution')
plt.ylabel('')
plt.tight_layout()
plt.savefig('output/pie_chart.png')
print("🥧 Pie chart saved to output/pie_chart.png")
plt.show()

# 🤖 STEP 4: Warehouse Slotting Logic

def assign_zone(movement_class):
    if movement_class == 'Fast Mover':
        return 'Front'
    elif movement_class == 'Medium Mover':
        return 'Middle'
    else:
        return 'Back'

# Apply the logic to create a new column
df['Storage_Zone'] = df['Movement_Class'].apply(assign_zone)

# Show sample of the result
print("\n🏷️ Slotting Suggestions (Sample):")
print(df[['SKU', 'Movement_Class', 'Storage_Zone']])

# Save final result
df.to_csv('output/final_slotting_plan.csv', index=False)
print("✅ Final slotting plan saved to output/final_slotting_plan.csv")
