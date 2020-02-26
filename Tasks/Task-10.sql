-- Набор процедур для элементарных операций над узлами каталога, обеспечивающих вычисление иерархического кода:
-- вставка, перемещение в иерархии, переименование.

-- Вставка
CREATE OR REPLACE PROCEDURE node_add(i_id_parent t_ctl_node.id_parent%TYPE,
                                     i_code t_ctl_node.code%TYPE,
                                     i_name t_ctl_node.name%TYPE)
    IS
    l_tree_code t_ctl_node.tree_code%TYPE;
BEGIN
    SELECT tree_code
    INTO l_tree_code
    FROM t_ctl_node
    WHERE ID_CTL_NODE = i_id_parent;
    l_tree_code := NVL(l_tree_code, '') || '/' || i_code;
    INSERT INTO t_ctl_node (id_parent, code, tree_code, name) VALUES (i_id_parent, i_code, l_tree_code, i_name);
    COMMIT;
END node_add;

-- Перемещение
