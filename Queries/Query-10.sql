-- Выявить наиболее характерные значения скидок. Для этого построить распределение по предоставляемым скидкам,
-- для каждой определить количество позиций, товаров и моделей, колдичество и сумму продаж.

SELECT ROUND(discount) AS discount,
       COUNT(ID_SALE_STR) AS positions_cnt,
       COUNT(DISTINCT id_ware) AS wares_cnt,
       COUNT(DISTINCT id_model) AS models_cnt,
       SUM(qty) AS total_wares_qty,
       SUM(summa) AS total_summa
FROM t_sale_str
JOIN t_ware USING(id_ware)
JOIN t_model USING(id_model)
GROUP BY ROUND(discount)