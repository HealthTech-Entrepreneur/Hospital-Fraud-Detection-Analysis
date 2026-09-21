# Protecting Hospital Revenue: End-to-End Healthcare Fraud Detection Analysis
I analyzed 10,000 healthcare claims and identified 826 fraudulent cases representing $800K+ dollars in revenue at risk.

## The Story: Protecting $800K in Revenue at Risk

In revenue cycle management (RCM), unaddressed billing anomalies drain hospital margins and create severe regulatory compliance liabilities. This project simulates an audit of **10,000 healthcare claim records** to uncover systemic fraud patterns, calculate direct financial exposure, and arm healthcare executives with data-driven recovery strategies.

By combining structured SQL auditing, Python hypothesis testing, custom feature engineering, and a star-schema Power BI dashboard, this pipeline turns millions of dollars in raw claims into actionable financial defense.

---

## Technical Pipeline & Workflow

```
[ Raw Dataset (10,000 Claim Records | 20 Base Columns) ]
                          │
                          ▼
[ 1. Microsoft SQL Server Management Studio (SSMS) ]
  └── Ingested claims data & executed 18 business-focused SQL queries
                          │
                          ▼
[ 2. Python Data Processing & Statistical EDA ]
  ├── Detailed Data Cleaning & Null Handling
  ├── Exploratory Data Analysis (Univariate, Bivariate, Multivariate)
  ├── Statistical Validation (T-Tests, ANOVA, Hypothesis Testing, Chi-Square Test)
  └── Feature Engineering (Expanded dataset from 20 to 39 enriched variables)
                          │
                          ▼
[ 3. Power BI Executive Suite ]
  ├── Constructed Dimensional Star Schema Data Model
  ├── Developed 25+ Custom DAX Atomic & Composite Measures
  └── Designed 4 Interactive Dynamic Dashboard Pages

```

---

## 1. SQL Business Investigation (SSMS)

Data was imported into **Microsoft SQL Server Management Studio (SSMS)** to conduct an inaugural audit answering **18 core business queries** across financial, clinical, and operational pillars:

* **Revenue Exposure:** Quantified overall fraud rates, monthly financial leakages, and uncollected revenue gaps.


* **Payer & Provider Risk:** Identified high-risk insurance payers, provider specialties, and repeat offender providers.


* **Operational Bottlenecks:** Analyzed claim submission delays (e.g., >30 days) and identified fraudulent billing code combinations.



---

## 2. Python Analytics & Feature Engineering

Using Jupyter Notebooks, the dataset underwent statistical examination and feature enrichment:

* **Exploratory Data Analysis (EDA):** Performed univariate, bivariate, and multivariate analysis to understand distribution patterns across patient demographics, claim sizes, and provider categories.


* **Statistical Hypothesis Testing:** Ran **T-Tests** and **ANOVA** models to mathematically prove that fraudulent claims carried statistically higher billing amounts rather than random variation.


* **Feature Engineering:** Transformed the core raw structure from **20 initial columns into 39 enriched variables**, adding risk scoring flags, claim age brackets, clinical severity indices, and financial risk flags.

---

## 3. Power BI Interactive Suite

The engineered dataset was loaded into Power BI to build an executive reporting system:

* **Star Schema Architecture:** Formed a clean dimensional model separating fact tables (Claims) from dimension tables (Providers, Patients, Payers, Codes).
* **25+ DAX Measures:** Engineered DAX calculations for dynamic fraud rates, total revenue at fraud risk, claim collection percentages, and period-over-period trend analysis.
* **4 Interactive Dashboards:**
1. **Financial Overview:** Highlights top-line revenue at risk, claim volume counts, and high-level fraud percentages.


2. **Payer & Provider Risk Evaluation:** Pinpoints repeat offender providers and payer-specific risk profiles.


3. **Patient Demographics & Geographic Risk:** Maps geographic fraud concentration by state and clinical age brackets.


4. **Operational RCM Audit:** Details Top 15 high-risk claims, CPT/ICD-10 billing code anomalies, and claim submission lag patterns.


---

## Key Business Insights

* **Financial Exposure:** Identified over **$800,000+ in Revenue at Fraud Risk** across 829 flagged audit cases.
* **Submission Lag Indicator:** Claims submitted more than 30 days after treatment showed a significantly higher correlation with billing anomalies.


* **Concentrated Risk:** A small subset of repeat offender providers accounted for a disproportionate share of high-value fraudulent billing claims.
