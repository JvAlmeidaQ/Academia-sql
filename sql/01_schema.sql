CREATE DATABASE Academia_FitFlow;

USE Academia_FitFlow;

CREATE TABLE Endereco(
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

CREATE TABLE Unidades(
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

CREATE TABLE Clientes(
    id_cliente INT AUTO_INCREMENT,
    cpf CHAR(11) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM('M','F') NOT NULL,
    data_nasc DATE NOT NULL,
    dia_pag INT NOT NULL,
    id_endereco INT NOT NULL UNIQUE,
    id_unidade INT NOT NULL,

    CONSTRAINT PK_Clientes PRIMARY KEY(id_cliente),

    CONSTRAINT FK_Endereco_Clientes
    FOREIGN KEY(id_endereco) REFERENCES Endereco(id_endereco),

    CONSTRAINT FK_Unidades_Clientes
    FOREIGN KEY(id_unidade) REFERENCES Unidades(id_unidade)
);

CREATE TABLE Planos(
    id_plano INT AUTO_INCREMENT,
    nome_plano VARCHAR(50) NOT NULL,
    duracao_plano INT NOT NULL,
    valor_mensal DECIMAL(10,2) NOT NULL,
    id_unidade INT NOT NULL,

    CONSTRAINT PK_Planos PRIMARY KEY(id_plano),

    CONSTRAINT FK_Unidades_Planos
    FOREIGN KEY(id_unidade) REFERENCES Unidades(id_unidade),

    CONSTRAINT CHK_preco_plano CHECK (valor_mensal > 0)
);

CREATE TABLE Assinaturas(
    id_assinatura INT AUTO_INCREMENT,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL, 
    status ENUM('ATIVA','CANCELADA','PAUSADA') DEFAULT 'ATIVA' NOT NULL,
    id_plano INT NOT NULL,
    id_cliente INT NOT NULL,

    CONSTRAINT PK_Assinaturas PRIMARY KEY(id_assinatura ),

    CONSTRAINT FK_Planos_Assinaturas
    FOREIGN KEY(id_plano) REFERENCES Planos(id_plano),

    CONSTRAINT FK_Cliente_Assinaturas
    FOREIGN KEY(id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Faturas(
    id_fatura INT AUTO_INCREMENT ,
    valor_fatura DECIMAL(10,2) NOT NULL,
    data_venc DATE NOT NULL,
    status ENUM('Pendente', 'Pago', 'Atrasado') DEFAULT 'Pendente' NOT NULL,
    id_assinatura INT NOT NULL,

    CONSTRAINT PK_Faturas PRIMARY KEY(id_fatura),

    CONSTRAINT FK_Assinaturas_Faturas
    FOREIGN KEY(id_assinatura) REFERENCES Assinaturas(id_assinatura)
);

CREATE TABLE Historico(
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