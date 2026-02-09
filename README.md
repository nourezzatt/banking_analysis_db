# Banking Transaction Analysis System (Fintech SQL)

## Project Overview
This project is a Fintech-focused SQL implementation designed to simulate a banking backend. It focuses on managing customer accounts, tracking multi-category transactions, and performing financial data analysis to derive business insights.

## Key Features
- **Financial Data Modeling**: Designed a robust schema to handle high-precision financial data (`DECIMAL` types) and transaction history.
- **Fintech Analysis**:
    - **Cash Flow Analysis**: Tracking net monthly inflows and outflows.
    - **Risk Monitoring**: Identifying high-value transactions for potential fraud review.
    - **Spending Behavior**: Categorizing transactions by merchant type (Food, Transport, Rent, etc.) to analyze customer habits.
- **Advanced SQL Techniques**:
    - Conditional Aggregations (`CASE WHEN`).
    - Date Formatting and Time-series grouping.
    - Complex Joins for customer profiling.

## Database Schema
- **Customers**: Stores personal details and account types.
- **Accounts**: Tracks real-time balances and account statuses.
- **Transactions**: A detailed ledger of all financial movements, including metadata like merchant categories and descriptions.

## Business Value
This system demonstrates how SQL can be used in a Fintech environment to:
1. Monitor liquidity and account health.
2. Provide data for financial dashboards.
3. Support risk management and compliance teams by flagging unusual activity.

## Author
**Nour Ezzat**
*BSc in Business and Computing Student*
