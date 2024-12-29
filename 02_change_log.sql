CREATE OR REPLACE TRIGGER trg_customers_changelog
  AFTER INSERT OR UPDATE OR DELETE ON customers
  FOR EACH ROW
BEGIN
  IF inserting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('customers'
      ,'INSERT'
      ,:new.id
      ,SYSDATE);
  ELSIF updating
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('customers'
      ,'UPDATE'
      ,:old.id
      ,SYSDATE);
  ELSIF deleting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('customers'
      ,'DELETE'
      ,:old.id
      ,SYSDATE);
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_account_changelog
  AFTER INSERT OR UPDATE OR DELETE ON account
  FOR EACH ROW
BEGIN
  IF inserting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('account'
      ,'INSERT'
      ,:new.id
      ,SYSDATE);
  ELSIF updating
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('account'
      ,'UPDATE'
      ,:old.id
      ,SYSDATE);
  ELSIF deleting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('account'
      ,'DELETE'
      ,:old.id
      ,SYSDATE);
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_bank_card_changelog
  AFTER INSERT OR UPDATE OR DELETE ON bank_card
  FOR EACH ROW
BEGIN
  IF inserting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('bank_card'
      ,'INSERT'
      ,:new.id
      ,SYSDATE);
  ELSIF updating
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('bank_card'
      ,'UPDATE'
      ,:old.id
      ,SYSDATE);
  ELSIF deleting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date)
    VALUES
      ('bank_card'
      ,'DELETE'
      ,:old.id
      ,SYSDATE);
  END IF;
END;
/
