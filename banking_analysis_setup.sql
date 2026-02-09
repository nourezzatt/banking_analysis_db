-- Fintech Project: Banking Transaction Analysis System
-- Author: Nour Ezzat

-- Create and use the database
DROP DATABASE IF EXISTS banking_analysis_db;
CREATE DATABASE banking_analysis_db;
USE banking_analysis_db;

-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    AccountType ENUM('Savings', 'Checking', 'Business') DEFAULT 'Checking',
    JoinDate DATE DEFAULT (CURRENT_DATE)
);

-- 2. Accounts Table
CREATE TABLE Accounts (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    Balance DECIMAL(15, 2) DEFAULT 0.00,
    Currency VARCHAR(3) DEFAULT 'CAD',
    Status ENUM('Active', 'Suspended', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 3. Transactions Table
CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    Amount DECIMAL(15, 2) NOT NULL,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer', 'Payment') NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MerchantCategory VARCHAR(50),
    Description TEXT,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- INSERT SAMPLE DATA
INSERT INTO Customers (FirstName, LastName, Email, AccountType, JoinDate) VALUES 
('Nour', 'Ezzat', 'nour@example.com', 'Checking', '2024-01-10'),
('Liam', 'Smith', 'liam@example.com', 'Savings', '2024-02-15'),
('Emma', 'Johnson', 'emma@example.com', 'Business', '2024-03-01'),
('Sophia', 'Brown', 'sophia@example.com', 'Checking', '2024-04-20');

INSERT INTO Accounts (CustomerID, Balance, Currency, Status) VALUES 
(1, 5000.00, 'CAD', 'Active'),
(2, 12500.50, 'CAD', 'Active'),
(3, 45000.00, 'CAD', 'Active'),
(4, 1200.00, 'CAD', 'Active');

INSERT INTO Transactions (AccountID, Amount, TransactionType, MerchantCategory, Description) VALUES 
(1, -50.00, 'Payment', 'Food', 'Starbucks Toronto'),
(1, -120.00, 'Payment', 'Transport', 'TTC Monthly Pass'),
(1, 2000.00, 'Deposit', 'Salary', 'Monthly Paycheck'),
(2, -500.00, 'Withdrawal', 'ATM', 'Cash Withdrawal'),
(2, 150.00, 'Deposit', 'Transfer', 'Interac e-Transfer'),
(3, -5000.00, 'Payment', 'Inventory', 'Office Supplies'),
(3, 10000.00, 'Deposit', 'Revenue', 'Client Payment'),
(4, -1500.00, 'Payment', 'Rent', 'Monthly Rent');

-- ANALYSIS QUERIES (Fintech Focus)

-- 1. Customer Portfolio Overview
-- Joins customers with their accounts to show total liquidity
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    c.AccountType,
    a.Balance,
    a.Status
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
ORDER BY a.Balance DESC;

-- 2. High-Value Transaction Identification
-- Identifies transactions above a certain threshold for risk monitoring
SELECT 
    t.TransactionID,
    c.FirstName,
    t.Amount,
    t.TransactionType,
    t.MerchantCategory,
    t.TransactionDate
FROM Transactions t
JOIN Accounts a ON t.AccountID = a.AccountID
JOIN Customers c ON a.CustomerID = c.CustomerID
WHERE ABS(t.Amount) > 1000
ORDER BY ABS(t.Amount) DESC;

-- 3. Spending Pattern Analysis by Category
-- Aggregates spending to show where money is going
SELECT 
    MerchantCategory,
    SUM(ABS(Amount)) AS TotalSpent,
    COUNT(*) AS TransactionCount
FROM Transactions
WHERE TransactionType IN ('Payment', 'Withdrawal')
GROUP BY MerchantCategory
ORDER BY TotalSpent DESC;

-- 4. Monthly Cash Flow Summary
-- Calculates net flow (Deposits - Payments/Withdrawals)
SELECT 
    DATE_FORMAT(TransactionDate, '%Y-%m') AS Month,
    SUM(CASE WHEN Amount > 0 THEN Amount ELSE 0 END) AS TotalDeposits,
    SUM(CASE WHEN Amount < 0 THEN ABS(Amount) ELSE 0 END) AS TotalOutflow,
    SUM(Amount) AS NetCashFlow
FROM Transactions
GROUP BY Month;

-- 5. Suspicious Activity Flagging
-- Flags accounts with balances below zero (if allowed) or very low balances
SELECT 
    c.FirstName,
    c.Email,
    a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
WHERE a.Balance < 500;
