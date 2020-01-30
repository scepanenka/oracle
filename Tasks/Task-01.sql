-- Триггер для строки поставки, автоматически вычисляющий сумму и НДС строки.
-- Следующий шаг — вычисление в триггере суммы и НДС заголовка поставки по изменению в строках.

CREATE OR REPLACE TRIGGER t_supply_str_biur_trg
    BEFORE INSERT OR UPDATE OF QTY, PRICE
        ON T_SUPPLY_STR
    FOR EACH ROW
    WHEN (
        old.price IS NULL OR
        old.qty IS NULL OR
        old.price <> new.price OR
        old.qty <> new.qty
        )
BEGIN
    :new.summa := :new.price * :new.qty;
    :new.nds := :new.summa * 0.2;
    UPDATE T_SUPPLY
        SET SUMMA = NVL(SUMMA, 0) + :new.summa,
            NDS = NVL(NDS, 0) + :new.nds
    WHERE T_SUPPLY.ID_SUPPLY = :new.id_supply;

end t_supply_str_biur_trg;