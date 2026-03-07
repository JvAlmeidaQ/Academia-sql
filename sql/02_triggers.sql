
DELIMITER $

CREATE TRIGGER IF NOT EXISTS TRG_Gerar_Fatura
AFTER INSERT ON Assinaturas
FOR EACH ROW
BEGIN
        DECLARE var_valor_mensal DECIMAL(10,2);
        DECLARE var_duracao_plano_meses INT;
        DECLARE var_dia_pag INT;
        DECLARE var_data_base DATE;
        DECLARE var_data_venc DATE;
        DECLARE var_i INT DEFAULT 0;

        IF NEW.status = 'ATIVA' THEN

            SELECT valor_mensal, duracao_plano_meses
            INTO var_valor_mensal, var_duracao_plano_meses
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

            WHILE var_i < var_duracao_plano_meses DO

                SET var_data_venc = DATE_ADD(var_data_base, INTERVAL var_i MONTH);
        
                INSERT INTO Faturas
                (valor_fatura, data_venc, status, id_assinatura)
                VALUES
                (var_valor_mensal,var_data_venc,'Pendente', NEW.id_assinatura);

                SET var_i = var_i + 1;
            END WHILE;

        ELSE
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Erro: Apenas assinaturas ATIVAS geram faturas automaticamente.';
        END IF;

END
$


CREATE TRIGGER IF NOT EXISTS TRG_Calcula_Fim_Assinatura 
BEFORE INSERT ON Assinaturas
FOR EACH ROW
BEGIN
    
    DECLARE var_duracao_plano_meses INT;

    SELECT duracao_plano_meses
    INTO var_duracao_plano_meses
    FROM Planos
    WHERE id_plano = NEW.id_plano;

    IF NEW.data_fim IS NULL THEN
        SET NEW.data_fim = DATE_ADD(
            NEW.data_inicio, INTERVAL var_duracao_plano_meses MONTH
        );
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro na Trigger TRG_Calcula_Fim_Assinatura : Falha ao calcular data final da assinatura.';
    END IF;
END 
$


CREATE TRIGGER IF NOT EXISTS TRG_Registra_Historico
AFTER UPDATE ON Assinaturas
FOR EACH ROW
BEGIN        
    DECLARE frase VARCHAR(255);

    IF OLD.status != NEW.status OR OLD.id_plano != NEW.id_plano THEN

         SET frase = CONCAT(
            'Assinatura ', NEW.id_assinatura, ': ',
            CASE 
                WHEN OLD.status != NEW.status THEN CONCAT('Status alterado de ', OLD.status, ' para ', NEW.status)
                WHEN OLD.id_plano != NEW.id_plano THEN 'Mudança de plano efetuada'
                ELSE 'Atualização de dados cadastrais'
            END
        );

        IF OLD.data_fim != NEW.data_fim THEN
            INSERT INTO Historico( desc_mudanca, id_plano_antigo, id_plano_novo, data_mudança, id_cliente, id_assinatura) 
            VALUES(frase, OLD.id_plano, NEW.id_plano, CURDATE(), NEW.id_cliente, OLD.id_assinatura );
        END IF;

    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro na Trigger TRG_Registra_Historico: Falha ao inserir historico.';
    END IF;
END
$

DELIMITER ;