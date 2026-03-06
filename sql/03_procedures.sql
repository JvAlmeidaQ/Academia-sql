USE Academia_FitFlow;

DELIMITER $

CREATE PROCEDURE IF NOT EXISTS SP_gerar_assinatura(
    IN p_id_plano INT,
    IN p_id_cliente INT
)
BEGIN
    DECLARE var_existe INT DEFAULT 0;
    DECLARE var_unidade_cliente INT;

    /* Variaveis de ERRO */
    DECLARE v_sqlstate CHAR(5);
    DECLARE v_errno INT;
    DECLARE v_text TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 
            v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_text = MESSAGE_TEXT;

        ROLLBACK;
        INSERT INTO Log_Erros (origem, sql_state, errno, mensagem_erro) 
        VALUES ('PROCEDURE: SP_gerar_assinatura', v_sqlstate, v_errno, v_text);
    END;

    START TRANSACTION;

        SELECT id_unidade
        INTO var_unidade_cliente
        FROM Clientes
        WHERE id_cliente = p_id_cliente;

        SELECT 1 INTO var_existe
        FROM Unidade_Planos
        WHERE id_unidade = var_unidade_cliente AND id_plano = p_id_plano;

        IF var_existe = 1 THEN
            INSERT INTO Assinaturas (id_assinatura, data_inicio,status,id_plano, id_cliente)
            VALUES (NULL,CURDATE(),'ATIVA',p_id_plano,p_id_cliente);

            UPDATE Clientes
            SET status = 'Ativo'
            WHERE id_cliente = p_id_cliente;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Plano não disponível para a unidade deste cliente.';
        END IF;

    COMMIT;
END
$

CREATE PROCEDURE IF NOT EXISTS SP_alterar_plano(
    IN new_id_plano INT,
    IN p_id_assinatura INT
)
BEGIN

    DECLARE v_sqlstate CHAR(5);
    DECLARE v_errno INT;
    DECLARE v_text TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 
            v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_text = MESSAGE_TEXT;

        ROLLBACK;
        INSERT INTO Log_Erros (origem, sql_state, errno, mensagem_erro) 
        VALUES ('PROCEDURE: SP_alterar_plano', v_sqlstate, v_errno, v_text);
    END;

    START TRANSACTION;
        UPDATE Assinaturas
         SET id_plano = new_id_plano, status = 'ATIVA'
        WHERE id_assinatura = p_id_assinatura;
    COMMIT;
END
$

CREATE PROCEDURE IF NOT EXISTS SP_alterar_status_assinatura(
    IN p_id_assinatura INT,
    IN p_new_status CHAR(10)
)
BEGIN
    DECLARE v_sqlstate CHAR(5);
    DECLARE v_errno INT;
    DECLARE v_text TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 
            v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_text = MESSAGE_TEXT;

        ROLLBACK;
        INSERT INTO Log_Erros (origem, sql_state, errno, mensagem_erro) 
        VALUES ('PROCEDURE: SP_alterar_status_assinatura', v_sqlstate, v_errno, v_text);
    END;

    START TRANSACTION;
        IF p_new_status = 'CANCELADA' THEN
            UPDATE Assinaturas
            SET status = p_new_status, data_fim = CURDATE()
            WHERE id_assinatura = p_id_assinatura;
        ELSE
            UPDATE Assinaturas
            SET status = p_new_status
            WHERE id_assinatura = p_id_assinatura;
        END IF;
    COMMIT;
END
$

CREATE PROCEDURE IF NOT EXISTS SP_registrar_pagamento(
    IN p_id_fatura INT
)
BEGIN
    
    DECLARE v_sqlstate CHAR(5);
    DECLARE v_errno INT;
    DECLARE v_text TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 
            v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_text = MESSAGE_TEXT;

        ROLLBACK;
        INSERT INTO Log_Erros (origem, sql_state, errno, mensagem_erro) 
        VALUES ('PROCEDURE: SP_registrar_pagamento', v_sqlstate, v_errno, v_text);
    END;

    START TRANSACTION;
       UPDATE Faturas
       SET status = 'Pago'
       WHERE id_fatura = p_id_fatura;
    COMMIT;
END
$

CREATE PROCEDURE IF NOT EXISTS SP_verificar_pag_pendente()
BEGIN
    DECLARE var_linhas_atualizadas INT;

    DECLARE v_sqlstate CHAR(5);
    DECLARE v_errno INT;
    DECLARE v_text TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        
        INSERT INTO Log_Erros (origem, sql_state, errno, mensagem_erro) 
        VALUES ('PROCEDURE: SP_registrar_pagamento', v_sqlstate, v_errno, v_text);

        INSERT INTO Log_Eventos(evento,detalhes)
        VALUES ('ERRO', 'Falha ao prcessar atrasos');
    END;

    START TRANSACTION;
            UPDATE Faturas
            SET status = 'Atrasado'
            WHERE data_venc < CURDATE()
            AND status = 'Pendente'; 

            SET var_linhas_atualizadas = ROW_COUNT();

            INSERT INTO Log_Eventos(evento,detalhes)
            VALUES('PROCESSAMENTO_DIARIO', 
                    CONCAT(var_linhas_atualizadas, ' fatura(s) Atrasadas.'));
    COMMIT;
END
$