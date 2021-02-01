CREATE OR REPLACE FUNCTION cancela_cadastro()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE cont integer;
DECLARE zero integer := 0;
BEGIN
	-- Retorna a quantidade de chips que o cliente possui
	SELECT COUNT(idnumero) FROM cliente_chip WHERE idcliente = NEW.idcliente INTO cont;
	-- Altera todos os chips que era do cliente para disponíveis
	WHILE zero != cont LOOP
		UPDATE chip SET disponivel = 'S' WHERE idnumero = (SELECT idnumero
														   FROM cliente_chip 
												 		   WHERE NEW.idcliente = idcliente
														   LIMIT 1);
		cont := cont - 1;
	END LOOP;
	
	-- Exclui da tabela cliente_chip o cliente com cadastro cancelado
	DELETE FROM cliente_chip WHERE idcliente = NEW.idcliente;
	RETURN NEW;
END $$;

--Trigger
CREATE TRIGGER cancela_cadastro_tg
AFTER UPDATE OF cancelado ON cliente
FOR EACH ROW
EXECUTE PROCEDURE cancela_cadastro()

