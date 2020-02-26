/* Вычислить число продаж, их общую сумму, средневзвешенную, максимальную и минимальную скидки по каждому клиенту,
 у которых были продажи со скидкой более, чем 25%. Все — без учета скидок на строки */

DEFINE

SELECT cl.moniker AS client,
       count(s.id_sale) sales_cnt,
       SUM(s.summa) AS sales_summa,
       SUM(s.summa)/count(s.id_sale) as avg_sale_sum,
       MAX(s.discount) AS max_discount,
       MIN(s.discount) AS min_discount
FROM T_SALE s
         JOIN T_CLIENT cl ON (s.ID_CLIENT = cl.ID_CLIENT)
GROUP BY cl.MONIKER
HAVING MAX(s.discount) > 25
