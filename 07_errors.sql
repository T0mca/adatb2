-- Túl nagy pénz felvétele

DECLARE
  v_max_id       NUMBER;
  v_min_id       NUMBER;
  v_random_index NUMBER;
BEGIN
  dbms_output.put_line('-------------------------');
  dbms_output.put_line('Withdrawing too much money');
  SELECT MAX(id) AS MAX
        ,MIN(id) AS MIN
  
    INTO v_max_id
        ,v_min_id
    FROM bank_card;

  dbms_output.put_line('Max: ' || v_max_id || ' min: ' || v_min_id);
  v_random_index := trunc(dbms_random.value(v_min_id, v_max_id));
  dbms_output.put_line('Selected index: ' || v_random_index);
  pkg_operations.use_atm(p_card_id => v_random_index, p_amount => -999999);

EXCEPTION
  WHEN pkg_operations.not_enough_balance THEN
    dbms_output.put_line('SUCCESS');
END;
/
-- Túl nagy pénz utalása

declare 
   v_max_id NUMBER;
   v_min_id NUMBER;
   v_center_id NUMBER;
   v_first_id NUMBER;
   v_second_id NUMBER;
begin
  dbms_output.put_line('-------------------------');
  dbms_output.put_line('Transfering too much money');
  
  SELECT MAX(id) as max, min(id) as min into v_max_id, v_min_id FROM account a;
  dbms_output.put_line('Max: ' || v_max_id || ' min: ' || v_min_id);
  v_center_id := trunc((v_min_id + v_max_id) / 2);
  
  v_first_id := trunc(dbms_random.value(v_min_id, v_center_id));
  v_second_id := trunc(dbms_random.value(v_center_id,v_max_id));
  
  pkg_operations.transfer(p_from_account_id => v_first_id,p_to_account_id => v_second_id,p_amount => 999999);
EXCEPTION
  WHEN pkg_operations.insufficient_funds THEN
    dbms_output.put_line('SUCCESS');
end;
/
-- Negatív összeg utalása

declare 
   v_max_id NUMBER;
   v_min_id NUMBER;
   v_center_id NUMBER;
   v_first_id NUMBER;
   v_second_id NUMBER;
begin
  dbms_output.put_line('-------------------------');
  dbms_output.put_line('Transfering negative money');
  
  SELECT MAX(id) as max, min(id) as min into v_max_id, v_min_id FROM account a;
  dbms_output.put_line('Max: ' || v_max_id || ' min: ' || v_min_id);
  v_center_id := trunc((v_min_id + v_max_id) / 2);
  
  v_first_id := trunc(dbms_random.value(v_min_id, v_center_id));
  v_second_id := trunc(dbms_random.value(v_center_id,v_max_id));
  
  pkg_operations.transfer(p_from_account_id => v_first_id,p_to_account_id => v_second_id,p_amount => -999999);
EXCEPTION
  WHEN pkg_operations.wrong_amount THEN
    dbms_output.put_line('SUCCESS');
end;
