CREATE OR REPLACE PACKAGE pkg_operations as
 undefinied_account EXCEPTION;
 pragma exception_init(undefinied_account, -20002);
 
 insufficient_funds EXCEPTION;
 pragma exception_init(insufficient_funds,-20003);
 
 PROCEDURE transfer(p_from_account_id NUMBER, p_to_account_id NUMBER, p_amount NUMBER);
 
 FUNCTION check_pin(p_card_id NUMBER, p_pin_code NUMBER) RETURN NUMBER;
 
END pkg_operations;
/
CREATE OR REPLACE PACKAGE BODY pkg_operations AS

  PROCEDURE transfer(p_from_account_id NUMBER, p_to_account_id NUMBER, p_amount NUMBER) AS
    v_balance NUMBER;
  BEGIN
    SELECT balance
    INTO v_balance
    FROM account
    WHERE id = p_from_account_id;

    IF v_balance < p_amount THEN
      RAISE insufficient_funds;
    END IF;

    UPDATE account
    SET balance = balance - p_amount
    WHERE id = p_from_account_id;

    UPDATE account
    SET balance = balance + p_amount
    WHERE id = p_to_account_id;
    
    INSERT INTO transaction (source_account,target_account,amount)
    VALUES (p_from_account_id,p_to_account_id,p_amount);

    COMMIT;
  END transfer;

  FUNCTION check_pin(p_card_id NUMBER, p_pin_code NUMBER) RETURN NUMBER AS
    v_key RAW(32) := UTL_RAW.cast_to_raw('12345678901234567890123456789012'); -- 32 byte kulcs
    v_encrypted RAW(2000);
    v_decrypted VARCHAR2(10);
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM bank_card
    WHERE id = p_card_id;

    IF v_count = 0 THEN
        RAISE undefinied_account;
    END IF;

    SELECT hextoraw(pin_code)
    INTO v_encrypted
    FROM bank_card
    WHERE id = p_card_id;

    v_decrypted := UTL_RAW.cast_to_varchar2(
        DBMS_CRYPTO.DECRYPT(
            src => v_encrypted,
            typ => DBMS_CRYPTO.ENCRYPT_AES + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
            key => v_key
        )
    );
    
    IF TO_NUMBER(v_decrypted) = p_pin_code THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END check_pin;

END pkg_operations;
