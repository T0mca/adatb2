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

ALTER SESSION SET CURRENT_SCHEMA=bank_manager;

CREATE TABLE customers(id NUMBER primary key,
                       firstname VARCHAR2(50),
                       lastname VARCHAR2(50),
                       phone VARCHAR2(15),
                       email VARCHAR2(100));
                       


