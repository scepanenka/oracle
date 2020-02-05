CREATE OR REPLACE FUNCTION GET_SUPPLY_SUMMA
    (i_id_supply IN NUMBER)
    RETURN t_supply.summa%type
IS
    supply_sum t_supply.summa%type;
BEGIN
    SELECT SUM(T_SUPPLY_STR.SUMMA) INTO supply_sum
        FROM T_SUPPLY
        JOIN T_SUPPLY_STR USING (ID_SUPPLY)
        WHERE ID_SUPPLY = i_id_supply;
RETURN  supply_sum;
END;