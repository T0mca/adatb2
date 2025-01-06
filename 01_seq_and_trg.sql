-- CREATING SEQUENCES                    
BEGIN
  FOR t IN (SELECT SEQUENCE_NAME FROM all_sequences where SEQUENCE_OWNER = 'BANK_MANAGER')
  LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || t.sequence_name;
  END LOOP;
END;
/
CREATE SEQUENCE customer_seq
START WITH 10500
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE bank_card_seq
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE account_seq
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE transaction_seq
START WITH 100
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE changelog_seq
START WITH 100
INCREMENT BY 1
NOCACHE
NOCYCLE;
/
CREATE OR REPLACE TRIGGER customers_trg 
BEFORE INSERT ON customers 
FOR EACH ROW
BEGIN
  IF :NEW.id IS NULL THEN
    :NEW.id := customer_seq.NEXTVAL;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER account_trg 
BEFORE INSERT ON account 
FOR EACH ROW
BEGIN
  IF :NEW.id IS NULL THEN
    :NEW.id := account_seq.NEXTVAL;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER bank_card_trg 
BEFORE INSERT ON bank_card 
FOR EACH ROW
BEGIN
  IF :NEW.id IS NULL THEN
    :NEW.id := bank_card_seq.NEXTVAL;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER transaction_trg 
BEFORE INSERT ON transaction
FOR EACH ROW
BEGIN
  IF :NEW.id IS NULL THEN
    :NEW.id := transaction_seq.NEXTVAL;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER changelog_trg
BEFORE INSERT ON changelog
FOR EACH ROW
BEGIN
  IF :NEW.id IS NULL THEN
    :NEW.id := changelog_seq.NEXTVAL;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER customers_version_trg
  BEFORE UPDATE ON customers
  FOR EACH ROW
BEGIN
  :new.version := :old.version + 1;
END;
/
CREATE OR REPLACE TRIGGER account_version_trg
  BEFORE UPDATE ON account
  FOR EACH ROW
BEGIN
  :new.version := :old.version + 1;
END;
/
CREATE OR REPLACE TRIGGER bank_card_version_trg
  BEFORE UPDATE ON bank_card
  FOR EACH ROW
BEGIN
  :new.version := :old.version + 1;
END;
