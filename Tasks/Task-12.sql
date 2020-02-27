CREATE OR REPLACE PROCEDURE check_dept_cycle
AS
    cycle_cnt NUMBER;
BEGIN
SELECT COUNT(*) cnt INTO cycle_cnt FROM t_dept
  WHERE CONNECT_BY_ISCYCLE=1
  START WITH id_parent IS NULL
  CONNECT BY NOCYCLE id_parent = PRIOR id_dept;
IF cycle_cnt = 0
    THEN
        DBMS_OUTPUT.PUT_LINE('There is no cycles in departments.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('There is ' || cycle_cnt || ' cycle(s) in departments.');
    END IF;
END;
/