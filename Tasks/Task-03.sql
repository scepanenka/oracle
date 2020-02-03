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

