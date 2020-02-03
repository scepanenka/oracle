CREATE TABLE t_supplier
(
    id_supplier NUMBER,
    moniker VARCHAR2(50) NOT NULL UNIQUE,
    name VARCHAR2(50) NOT NULL,
    PRIMARY KEY (id_supplier)
);

CREATE TABLE t_supply
(
    id_supply NUMBER,
    code VARCHAR2(30),
    num VARCHAR2(30),
    dt DATE,
    id_supplier NUMBER NOT NULL,
    e_state NUMBER(1) NOT NULL,
    summa NUMBER(14,2),
    nds NUMBER (14,2),
    PRIMARY KEY (id_supply)
);

CREATE TABLE t_supply_str
(
    id_supply_str NUMBER,
    id_supply NUMBER NOT NULL ,
    num NUMBER(6),
    id_ware NUMBER NOT NULL,
    qty NUMBER(6),
    price NUMBER(8,2),
    summa NUMBER(14,2),
    nds NUMBER (14,2),
    PRIMARY KEY (id_supply_str),
    CONSTRAINT supply_qty_ch CHECK ( qty > 0 ),
    CONSTRAINT supply_price_ch CHECK ( price >= 0 )
);

CREATE TABLE t_rest
(
    id_ware NUMBER NOT NULL ,
    qty NUMBER(6),
    PRIMARY KEY (id_ware),
    CONSTRAINT rest_qty_ch CHECK ( qty >=0 )
);

CREATE TABLE t_rest_hist
(
    id_ware NUMBER NOT NULL,
    dt_beg DATE NOT NULL,
    dt_end DATE NOT NULL,
    qty NUMBER(6) NOT NULL,
    CONSTRAINT rest_hist_qty_ch CHECK ( qty >=0 )
);

CREATE TABLE t_ctl_node
(
    id_ctl_node NUMBER,
    id_parent NUMBER,
    code VARCHAR2(12) NOT NULL ,
    tree_code VARCHAR2(240) NOT NULL,
    name VARCHAR2(100) NOT NULL,
    PRIMARY KEY (id_ctl_node)
);

CREATE TABLE t_model (
    id_model NUMBER,
    moniker VARCHAR2(12) NOT NULL UNIQUE,
    name VARCHAR2(50) NOT NULL,
    id_node NUMBER NOT NULL,
    grp VARCHAR2(50),
    subgrp VARCHAR2(50),
    label VARCHAR2(50),
    price NUMBER(8,2),
    PRIMARY KEY (id_model)
);

CREATE TABLE t_price_model (
    id_model NUMBER,
    dt_beg DATE,
    dt_end DATE,
    price NUMBER(8,2)
);

CREATE TABLE t_dept (
    id_dept NUMBER,
    name VARCHAR2(50) NOT NULL,
    id_parent NUMBER,
    PRIMARY KEY (id_dept)
);

CREATE TABLE t_client (
  id_client NUMBER,
  id_dept NUMBER,
  moniker VARCHAR2(12) UNIQUE NOT NULL,
  name VARCHAR2(50) NOT NULL,
  is_vip NUMBER(1) DEFAULT 0 NOT NULL,
  town VARCHAR2(25),
  PRIMARY KEY (id_client)
);

CREATE TABLE t_ware(
  id_ware NUMBER,
  moniker VARCHAR2(12) UNIQUE NOT NULL,
  name VARCHAR2(50) NOT NULL,
  id_model NUMBER NOT NULL,
  sz_orig VARCHAR2(30),
  sz_rus VARCHAR2(30),
  price NUMBER(8,2) NOT NULL,
  PRIMARY KEY (id_ware),
  CONSTRAINT ware_price_ch CHECK ( price > 0 )
);

CREATE TABLE t_price_ware (
    id_ware NUMBER NOT NULL,
    dt_beg DATE,
    dt_end DATE,
    price NUMBER (8,2) NOT NULL
);

CREATE TABLE t_sale (
  id_sale NUMBER,
  num VARCHAR2(30),
  dt DATE,
  id_client NUMBER NOT NULL,
  e_state SMALLINT NOT NULL,
  discount NUMBER(8,6) default 0,
  summa NUMBER(14,2),
  nds NUMBER (14,2),
  PRIMARY KEY (id_sale)
);

CREATE TABLE t_sale_str (
  id_sale_str NUMBER,
  id_sale NUMBER,
  num NUMBER(6),
  id_ware NUMBER,
  qty NUMBER(6),
  price NUMBER(8,2),
  discount NUMBER(8,2) default 0,
  disc_price NUMBER(8,2),
  summa NUMBER(14,2),
  nds NUMBER (14,2),
  PRIMARY KEY (id_sale_str),
  CONSTRAINT sale_qty_ch CHECK ( qty > 0 ),
  CONSTRAINT sale_price_ch CHECK ( price > 0 )
);

CREATE TABLE t_sale_rep (
    id_ware NUMBER,
    month DATE,
    inp_qty NUMBER,
    inp_sum NUMBER,
    supply_qty NUMBER,
    supply_sum NUMBER,
    sale_qty NUMBER,
    sale_sum NUMBER,
    out_qty NUMBER,
    out_sum NUMBER
);

CREATE TABLE t_state (
    id_state NUMBER(1),
    name VARCHAR2(12) NOT NULL,
    PRIMARY KEY (id_state)
);

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

