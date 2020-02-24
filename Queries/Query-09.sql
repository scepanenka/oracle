-- Выдать отчет о продажах по подразделениям, для каждого подразделения в дереве в отчет включать подчиненные.
-- В отчете — число продаж, число строк, количество, общая сумма.

SELECT LPAD(' ', 3 * (LEVEL - 1)) || name AS department,
       NVL(sales_cnt, 0)                  AS sales_cnt,
       NVL(strings_cnt, 0)                AS strings_cnt,
       NVL(sales_qty, 0)                  AS qty,
       NVL(sales_summa, 0)                AS summa
FROM t_dept
         LEFT JOIN (
    SELECT dept_id,
           COUNT(DISTINCT id_sale)     AS sales_cnt,
           COUNT(DISTINCT id_sale_str) AS strings_cnt,
           SUM(qty)                    AS sales_qty,
           SUM(summa)                  AS sales_summa
    FROM (
             SELECT connect_by_root (id_dept) dept_id,
                    id_sale,
                    id_sale_str,
                    qty,
                    st.summa
             FROM t_dept
                      LEFT JOIN t_client USING (id_dept)
                      LEFT JOIN t_sale USING (id_client)
                      LEFT JOIN t_sale_str st USING (id_sale)
             CONNECT BY PRIOR id_dept = id_parent)
    GROUP BY dept_id) ds ON (dept_id = id_dept)
CONNECT BY PRIOR dept_id = id_parent
START WITH id_parent IS NULL