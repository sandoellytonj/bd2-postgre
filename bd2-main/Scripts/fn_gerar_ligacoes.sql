-- Função para gerar ligações entre os chips ativos
-- Recebe uma data e o chip emissor
CREATE OR REPLACE FUNCTION gerar_ligacoes(dataLigacao timestamp, chip_emissor varchar(11))
RETURNS VOID
AS $$
DECLARE
	random_int integer;
	chip_receptor varchar(11);
	uf_origem char(2);
	uf_destino char(2);
	data_gerada timestamp;
	mes varchar(20);
	dias double precision;
	ano varchar(4);
	data_gerada2 timestamp;
BEGIN
	-- Select para verificar o número de dias de determinado mês
	SELECT  
		DATE_PART('days', 
			DATE_TRUNC('month', dataLigacao::timestamp) 
			+ '1 MONTH'::INTERVAL 
			- '1 DAY'::INTERVAL
		) INTO dias;
	-- Retorna o número do mês
	SELECT SUBSTRING (dataLigacao::varchar FROM 6 FOR 2) INTO mes;
	-- Retorna o ano
	SELECT SUBSTRING (dataLigacao::varchar FROM 1 FOR 4) INTO ano;
	-- Retorna a uf baseado no DDD do emissor
	SELECT uf FROM estado WHERE ddd = SUBSTRING (chip_emissor FROM 1 FOR 2)::int INTO uf_origem;
 	
	-- Percorre todos os dias do mês
	FOR dias_i in 1..dias LOOP
		--Data que varia ao longo do mês
		data_gerada := (ano||'-'||mes||'-'||dias_i)::timestamp;
		--Número aleatório de ligações no dia
		random_int := random() * 9::int + 1;
		--For para gerar as ligações do dia
		FOR ligacao_i in 1..random_int LOOP
			--Seleciona um chip receptor aleatoriamente
			SELECT idnumero FROM cliente_chip WHERE idnumero != chip_emissor ORDER BY RANDOM()  LIMIT 1 INTO chip_receptor;
			--Seleciona a uf de destino com base no DDD do chip receptor
			SELECT uf FROM estado WHERE ddd = SUBSTRING (chip_receptor FROM 1 FOR 2)::int INTO uf_destino;
			--Define um horário único para cada ligação
			SELECT data_gerada + (ligacao_i * interval '1 hour') + (ligacao_i * interval '20 second') INTO data_gerada2;
			--Insere na tabela
			INSERT INTO ligacao VALUES (date_trunc('second',data_gerada2), chip_emissor, uf_origem, 
									chip_receptor, uf_destino, date_trunc('second', random()*interval '1 HOUR'));
		END LOOP;
	END LOOP;
END $$
LANGUAGE plpgsql;


