-- Вывод таблицы подразделений с отступами в соответствии с уровнями каталога
SELECT LPAD(' ', 2*(LEVEL-1))|| name AS "PADDED NAME", LEVEL, ID_PARENT FROM T_DEPT
START WITH ID_PARENT IS NULL
CONNECT BY NOCYCLE PRIOR ID_DEPT = ID_PARENT
ORDER SIBLINGS BY NAME