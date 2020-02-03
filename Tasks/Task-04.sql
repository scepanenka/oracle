/* Триггер для строки продажи и для самой продажи, автоматически вычисляющий сумму по строкам при изменении цены
   или количества, а также скидки в заголовке, и изменяющие общую сумму продажи в заголовке. */

CREATE OR REPLACE TRIGGER t_sale_str_biur_price_trg
    BEFORE INSERT OR UPDATE OR DELETE ON T_SALE_STR
    FOR EACH ROW
    WHEN (
                OLD.PRICE IS NULL
            OR NEW.PRICE IS NULL
            OR NEW.PRICE <> OLD.PRICE
            OR NEW.QTY<>OLD.QTY
            OR (OLD.SUMMA IS NOT NULL AND NEW.SUMMA IS NULL)

        )
DECLARE
    l_price_ware t_price_ware.price%TYPE;
BEGIN
    IF DELETING
    THEN
        BEGIN
            UPDATE T_SALE
            SET SUMMA = (NVL(SUMMA, 0) - NVL(:OLD.SUMMA, 0))*(1-DISCOUNT/100),
                NDS   = NVL(NDS, 0) - NVL(:old.nds, 0)
            WHERE T_SALE.ID_SALE = :OLD.id_sale;
        end;
    ELSE
        BEGIN
            SELECT pw.PRICE INTO l_price_ware
            FROM T_PRICE_WARE pw, T_SALE s
            WHERE pw.ID_WARE = :NEW.id_ware
              and s.ID_SALE = :NEW.id_sale
              AND s.DT >= pw.DT_BEG
              AND (s.DT < pw.DT_END OR pw.DT_END IS NULL);

            :NEW.price := l_price_ware;
            :NEW.disc_price := l_price_ware*(1 - NVL(:NEW.discount, 0)/100);
            :NEW.summa := :NEW.disc_price * :new.qty;
            :NEW.nds := :new.summa * 0.2;

            UPDATE T_SALE
                SET SUMMA = NVL(SUMMA, 0) + NVL(:NEW.summa, 0) - NVL(:OLD.summa, 0),
                    NDS   = NVL(NDS, 0) + NVL(:NEW.nds, 0) - NVL(:OLD.nds, 0)
            WHERE ID_SALE = :NEW.id_sale;
        END;
    END IF;
end t_sale_str_biur_price_trg;
