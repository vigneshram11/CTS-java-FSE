BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE loans';
  EXECUTE IMMEDIATE 'DROP TABLE customers';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/


CREATE TABLE customers (
  customer_id NUMBER,
  name VARCHAR2(50),
  age NUMBER,
  balance NUMBER,
  loan_interest_rate NUMBER,
  isVIP VARCHAR2(5)
);


CREATE TABLE loans (
  loan_id NUMBER,
  customer_id NUMBER,
  loan_due_date DATE
);


BEGIN
  INSERT INTO customers VALUES (1, 'Ravi', 65, 15000, 9.5, 'FALSE');
  INSERT INTO customers VALUES (2, 'Meena', 45, 5000, 10.0, 'FALSE');
  INSERT INTO customers VALUES (3, 'John', 70, 12000, 11.0, 'FALSE');
  INSERT INTO customers VALUES (4, 'Sara', 30, 9500, 8.5, 'FALSE');

  INSERT INTO loans VALUES (101, 1, SYSDATE + 10);
  INSERT INTO loans VALUES (102, 2, SYSDATE + 40);
  INSERT INTO loans VALUES (103, 3, SYSDATE + 5);
  INSERT INTO loans VALUES (104, 4, SYSDATE + 20);

  COMMIT;
END;
/

-- Scenario 1: Apply 1% Interest Discount for Customers > 60
BEGIN
  FOR rec IN (SELECT customer_id, loan_interest_rate FROM customers WHERE age > 60)
  LOOP
    UPDATE customers
    SET loan_interest_rate = rec.loan_interest_rate - 1
    WHERE customer_id = rec.customer_id;
  END LOOP;

  COMMIT;
END;
/

-- Scenario 2: Promote to VIP if Balance > 10,000
BEGIN
  FOR rec IN (SELECT customer_id FROM customers WHERE balance > 10000)
  LOOP
    UPDATE customers
    SET isVIP = 'TRUE'
    WHERE customer_id = rec.customer_id;
  END LOOP;

  COMMIT;
END;
/

-- Scenario 3: Print Loan Reminders
SET SERVEROUTPUT ON;
BEGIN
  FOR rec IN (SELECT l.customer_id, c.name, l.loan_due_date
              FROM loans l
              JOIN customers c ON l.customer_id = c.customer_id
              WHERE l.loan_due_date <= SYSDATE + 30)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Reminder: Dear ' || rec.name || ', your loan is due on ' || TO_CHAR(rec.loan_due_date, 'DD-MON-YYYY'));
  END LOOP;
END;
/

-- View Final Customer Table
SELECT * FROM customers;
