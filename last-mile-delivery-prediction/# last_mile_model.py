# Importing required libraries
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
from sklearn.preprocessing import LabelEncoder

# Step 1: Load Dataset
df = pd.read_csv("lastMile_SyntheticBalanced.csv")

# Step 2: Encode Categorical Columns
categorical_cols = ['VehicleType', 'FulfillmentChannel']
le_dict = {}
for col in categorical_cols:
    le = LabelEncoder()
    df[col] = le.fit_transform(df[col])
    le_dict[col] = le  # Save encoder if you want to decode later

# Step 3: Feature Selection
X = df.drop(columns=["DeliveryTime", "Late"])  # Drop non-predictive and target
y = df["Late"]

# Step 4: Train-Test Split (Stratified for class balance)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Step 5: Train the Model
model = RandomForestClassifier(n_estimators=100, random_state=42, class_weight='balanced')
model.fit(X_train, y_train)

# Step 6: Predictions
y_pred = model.predict(X_test)

# Step 7: Evaluation
accuracy = accuracy_score(y_test, y_pred)
matrix = confusion_matrix(y_test, y_pred)
report = classification_report(y_test, y_pred)

# Print results
print("✅ Accuracy:", accuracy)
print("✅ Confusion Matrix:\n", matrix)
print("✅ Classification Report:\n", report)

# Step 8: Export for Power BI
results_df = X_test.copy()
results_df['actual_late'] = y_test.values
results_df['predicted_late'] = y_pred
results_df['correct_prediction'] = (results_df['actual_late'] == results_df['predicted_late']).astype(int)
results_df.to_csv("delivery_model_results_realistic.csv", index=False)

print("📁 File saved: delivery_model_results_realistic.csv")
