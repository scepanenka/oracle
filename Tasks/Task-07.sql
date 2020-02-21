-- Доработка предыдущего: при исполнении накладной необходимо блокировать продажу отсутствующего товара,
-- но при этом обязательно выдавать сообщение по всем товарам, которых не хватает, а не останавливаться на первом.

CREATE OR REPLACE TRIGGER t_sale_bur_trg
    BEFORE UPDATE
    ON t_sale
    FOR EACH ROW
    WHEN (OLD.e_state <> NEW.e_state AND NEW.e_state = 1)
DECLARE
    TYPE waresRest_type IS TABLE OF t_rest%ROWTYPE INDEX BY PLS_INTEGER;
    sale_str_ware_rest waresRest_type;
    CURSOR cur IS SELECT id_ware, qty
                  FROM t_sale_str
                  WHERE id_sale = :NEW.id_sale;
    l_rest             t_rest.qty%TYPE;
    l_error_message    VARCHAR2(2000) := 'Sale id=' || :NEW.id_sale || ' cannot be performed.';
BEGIN
    FOR w IN cur
        LOOP
            BEGIN
                SELECT qty
                INTO l_rest
                FROM t_rest
                WHERE id_ware = w.id_ware;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN l_rest := 0;
            END;
            IF l_rest - w.qty < 0
            THEN
                sale_str_ware_rest(sale_str_ware_rest.count).id_ware := w.id_ware;
                sale_str_ware_rest(sale_str_ware_rest.count - 1).qty := w.qty;
            END IF;
        END LOOP;
    IF sale_str_ware_rest.count > 0 THEN
        FOR indx IN 0 .. sale_str_ware_rest.count - 1
            LOOP
                l_error_message := CONCAT(l_error_message, chr(10) ||
                                                           'Ware is out of stock: ware id=' ||
                                                           sale_str_ware_rest(indx).id_ware ||
                                                           ' AND qty=' ||
                                                           sale_str_ware_rest(indx).qty);
            END LOOP;
        RAISE_APPLICATION_ERROR(-20101, l_error_message);
    END IF;
END t_sale_bur_trg;
/