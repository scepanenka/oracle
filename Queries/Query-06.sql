-- Вывод каталога с отступами, для каждого узла — число моделей и товаров в нем и нижележащих узлах.
SELECT
    LPAD(' ', 2 * (LEVEL - 1)) || n.NAME AS NODENAME,
       model_cnt, ware_cnt
FROM T_CTL_NODE n
JOIN (
    SELECT id_node, COUNT(distinct id_model) as model_cnt, COUNT(distinct id_ware) ware_cnt
    FROM (SELECT connect_by_root (n.ID_CTL_NODE) as id_node, m.ID_MODEL as id_model, w.ID_WARE as id_ware
            FROM T_CTL_NODE n
            left join T_MODEL m on n.ID_CTL_NODE = m.ID_NODE
            left join T_WARE w on m.ID_MODEL= w.ID_MODEL
            CONNECT BY NOCYCLE PRIOR ID_CTL_NODE = ID_PARENT
            ORDER SIBLINGS BY n.ID_CTL_NODE
        )
        GROUP BY id_node
    )
ON n.ID_CTL_NODE = id_node
CONNECT BY NOCYCLE PRIOR n.ID_CTL_NODE = n.ID_PARENT
START WITH n.ID_PARENT IS NULL
ORDER SIBLINGS BY n.NAME;