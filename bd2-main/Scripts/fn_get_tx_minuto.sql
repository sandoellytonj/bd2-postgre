-- Função auxiliar de fatura para pegar o vaor da taxa de minutos excedentes 
CREATE OR REPLACE FUNCTION get_tx_minuto_ex(numPlano int)
RETURNS numeric
AS $$
DECLARE valor_minuto numeric;
BEGIN
	SELECT ta.valor
	FROM plano_tarifa pt JOIN tarifa ta ON ta.idtarifa = pt.idtarifa INTO valor_minuto
	-- As tarifas com ID ímpar é tarifa de minuto excedente, se for par é relativa a roaming
	WHERE pt.idplano = 1 AND ta.idtarifa % 2 != 0;
	RETURN valor_minuto;
END $$
LANGUAGE plpgsql;

