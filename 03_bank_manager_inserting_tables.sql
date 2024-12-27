DELETE FROM customers;
DELETE FROM account;
DELETE FROM bank_card;

BEGIN
  pkg_manage_bank.create_customer('Nagy', 'István', '06201234568', 'nagy.istvan@gmail.com');
  pkg_manage_bank.create_customer('Kiss', 'Erika', '06201234569', 'kiss.erika@gmail.com');
  pkg_manage_bank.create_customer('Tóth', 'Gábor', '06201234570', 'toth.gabor@gmail.com');
  pkg_manage_bank.create_customer('Farkas', 'Júlia', '06201234571', 'farkas.julia@gmail.com');
  pkg_manage_bank.create_customer('Szabó', 'László', '06201234572', 'szabo.laszlo@gmail.com');
  pkg_manage_bank.create_customer('Varga', 'Andrea', '06201234573', 'varga.andrea@gmail.com');
  pkg_manage_bank.create_customer('Horváth', 'Dániel', '06201234574', 'horvath.daniel@gmail.com');
  pkg_manage_bank.create_customer('Balogh', 'Katalin', '06201234575', 'balogh.katalin@gmail.com');
  pkg_manage_bank.create_customer('Molnár', 'Tamás', '06201234576', 'molnar.tamas@gmail.com');
  pkg_manage_bank.create_customer('Papp', 'Zoltán', '06201234577', 'papp.zoltan@gmail.com');
  pkg_manage_bank.create_customer('Kovács', 'Anna', '06201234578', 'kovacs.anna@gmail.com');
  pkg_manage_bank.create_customer('Nagy', 'Béla', '06201234579', 'nagy.bela@gmail.com');
  pkg_manage_bank.create_customer('Kiss', 'János', '06201234580', 'kiss.janos@gmail.com');
  pkg_manage_bank.create_customer('Tóth', 'Zsófia', '06201234581', 'toth.zsofia@gmail.com');
  pkg_manage_bank.create_customer('Farkas', 'Máté', '06201234582', 'farkas.mate@gmail.com');
  pkg_manage_bank.create_customer('Szabó', 'Réka', '06201234583', 'szabo.reka@gmail.com');
  pkg_manage_bank.create_customer('Varga', 'István', '06201234584', 'varga.istvan@gmail.com');
  pkg_manage_bank.create_customer('Horváth', 'Péter', '06201234585', 'horvath.peter@gmail.com');
  pkg_manage_bank.create_customer('Balogh', 'László', '06201234586', 'balogh.laszlo@gmail.com');
  pkg_manage_bank.create_customer('Molnár', 'Andrea', '06201234587', 'molnar.andrea@gmail.com');
  pkg_manage_bank.create_customer('Papp', 'Gábor', '06201234588', 'papp.gabor@gmail.com');

END;
/
COMMIT;
/

-- SELECT * FROM USER_ERRORS WHERE NAME = 'PKG_MANAGE_BANK';
-- COMMIT;
-- SELECT * FROM customers;
-- SELECT * FROM account FOR UPDATE;
-- SELECT * FROM bank_card WHERE account_id = 1000;
-- SELECT * FROM transaction;

declare
pin_code NUMBER;
begin
pkg_manage_bank.addCardToAccount(p_account_id => 1063,p_generated_pin => pin_code);
dbms_output.put_line('A generalt pin code: ' || pin_code);

end;

begin
  pkg_operations.transfer(1063,1064,99999999);
end;

