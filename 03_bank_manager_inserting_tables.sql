DELETE FROM customers;
DELETE FROM account;
DELETE FROM bank_card;

BEGIN
  pkg_manage_bank.create_customer('Nagy', 'Istv�n', '06201234568', 'nagy.istvan@gmail.com');
  pkg_manage_bank.create_customer('Kiss', 'Erika', '06201234569', 'kiss.erika@gmail.com');
  pkg_manage_bank.create_customer('T�th', 'G�bor', '06201234570', 'toth.gabor@gmail.com');
  pkg_manage_bank.create_customer('Farkas', 'J�lia', '06201234571', 'farkas.julia@gmail.com');
  pkg_manage_bank.create_customer('Szab�', 'L�szl�', '06201234572', 'szabo.laszlo@gmail.com');
  pkg_manage_bank.create_customer('Varga', 'Andrea', '06201234573', 'varga.andrea@gmail.com');
  pkg_manage_bank.create_customer('Horv�th', 'D�niel', '06201234574', 'horvath.daniel@gmail.com');
  pkg_manage_bank.create_customer('Balogh', 'Katalin', '06201234575', 'balogh.katalin@gmail.com');
  pkg_manage_bank.create_customer('Moln�r', 'Tam�s', '06201234576', 'molnar.tamas@gmail.com');
  pkg_manage_bank.create_customer('Papp', 'Zolt�n', '06201234577', 'papp.zoltan@gmail.com');
  pkg_manage_bank.create_customer('Kov�cs', 'Anna', '06201234578', 'kovacs.anna@gmail.com');
  pkg_manage_bank.create_customer('Nagy', 'B�la', '06201234579', 'nagy.bela@gmail.com');
  pkg_manage_bank.create_customer('Kiss', 'J�nos', '06201234580', 'kiss.janos@gmail.com');
  pkg_manage_bank.create_customer('T�th', 'Zs�fia', '06201234581', 'toth.zsofia@gmail.com');
  pkg_manage_bank.create_customer('Farkas', 'M�t�', '06201234582', 'farkas.mate@gmail.com');
  pkg_manage_bank.create_customer('Szab�', 'R�ka', '06201234583', 'szabo.reka@gmail.com');
  pkg_manage_bank.create_customer('Varga', 'Istv�n', '06201234584', 'varga.istvan@gmail.com');
  pkg_manage_bank.create_customer('Horv�th', 'P�ter', '06201234585', 'horvath.peter@gmail.com');
  pkg_manage_bank.create_customer('Balogh', 'L�szl�', '06201234586', 'balogh.laszlo@gmail.com');
  pkg_manage_bank.create_customer('Moln�r', 'Andrea', '06201234587', 'molnar.andrea@gmail.com');
  pkg_manage_bank.create_customer('Papp', 'G�bor', '06201234588', 'papp.gabor@gmail.com');

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

