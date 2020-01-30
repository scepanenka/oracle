/* Триггер для строки продажи и для самой продажи, автоматически вычисляющий сумму по строкам при изменении цены
   или количества, а также скидки в заголовке, и изменяющие общую сумму продажи в заголовке. Задача сложная из-за
   mutating по простой схеме, когда изменение скидки меняет строки, а изменение суммы строки — меняет сумму в заголовке.
   Как альтернатива: для изменения скидки используется процедура, но тогда нужно придумать механизм блокировки прямого
   изменения этого поля в таблице. */


CREATE OR REPLACE TRIGGER t_supply_str_biur_trg
    BEFORE INSERT OR UPDATE OF QTY, PRICE
        ON T_SALE_STR
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
end t_supply_str_biur_trg;