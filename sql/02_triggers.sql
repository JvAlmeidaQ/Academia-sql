USE Academia_FitFlow;

DELIMITER $

CREATE TRIGGER TRG_Gerar_Fatura
AFTER INSERT ON Assinaturas
FOR EACH ROW
BEGIN
        DECLARE var_valor_plano DECIMAL(10,2);
        DECLARE var_dia_pag INT;
        DECLARE var_data_base DATE;
        DECLARE var_data_venc DATE;

        IF NEW.status = 'ATIVA' THEN

            SELECT valor_mensal 
            INTO var_valor_plano
            FROM Planos
            WHERE id_plano = NEW.id_plano;


            SELECT dia_pag
            INTO var_dia_pag
            FROM Clientes
            WHERE id_cliente = NEW.id_cliente;

            SET var_data_base = STR_TO_DATE (
                CONCAT(YEAR(CURDATE()), '-', MONTH(CURDATE()), '-', var_dia_pag),
                '%Y-%m-%d'
            );
            
            IF var_data_base < CURDATE() THEN
                SET var_data_base = DATE_ADD(var_data_base, INTERVAL 1 MONTH);
            END IF;

            SET var_data_venc = var_data_base;
       
            INSERT INTO Faturas
            (id_fatura, valor_fatura, data_venc, status, id_assinatura)
            VALUES
            (NULL,var_valor_plano,var_data_venc,'Pendente', NEW.id_assinatura);

    END IF;

END
$


CREATE TRIGGER TRG_Calcula_Fim_Assinatura 
BEFORE INSERT ON Assinaturas
FOR EACH ROW
BEGIN
    
    DECLARE var_duracao_plano INT;

    SELECT duracao_plano
    INTO var_duracao_plano
    FROM Planos
    WHERE id_plano = NEW.id_plano;

    IF NEW.data_fim IS NULL THEN
        SET NEW.data_fim = DATE_ADD(
            NEW.data_inicio, INTERVAL var_duracao_plano DAY
        );
    END IF;
END 
$


CREATE TRIGGER TRG_Registra_Historico
AFTER UPDATE ON Assinaturas
FOR EACH ROW
BEGIN
    DECLARE var_valor_old_plano, 
            var_valor_new_plano DECIMAL(10,2);
            
    DECLARE var_plano_old, var_plano_new VARCHAR(100);
    DECLARE frase VARCHAR(255);

    IF OLD.status != NEW.status OR OLD.id_plano != NEW.id_plano THEN

        SET frase = CONCAT(
            'A matricula foi ',
            CASE NEW.status
                WHEN 'ATIVA' THEN 'ativada com sucesso'
                WHEN 'TRANCADA' THEN 'temporariamente trancada'
                WHEN 'CANCELADA' THEN 'cancelada definitivamente'
                ELSE 'atualizada'
            END
        );

        SELECT valor_mensal, nome_plano 
                INTO var_valor_old_plano, var_plano_old
                FROM Planos
                WHERE id_plano = OLD.id_plano;

        SELECT valor_mensal, nome_plano
            INTO var_valor_new_plano, var_plano_new
            FROM Planos
            WHERE id_plano = NEW.id_plano;

        INSERT INTO Historico(
            id_historico,
            desc_mudanca,
            valor_antigo,
            valor_novo,
            plano_antigo,
            plano_novo,
            id_plano,
            id_cliente,
            id_assinatura
        ) 
        VALUES(
                NULL,
                frase,
                var_valor_old_plano,
                var_valor_new_plano,
                var_plano_old,
                var_plano_new,
                OLD.id_plano,
                NEW.id_cliente,
                OLD.id_assinatura
            );
    END IF;
END
$