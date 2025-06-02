# ⚡ Smart Meter Anomaly Detection System

This repository contains the codebase, sample data, and documentation for my final year dissertation project submitted for the **BSc in Computing & IT**.

The project focuses on building a scalable, intelligent anomaly detection pipeline using smart electricity meter data from thousands of households across London. It combines data engineering, machine learning, and real-time visualization to detect energy misuse, faults, and unexpected consumption patterns.

---

##  Objectives

- Designed an end-to-end machine learning pipeline for time-series anomaly detection.
- Detected unusual electricity usage patterns across different seasons and household groups.
- Implemented scalable, efficient data processing techniques for large volumes (150M+ rows).
- Delivered interpretable results through Metabase dashboards and model evaluation visuals.

---

##  Technologies & Tools Used

| Category          | Stack Used                            |
|------------------|----------------------------------------|
| ML Models        | Isolation Forest, Conv1D Autoencoder   |
| Data Engineering | PostgreSQL, DuckDB, Apache Kafka       |
| Scripting        | Python, Pandas, scikit-learn, TensorFlow |
| Visualization    | Metabase, Matplotlib, Seaborn          |
| Deployment       | Jupyter Notebooks, SQL, Bash           |

---

##  Project Structure

```plaintext
smart-meter-anomaly-detection/
│
├── database and feature extraction/           # SQL datasets and database schema
│   ├── database/
│   │   └── create_tables.sql                  ← PostgreSQL schema for smart meter data
│   ├── training/
│   │   └── sample.sql                         ← Stratified sample for model training
│   └── model_testing/
│       ├── test_sets.sql                      ← Testing sets from unseen time periods
│       ├── testing_and_results_new_auto_encoder.sql ← Autoencoder testing with synthetic anomalies
│       └── testing_and_result_new_if.sql      ← Isolation Forest testing with synthetic anomalies
│
├── data analysis/                             # Exploratory analysis and dashboard queries
│   └── metabase_questions.sql                 ← Visualised Metabase SQL queries
│
├── Machine Learning Models/                   # Python notebooks for model training
│   └── isolation_forest_and_conv1d-ae_neural_network.ipynb  ← Full ML pipeline
│
├── README.md                                  # Project overview (this file)
└── .gitignore                                 # Excludes raw data and cache files
