/* Триггер для строки продажи и для самой продажи, автоматически вычисляющий сумму по строкам при изменении цены
   или количества, а также скидки в заголовке, и изменяющие общую сумму продажи в заголовке. */

CREATE OR REPLACE TRIGGER t_sale_str_iduc_trg
    FOR INSERT OR DELETE OR UPDATE
    ON T_SALE_STR
    COMPOUND TRIGGER

    TYPE sale_id_type IS TABLE OF t_sale.id_sale%TYPE INDEX BY PLS_INTEGER;
    g_sale_ids sale_id_type;

    BEFORE EACH ROW IS
    BEGIN
        DECLARE
            l_price_ware t_price_ware.price%TYPE;
        BEGIN
            IF INSERTING OR UPDATING
            THEN
                BEGIN
                    SELECT pw.PRICE
                    INTO l_price_ware
                    FROM T_PRICE_WARE pw,
                         T_SALE s
                    WHERE pw.ID_WARE = :NEW.id_ware
                      and s.ID_SALE = :NEW.id_sale
                      AND s.DT >= pw.DT_BEG
                      AND (s.DT < pw.DT_END OR pw.DT_END IS NULL);

                    :NEW.price := l_price_ware;
                    :NEW.disc_price := l_price_ware * (1 - NVL(:NEW.discount, 0) / 100);
                    :NEW.summa := :NEW.disc_price * :new.qty;
                    :NEW.nds := :new.summa * 0.2;
                    g_sale_ids(g_sale_ids.COUNT +1) := :NEW.id_sale;
                END;
            ELSE
                g_sale_ids(g_sale_ids.COUNT +1) := :OLD.id_sale;
            END IF;
        END;
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
        l_summa t_sale.summa%TYPE;
    BEGIN
        FORALL i IN 1 .. g_sale_ids.COUNT
            UPDATE T_SALE
            SET SUMMA = (SELECT SUM(T_SALE_STR.SUMMA)
                            FROM T_SALE_STR
                            WHERE ID_SALE = g_sale_ids(i))*(1-DISCOUNT/100),
                NDS = (SELECT SUM(T_SALE_STR.SUMMA)
                            FROM T_SALE_STR
                            WHERE ID_SALE = g_sale_ids(i))*(1-DISCOUNT/100) * 0.2
            WHERE ID_SALE = g_sale_ids(i);


    END AFTER STATEMENT;
    END t_sale_str_iduc_trg;