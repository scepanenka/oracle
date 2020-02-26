-- Процедура или триггер исполнения поставки и продажи, изменяющая текущее количество товара на складе.
-- Естественно, должна обрабатыватьcя отмена исполнения. Для проверки, помимо теста, можно отменить исполнение
-- всех накладных — остаток должен стать нулевым. После этого — снова исполнить все накладные и проверить,
-- что результат совпал — используя для сравнения таблицу истории остатков.

CREATE OR REPLACE TRIGGER t_supply_aur_trg
AFTER UPDATE OF e_state ON t_supply
FOR EACH ROW
    WHEN ( OLD.e_state <> NEW.e_state )
DECLARE
    CURSOR cur IS SELECT id_ware, qty FROM t_supply_str WHERE id_supply = :NEW.id_supply;
    rest_exists NUMBER;
BEGIN
    FOR w IN cur
    LOOP
        SELECT COUNT(*) INTO rest_exists FROM t_rest WHERE id_ware = w.id_ware;
        IF (rest_exists) = 0
            AND :NEW.e_state = 1
            THEN
                BEGIN
                INSERT INTO t_rest VALUES (w.id_ware, w.qty);
                INSERT INTO t_rest_hist VALUES (w.id_ware, SYSDATE, NULL, w.qty);
                END;
        ELSIF (:NEW.e_state = 1)
            THEN UPDATE T_REST SET qty = qty + w.qty WHERE id_ware = w.id_ware;
        ELSIF (:NEW.e_state = 0)
            THEN UPDATE T_REST SET qty = qty - w.qty WHERE id_ware = w.id_ware;
        END IF;
    END LOOP;
END t_supply_aur_trg;
/

CREATE OR REPLACE TRIGGER t_sale_ar_u_trg
AFTER UPDATE OF e_state ON t_sale
FOR EACH ROW
    WHEN ( OLD.e_state <> NEW.e_state )
DECLARE
    CURSOR cur IS SELECT id_ware, qty FROM t_sale_str WHERE id_sale = :NEW.id_sale;
    ware_not_exist EXCEPTION;
    rest_exists NUMBER;
BEGIN
    FOR w IN cur
    LOOP
        SELECT COUNT(*) INTO rest_exists FROM t_rest WHERE id_ware = w.id_ware;
        IF rest_exists = 0
        THEN RAISE ware_not_exist;
        ELSIF (:NEW.e_state = 1)
            THEN UPDATE T_REST SET qty = qty - w.qty WHERE id_ware = w.id_ware;
        ELSIF (:NEW.e_state = 0)
            THEN UPDATE T_REST SET qty = qty + w.qty WHERE id_ware = w.id_ware;
        END IF;
    END LOOP;
    EXCEPTION
    WHEN ware_not_exist
    THEN
        RAISE_APPLICATION_ERROR(-20101, 'Ware not exist');
END t_sale_ar_u_trg;
/