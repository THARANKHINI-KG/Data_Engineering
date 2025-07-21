--------- CREATING DATABASE ---------
create database HMBank;

use HMBank;

--------- CREATING TABLES ---------

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    address VARCHAR(255)
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    account_type VARCHAR(20) CHECK (account_type IN ('savings', 'current', 'zero_balance')),
    balance DECIMAL(15, 2) CHECK (balance >= 0),

    CONSTRAINT FK_Accounts_Customers FOREIGN KEY (customer_id) 
        REFERENCES Customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    account_id INT NOT NULL,
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer')),
    amount DECIMAL(15, 2) CHECK (amount > 0),
    transaction_date DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Transactions_Accounts FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--------- INSERTING VALUES INTO THE TABLE ---------

INSERT INTO Customers (first_name, last_name, DOB, email, phone_number, address) VALUES
('Alice', 'Johnson', '1990-03-15', 'alice.j@example.com', '9876543210', '123 Main St'),
('Bob', 'Smith', '1985-06-20', 'bob.smith@example.com', '9876543211', '456 Oak Ave'),
('Carol', 'Davis', '1992-01-10', 'carol.davis@example.com', '9876543212', '789 Pine Ln'),
('David', 'Miller', '1988-11-05', 'david.miller@example.com', '9876543213', '321 Cedar Rd'),
('Eva', 'Brown', '1995-09-30', 'eva.brown@example.com', '9876543214', '654 Maple St'),
('Frank', 'Wilson', '1991-12-22', 'frank.w@example.com', '9876543215', '987 Elm Blvd'),
('Grace', 'Taylor', '1987-07-18', 'grace.taylor@example.com', '9876543216', '159 Birch Ct'),
('Henry', 'Anderson', '1983-04-02', 'henry.anderson@example.com', '9876543217', '753 Walnut Dr'),
('Ivy', 'Thomas', '1996-10-25', 'ivy.thomas@example.com', '9876543218', '951 Spruce Way'),
('Jack', 'Moore', '1989-02-14', 'jack.moore@example.com', '9876543219', '852 Redwood Pl');

INSERT INTO Accounts (customer_id, account_type, balance) VALUES
(1, 'savings', 5000.00),
(2, 'current', 15000.00),
(3, 'savings', 3000.00),
(4, 'zero_balance', 0.00),
(5, 'current', 10000.00),
(6, 'savings', 7500.00),
(7, 'current', 20000.00),
(8, 'zero_balance', 0.00),
(9, 'savings', 8500.00),
(10, 'current', 12000.00);

INSERT INTO Transactions (account_id, transaction_type, amount) VALUES
(1, 'deposit', 2000.00),
(2, 'withdrawal', 3000.00),
(3, 'deposit', 1000.00),
(4, 'deposit', 500.00),
(5, 'withdrawal', 2000.00),
(6, 'deposit', 2500.00),
(7, 'transfer', 4000.00),
(8, 'deposit', 1500.00),
(9, 'withdrawal', 1000.00),
(10, 'deposit', 3000.00);

--------- QUERIES -------------

-- 1. Total deposit amount by each customer
SELECT c.first_name, c.last_name, SUM(t.amount) AS total_deposit
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_type = 'deposit'
GROUP BY c.first_name, c.last_name;

-- 2. Average transaction amount per customer
SELECT 
    c.first_name, 
    c.last_name, 
    AVG(t.amount) AS avg_transaction_amount
FROM Customers c
LEFT JOIN Accounts a ON c.customer_id = a.customer_id
LEFT JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.first_name, c.last_name;

-- 3. Total number of transactions per customer 
SELECT 
    c.first_name, 
    c.last_name, 
    COUNT(t.transaction_id) AS transaction_count
FROM Customers c
LEFT JOIN Accounts a ON c.customer_id = a.customer_id
LEFT JOIN Transactions t ON a.account_id = t.account_id
GROUP BY c.first_name, c.last_name;

-- 4. Customer with Highest Total Deposit
SELECT TOP 1 c.first_name, c.last_name, SUM(t.amount) AS total_deposit
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_type = 'deposit'
GROUP BY c.first_name, c.last_name
ORDER BY total_deposit DESC;

-- 5. Show all transactions with corresponding customer details
SELECT c.first_name, c.last_name, t.transaction_type, t.amount, t.transaction_date
FROM Customers c
INNER JOIN Accounts a ON c.customer_id = a.customer_id
INNER JOIN Transactions t ON a.account_id = t.account_id;

-- 6. Customers who made withdrawals and the total amount withdrawn
SELECT c.first_name, c.last_name, SUM(t.amount) AS total_withdrawn
FROM Customers c
RIGHT JOIN Accounts a ON c.customer_id = a.customer_id
RIGHT JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_type = 'withdrawal'
GROUP BY c.first_name, c.last_name;

--------- VIEW ALL ---------

SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Transactions;
