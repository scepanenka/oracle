
-- Триггер для строки поставки, автоматически вычисляющий сумму и НДС строки.
-- Следующий шаг — вычисление в триггере суммы и НДС заголовка поставки по изменению в строках.

CREATE OR REPLACE TRIGGER t_supply_str_biur_trg
    BEFORE UPDATE OF QTY, PRICE OR INSERT OR DELETE
    ON T_SUPPLY_STR
    FOR EACH ROW
    WHEN (
            old.price IS NULL OR
            old.qty IS NULL OR
            old.price <> new.price OR
            old.qty <> new.qty OR
            (OLD.SUMMA IS NOT NULL AND NEW.SUMMA IS NULL)
        )
BEGIN
    IF DELETING
    THEN
        BEGIN
            UPDATE T_SUPPLY
            SET SUMMA = NVL(SUMMA, 0) - NVL(:OLD.SUMMA, 0),
                NDS   = NVL(NDS, 0) - NVL(:old.nds, 0)
            WHERE T_SUPPLY.ID_SUPPLY = :old.id_supply;
        end;
    ELSE
        BEGIN
            :new.summa := :new.price * :new.qty;
            :new.nds := :new.summa * 0.2;
            UPDATE T_SUPPLY
            SET SUMMA = NVL(SUMMA, 0) + NVL(:new.summa, 0) - NVL(:OLD.SUMMA, 0),
                NDS   = NVL(NDS, 0) + NVL(:new.nds, 0) - NVL(:OLD.NDS, 0)
            WHERE T_SUPPLY.ID_SUPPLY = :new.id_supply;
        END;
    END IF;
end t_supply_str_biur_trg;
/

-- Триггер, блокирующий установку скидки более 20% для «неVIP»-клиентов.

CREATE OR REPLACE TRIGGER t_sale_bui_trg
    BEFORE UPDATE OF DISCOUNT OR INSERT ON T_SALE
    FOR EACH ROW
    DECLARE
        l_is_vip T_CLIENT.IS_VIP%type;
BEGIN
    SELECT IS_VIP INTO l_is_vip
    FROM T_CLIENT
        WHERE T_CLIENT.ID_CLIENT = :NEW.ID_CLIENT;
    IF :NEW.discount > 20 and l_is_vip = 0
        THEN RAISE_APPLICATION_ERROR(-20000, 'Discount ' || :new.DISCOUNT || '% is possible only for VIP clients.');
        END IF;
end t_sale_bui_trg;
/

-- Триггер, автоматически устанавливающий цену продажи товара по значению цены на дату продажи с учетом скидки.
CREATE OR REPLACE TRIGGER t_sale_str_biur_price_trg
BEFORE INSERT OR UPDATE ON T_SALE_STR
    FOR EACH ROW
    WHEN (
        OLD.PRICE IS NULL
        OR NEW.PRICE IS NULL
        OR NEW.PRICE <> OLD.PRICE
        )
    DECLARE
        l_price_ware t_price_ware.price%TYPE;
    BEGIN

        SELECT pw.PRICE INTO l_price_ware
        FROM T_PRICE_WARE pw, T_SALE s
        WHERE pw.ID_WARE = :NEW.ID_WARE
            and s.ID_SALE = :NEW.ID_SALE
            AND s.DT >= pw.DT_BEG
            AND (s.DT < pw.DT_END OR pw.DT_END IS NULL);

        :NEW.price := l_price_ware;
        :NEW.disc_price := l_price_ware*(1 - NVL(:NEW.discount, 0)/100);
    end t_sale_str_biur_price_trg;
/

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
/