# E-commerce Sales & Customer Analytics

A data analytics portfolio project using MySQL and Power BI to explore retail transactions, analyze sales performance, understand customer purchasing behavior, and identify business trends.

## Project Overview

This project analyzes the UCI Online Retail dataset to uncover insights into sales, customers, products, and geographic performance. SQL is used for data quality checks and exploratory analysis, while Power BI is used to build an interactive dashboard with key performance indicators and visualizations.

## Project Type

Data Analytics · Business Intelligence

## Objectives

- Analyze overall sales and order activity.
- Identify top-performing countries and stock codes.
- Explore monthly sales trends.
- Understand customer counts and purchasing activity.
- Build an interactive Power BI dashboard with KPI cards, charts, and slicers.

## Tools & Technologies

- **MySQL** — data inspection, quality checks, and SQL analysis
- **Power BI Desktop** — data modeling, DAX measures, visualizations, and dashboard design
- **Microsoft Excel / CSV** — source data handling

## Dataset

The project uses the **Online Retail** dataset from the UCI Machine Learning Repository.

The dataset contains transactional records from a UK-based online retailer, including invoice numbers, stock codes, product descriptions, quantities, invoice dates, unit prices, customer IDs, and countries.

Dataset source: https://archive.ics.uci.edu/dataset/352/online+retail

## Project Workflow

### 1. Data Inspection and Quality Checks

The source data was loaded into MySQL. Two tables were maintained:

- `online_retail_raw` — original source data, preserved unchanged
- `online_retail_clean` — working copy used for analysis

Data quality checks identified:

- Missing customer IDs
- Missing product descriptions
- Canceled invoices
- Negative and zero quantities
- Negative and zero unit prices
- Potential duplicate records
- Invoice date validity

Potential duplicates were investigated rather than automatically deleted, because repeated invoice and product combinations can represent legitimate transactions.

### 2. SQL Analysis

SQL was used to explore transaction data and calculate:

- Sales by country
- Sales by month
- Customer counts and spending
- Order frequency
- Product and stock-code performance
- Average order value by country

Invoice dates were parsed using the `DD-MM-YYYY HH:MM` format.

### 3. Power BI Dashboard

The data was imported into Power BI Desktop, and column data types were configured. DAX measures and a calculated Sales column were used to build the report.

The dashboard includes:

- Gross Sales KPI
- Net Transaction KPI
- Total Orders KPI
- Unique Customers KPI
- Top 10 Countries by Gross Sales
- Monthly Gross Sales Trend
- Top 10 Stock Codes by Gross Sales
- Country-wise Gross Sales Summary
- Country, Product, and Customer slicers

## Key Findings

The current dashboard reports the following approximate figures:

| Metric | Result |
|---|---:|
| Gross Sales | 10.67 million |
| Net Transaction Value | 9.75 million |
| Total Orders | 22K |
| Unique Customers | 4,372 |

### Note
Gross sales excludes canceled invoices and rows with nonpositive quantities or unit prices. Signed transaction value includes positive and negative transaction values. Monetary figures are reported in the dataset's units.

## Additional observations:

- The United Kingdom accounts for approximately 84% of the dataset's signed transaction value.
- The dataset contains 4,372 unique customers with recorded customer IDs.
- Approximately 22,000 distinct non-canceled invoice numbers were identified.
- Some high-value stock codes represent postage or other transaction charges rather than ordinary products.
- The analysis identified missing customer information, missing product descriptions, canceled invoices, returns, and nonpositive prices.

These results should be interpreted according to the calculation definitions below.

## Calculation Definitions

**Gross Sales:** The current DAX measure excludes canceled invoices (invoice numbers starting with `C`) and rows with nonpositive quantities or unit prices. It therefore represents filtered positive sales activity, not an accounting-reconciled gross sales figure.

**Net Transaction Value:** The sum of signed transaction values (`quantity × unit_price`) across all rows, including negative values and canceled invoices. It should not be interpreted as finalized accounting net sales without further reconciliation.

**Total Orders:** The distinct count of invoice numbers excluding invoice numbers starting with `C`. It can still include invoices containing returns.

**Unique Customers:** The distinct count of nonempty customer IDs.

The displayed figures are rounded. The source dataset does not include an explicit currency column, so monetary figures should not be assigned a currency without confirming the dataset's convention.

## Dashboard Preview

The interactive Power BI dashboard summarizes sales performance, order activity, customer reach, and country-level trends.

![E-commerce Sales Dashboard](Images/Dashboard.png)

## Dashboard Features

- KPI cards for Gross Sales, Net Transaction Value, Total Orders, and Unique Customers
- Top 10 countries by gross sales
- Monthly gross sales trend
- Top 10 stock codes by gross sales
- Country-wise gross sales summary
- Interactive slicers for country, product, and customer

## Skills Demonstrated

- **SQL & MySQL:** Data quality checks, filtering, aggregation, date conversion, and exploratory analysis
- **Power BI:** Interactive dashboards, KPI cards, charts, tables, and slicers
- **DAX:** Calculated columns and measures for sales, orders, and customer metrics
- **Data Cleaning:** Identifying missing values, canceled invoices, returns, and invalid business values
- **Business Analysis:** Evaluating geographic sales distribution, customer activity, and monthly trends
- **Data Visualization:** Presenting findings through an interactive business intelligence dashboard

## Future Improvements

- Reconcile gross sales, returns, and canceled invoices with a clearly defined accounting approach.
- Add customer segmentation and repeat-purchase analysis.
- Improve product descriptions and distinguish merchandise from postage and other charges.
- Validate the full monthly date range and compare equivalent months across years.
- Add further customer retention and profitability metrics if suitable data becomes available.

## Conclusion

This project demonstrates an end-to-end analytics workflow using MySQL and Power BI, from inspecting transactional data and assessing data quality to creating an interactive dashboard that summarizes sales, orders, customers, countries, and stock-code performance.
