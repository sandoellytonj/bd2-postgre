--Verifica os requisitos de cliente e chip antes de fazer a associação entre eles e inserir na tabela cliente_chip
CREATE OR REPLACE FUNCTION verifica_insert_cliente_chip()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	--Verifica se o número é valido, ou seja, está disponível S e é Ativo S
	IF (SELECT idnumero FROM chip WHERE (idnumero = NEW.idnumero 
				AND ativo = 'S' AND disponivel = 'S' )) IS NULL THEN
		RAISE NOTICE 'Número emissor % indisponivel e/ou inativo', NEW.idnumero;
		RAISE EXCEPTION '%', 'Numero invalido' USING ERRCODE = 22023;
	END IF;
	
	--Verifica se o cliente está com o cadastro ativo dentro do banco de dados
	IF (SELECT idcliente FROM cliente WHERE idcliente = NEW.idcliente AND cancelado = 'N') IS NULL THEN
		RAISE NOTICE 'Cliente com cadastro cancelado';
		RAISE EXCEPTION '%', 'Cliente Cancelado' USING ERRCODE = 22023;
	END IF;
	
	RETURN NEW;
END $$;

--Trigger para função antes de inserir em cliente_chip
CREATE TRIGGER validar_insert_cliente_tg
BEFORE INSERT ON cliente_chip
FOR EACH ROW
EXECUTE PROCEDURE verifica_insert_cliente_chip()

