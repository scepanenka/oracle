/* Вычислить число продаж, их общую сумму, средневзвешенную,
 максимальную и минимальную скидки по каждому клиенту,
 у которых были продажи со скидкой более, чем 25%.
 Все — без учета скидок на строки */

SELECT cl.MONIKER, count(s.ID_SALE), SUM(s.SUMMA)
FROM T_SALE s
JOIN T_CLIENT cl USING (ID_CLIENT)
GROUP BY cl.MONIKER
ORDER BY cl.MONIKER