/* ------------------------------- */
/*--------N�v:Horv�th Tam�s--------*/
/*----------Neptun:TZY8B6----------*/
/* ------------------------------- */
/*
SELECT sid, serial#, username, status
FROM v$session
WHERE status = 'ACTIVE' and username = 'BANK_MANAGER'

ALTER SYSTEM KILL SESSION '138,5499';
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
grant CREATE view TO bank_manager;
grant CREATE sequence TO bank_manager;
grant CREATE PROCEDURE TO bank_manager;
grant CREATE TRIGGER TO bank_manager;
grant EXECUTE ON dbms_crypto TO bank_manager;

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
                         email VARCHAR2(100),
                         version NUMBER DEFAULT 1 NOT NULL) tablespace users;

CREATE TABLE account(id NUMBER primary key,
                     customer_id NUMBER references customers(id) ON DELETE
                     cascade,
                     balance     NUMBER(15, 2) DEFAULT 0 NOT NULL,
                     version NUMBER DEFAULT 1 NOT NULL) tablespace users;

CREATE TABLE bank_card(id NUMBER primary key,
                       account_id NUMBER references account(id) ON DELETE
                       cascade,
                       pin_code VARCHAR2(32),
                       is_locked  NUMBER(1) DEFAULT 0,
                       version NUMBER DEFAULT 1 NOT NULL) tablespace users;

CREATE TABLE TRANSACTION(id NUMBER primary key,
                         source_account NUMBER references account(id) ON
                         DELETE cascade,
                         target_account NUMBER references account(id) ON
                         DELETE cascade,
                         amount NUMBER(15, 2) NOT NULL) tablespace users;

CREATE TABLE changelog(id NUMBER primary key,
                       table_name VARCHAR2(50) NOT NULL,
                       operation VARCHAR2(10) NOT NULL,
                       record_id NUMBER NOT NULL,
                       change_date DATE DEFAULT SYSDATE NOT NULL,
                       change_by VARCHAR(50) NOT NULL,
                       version NUMBER NOT NULL
                       );
