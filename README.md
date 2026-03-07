# FitFlow Management System 🏋️‍♂️

**FitFlow** é um sistema de banco de dados projetado para simular o gerenciamento completo de uma rede de academias.

O projeto foi desenvolvido utilizando **MySQL** focando em **modelagem relacional normalizada, automação de processos financeiros e análise de dados**.

Entre os recursos implementados estão **assinaturas recorrentes, Linha do Tempo automática de alterações e consultas para vizualização do negócio**.

---

# 🎯 Objetivo do Projeto

Este projeto foi criado para consolidar conhecimentos em:

* Modelagem de dados relacional
* SQL
* Automação com **Triggers** e **Stored Procedures**
* Agendamento de tarefas com **Event Scheduler**
* Construção de métricas de negócio utilizando **consultas analíticas**

A arquitetura foi projetada seguindo as **Três Formas Normais (3NF)** para garantir consistência e integridade dos dados.

---

# 🚀 Funcionalidades Principais

### 🧾 Gestão de Assinaturas

* Criação e gerenciamento de planos de academia
* Associação de clientes a assinaturas
* Controle de status de assinatura

### 🔄 Recorrência Financeira

* Geração automática de faturas mensais utilizando **Triggers**
* Controle de pagamentos e inadimplência

### 📜 Auditoria de Alterações

Sistema automático de histórico que registra:

* Mudanças de plano
* Alterações de status de assinatura
* Linha do tempo de relacionamento do cliente com a academia

### 📊 Business Intelligence (SQL Analytics)

O banco inclui **consultas analíticas prontas** para geração de insights como:

* faturamento por unidade
* popularidade de planos
* 
---

# 🛠️ Tecnologias Utilizadas

* **MySQL 8+**
* SQL (DDL, DML)
* **Triggers**
* **Stored Procedures**
* **Event Scheduler**
* **Views**
* **Window Functions**
* Modelagem relacional (3NF)

---

# 🏗️ Arquitetura do Projeto

O projeto é modular e organizado em scripts SQL independentes.

```
sql/
 ├── 01_schema.sql
 ├── 02_triggers.sql
 ├── 03_procedures.sql
 ├── 04_events_jobs.sql
 ├── 05_seed.sql
 └── 06_analytics.sql
```

Descrição dos arquivos:

| Arquivo              | Função                                   |
| -------------------- | ---------------------------------------- |
| `01_schema.sql`      | Estrutura do banco e criação das tabelas |
| `02_triggers.sql`    | Automação de faturamento e auditoria     |
| `03_procedures.sql`  | Lógicas de negócio                       |
| `04_events_jobs.sql` | Tarefas agendadas                        |
| `05_seed.sql`        | Dados simulados para testes              |
| `06_analytics.sql`   | Consultas analíticas                     |

Um script principal (`Main.sql`) executa todos os arquivos e reconstrói o ambiente completo.

---

# 🧠 Modelagem de Dados

O modelo relacional foi projetado para representar o funcionamento de uma rede de academias.

Principais entidades do sistema:

* **Clientes**
* **Unidades**
* **Planos**
* **Assinaturas**
* **Faturas**
* **Histórico de Alterações**

Regras importantes da modelagem:

* Cada **cliente pertence a uma unidade**
* Uma **assinatura conecta cliente e plano**
* **Faturas** são geradas a partir de assinaturas
* Todas as mudanças relevantes são registradas na tabela de **histórico**

O DER completo está disponível em:

```
docs/ERD_Academia_FitFlow.jpg
```

---

# 📊 Business Intelligence (SQL Analytics)

As consultas analíticas do projeto são organizadas em três níveis de análise.

| Nível       | Objetivo                | Exemplos                             |
| ----------- | ----------------------- | ------------------------------------ |
| Operacional | Monitoramento diário    | clientes ativos, faturas a vencer    |
| Gerencial   | Performance da academia | faturamento por unidade              |
| Estratégico | Tomada de decisão       | churn rate e segmentação de clientes |

---

# 📈 Exemplo de Query Analítica

Cálculo de faturamento total por unidade:

```sql
SELECT 
    unidade_id,
    SUM(valor_pago) AS faturamento_total
FROM faturas
WHERE status = 'PAGA'
GROUP BY unidade_id;
```

Exemplo de segmentação de clientes usando **Window Functions**:

```sql
SELECT 
    cliente_id,
    SUM(valor_pago) AS receita_total,
    NTILE(10) OVER (ORDER BY SUM(valor_pago) DESC) AS segmento
FROM faturas
GROUP BY cliente_id;
```

---

# 🚀 Como Executar o Projeto

Certifique-se de possuir um servidor **MySQL ou MariaDB** em execução.

Execute o script principal:

```sql
SOURCE Main.sql;
```

Esse comando irá:

1. Criar todas as tabelas
2. Configurar triggers e procedures
3. Inserir dados de teste
4. Criar as views e executar as Queries de analytics

---

Projeto desenvolvido para fins educacionais.
