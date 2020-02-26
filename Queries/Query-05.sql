-- Вывод каталога с отступами, для листа с товарами — число моделей и товаров в нем.
SELECT
    LPAD(' ', 2 * (LEVEL - 1)) || n.NAME AS NODENAME,
       nodes.models_cnt, nodes.wares_cnt
FROM T_CTL_NODE n
JOIN (
    SELECT
           n.ID_CTL_NODE as id_node,
           COUNT(distinct m.ID_MODEL) as models_cnt,
           COUNT(distinct w.ID_WARE) as wares_cnt
    FROM T_CTL_NODE n
    LEFT JOIN T_MODEL m ON n.ID_CTL_NODE = m.ID_NODE
    LEFT JOIN T_WARE w ON m.ID_MODEL = w.ID_MODEL
    GROUP BY n.ID_CTL_NODE) nodes
    ON n.ID_CTL_NODE = nodes.id_node
CONNECT BY NOCYCLE PRIOR n.ID_CTL_NODE = n.ID_PARENT
START WITH n.ID_PARENT IS NULL
ORDER SIBLINGS BY n.NAME;

SELECT
    n.NAME AS NODENAME,LEVEL
FROM T_CTL_NODE n
WHERE LEVEL=1
CONNECT BY NOCYCLE PRIOR n.ID_CTL_NODE = n.ID_PARENT
START WITH n.ID_PARENT = 1001
ORDER SIBLINGS BY n.NAME;

SELECT id_ctl_node, id_parent
                          FROM t_ctl_node
                          WHERE id_ctl_node != 1001
                          CONNECT BY id_parent = PRIOR id_ctl_node
                          START WITH id_ctl_node = 1001
                          ORDER BY LEVEL;

SELECT id_ctl_node, id_parent FROM t_ctl_node
        WHERE LEVEL=2
        CONNECT BY id_parent = PRIOR id_ctl_node
        START WITH id_ctl_node = 1001;
