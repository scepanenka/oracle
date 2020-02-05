/* Процедура назначения цены товару на заданном интервале, соответственно изменяющая таблицу цен.
   Должна изменять также цены в продажах-черновиках, естественно, с учетом скидки. */

CREATE OR REPLACE PROCEDURE set_price(i_id_ware t_ware.ID_WARE%TYPE,
                                      i_price t_ware.price%TYPE,
                                      i_dt_beg DATE DEFAULT SYSDATE,
                                      i_dt_end DATE DEFAULT NULL)
    IS
BEGIN
    UPDATE T_PRICE_WARE
    SET DT_END = i_dt_beg
    WHERE ID_WARE = i_id_ware
      AND DT_END IS NULL
      AND DT_BEG < i_dt_beg;

    INSERT
    INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE)
    VALUES (i_id_ware, i_dt_beg, i_dt_end, i_price);

    UPDATE T_WARE
    SET PRICE = GET_PRICE_BY_DATE(i_id_ware, i_dt_beg)
    WHERE ID_WARE = i_id_ware;

    UPDATE T_SALE_STR
    SET PRICE = i_price
    WHERE ID_WARE = i_id_ware
      AND (SELECT E_STATE
           FROM T_SALE
           WHERE T_SALE.ID_SALE = T_SALE_STR.ID_SALE
             AND DT >= i_dt_beg
             AND (DT < i_dt_end OR i_dt_end IS NULL)
          ) = 0;
    COMMIT;

END set_price;
/