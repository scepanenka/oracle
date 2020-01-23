DROP TABLE t_supplier;
CREATE TABLE t_supplier 
(
    id_supplier NUMBER, 
    moniker VARCHAR2(50), 
    name VARCHAR2(50)    
);

DROP TABLE t_supply;
CREATE TABLE t_supply 
(
    id_supply NUMBER,
    code VARCHAR2(30),
    num VARCHAR2(30),
    dt DATE,
    id_supplier NUMBER,
    e_state SMALLINT,
    summa NUMBER(14,2),
    nds NUMBER (14,2)
);

DROP TABLE t_supply_str;
CREATE TABLE t_supply_str 
(
    id_supply_str NUMBER,
    id_supply NUMBER,
    code VARCHAR2(30),
    num NUMBER(6),
    id_ware NUMBER,
    qty NUMBER(6),
    price NUMBER(8,2)
);

DROP TABLE t_rest;
CREATE TABLE t_rest
(
    id_ware NUMBER,
    qty NUMBER(6)
);

DROP TABLE t_rest_hist;
CREATE TABLE t_rest_hist
(
    id_ware NUMBER,
    dt_beg DATE,
    dt_end DATE,
    qty NUMBER(6)
);

DROP TABLE t_ctl_node;
CREATE TABLE t_ctl_node
(
    id_ctl_node NUMBER,
    id_parent NUMBER,
    code VARCHAR2(12),
    tree_code VARCHAR2(240),
    name VARCHAR2(100)
);

DROP TABLE t_model;
CREATE TABLE t_model (
    id_model NUMBER,
    moniker VARCHAR2(12),
    name VARCHAR2(50),
    id_node NUMBER,
    grp VARCHAR2(50),
    subgrp VARCHAR2(50),
    label VARCHAR2(50),
    price NUMBER(8,2)
);

DROP TABLE t_price_model;
CREATE TABLE t_price_model (
    id_model NUMBER,
    dt_beg DATE,
    dt_end DATE,
    price NUMBER(8,2)
);

DROP TABLE t_dept;
CREATE TABLE t_dept (
    id_dept NUMBER,
    name VARCHAR2(50),
    id_parent NUMBER
);

DROP TABLE t_client;
CREATE TABLE t_client (
  id_client NUMBER,
  id_dept NUMBER,
  moniker VARCHAR2(12),
  name VARCHAR2(50)
);

DROP TABLE t_sale;
CREATE TABLE t_sale (
  id_sale NUMBER,
  num VARCHAR2(30),
  dt DATE,
  id_client NUMBER,
  e_state SMALLINT,
  price NUMBER(8,2),
  discount NUMBER(8,6),
  summa NUMBER(14,2),
  nds NUMBER (14,2)
);

DROP TABLE t_sale_str;
CREATE TABLE t_sale_str (
  id_sale_str NUMBER,
  id_sale NUMBER,
  num NUMBER(6),
  id_ware NUMBER,
  qty NUMBER(6),
  price NUMBER(8,2),
  discount NUMBER(8,2),
  summa NUMBER(14,2),
  nds NUMBER (14,2)
);

DROP TABLE t_price_ware;
CREATE TABLE t_price_ware (
    id_ware NUMBER,
    dt_beg DATE,
    dt_end DATE,
    price NUMBER (8,2)
);

DROP TABLE t_ware;
CREATE TABLE t_ware(
  id_ware NUMBER,
  moniker VARCHAR2(12),
  name VARCHAR2(50),
  id_model NUMBER,
  sz_orig VARCHAR2(30),
  sz_rus VARCHAR2(30),
  price NUMBER(8,2)
);

DROP TABLE t_sale_rep;
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

COMMIT;