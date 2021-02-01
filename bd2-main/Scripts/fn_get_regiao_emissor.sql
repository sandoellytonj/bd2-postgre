CREATE OR REPLACE FUNCTION get_regiao_emissor(numero varchar(11))
RETURNS integer
AS $$
DECLARE
	regiao_emissor integer;
BEGIN
	SELECT es.idregiao INTO regiao_emissor
	FROM ligacao li JOIN estado es ON es.uf = li.uforigem
	WHERE li.chip_emissor = numero;
	RETURN regiao_emissor;
END $$
LANGUAGE plpgsql;