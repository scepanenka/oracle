CREATE OR REPLACE FUNCTION get_price_by_date(i_id_ware t_ware.id_ware%TYPE,
                                             i_date DATE DEFAULT SYSDATE)
    RETURN
        t_ware.price%TYPE
    IS
    o_price t_ware.price%TYPE;
BEGIN
    SELECT PRICE
    INTO o_price
    FROM T_PRICE_WARE
    WHERE ID_WARE = i_id_ware
      AND DT_BEG <= i_date
      AND (DT_END > i_date or DT_END IS NULL);
    RETURN o_price;
END;
/