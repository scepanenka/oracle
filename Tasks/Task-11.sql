-- триггер, обеспечивающий вычисление иерархического кода для узлов каталога.
CREATE OR REPLACE TRIGGER t_ctl_node_compound_trg
    FOR UPDATE OF id_parent, code OR INSERT
    ON t_ctl_node
    COMPOUND TRIGGER
    TYPE id_node_type IS TABLE OF t_ctl_node.id_ctl_node%TYPE INDEX BY PLS_INTEGER;
    g_node_ids id_node_type;
BEFORE EACH ROW IS
BEGIN
    DECLARE
        l_tree_code t_ctl_node.tree_code%TYPE;
    BEGIN
        IF INSERTING THEN
            SELECT id_ctl_node_seq.NEXTVAL INTO :new.id_ctl_node FROM dual;
            BEGIN
                SELECT tree_code INTO l_tree_code FROM t_ctl_node WHERE ID_CTL_NODE = :NEW.id_parent;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            :NEW.tree_code := NVL(l_tree_code, '') || '/' || :NEW.code;
        ELSIF UPDATING THEN
            g_node_ids(g_node_ids.COUNT) := :old.id_ctl_node;
        END IF;
    END;
END BEFORE EACH ROW;
AFTER STATEMENT IS
        l_id_node t_ctl_node.id_ctl_node%TYPE;
        CURSOR child_nodes_cursor IS SELECT id_ctl_node FROM t_ctl_node
            WHERE LEVEL>=1
            CONNECT BY id_parent = PRIOR id_ctl_node
            START WITH id_ctl_node = l_id_node;
BEGIN
IF g_node_ids.count > 0 THEN
FOR indx IN 0 .. (g_node_ids.COUNT - 1)
LOOP
l_id_node := g_node_ids(indx);
FOR n IN child_nodes_cursor
LOOP
UPDATE t_ctl_node
        SET tree_code = (SELECT SYS_CONNECT_BY_PATH(CODE, '/')
                         FROM t_ctl_node
                         WHERE ID_CTL_NODE = n.id_ctl_node
                         CONNECT BY id_parent = PRIOR id_ctl_node
                         START WITH ID_PARENT IS NULL)
        WHERE id_ctl_node = n.id_ctl_node;
END LOOP;
END LOOP;
END IF;
END AFTER STATEMENT;
END t_ctl_node_compound_trg;
/

