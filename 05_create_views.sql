CREATE OR REPLACE VIEW vw_first_normal_form AS
SELECT 
    c.id AS customer_id,
    c.firstname || ' ' || c.lastname AS full_name,
    c.phone,
    c.email,
    a.id AS account_id,
    a.balance,
    bc.id AS card_id,
    CASE 
      WHEN bc.is_locked = 1 THEN 'Yes'
      WHEN bc.is_locked = 0 THEN 'No'
      ELSE NULL
   END AS card_locked
FROM 
    customers c
LEFT JOIN 
    account a ON c.id = a.customer_id
LEFT JOIN 
    bank_card bc ON a.id = bc.account_id
/
-- SELECT * FROM vw_first_normal_form where customer_id = 10500;

CREATE OR REPLACE VIEW vw_account_transactions AS
SELECT
    a.id AS account_id,
    t.id AS transaction_id,
    t.source_account,
    t.target_account,
    t.amount
FROM
    account a
LEFT JOIN
    transaction t ON a.id = t.source_account OR a.id = t.target_account
WHERE t.id IS NOT NULL
ORDER BY
    a.id, t.id;
/
-- SELECT * FROM transaction;
-- SELECT * FROM vw_account_transactions WHERE account_id = 1000;

CREATE OR REPLACE VIEW vw_customer_account_summary AS
SELECT
    c.id AS customer_id,
    c.firstname || ' ' || c.lastname AS full_name,
    c.email,
    c.phone,
    COUNT(a.id) AS account_count,
    NVL(SUM(a.balance), 0) AS total_balance
FROM
    customers c
LEFT JOIN
    account a ON c.id = a.customer_id
GROUP BY
    c.id, c.firstname, c.lastname, c.email, c.phone;
/
-- SELECT * FROM vw_customer_account_summary

CREATE OR REPLACE VIEW vw_inactive_customers AS
SELECT
    c.id AS customer_id,
    c.firstname || ' ' || c.lastname AS full_name,
    c.email,
    c.phone
FROM
    customers c
LEFT JOIN
    account a ON c.id = a.customer_id
LEFT JOIN
    transaction t ON a.id = t.source_account OR a.id = t.target_account
WHERE
    a.id IS NULL OR t.id IS NULL;
/
/*
begin
  pkg_manage_bank.create_customer('Kis', 'István', '06201234567', 'kis.istvan@gmail.com');
end;
/
SELECT * FROM vw_inactive_customers;

*/

-- CHANGELOG VIEWS

CREATE OR REPLACE VIEW customers_changelog AS
SELECT c.id, c.operation, c.record_id, c.change_date, c.change_by, c.version
FROM changelog c
WHERE c.table_name = 'customers';
/
-- SELECT * FROM customers_changelog

CREATE OR REPLACE VIEW account_changelog AS
SELECT c.id, c.operation, c.record_id, c.change_date, c.change_by, c.version
FROM changelog c
WHERE c.table_name = 'account';
/
-- SELECT * FROM account_changelog

CREATE OR REPLACE VIEW bank_card_changelog AS
SELECT c.id, c.operation, c.record_id, c.change_date, c.change_by, c.version
FROM changelog c
WHERE c.table_name = 'bank_card';
/
-- SELECT * FROM bank_card_changelog








