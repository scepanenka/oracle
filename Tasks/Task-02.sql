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