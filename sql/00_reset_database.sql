USE Academia_FitFlow;

SET FOREIGN_KEY_CHECKS = 0;

DROP EVENT IF EXISTS EV_verificar_faturas_atrasadas;

-- Drop de Procedures
DROP PROCEDURE IF EXISTS SP_gerar_assinatura;
DROP PROCEDURE IF EXISTS SP_alterar_plano;
DROP PROCEDURE IF EXISTS SP_alterar_status_assinatura;
DROP PROCEDURE IF EXISTS SP_registrar_pagamento;
DROP PROCEDURE IF EXISTS SP_verificar_pag_pendente;

-- Drop de Triggers
DROP TRIGGER IF EXISTS TRG_Gerar_Fatura;
DROP TRIGGER IF EXISTS TRG_Calcula_Fim_Assinatura;
DROP TRIGGER IF EXISTS TRG_Registra_Historico;

-- Drop de Tabelas
DROP TABLE IF EXISTS Log_Eventos;
DROP TABLE IF EXISTS Log_Erros;
DROP TABLE IF EXISTS Faturas;
DROP TABLE IF EXISTS Historico;
DROP TABLE IF EXISTS Assinaturas;
DROP TABLE IF EXISTS Unidade_Planos;
DROP TABLE IF EXISTS Planos;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Unidades;
DROP TABLE IF EXISTS Telefones;
DROP TABLE IF EXISTS Endereco;

SET FOREIGN_KEY_CHECKS = 1;