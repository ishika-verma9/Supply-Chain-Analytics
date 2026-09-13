# Trained Models

This directory documents the machine learning models developed for the
project. The trained model binaries are not included in this repository
because of GitHub's file-size constraints.

## Demand Forecasting

The following models were evaluated:

- Naive Baseline
- Linear Regression
- Random Forest
- XGBoost

**Selected model:** Random Forest

- MAE: 219.1
- RMSE: 365.6
- MAE improvement vs. naive baseline: 34.2%

## Stockout Risk Prediction

The following classification models were evaluated:

- Logistic Regression
- Random Forest Classifier

**Selected model:** Logistic Regression

- Precision: 70.8%
- Recall: 94.6%
- F1 Score: 81.0%

Model comparison outputs and feature-importance results are available in
the `reports/` directory.
