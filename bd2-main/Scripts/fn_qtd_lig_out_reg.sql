-- Função auxiliar de fatura para ver a quantidade de ligações para fora da região do emissor
CREATE OR REPLACE FUNCTION get_qnt_regiao_diferente(numero varchar(11))
RETURNS bigint
AS $$
DECLARE
	 qnt_mesma_regiao bigint;
	 qnt_total_ligacoes bigint;
	 qnt_regiao_diferente bigint;
BEGIN
	--Número de ligações dentro da mesma região
	SELECT COUNT(li.chip_receptor) INTO qnt_mesma_regiao
	FROM ligacao li JOIN estado es ON es.uf = li.ufdestino
	WHERE get_regiao_emissor(numero) = es.idregiao
 	GROUP BY es.idregiao;
	
	--Número de ligações no total
	SELECT COUNT(chip_emissor) INTO qnt_total_ligacoes
	FROM ligacao
	WHERE chip_emissor = numero;
	
	--A diferença entre o número total de ligações e as ligações pra mesma região é o número de ligações para fora da região
	qnt_regiao_diferente := qnt_total_ligacoes - qnt_mesma_regiao;
	
	RETURN qnt_regiao_diferente;
END $$
LANGUAGE plpgsql;

