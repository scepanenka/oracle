-- Найти модели, на которые предоставлены нехарактерно большие скидки, с учетом предыдущего анализа.
-- Сделать предположение о с составе этих моделей

SELECT id_model,
       m.name               AS model_name,
       ROUND(AVG(discount)) AS avg_discount
FROM t_model m
         JOIN t_ware USING (id_model)
         JOIN t_sale_str USING (id_ware)
WHERE discount > 0
GROUP BY id_model, m.name
HAVING AVG(discount) > (SELECT AVG(discount) FROM t_sale_str WHERE discount > 0) + 10;