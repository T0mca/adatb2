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
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('customers'
      ,'INSERT'
      ,:new.id
      ,SYSDATE
      ,USER
      ,1);
  ELSIF updating
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('customers'
      ,'UPDATE'
      ,:old.id
      ,SYSDATE
      ,USER
      ,:OLD.version);
  ELSIF deleting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('customers'
      ,'DELETE'
      ,:old.id
      ,SYSDATE
      ,USER
      ,:OLD.version);
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
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('account'
      ,'INSERT'
      ,:new.id
      ,SYSDATE
      ,USER
      ,1);
  ELSIF updating
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('account'
      ,'UPDATE'
      ,:old.id
      ,SYSDATE
      ,USER
      ,:OLD.version);
  ELSIF deleting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('account'
      ,'DELETE'
      ,:old.id
      ,SYSDATE
      ,USER
      ,:OLD.version);
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
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('bank_card'
      ,'INSERT'
      ,:new.id
      ,SYSDATE
      ,USER
      ,1);
  ELSIF updating
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('bank_card'
      ,'UPDATE'
      ,:old.id
      ,SYSDATE
      ,USER
      ,:OLD.version);
  ELSIF deleting
  THEN
    INSERT INTO changelog
      (table_name
      ,operation
      ,record_id
      ,change_date
      ,change_by
      ,version)
    VALUES
      ('bank_card'
      ,'DELETE'
      ,:old.id
      ,SYSDATE
      ,USER
      ,:OLD.version);
  END IF;
END;
/
