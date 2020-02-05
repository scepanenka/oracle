CREATE  OR REPLACE FUNCTION GET_SALE_SUMMA
    (i_id_sale IN NUMBER)
    RETURN t_sale.summa%type
IS
    l_sale_summa t_sale.summa%type;
BEGIN
    SELECT SUM(T_SALE_STR.SUMMA) INTO l_sale_summa
        FROM T_SALE
        JOIN T_SALE_STR USING (ID_SALE)
        WHERE ID_SALE = i_id_sale;
RETURN  l_sale_summa;
END;
/

