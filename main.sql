DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS AccountHolders;

CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE NOT NULL,
    PhoneNumber TEXT,
    Address TEXT,
    DateOfBirth DATE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Branches (
    BranchID INTEGER PRIMARY KEY AUTOINCREMENT,
    BranchName TEXT NOT NULL,
    Location TEXT NOT NULL
);

CREATE TABLE Accounts (
    AccountID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerID INTEGER,
    AccountType TEXT NOT NULL,
    Balance REAL DEFAULT 0.00,
    BranchID INTEGER,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

CREATE TABLE Transactions (
    TransactionID INTEGER PRIMARY KEY AUTOINCREMENT,
    AccountID INTEGER,
    TransactionType TEXT NOT NULL,
    Amount REAL NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE AccountHolders (
    CustomerID INTEGER,
    AccountID INTEGER,
    PRIMARY KEY (CustomerID, AccountID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE INDEX idx_lastname ON Customers(LastName);
CREATE INDEX idx_email ON Customers(Email);

CREATE INDEX idx_customerid ON Accounts(CustomerID);
CREATE INDEX idx_branchid ON Accounts(BranchID);

SELECT Customers.FirstName, Customers.LastName, Accounts.AccountType, Accounts.Balance
FROM Customers
JOIN Accounts ON Customers.CustomerID = Accounts.CustomerID;

SELECT Accounts.AccountType, Transactions.TransactionType, Transactions.Amount
FROM Accounts
JOIN Transactions ON Accounts.AccountID = Transactions.AccountID;

SELECT Customers.FirstName, Customers.LastName, Accounts.AccountType, Branches.BranchName
FROM Customers
JOIN Accounts ON Customers.CustomerID = Accounts.CustomerID
JOIN Branches ON Accounts.BranchID = Branches.BranchID;

SELECT * FROM Customers
JOIN Accounts ON Customers.CustomerID = Accounts.CustomerID
WHERE Accounts.Balance > 10000;

SELECT * FROM Transactions
WHERE TransactionDate >= datetime('now', '-30 days');

SELECT * FROM Accounts
WHERE BranchID = 1;

SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Accounts WHERE AccountID IN (SELECT AccountID FROM Transactions));

SELECT * FROM Transactions
JOIN Accounts ON Transactions.AccountID = Accounts.AccountID
WHERE Accounts.CustomerID = 1;

SELECT SUM(Balance) FROM Accounts
WHERE BranchID = 1;

SELECT Customers.FirstName, Customers.LastName, COUNT(Accounts.AccountID) AS NumberOfAccounts
FROM Customers
JOIN Accounts ON Customers.CustomerID = Accounts.CustomerID
GROUP BY Customers.CustomerID;

SELECT AccountID, AVG(Amount) AS AverageAmount
FROM Transactions
GROUP BY AccountID;

SELECT Branches.BranchName, COUNT(Accounts.AccountID) AS NumberOfAccounts
FROM Branches
JOIN Accounts ON Branches.BranchID = Accounts.BranchID
GROUP BY Branches.BranchID
HAVING COUNT(Accounts.AccountID) > 100;

SELECT * FROM Accounts
WHERE AccountID NOT IN (SELECT AccountID FROM Transactions WHERE TransactionDate >= datetime('now', '-1 year'));
