--Função auxiliar de fatura para pegar o valor da taxa de roaming
CREATE OR REPLACE FUNCTION get_tx_roaming(numPlano int)
RETURNS numeric
AS $$
DECLARE
valor_roaming numeric;
BEGIN
	SELECT ta.valor
	FROM plano_tarifa pt JOIN tarifa ta ON ta.idtarifa = pt.idtarifa INTO valor_roaming
	--As tarifas com ID ímpar é tarifa de minuto excedente, se for par é relativa a roaming
	WHERE pt.idplano = numPlano AND ta.idtarifa % 2 = 0;
	RETURN valor_roaming;
END $$
LANGUAGE plpgsql;
