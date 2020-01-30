-- Вывод каталога с отступами, для листа с товарами — число моделей и товаров в нем.
SELECT
    LPAD(' ', 2 * (LEVEL - 1)) || n.NAME AS NODENAME,
       nodes.models_cnt, nodes.wares_cnt
FROM T_CTL_NODE n
JOIN (
    SELECT
           n.ID_CTL_NODE as id_node,
           COUNT(m.ID_MODEL) as models_cnt,
           COUNT(w.ID_WARE) as wares_cnt
    FROM T_CTL_NODE n
    LEFT JOIN T_MODEL m ON n.ID_CTL_NODE = m.ID_NODE
    LEFT JOIN T_WARE w ON m.ID_MODEL = w.ID_MODEL
    GROUP BY n.ID_CTL_NODE) nodes
    ON n.ID_CTL_NODE = nodes.id_node
CONNECT BY NOCYCLE PRIOR n.ID_CTL_NODE = n.ID_PARENT
START WITH n.ID_PARENT IS NULL
ORDER SIBLINGS BY n.NAME;