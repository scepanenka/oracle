SELECT m.label AS model,
       count(s.ID_SALE_STR) AS cnt,
       SUM(qty) AS qty,
       ROUND(SUM(s.SUMMA)/count(s.ID_SALE_STR), 2) as avg_sum,
       MAX(s.discount) AS max_discont,
       MIN(s.discount) AS min_discount
FROM t_model m
JOIN t_ware w ON (m.id_model=w.id_model)
JOIN t_sale_str s ON (s.ID_WARE=w.ID_WARE)
GROUP BY m.label