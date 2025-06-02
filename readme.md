#  Smart Meter Anomaly Detection System

This repository contains the codebase, sample data, and documentation for my final year dissertation project submitted for the BSc in Computing & IT.

The project focuses on building a scalable, intelligent anomaly detection pipeline using smart electricity meter data from thousands of households across London. It combines data engineering, machine learning, and real-time visualization to detect energy misuse, faults, and unexpected patterns.

---

##  Objectives

- Designed an end-to-end machine learning pipeline for time-series anomaly detection.
- Detected unusual electricity usage patterns across different seasons and household types.
- Implemented a scalable and efficient data processing techniques for large volumes (150M+ rows).
- Delivered interpretable results through dashboards and model evaluation visuals using metabase.

---

## 🧠 Technologies & Tools Used

| Category          | Stack Used                          |
|-------------------|--------------------------------------|
| ML Models         | Isolation Forest, Conv1D Autoencoder |
| Data Engineering  | PostgreSQL, DuckDB, Apache Kafka     |
| Scripting         | Python, Pandas, scikit-learn, TensorFlow |
| Visualization     | Metabase, Matplotlib, Seaborn        |
| Deployment        | Jupyter Notebooks, SQL, Bash         |

---

## Project Structure

smart-meter-anomaly-detection/
│
├── database and feature extraction/                         # storage for datasets.
│   ├── database/create_tables.sql       ← database schema
│   ├── training/sample.sql             ← stratified sample for training
│   ├── model_testing/test_sets.sql         ← Testing data
│   ├── model_testing/testing_and_results_new_auto_encoder.sql ← Neural Network Testing data with synthetic anomalies.
│   └── model_testing/testing_and_result_new_if.sql ← Testing data with synthetic anomalies for Isolation Forest.
├── data analysis/                         # Exploritory Data Analysis for the smart meter data.
│   └── data analysis/metabase_questions.sql                ← Visualised metabase queries with aggregations.   
│
├── Machine Learning Models/                         # Python Notebook.
│   ├── isolation_forest_and_conv1d-ae_neural_network.ipynb  ← Model training and testing.        
├── README.md                     # Project overview (this file)
└── .gitignore                    # Files/folders excluded from Git

##  Results

- Achieved **98% precision** using Conv1D Autoencoder on stratified seasonal validation sets with synthetic anomalies.
- Pipeline performance optimized to handle **millions of rows** using chunked loading and stratified sampling.
- Visual insights delivered via **Metabase dashboards**.

