SET GLOBAL event_scheduler = ON;

USE Academia_FitFlow;

CREATE EVENT IF NOT EXISTS EV_verificar_faturas_atrasadas
ON SCHEDULE EVERY 1 DAY
STARTS '2026-03-04 06:00:00' 
DO
  CALL SP_verificar_pag_pendente();