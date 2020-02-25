-- Триггер для ведения таблицы истории остатков.
CREATE OR REPLACE TRIGGER t_rest_aiu_r_trg
AFTER UPDATE OR INSERT ON t_rest
FOR EACH ROW
WHEN (OLD.qty<>NEW.qty)
DECLARE
    l_rest_exists NUMBER;
BEGIN
IF INSERTING THEN INSERT INTO t_rest_hist(ID_WARE, DT_BEG, DT_END, QTY)
VALUES (:NEW.id_ware, SYSDATE, NULL, :NEW.qty);
ELSIF UPDATING THEN
    BEGIN
        SELECT COUNT(*) INTO l_rest_exists FROM t_rest_hist WHERE id_ware = :NEW.id_ware AND DT_END IS NULL;
        IF l_rest_exists > 0
            THEN UPDATE t_rest_hist SET dt_end = SYSDATE WHERE dt_end IS NULL AND id_ware = :NEW.id_ware;
        end if;
        INSERT INTO t_rest_hist(ID_WARE, DT_BEG, DT_END, QTY) VALUES (:NEW.id_ware, SYSDATE, NULL, :NEW.qty);
    end;
end if;
END t_rest_aiu_r_trg;