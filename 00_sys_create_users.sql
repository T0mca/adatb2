/* ------------------------------- */
/*--------Név:Horváth Tamás--------*/
/*----------Neptun:TZY8B6----------*/
/* ------------------------------- */
/*
SELECT sid, serial#, username, status
FROM v$session
WHERE status = 'ACTIVE' and username = 'BANK_MANAGER'

ALTER SYSTEM KILL SESSION '10,211';
*/

DECLARE
  l_cnt NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO l_cnt
    FROM dba_users t
   WHERE t.username = 'BANK_MANAGER';
  IF l_cnt = 1
  THEN
    EXECUTE IMMEDIATE 'DROP USER bank_manager CASCADE';
  END IF;
END;
/ 
CREATE USER bank_manager identified BY 12345678 DEFAULT tablespace users quota unlimited ON users;

grant CREATE session TO bank_manager;
grant CREATE TABLE TO bank_manager;
grant CREATE VIEW TO bank_manager;
grant CREATE SEQUENCE TO bank_manager;
grant CREATE PROCEDURE TO bank_manager;
grant CREATE TRIGGER TO bank_manager;
GRANT EXECUTE ON DBMS_CRYPTO TO bank_manager;

ALTER session SET current_schema = bank_manager;

--CREATING TABLES

BEGIN
  FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'BANK_MANAGER')
  LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name ||
                      ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/
CREATE TABLE customers(id NUMBER primary key,
                         firstname VARCHAR2(50) NOT NULL,
                         lastname VARCHAR2(50) NOT NULL,
                         phone VARCHAR2(15),
                         email VARCHAR2(100)) tablespace users;

CREATE TABLE account(id NUMBER primary key,
                     customer_id NUMBER REFERENCES customers(id) ON DELETE CASCADE,
                     balance NUMBER(15, 2) DEFAULT 0 NOT NULL) tablespace users;

CREATE TABLE bank_card(id NUMBER primary key,
                       account_id NUMBER REFERENCES account(id) ON DELETE CASCADE,
                       pin_code VARCHAR2(32),
                       is_locked  NUMBER(1) DEFAULT 0) tablespace users;

CREATE TABLE TRANSACTION(id NUMBER primary key,
                         source_account NUMBER references account(id) ON DELETE CASCADE,
                         target_account NUMBER references account(id) ON DELETE CASCADE,
                         amount NUMBER(15, 2) NOT NULL) tablespace users;
                         

