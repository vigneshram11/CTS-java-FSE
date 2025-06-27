-- Enable DBMS output
SET SERVEROUTPUT ON;

-- Drop tables if they already exist
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE accounts';
  EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

-- Create Accounts Table
CREATE TABLE accounts (
  account_id NUMBER PRIMARY KEY,
  customer_id NUMBER,
  account_type VARCHAR2(20),
  balance NUMBER
);

-- Create Employees Table
CREATE TABLE employees (
  emp_id NUMBER PRIMARY KEY,
  name VARCHAR2(50),
  department VARCHAR2(30),
  salary NUMBER
);

-- Insert sample data into Accounts
BEGIN
  INSERT INTO accounts VALUES (1, 101, 'savings', 10000);
  INSERT INTO accounts VALUES (2, 102, 'savings', 5000);
  INSERT INTO accounts VALUES (3, 101, 'current', 7000);
  INSERT INTO accounts VALUES (4, 103, 'savings', 2000);
  COMMIT;
END;
/

-- Insert sample data into Employees
BEGIN
  INSERT INTO employees VALUES (1, 'Anita', 'Sales', 30000);
  INSERT INTO employees VALUES (2, 'Raj', 'IT', 40000);
  INSERT INTO employees VALUES (3, 'Divya', 'Sales', 35000);
  INSERT INTO employees VALUES (4, 'John', 'HR', 28000);
  COMMIT;
END;
/

-- Scenario 1: ProcessMonthlyInterest (1% for savings)
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
  UPDATE accounts
  SET balance = balance + (balance * 0.01)
  WHERE account_type = 'savings';
  
  COMMIT;
END;
/

-- Scenario 2: UpdateEmployeeBonus
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
  p_department IN VARCHAR2,
  p_bonus_percent IN NUMBER
) IS
BEGIN
  UPDATE employees
  SET salary = salary + (salary * p_bonus_percent / 100)
  WHERE department = p_department;

  COMMIT;
END;
/

-- Scenario 3: TransferFunds between accounts
CREATE OR REPLACE PROCEDURE TransferFunds (
  p_from_account IN NUMBER,
  p_to_account IN NUMBER,
  p_amount IN NUMBER
) IS
  v_balance NUMBER;
BEGIN
  SELECT balance INTO v_balance FROM accounts WHERE account_id = p_from_account;

  IF v_balance < p_amount THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
  END IF;

  UPDATE accounts
  SET balance = balance - p_amount
  WHERE account_id = p_from_account;

  UPDATE accounts
  SET balance = balance + p_amount
  WHERE account_id = p_to_account;

  COMMIT;
END;
/

-- execute all 3 procedures
BEGIN
  ProcessMonthlyInterest;
  UpdateEmployeeBonus('Sales', 10);
  TransferFunds(1, 2, 2000);
END;
/

-- display account and employee info (inside PL/SQL block)
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Final Account Balances ---');
  FOR rec IN (SELECT * FROM accounts) LOOP
    DBMS_OUTPUT.PUT_LINE('Account ' || rec.account_id || 
                         ' (Type: ' || rec.account_type || ') - Balance: ' || rec.balance);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('--- Final Employee Salaries ---');
  FOR emp IN (SELECT * FROM employees) LOOP
    DBMS_OUTPUT.PUT_LINE(emp.name || ' (' || emp.department || ') - Salary: ' || emp.salary);
  END LOOP;
END;
/