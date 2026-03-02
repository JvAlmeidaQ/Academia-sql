USE Academia_FitFlow;

/* --------- Adicionando as PK ----- */

ALTER TABLE Endereco
ADD CONSTRAINT PK_Endereco
PRIMARY KEY(id_endereco);

ALTER TABLE Endereco
MODIFY COLUMN id_endereco INT AUTO_INCREMENT UNIQUE;

ALTER TABLE Unidades
ADD CONSTRAINT PK_Unidades
PRIMARY KEY(id_unidade);

ALTER TABLE Unidades
MODIFY COLUMN id_unidade INT AUTO_INCREMENT UNIQUE;

ALTER TABLE Clientes
ADD CONSTRAINT PK_Clientes
PRIMARY KEY(id_cliente);

ALTER TABLE Clientes
MODIFY COLUMN id_cliente INT AUTO_INCREMENT UNIQUE;

ALTER TABLE Planos
ADD CONSTRAINT PK_Planos
PRIMARY KEY(id_plano);

ALTER TABLE Planos
MODIFY COLUMN id_plano INT AUTO_INCREMENT UNIQUE;

ALTER TABLE Assinaturas
ADD CONSTRAINT PK_Assinaturas
PRIMARY KEY(id_assinatura );

ALTER TABLE Assinaturas
MODIFY COLUMN id_assinatura  INT AUTO_INCREMENT UNIQUE;

ALTER TABLE Faturas
ADD CONSTRAINT PK_Faturas
PRIMARY KEY(id_fatura);

ALTER TABLE Faturas
MODIFY COLUMN id_fatura  INT AUTO_INCREMENT UNIQUE;

ALTER TABLE Historico
ADD CONSTRAINT PK_Historico
PRIMARY KEY(id_historico);

ALTER TABLE Historico
MODIFY COLUMN id_historico  INT AUTO_INCREMENT UNIQUE;

/* --------- Adicionando as Futuras FK ----- */

ALTER TABLE Unidades
ADD COLUMN id_endereco INT NOT NULL UNIQUE;

ALTER TABLE Clientes
ADD COLUMN id_endereco INT NOT NULL UNIQUE;

ALTER TABLE Clientes
ADD COLUMN id_unidade INT NOT NULL;

ALTER TABLE Planos
ADD COLUMN id_unidade INT NOT NULL;

ALTER TABLE Historico
ADD COLUMN id_plano INT NOT NULL;

ALTER TABLE Historico
ADD COLUMN id_cliente INT NOT NULL;

ALTER TABLE Assinaturas
ADD COLUMN id_plano INT NOT NULL;

ALTER TABLE Assinaturas
ADD COLUMN id_cliente INT NOT NULL;

ALTER TABLE Faturas
ADD COLUMN id_assinatura INT NOT NULL;

/* --------- Adicionando as Constraints FK ---------- */
ALTER TABLE Unidades
ADD CONSTRAINT FK_Endereco_Unidades
FOREIGN KEY(id_endereco) REFERENCES Endereco(id_endereco);

ALTER TABLE Clientes
ADD CONSTRAINT FK_Endereco_Clientes
FOREIGN KEY(id_endereco) REFERENCES Endereco(id_endereco);

ALTER TABLE Clientes
ADD CONSTRAINT FK_Unidades_Clientes
FOREIGN KEY(id_unidade) REFERENCES Unidades(id_unidade);

ALTER TABLE Planos
ADD CONSTRAINT FK_Unidades_Planos
FOREIGN KEY(id_unidade) REFERENCES Unidades(id_unidade);

ALTER TABLE Historico
ADD CONSTRAINT FK_Planos_Historico
FOREIGN KEY(id_plano) REFERENCES Planos(id_plano);

ALTER TABLE Historico
ADD CONSTRAINT FK_Cliente_Historico
FOREIGN KEY(id_cliente) REFERENCES Clientes(id_cliente);

ALTER TABLE Assinaturas
ADD CONSTRAINT FK_Planos_Assinaturas
FOREIGN KEY(id_plano) REFERENCES Planos(id_plano);

ALTER TABLE Assinaturas
ADD CONSTRAINT FK_Cliente_Assinaturas
FOREIGN KEY(id_cliente) REFERENCES Clientes(id_cliente);

ALTER TABLE Faturas
ADD CONSTRAINT FK_Assinaturas_Faturas
FOREIGN KEY(id_assinatura) REFERENCES Assinaturas(id_assinatura);