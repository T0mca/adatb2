CREATE OR REPLACE PACKAGE pkg_operations AS
  undefinied_account EXCEPTION;
  PRAGMA EXCEPTION_INIT(undefinied_account, -20002);

  insufficient_funds EXCEPTION;
  PRAGMA EXCEPTION_INIT(insufficient_funds, -20003);

  card_locked_or_not_found EXCEPTION;
  PRAGMA EXCEPTION_INIT(card_locked_or_not_found, -20004);
  
  not_enough_balance EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_enough_balance, -20005);
  
  wrong_amount EXCEPTION;
  PRAGMA EXCEPTION_INIT(wrong_amount, -20006);

  PROCEDURE transfer(p_from_account_id NUMBER
                    ,p_to_account_id   NUMBER
                    ,p_amount          NUMBER);

  PROCEDURE use_atm(p_card_id NUMBER
                   ,p_amount  NUMBER);

  FUNCTION check_pin(p_card_id  NUMBER
                    ,p_pin_code NUMBER) RETURN NUMBER;

END pkg_operations;
/
CREATE OR REPLACE PACKAGE BODY pkg_operations AS

PROCEDURE transfer(p_from_account_id NUMBER, p_to_account_id NUMBER, p_amount NUMBER) AS
v_balance NUMBER;
BEGIN
  
IF p_amount < 0 THEN
  RAISE wrong_amount;
END IF; 

SELECT balance INTO v_balance FROM account WHERE id = p_from_account_id;

IF v_balance < p_amount THEN RAISE insufficient_funds;
END IF;

UPDATE account SET balance = balance - p_amount WHERE id = p_from_account_id;

UPDATE account SET balance = balance + p_amount WHERE id = p_to_account_id;

INSERT INTO TRANSACTION(source_account, target_account, amount) VALUES(p_from_account_id, p_to_account_id, p_amount);

COMMIT;
END transfer;

PROCEDURE use_atm(p_card_id NUMBER
                 ,p_amount  NUMBER) AS
  v_count      NUMBER;
  v_account_id NUMBER;
  v_balance    NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM bank_card WHERE id = p_card_id;

  IF v_count = 0
  THEN
    RAISE undefinied_account;
  END IF;
  
  SELECT b.account_id
        ,a.balance
    INTO v_account_id
        ,v_balance
    FROM bank_card b
   INNER JOIN account a
      ON a.id = b.account_id
   WHERE b.id = p_card_id
     AND b.is_locked = 0;

  IF v_account_id IS NULL
  THEN
    RAISE card_locked_or_not_found;
  END IF;
  
  IF v_balance + p_amount < 0 THEN
    RAISE not_enough_balance;
  end if;

  IF p_amount < 0
  THEN
    UPDATE account
       SET balance = balance + p_amount
     WHERE id = v_account_id;
  
    INSERT INTO TRANSACTION
      (source_account
      ,target_account
      ,amount)
    VALUES
      (v_account_id
      ,NULL
      ,p_amount);
  
  ELSIF p_amount > 0
  THEN
    UPDATE account
       SET balance = balance + p_amount
     WHERE id = v_account_id;
  
    INSERT INTO TRANSACTION
      (source_account
      ,target_account
      ,amount)
    VALUES
      (NULL
      ,v_account_id
      ,p_amount);
  END IF;

END use_atm;

FUNCTION check_pin(p_card_id NUMBER, p_pin_code NUMBER) RETURN NUMBER AS
v_key RAW(32) := utl_raw.cast_to_raw('12345678901234567890123456789012'); v_encrypted RAW(2000); v_decrypted VARCHAR2(10); v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM bank_card WHERE id = p_card_id;

IF v_count = 0 THEN RAISE undefinied_account;
END IF;

SELECT hextoraw(pin_code) INTO v_encrypted FROM bank_card WHERE id = p_card_id;

v_decrypted := utl_raw.cast_to_varchar2(dbms_crypto.decrypt(src => v_encrypted, typ => dbms_crypto.encrypt_aes + dbms_crypto.chain_cbc + dbms_crypto.pad_pkcs5, key => v_key));

IF to_number(v_decrypted) = p_pin_code THEN RETURN 1; ELSE RETURN 0;
END IF;
END check_pin;

END pkg_operations;
