-- Вывод каталога с отступами в соответствии с уровнями каталога. Для каждого узла — число нижележащих узлов.
SELECT
    LPAD(' ', 3 * (LEVEL - 1)) || NAME AS NODENAME,
    DECODE (CONNECT_BY_ISLEAF, 0, childs_cnt, 0) AS children_count
FROM T_CTL_NODE
LEFT JOIN (
   SELECT
      id_root_node, COUNT(*) childs_cnt
   FROM (
      SELECT
         CONNECT_BY_ROOT (ID_CTL_NODE) AS id_root_node
      FROM
         T_CTL_NODE
      WHERE LEVEL = 2
      CONNECT BY NOCYCLE PRIOR ID_CTL_NODE = ID_PARENT)
   GROUP BY id_root_node)
ON ID_CTL_NODE = id_root_node
CONNECT BY NOCYCLE PRIOR ID_CTL_NODE = ID_PARENT
START WITH ID_PARENT IS NULL
ORDER SIBLINGS BY NAME;