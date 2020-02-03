-- T_SUPPLIER
INSERT INTO t_supplier (ID_SUPPLIER, MONIKER, NAME) VALUES (1001, 'Supplier1', 'Supplier1_fullname');
INSERT INTO t_supplier (ID_SUPPLIER, MONIKER, NAME) VALUES (1002, 'Supplier2', 'Supplier2_fullname');
INSERT INTO t_supplier (ID_SUPPLIER, MONIKER, NAME) VALUES (1003, 'Supplier3', 'Supplier3_fullname');
INSERT INTO t_supplier (ID_SUPPLIER, MONIKER, NAME) VALUES (1004, 'Supplier4', 'Supplier4_fullname');

-- T_STATE
INSERT INTO T_STATE VALUES (0, 'New');
INSERT INTO T_STATE VALUES (1, 'Done');

-- T_SUPPLY
INSERT INTO T_SUPPLY (ID_SUPPLY, CODE, DT, ID_SUPPLIER, E_STATE) VALUES  (1001,'SUPPLY0001', TO_DATE('2020-01-20', 'YYYY-MM-DD'), 1001, 0);
INSERT INTO T_SUPPLY (ID_SUPPLY, CODE, DT, ID_SUPPLIER, E_STATE) VALUES  (1002,'SUPPLY0002', TO_DATE('2020-01-21', 'YYYY-MM-DD'), 1002, 0);
INSERT INTO T_SUPPLY (ID_SUPPLY, CODE, DT, ID_SUPPLIER, E_STATE) VALUES  (1003,'SUPPLY0003', TO_DATE('2020-01-22', 'YYYY-MM-DD'), 1003, 0);
INSERT INTO T_SUPPLY (ID_SUPPLY, CODE, DT, ID_SUPPLIER, E_STATE) VALUES  (1004,'SUPPLY0004', TO_DATE('2020-01-22', 'YYYY-MM-DD'), 1004, 0);

-- T_CTL_NODE
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1001, NULL, 'CODE0001', 'TREE0001', 'NAME0001');
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1002, 1001, 'CODE0002', 'TREE0002', 'NAME0002');
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1003, 1001, 'CODE0003', 'TREE0003', 'NAME0003');
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1004, 1001, 'CODE0004', 'TREE0004', 'NAME0004');
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1005, NULL, 'CODE0005', 'TREE0005', 'NAME0005');
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1006, 1005, 'CODE0006', 'TREE0006', 'NAME0006');
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1007, 1005, 'CODE0007', 'TREE0007', 'NAME0007');
INSERT INTO T_CTL_NODE (ID_CTL_NODE, ID_PARENT, CODE, TREE_CODE, NAME) VALUES (1008, 1004, 'CODE0008', 'TREE0008', 'NAME0008');

-- T_MODEL
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1001, 'MD000001', 'Model001', 1002, 'GRUPP001', 'SUBGRP01', 'LABEL001', 100);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1002, 'MD000002', 'Model002', 1002, 'GRUPP001', 'SUBGRP02', 'LABEL001', 200);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1003, 'MD000003', 'Model003', 1002, 'GRUPP002', 'SUBGRP01', 'LABEL002', 300);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1004, 'MD000004', 'Model004', 1002, 'GRUPP002', 'SUBGRP03', 'LABEL002', 400);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1005, 'MD000005', 'Model005', 1002, 'GRUPP003', 'SUBGRP04', 'LABEL003', 400);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1006, 'MD000006', 'Model006', 1006, 'GRUPP003', 'SUBGRP04', 'LABEL003', 50);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1007, 'MD000007', 'Model007', 1006, 'GRUPP003', 'SUBGRP04', 'LABEL003', 60);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1008, 'MD000008', 'Model008', 1006, 'GRUPP003', 'SUBGRP04', 'LABEL003', 70);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1009, 'MD000009', 'Model009', 1007, 'GRUPP003', 'SUBGRP04', 'LABEL003', 80);
INSERT INTO T_MODEL (ID_MODEL, MONIKER, NAME, ID_NODE, GRP, SUBGRP, LABEL, PRICE) VALUES (1010, 'MD000010', 'Model010', 1008, 'GRUPP003', 'SUBGRP04', 'LABEL003', 180);

-- T_PRICE_MODEL
INSERT INTO T_PRICE_MODEL (ID_MODEL, DT_BEG, DT_END, PRICE) VALUES (1001, DATE '2019-12-01', DATE '2020-01-01', 95);
INSERT INTO T_PRICE_MODEL (ID_MODEL, DT_BEG, DT_END, PRICE) VALUES (1002, DATE '2019-12-01', DATE '2020-01-01', 190);
INSERT INTO T_PRICE_MODEL (ID_MODEL, DT_BEG, DT_END, PRICE) VALUES (1003, DATE '2019-12-01', DATE '2020-01-01', 250);
INSERT INTO T_PRICE_MODEL (ID_MODEL, DT_BEG, DT_END, PRICE) VALUES (1004, DATE '2019-12-01', DATE '2020-01-01', 350);
INSERT INTO T_PRICE_MODEL (ID_MODEL, DT_BEG, DT_END, PRICE) VALUES (1005, DATE '2019-12-01', DATE '2020-01-01', 450);

-- T_WARE
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1001, 'PROD0001', 'PROD0001', 1001, 'M', '48', 110);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1002, 'PROD0002', 'PROD0002', 1001, 'L', '52', 110);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1003, 'PROD0003', 'PROD0003', 1001, 'XL', '56', 110);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1004, 'PROD0004', 'PROD0004', 1002, 'M', '48', 200);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1005, 'PROD0005', 'PROD0005', 1003, 'M', '48', 300);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1006, 'PROD0006', 'PROD0006', 1006, 'M', '48', 70);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1007, 'PROD0007', 'PROD0007', 1006, 'M', '48', 70);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1008, 'PROD0008', 'PROD0008', 1007, 'M', '48', 80);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1009, 'PROD0009', 'PROD0009', 1010, 'M', '48', 180);
INSERT INTO T_WARE (ID_WARE, MONIKER, NAME, ID_MODEL, SZ_ORIG, SZ_RUS, PRICE) VALUES (1010, 'PROD0010', 'PROD0010', 1010, 'L', '52', 180);

-- T_PRICE_WARE
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1001, DATE '2019-12-01', DATE '2020-01-01', 100);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1002, DATE '2019-12-01', DATE '2020-01-01', 95);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1003, DATE '2019-12-01', DATE '2020-01-01', 100);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1004, DATE '2019-12-01', DATE '2020-01-01', 200);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1005, DATE '2019-12-01', DATE '2020-01-01', 300);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1001, DATE '2020-01-01', NULL, 110);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1002, DATE '2020-01-01', NULL, 110);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1003, DATE '2020-01-01', NULL, 110);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1004, DATE '2020-01-01', NULL, 210);
INSERT INTO T_PRICE_WARE (ID_WARE, DT_BEG, DT_END, PRICE) VALUES (1005, DATE '2020-01-01', NULL, 310);

-- T_SUPPLY_STR
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1001, 1001, 1001, 1001, 100, 70);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1002, 1001, 1002, 1002, 100, 70);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1003, 1001, 1003, 1003, 100, 70);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1004, 1002, 1004, 1004, 200, 70);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1005, 1002, 1005, 1002, 100, 70);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1006, 1003, 1006, 1003, 100, 170);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1007, 1003, 1007, 1004, 100, 260);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1008, 1004, 1008, 1004, 100, 260);
INSERT INTO T_SUPPLY_STR (ID_SUPPLY_STR, ID_SUPPLY, NUM, ID_WARE, QTY, PRICE) VALUES (1009, 1004, 1009, 1005, 100, 350);

-- T_DEPT
INSERT INTO T_DEPT (ID_DEPT, NAME, ID_PARENT) VALUES (1001, 'MAINDEPT', NULL);
INSERT INTO T_DEPT (ID_DEPT, NAME, ID_PARENT) VALUES (1002, 'SUBDEPT_110', 1001);
INSERT INTO T_DEPT (ID_DEPT, NAME, ID_PARENT) VALUES (1003, 'SUBDEPT_120', 1001);
INSERT INTO T_DEPT (ID_DEPT, NAME, ID_PARENT) VALUES (1004, 'SUBDEPT_121', 1003);
INSERT INTO T_DEPT (ID_DEPT, NAME, ID_PARENT) VALUES (1005, 'SUBDEPT_122', 1003);
INSERT INTO T_DEPT (ID_DEPT, NAME, ID_PARENT) VALUES (1006, 'SUBDEPT_111', 1002);

-- T_CLIENT
INSERT INTO T_CLIENT (ID_CLIENT, ID_DEPT, MONIKER, NAME, IS_VIP) VALUES (1001, 1001, 'Client_01', 'Client First', 1);
INSERT INTO T_CLIENT (ID_CLIENT, ID_DEPT, MONIKER, NAME) VALUES (1002, 1001, 'Client_02', 'Client Second');
INSERT INTO T_CLIENT (ID_CLIENT, ID_DEPT, MONIKER, NAME) VALUES (1003, 1002, 'Client_03', 'Client Third');
INSERT INTO T_CLIENT (ID_CLIENT, ID_DEPT, MONIKER, NAME) VALUES (1004, 1003, 'Client_04', 'Client Fourth');

-- T_SALE
INSERT INTO T_SALE (ID_SALE, NUM, DT, ID_CLIENT, E_STATE, DISCOUNT) VALUES (1001, 'SALE_0001', DATE '2020-01-23', 1001, 0, 25);
INSERT INTO T_SALE (ID_SALE, NUM, DT, ID_CLIENT, E_STATE, DISCOUNT) VALUES (1002, 'SALE_0002', DATE '2020-01-23', 1002, 0, 10);
INSERT INTO T_SALE (ID_SALE, NUM, DT, ID_CLIENT, E_STATE, DISCOUNT) VALUES (1003, 'SALE_0003', DATE '2020-01-23', 1003, 0, 5);
INSERT INTO T_SALE (ID_SALE, NUM, DT, ID_CLIENT, E_STATE, DISCOUNT) VALUES (1004, 'SALE_0004', DATE '2020-01-23', 1003, 0, 5);
INSERT INTO T_SALE (ID_SALE, NUM, DT, ID_CLIENT, E_STATE, DISCOUNT) VALUES (1005, 'SALE_0005', TO_DATE('24.01.2020', 'DD.MM.YYYY'), 1004, 0, 20);

-- T_SALE_STR
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY) VALUES (1001, 1001, 1001, 1001, 1);
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY, DISCOUNT) VALUES (1002, 1001, 1002, 1002, 2, 10);
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY) VALUES (1003, 1002, 1003, 1001, 1);
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY) VALUES (1004, 1003, 1004, 1001, 1);
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY, DISCOUNT) VALUES (1005, 1004, 1005, 1004, 2, 5);
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY) VALUES (1006, 1005, 1006, 1003, 5);
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY) VALUES (1007, 1005, 1007, 1002, 5);
INSERT INTO T_SALE_STR (ID_SALE_STR, ID_SALE, NUM, ID_WARE, QTY) VALUES (1008, 1005, 1008, 1001, 5);

COMMIT;