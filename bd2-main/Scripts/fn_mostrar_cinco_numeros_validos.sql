--Função para mostrar ao cliente até 5 números válidos para ele escolher
CREATE OR REPLACE FUNCTION mostrar_numeros(ddd char(2), operadora int)
RETURNS TABLE(idnumero char(11), idplano integer, descricao varchar(50))
AS $$
BEGIN
	RETURN QUERY SELECT c.idnumero Numero, p.idplano Plano, p.descricao Descricao 
	FROM chip c JOIN plano p ON c.idplano = p.idplano
	WHERE SUBSTRING (c.idnumero FROM 1 FOR 2) = ddd AND c.idoperadora = operadora 
	AND c.disponivel = 'S' AND c.ativo = 'S' --É preciso que o chip esteja disponível e em funcionamento
	LIMIT 5;
END $$
LANGUAGE plpgsql;
