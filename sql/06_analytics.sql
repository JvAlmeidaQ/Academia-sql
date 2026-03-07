USE Academia_FitFlow;

/*Nível 1: Operacional (Básico)*/

-- 1. Relatório de Clientes por Região
SELECT C.nome, E.cidade, E.bairro
FROM Clientes C
INNER JOIN Endereco E
    ON C.id_endereco = E.id_endereco
WHERE C.status = 'Ativo'
ORDER BY E.cidade;

-- 2. Visão de Receita de Curto Prazo
SELECT F.status, F.valor_fatura, F.data_venc
FROM Faturas F
WHERE F.status = 'Pendente'
    AND F.data_venc BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY data_venc;

-- 3. Clientes que estão com faturas para vencer nos proximos dias
SELECT 
    C.nome,
    U.nome_unidade,
    P.nome_plano,
    F.status, F.valor_fatura, F.data_venc
FROM Faturas F
INNER JOIN Assinaturas A
    ON F.id_assinatura = A.id_assinatura
INNER JOIN Clientes C 
    ON C.id_cliente = A.id_cliente
INNER JOIN Unidades U
    ON U.id_unidade = C.id_unidade
INNER JOIN Planos P
    ON P.id_plano = A.id_plano
WHERE 
    F.data_venc BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
    AND 
    F.status = 'Pendente'
ORDER BY data_venc;

/* Nível 2: Gerencial (Intermediário) */

-- 1. Performance por Unidade
SELECT 
    U.nome_unidade AS 'Unidades',
    SUM(F.valor_fatura) AS 'Valores Pago'
FROM Faturas F
INNER JOIN Assinaturas A
    ON A.id_assinatura = F.id_assinatura
INNER JOIN Clientes C
    ON C.id_cliente = A.id_cliente
INNER JOIN Unidades U 
    ON U.id_unidade = C.id_unidade
WHERE F.status = 'Pago'
GROUP BY(U.nome_unidade);

-- 2. Popularidade de Planos

SELECT 
    P.nome_plano, P.valor_mensal,
    COUNT(A.id_assinatura) AS 'QTD.Assinaturas por Plano'
FROM Planos P
INNER JOIN Assinaturas A
    ON A.id_plano = P.id_plano
WHERE A.status IN ('ATIVA','PAUSADA')
GROUP BY(P.id_plano);

-- 3. Inadimplência Relativa
SELECT 
    U.nome_unidade AS 'Unidades',
    SUM(CASE WHEN F.status = 'Atrasado' THEN 1 ELSE 0 END) * 1.0 
        /COUNT(F.id_assinatura) 
            AS 'Taxa de Inadimplencia'
FROM Faturas F
INNER JOIN Assinaturas A
    ON A.id_assinatura = F.id_assinatura
INNER JOIN Clientes C
    ON C.id_cliente = A.id_cliente
INNER JOIN Unidades U 
    ON U.id_unidade = C.id_unidade
GROUP BY(U.nome_unidade);

/* Nível 3: Avançado (Visão Estratégica) */

-- 1. Análise de Fidelidade (Churn Rate)

SELECT 
    P.nome_plano,
    AVG(DATEDIFF(A.data_fim,A.data_inicio))
FROM Assinaturas A 
INNER JOIN Planos P
    ON A.id_plano = P.id_plano
WHERE A.status = 'CANCELADA'
GROUP BY (P.nome_plano);

-- 2. Segmentação de Clientes "VIPs"
SELECT * FROM (
    SELECT 
        C.id_cliente,
        C.nome,
        SUM(F.valor_fatura) AS 'Valor Gasto',
        NTILE(10) OVER (ORDER BY SUM(F.valor_fatura) DESC) AS Porcentagem
    FROM Clientes C
    INNER JOIN Assinaturas A 
        ON A.id_cliente = C.id_cliente
    INNER JOIN Faturas F 
        ON F.id_assinatura = A.id_assinatura 
    WHERE C.status = 'Ativo'
      AND A.status IN ('ATIVA','PAUSADA')
    GROUP BY C.id_cliente, C.nome
) AS Ranking_VIP
WHERE Porcentagem = 1;


-- 3. Dashboard Executivo (View)
DROP VIEW IF EXISTS VW_Detalhes_Operacionais;
CREATE VIEW VW_Detalhes_Operacionais AS
SELECT
        C.nome,
        C.status AS status_cliente,
        T.numero,
        A.data_fim,
        F.valor_fatura,
        F.status AS status_fatura,
        H.desc_mudanca
FROM Clientes C
INNER JOIN Telefone T
    ON T.id_cliente = C.id_cliente
INNER JOIN Assinaturas A
    ON A.id_cliente = C.id_cliente
INNER JOIN Faturas F
    ON F.id_assinatura = A.id_assinatura
INNER JOIN Historico H
    ON H.id_assinatura = A.id_assinatura
WHERE C.status = 'Ativo'
      AND A.status IN ('ATIVA','PAUSADA') 
      OR (A.status = 'CANCELADA' AND A.data_fim >= DATE_SUB(CURDATE(), INTERVAL 30 DAY));

DROP VIEW IF EXISTS VW_Dashboard;
CREATE VIEW VW_Dashboard AS
SELECT 
        U.nome_unidade,
        SUM(CASE WHEN F.status = 'Pago' THEN F.valor_fatura ELSE 0 END) AS faturamento_total,

        COUNT(CASE WHEN A.data_inicio >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) AS novas_assinaturas,

        COUNT(CASE WHEN A.status = 'CANCELADA' AND A.data_fim >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) AS assinaturas_canceladas
FROM Unidades U
INNER JOIN Clientes C
    ON C.id_unidade = U.id_unidade
INNER JOIN Assinaturas A 
    ON A.id_cliente = C.id_cliente
INNER JOIN Faturas F 
    ON F.id_assinatura = A.id_assinatura
GROUP BY U.nome_unidade;


/* Querys de Historico */

SELECT
        H.plano_antigo,
        H.plano_novo,
        H.desc_mudanca,