CREATE DATABASE Academia_FitFlow;

USE Academia_FitFlow;

CREATE TABLE IF NOT EXISTS Endereco(
    id_endereco INT AUTO_INCREMENT,
    rua VARCHAR(30) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(30) NOT NULL,
    cidade VARCHAR(30) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    complemento VARCHAR(30),

    CONSTRAINT PK_Endereco PRIMARY KEY(id_endereco)
);

CREATE TABLE IF NOT EXISTS Unidades(
    id_unidade INT AUTO_INCREMENT,
    cnpj CHAR(14) NOT NULL UNIQUE,
    nome_unidade VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    id_endereco INT NOT NULL UNIQUE,

    CONSTRAINT PK_Unidades PRIMARY KEY(id_unidade),

    CONSTRAINT FK_Endereco_Unidades
    FOREIGN KEY(id_endereco) REFERENCES Endereco(id_endereco),

    CONSTRAINT CK_tam_cnpj CHECK (LENGTH(cnpj) = 14)
);

CREATE TABLE IF NOT EXISTS Clientes(
    id_cliente INT AUTO_INCREMENT,
    cpf CHAR(11) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM('M','F') NOT NULL,
    data_nasc DATE NOT NULL,
    dia_pag INT NOT NULL,
    status ENUM('Ativo','Inativo','Bloqueado','Prospect') DEFAULT 'Prospect',
    id_endereco INT NOT NULL UNIQUE,
    id_unidade INT NOT NULL,

    CONSTRAINT PK_Clientes PRIMARY KEY(id_cliente),

    CONSTRAINT FK_Endereco_Clientes
    FOREIGN KEY(id_endereco) REFERENCES Endereco(id_endereco),

    CONSTRAINT FK_Unidades_Clientes
    FOREIGN KEY(id_unidade) REFERENCES Unidades(id_unidade)
);

CREATE TABLE IF NOT EXISTS Telefone(
    id_telefone INT AUTO_INCREMENT,
    ddd CHAR(3) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    tipo_telefone ENUM('Comercial','Celular','Residencial') NOT NULL,
    id_cliente INT,
    id_unidade INT,

    CONSTRAINT PK_Telefone PRIMARY KEY(id_telefone),

    CONSTRAINT FK_Unidade_Telefone
    FOREIGN KEY(id_unidade) REFERENCES Unidades(id_unidade),

    CONSTRAINT FK_Cliente_Telefone
    FOREIGN KEY(id_cliente) REFERENCES Clientes(id_cliente),

    CONSTRAINT CK_tam_ddd CHECK (LENGTH(ddd) > 2),
    CONSTRAINT CK_tam_numero CHECK (LENGTH(numero) >= 8)
);

CREATE TABLE IF NOT EXISTS Planos(
    id_plano INT AUTO_INCREMENT,
    nome_plano VARCHAR(50) NOT NULL,
    duracao_plano INT NOT NULL,
    valor_mensal DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Planos PRIMARY KEY(id_plano),

    CONSTRAINT CHK_preco_plano CHECK (valor_mensal > 0)
);

CREATE TABLE IF NOT EXISTS Unidade_Planos(
    id_unidade INT NOT NULL,
    id_plano INT NOT NULL,

    CONSTRAINT PK_Unidade_Plano PRIMARY KEY(id_unidade,id_plano),

    CONSTRAINT FK_Unidade_Link FOREIGN KEY (id_unidade) REFERENCES Unidades(id_unidade),
    CONSTRAINT FK_Plano_Link FOREIGN KEY (id_plano) REFERENCES Planos(id_plano)
);

CREATE TABLE IF NOT EXISTS Assinaturas(
    id_assinatura INT AUTO_INCREMENT,
    data_inicio DATE NOT NULL,
    data_fim DATE, 
    status ENUM('ATIVA','CANCELADA','PAUSADA') DEFAULT 'ATIVA' NOT NULL,
    id_plano INT NOT NULL,
    id_cliente INT NOT NULL,

    CONSTRAINT PK_Assinaturas PRIMARY KEY(id_assinatura ),

    CONSTRAINT FK_Planos_Assinaturas
    FOREIGN KEY(id_plano) REFERENCES Planos(id_plano),

    CONSTRAINT FK_Cliente_Assinaturas
    FOREIGN KEY(id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE IF NOT EXISTS Faturas(
    id_fatura INT AUTO_INCREMENT ,
    valor_fatura DECIMAL(10,2) NOT NULL,
    data_venc DATE NOT NULL,
    status ENUM('Pendente', 'Pago', 'Atrasado') DEFAULT 'Pendente' NOT NULL,
    id_assinatura INT NOT NULL,

    CONSTRAINT PK_Faturas PRIMARY KEY(id_fatura),

    CONSTRAINT FK_Assinaturas_Faturas
    FOREIGN KEY(id_assinatura) REFERENCES Assinaturas(id_assinatura)
);

CREATE TABLE IF NOT EXISTS Historico(
    id_historico INT AUTO_INCREMENT,
    desc_mudanca VARCHAR(255) NOT NULL,
    valor_antigo DECIMAL(10,2) NOT NULL,
    valor_novo DECIMAL(10,2) NOT NULL,
    plano_antigo VARCHAR(100) NOT NULL,
    plano_novo VARCHAR(100) NOT NULL,
    id_plano INT NOT NULL,
    id_cliente INT NOT NULL,
    id_assinatura INT NULL,

    CONSTRAINT PK_Historico PRIMARY KEY(id_historico),

    CONSTRAINT FK_Planos_Historico
    FOREIGN KEY(id_plano) REFERENCES Planos(id_plano),

    CONSTRAINT FK_Cliente_Historico
    FOREIGN KEY(id_cliente) REFERENCES Clientes(id_cliente),

    CONSTRAINT FK_Assinatura_Historico
    FOREIGN KEY(id_assinatura) REFERENCES Assinaturas(id_assinatura)
);

CREATE TABLE IF NOT EXISTS Log_Erros (
    id_log_erro INT AUTO_INCREMENT PRIMARY KEY,
    origem VARCHAR(100) NOT NULL,
    sql_state CHAR(5),
    errno INT,
    mensagem_erro TEXT,
    data_erro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Log_Eventos(
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    evento VARCHAR(100) NOT NULL,
    detalhes VARCHAR(100) NOT NULL,
    data_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);