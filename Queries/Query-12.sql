-- Вывод таблицы подразделений, для каждого узла — сумма продаж за заданный месяц.
-- Написать запрос по таблице с отчетом и по исходным документам. Проверить соответствие.

SELECT LPAD(' ', 3 * (LEVEL - 1)) || name AS department,
       NVL(sales_sum, 0)                  AS sum_per_month
FROM t_dept
         LEFT JOIN ((
    SELECT id_dept,
           SUM(summa) AS sales_sum
    FROM t_dept
             JOIN t_client USING (id_dept)
             JOIN t_sale USING (id_client)
    WHERE TRUNC(dt, 'MM') = TO_DATE('2020-01', 'YYYY-MM')
    GROUP BY id_dept)) USING (id_dept)
CONNECT BY PRIOR id_dept = id_parent
START WITH id_parent IS NULL;