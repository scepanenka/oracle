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