-- Função auxiliar de fatura para gerar min_out
CREATE OR REPLACE FUNCTION gerar_t_min_in(numero varchar(11))
RETURNS bigint
AS $$
DECLARE
	op_igual bigint;
BEGIN
	SELECT FLOOR (EXTRACT (EPOCH FROM date_trunc('second', SUM(duracao)))/60)::bigint t_min_in INTO op_igual
	FROM ligacao
 	WHERE SUBSTRING (chip_emissor FROM 4 FOR 2) = SUBSTRING (chip_receptor FROM 4 FOR 2) AND chip_emissor = numero
	GROUP BY chip_emissor;
	IF op_igual IS NULL THEN
		op_igual := 0;
	END IF;
	RETURN op_igual;
END $$
LANGUAGE plpgsql;
