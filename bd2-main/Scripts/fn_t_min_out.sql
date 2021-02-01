--Função auxiliar de fatura para mostrar os minutos de ligação para operadora diferente
CREATE OR REPLACE FUNCTION gerar_t_min_out(numero varchar(11))
RETURNS bigint
AS $$
DECLARE
	op_diferente bigint;
BEGIN
	--conveter o intervalo de duração da chamada para minutos
	SELECT FLOOR (EXTRACT (EPOCH FROM date_trunc('second', SUM(duracao)))/60)::bigint t_min_out INTO op_diferente
	FROM ligacao
	--garante que sejam de operadoras diferentes
 	WHERE SUBSTRING (chip_emissor FROM 4 FOR 2) != SUBSTRING (chip_receptor FROM 4 FOR 2) AND chip_emissor = numero
	GROUP BY chip_emissor;
	--caso não tenha ligado, é atribuído o número zero
	IF op_diferente IS NULL THEN
		op_diferente := 0;
	END IF;
	RETURN op_diferente;
END $$
LANGUAGE plpgsql;

