-- 1. Endereços
INSERT INTO Endereco (rua, numero, bairro, cidade, estado, cep) VALUES
('Rua dos Tupis', '450', 'Centro', 'Belo Horizonte', 'MG', '30190060'), 
('Av. Paulista', '1000', 'Bela Vista', 'São Paulo', 'SP', '01310100'),      
('Rua XV de Novembro', '200', 'Centro', 'Ouro Preto', 'MG', '36200000'),    
('Rua Halfeld', '500', 'Centro', 'Juiz de Fora', 'MG', '36010002'),        
('Av. Atlântica', '1702', 'Copacabana', 'Rio de Janeiro', 'RJ', '22021001'),
('Rua XV de Novembro', '300', 'Centro', 'Curitiba', 'PR', '80020310'),    
('Av. Tancredo Neves', '120', 'Caminho das Árvores', 'Salvador', 'BA', '41820020'), 
('Rua dos Andradas', '800', 'Centro Histórico', 'Porto Alegre', 'RS', '90020000'), 
('SCN Quadra 2', '10', 'Asa Norte', 'Brasília', 'DF', '70712900'),        
('Av. Boa Viagem', '2000', 'Boa Viagem', 'Recife', 'PE', '51011000'),      
('Av. Beira Mar', '4000', 'Meireles', 'Fortaleza', 'CE', '60165121'),    
('Av. T-10', '50', 'Setor Bueno', 'Goiânia', 'GO', '74223060');           

-- 2. Unidades
INSERT INTO Unidades (cnpj, nome_unidade, email, id_endereco) VALUES
('12345678000190', 'FitFlow BH', 'bh@fitflow.com', 1), ('98765432000110', 'FitFlow Paulista', 'sp@fitflow.com', 2),
('11111111000101', 'Unidade Centro', 'centro@fitflow.com', 3), ('22222222000102', 'Unidade Norte', 'norte@fitflow.com', 4),
('33333333000103', 'Unidade Sul', 'sul@fitflow.com', 5), ('44444444000104', 'Unidade Leste', 'leste@fitflow.com', 6),
('55555555000105', 'Unidade Oeste', 'oeste@fitflow.com', 7), ('66666666000106', 'Unidade Premium', 'prem@fitflow.com', 8),
('77777777000107', 'Unidade Express', 'exp@fitflow.com', 9), ('88888888000108', 'Unidade Fitness', 'fit@fitflow.com', 10),
('99999999000109', 'Unidade Total', 'total@fitflow.com', 11), ('10101010000110', 'Unidade Pro', 'pro@fitflow.com', 12);

-- 3. Planos (Catálogo Global)
INSERT INTO Planos (nome_plano, duracao_plano_meses, valor_mensal) VALUES
('Mensal', 1, 100.00), ('Trimestral', 3, 90.00), ('Anual', 12, 75.00);

-- 4. Associativa (Disponibilidade dos planos em cada unidade)
-- Ligando todos os 3 planos a todas as 12 unidades (N:N)
INSERT INTO Unidade_Planos (id_unidade, id_plano)
SELECT u.id_unidade, p.id_plano FROM Unidades u, Planos p;

-- 5. Clientes e Endereços Específicos
INSERT INTO Endereco (rua, numero, bairro, cidade, estado, cep) VALUES
('Rua Timbiras', '1500', 'Funcionários', 'Belo Horizonte', 'MG', '30140061'),
('Rua Padre Toledo', '50', 'Centro', 'Ouro Preto', 'MG', '36200022'),          
('Rua Augusta', '900', 'Consolação', 'São Paulo', 'SP', '01305000'),      
('Rua Marechal Deodoro', '300', 'Centro', 'Juiz de Fora', 'MG', '36013000');

INSERT INTO Clientes (cpf, nome, sexo, data_nasc, dia_pag, id_endereco, id_unidade) VALUES
('11122233344', 'João Silva', 'M', '1990-05-15', 10, 13, 1),
('22233344455', 'João Fiel', 'M', '1990-01-01', 5, 14, 1),
('33344455566', 'Maria Devedora', 'F', '1995-02-02', 10, 15, 2),
('44455566677', 'Pedro Mudança', 'M', '1988-03-03', 15, 16, 3);

-- 6. Telefones (Reais e Convencionais)
INSERT INTO Telefone (ddd, numero, tipo_telefone, id_cliente, id_unidade) VALUES
('031', '999887766', 'Celular', 1, NULL),
('031', '32221000', 'Comercial', NULL, 1),
('011', '988776655', 'Celular', 3, NULL),
('032', '32154000', 'Comercial', NULL, 3);

-- 7. Assinaturas (Via Procedure para testar o gatilho)
-- Cliente 1 e 2 na Unidade 1 (Plano 1 - Mensal)
CALL SP_gerar_assinatura(1, 1);
CALL SP_gerar_assinatura(1, 2);

-- Cliente 3 na Unidade 2 (Plano 1 - Mensal)
CALL SP_gerar_assinatura(1, 3);

-- Cliente 4 na Unidade 3 (Plano 1 - Mensal)
CALL SP_gerar_assinatura(1, 4);


/* Novos Inserts */

INSERT INTO Endereco (rua, numero, bairro, cidade, estado, cep) VALUES
('Rua da Bahia','1200','Centro','Belo Horizonte','MG','30160010'),
('Av. Afonso Pena','3500','Funcionários','Belo Horizonte','MG','30130008'),
('Rua Oscar Freire','850','Jardins','São Paulo','SP','01426001'),
('Rua Haddock Lobo','595','Cerqueira César','São Paulo','SP','01414001'),
('Av. Rio Branco','156','Centro','Rio de Janeiro','RJ','20040002'),
('Rua das Laranjeiras','220','Laranjeiras','Rio de Janeiro','RJ','22240003'),
('Rua Santa Rita','75','Centro','Ouro Preto','MG','35400000'),
('Rua Batista de Oliveira','900','Centro','Juiz de Fora','MG','36010010'),
('Av. Getúlio Vargas','400','Savassi','Belo Horizonte','MG','30112020'),
('Rua Alagoas','1300','Funcionários','Belo Horizonte','MG','30130160'),
('Av. Brigadeiro Faria Lima','2100','Itaim Bibi','São Paulo','SP','04538000'),
('Rua Vergueiro','1500','Paraíso','São Paulo','SP','04101000'),
('Av. Presidente Vargas','1000','Centro','Rio de Janeiro','RJ','20071004'),
('Rua do Catete','311','Catete','Rio de Janeiro','RJ','22220000'),
('Rua Espírito Santo','980','Centro','Belo Horizonte','MG','30160031'),
('Rua São Mateus','150','São Mateus','Juiz de Fora','MG','36025001');

INSERT INTO Clientes (cpf,nome,sexo,data_nasc,dia_pag,id_endereco,id_unidade) VALUES
('55511122233','Carlos Eduardo Souza','M','1989-04-10',5,17,1),
('55511122234','Fernanda Alves Pereira','F','1992-07-15',10,18,1),
('55511122235','Ricardo Martins','M','1985-02-20',15,19,2),
('55511122236','Juliana Castro','F','1998-11-05',10,20,2),
('55511122237','Marcos Vinicius Lima','M','1991-01-30',20,21,3),
('55511122238','Patricia Gomes Rocha','F','1993-03-12',5,22,4),
('55511122239','Lucas Henrique Melo','M','2000-06-18',10,23,5),
('55511122240','Camila Teixeira','F','1996-09-22',15,24,6),
('55511122241','Bruno Carvalho','M','1987-05-08',5,25,7),
('55511122242','Amanda Ribeiro','F','1995-08-17',10,26,8),
('55511122243','Rafael Batista','M','1990-10-03',15,27,9),
('55511122244','Larissa Fernandes','F','1999-12-11',20,28,10),
('55511122245','Thiago Moreira','M','1986-07-07',5,29,11),
('55511122246','Beatriz Monteiro','F','1997-04-19',10,30,12),
('55511122247','Felipe Nogueira','M','1994-01-25',15,31,3),
('55511122248','Daniela Pacheco','F','1992-06-09',10,32,4);

CALL SP_gerar_assinatura(1,5);
CALL SP_gerar_assinatura(2,6);
CALL SP_gerar_assinatura(1,7);
CALL SP_gerar_assinatura(3,8);
CALL SP_gerar_assinatura(1,9);
CALL SP_gerar_assinatura(2,10);
CALL SP_gerar_assinatura(1,11);
CALL SP_gerar_assinatura(3,12);
CALL SP_gerar_assinatura(2,13);
CALL SP_gerar_assinatura(1,14);
CALL SP_gerar_assinatura(1,15);
CALL SP_gerar_assinatura(2,16);
CALL SP_gerar_assinatura(3,17);
CALL SP_gerar_assinatura(1,18);
CALL SP_gerar_assinatura(2,19);
CALL SP_gerar_assinatura(3,20);

CALL SP_alterar_plano(2,3);
CALL SP_alterar_plano(3,5);
CALL SP_alterar_plano(1,7);

CALL SP_alterar_status_assinatura(4,'PAUSADA');
CALL SP_alterar_status_assinatura(6,'CANCELADA');
CALL SP_alterar_status_assinatura(8,'PAUSADA');

CALL SP_registrar_pagamento(1);
CALL SP_registrar_pagamento(2);
CALL SP_registrar_pagamento(3);
CALL SP_registrar_pagamento(4);

CALL SP_verificar_pag_pendente();


/* SIMULAÇÃO 6 MESES */

-- Janeiro
INSERT INTO Endereco (rua,numero,bairro,cidade,estado,cep) VALUES
('Rua Sergipe','700','Savassi','Belo Horizonte','MG','30130171'),
('Rua Bela Cintra','1200','Consolação','São Paulo','SP','01415002');

INSERT INTO Clientes (cpf,nome,sexo,data_nasc,dia_pag,id_endereco,id_unidade) VALUES
('55511122260','Gabriel Fernandes','M','1994-02-10',10,33,1),
('55511122261','Renata Carvalho','F','1991-05-22',15,34,2);

CALL SP_gerar_assinatura(1,21);
CALL SP_gerar_assinatura(2,22);

CALL SP_registrar_pagamento(5);
CALL SP_registrar_pagamento(6);

-- Fevereiro
CALL SP_alterar_plano(3,2);
CALL SP_alterar_plano(2,5);

INSERT INTO Endereco (rua,numero,bairro,cidade,estado,cep) VALUES
('Rua Amazonas','500','Centro','Belo Horizonte','MG','30180001');

INSERT INTO Clientes (cpf,nome,sexo,data_nasc,dia_pag,id_endereco,id_unidade) VALUES
('55511122262','Rodrigo Santana','M','1988-09-12',10,35,3);

CALL SP_gerar_assinatura(1,23);


-- Março
CALL SP_alterar_status_assinatura(3,'PAUSADA');
CALL SP_alterar_status_assinatura(7,'PAUSADA');

CALL SP_registrar_pagamento(7);
CALL SP_registrar_pagamento(8);

-- Abril
CALL SP_alterar_status_assinatura(5,'CANCELADA');

INSERT INTO Endereco (rua,numero,bairro,cidade,estado,cep) VALUES
('Rua Padre Eustáquio','210','Padre Eustáquio','Belo Horizonte','MG','30720100');

INSERT INTO Clientes (cpf,nome,sexo,data_nasc,dia_pag,id_endereco,id_unidade) VALUES
('55511122263','Julio Cesar Oliveira','M','1987-04-15',20,36,4);

CALL SP_gerar_assinatura(2,24);

-- Maio
CALL SP_alterar_plano(3,9);
CALL SP_alterar_plano(2,10);

CALL SP_registrar_pagamento(9);
CALL SP_registrar_pagamento(10);

-- Junho
CALL SP_verificar_pag_pendente();