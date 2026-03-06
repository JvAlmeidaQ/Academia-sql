DROP DATABASE IF EXISTS Academia_FitFlow;
CREATE DATABASE Academia_FitFlow;
USE Academia_FitFlow;

-- 2. DDL - Tabelas
SOURCE 01_schema.sql; 

-- 3. (Procedures e Triggers)
SOURCE 02_triggers.sql;

SOURCE 03_procedures.sql;

-- 4. Eventos
SOURCE 04_events_jobs.sql;

-- 5. DML - Dados iniciais (Seeds)
SOURCE 05_seed.sql;

-- 6. Query's
SOURCE 06_analytics.sql;