-- Набор процедур для элементарных операций над узлами каталога, обеспечивающих вычисление иерархического кода:
-- вставка, перемещение в иерархии, переименование.

-- Вставка
CREATE OR REPLACE PROCEDURE node_add(i_id_parent t_ctl_node.id_parent%TYPE,
                                     i_code t_ctl_node.code%TYPE,
                                     i_name t_ctl_node.name%TYPE)
    IS
    l_tree_code t_ctl_node.tree_code%TYPE;
BEGIN
    SELECT tree_code INTO l_tree_code FROM t_ctl_node WHERE id_ctl_node = i_id_parent;
    l_tree_code := NVL(l_tree_code, '') || '/' || i_code;
    INSERT INTO t_ctl_node (id_parent, code, tree_code, name) VALUES (i_id_parent, i_code, l_tree_code, i_name);
    COMMIT;
END node_add;
/

-- Перемещение
CREATE OR REPLACE PROCEDURE node_move(i_id_node t_ctl_node.id_ctl_node%TYPE,
                                      i_id_new_parent t_ctl_node.id_parent%TYPE)
    IS
    l_tree_code t_ctl_node.tree_code%TYPE;
    l_code      t_ctl_node.code%TYPE;
    CURSOR child_nodes_cursor IS SELECT id_ctl_node, id_parent FROM t_ctl_node
        WHERE LEVEL=2
        CONNECT BY id_parent = PRIOR id_ctl_node
        START WITH id_ctl_node = i_id_node;
BEGIN
    SELECT tree_code INTO l_tree_code FROM t_ctl_node WHERE id_ctl_node = i_id_new_parent;
    SELECT code INTO l_code FROM t_ctl_node WHERE id_ctl_node = i_id_node;
    l_tree_code := NVL(l_tree_code, '') || '/' || l_code;
    UPDATE t_ctl_node
    SET id_parent = i_id_new_parent,
        tree_code = l_tree_code
    WHERE id_ctl_node = i_id_node;
    COMMIT;

    FOR n IN child_nodes_cursor
    LOOP
        node_move(n.id_ctl_node, n.id_parent);
    END LOOP;
    COMMIT;
END node_move;
/