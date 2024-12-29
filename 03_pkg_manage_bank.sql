CREATE OR REPLACE PACKAGE pkg_manage_bank IS
  wrong_email_exception EXCEPTION;
  PRAGMA EXCEPTION_INIT(wrong_email_exception, -20000);

  undefinied_id EXCEPTION;
  PRAGMA EXCEPTION_INIT(undefinied_id, -20001);

  PROCEDURE create_customer(p_first_name VARCHAR2
                           ,p_last_name  VARCHAR2
                           ,p_phone      IN VARCHAR2
                           ,p_email      IN VARCHAR2);

  PROCEDURE freezecard(p_card_id IN NUMBER);
  PROCEDURE unfreezecard(p_card_id IN NUMBER);
  PROCEDURE addcardtoaccount(p_account_id    IN NUMBER
                            ,p_generated_pin OUT NUMBER);
  PROCEDURE addaccounttocustomer(p_customer_id IN NUMBER
                                ,p_account_id  OUT NUMBER);

END pkg_manage_bank;
/
CREATE OR REPLACE PACKAGE BODY pkg_manage_bank AS
FUNCTION validate_email(p_email IN VARCHAR2) RETURN BOOLEAN IS
l_email_regex CONSTANT VARCHAR2(100) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
BEGIN
RETURN regexp_like(p_email, l_email_regex);
EXCEPTION
WHEN OTHERS THEN RETURN FALSE;
END validate_email;

PROCEDURE freezecard(p_card_id IN NUMBER) AS
BEGIN
UPDATE bank_card SET is_locked = 1 WHERE id = p_card_id;
END;

PROCEDURE unfreezecard(p_card_id IN NUMBER) AS
BEGIN
UPDATE bank_card SET is_locked = 0 WHERE id = p_card_id;
END;

PROCEDURE addcardtoaccount(p_account_id IN NUMBER, p_generated_pin OUT NUMBER) AS
v_gen_pin_code NUMBER; v_encrypted RAW(2000); v_key RAW(32) := utl_raw.cast_to_raw('12345678901234567890123456789012'); v_acc_number NUMBER;
BEGIN
SELECT COUNT(*) INTO v_acc_number FROM account WHERE id = p_account_id;

IF v_acc_number = 0 THEN RAISE undefinied_id;
END IF;

v_gen_pin_code := trunc(dbms_random.value(1000, 10000)); v_encrypted := dbms_crypto.encrypt(src => utl_raw.cast_to_raw(v_gen_pin_code), typ => dbms_crypto.encrypt_aes + dbms_crypto.chain_cbc + dbms_crypto.pad_pkcs5, key => v_key);

INSERT INTO bank_card(account_id, pin_code) VALUES(p_account_id, v_encrypted);

p_generated_pin := v_gen_pin_code;
END;

PROCEDURE addaccounttocustomer(p_customer_id IN NUMBER, p_account_id OUT NUMBER) AS
v_cust_number NUMBER; v_account_id NUMBER;
BEGIN
SELECT COUNT(*) INTO v_cust_number FROM customers WHERE id = p_customer_id;

IF v_cust_number = 0 THEN RAISE undefinied_id;
END IF;

INSERT INTO account(customer_id) VALUES(p_customer_id) RETURNING id INTO v_account_id; p_account_id := v_account_id;

END;

PROCEDURE create_customer(p_first_name VARCHAR2, p_last_name VARCHAR2, p_phone IN VARCHAR2, p_email IN VARCHAR2) AS
v_customer_id NUMBER; v_account_id NUMBER;

BEGIN

IF NOT validate_email(p_email) THEN RAISE wrong_email_exception;
END IF;

INSERT INTO customers(firstname, lastname, phone, email) VALUES(p_first_name, p_last_name, p_phone, p_email) RETURNING id INTO v_customer_id;

INSERT INTO account(customer_id, balance) VALUES(v_customer_id, 0) RETURNING id INTO v_account_id;

END create_customer;

END pkg_manage_bank;

-- SELECT * FROM user_errors WHERE NAME = 'PKG_MANAGE_BANK';
