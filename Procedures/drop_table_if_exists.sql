CREATE OR REPLACE PROCEDURE drop_table_if_exists (tbl_name IN VARCHAR2)
IS
    l_tbl_exist  NUMBER;
BEGIN
SELECT COUNT(*) INTO l_tbl_exist FROM USER_TABLES WHERE table_name = tbl_name;
IF l_tbl_exist = 1 THEN
    EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name || ' CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('Table ' || tbl_name || ' dropped.');
ELSE DBMS_OUTPUT.PUT_LINE('Table ' || tbl_name || ' not exist.');
END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/