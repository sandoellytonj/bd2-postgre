--Verifica se é possível realizar a ligação
CREATE OR REPLACE FUNCTION validar_ligacao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	-- Verifica se o número emissor é ativo e indisponível (pertence a um cliente)
	IF (SELECT idnumero FROM chip WHERE (idnumero = NEW.chip_emissor 
				AND ativo = 'S' AND disponivel = 'N' )) IS NULL THEN
		RAISE NOTICE 'Número emissor % indisponivel e/ou inativo', NEW.chip_emissor;
		RAISE EXCEPTION '%', 'Numero invalido' USING ERRCODE = 22023; 
	END IF;
	
	-- Verifica se o número receptor é ativo e indisponível (pertence a um cliente)
	IF (SELECT idnumero FROM chip WHERE (idnumero = NEW.chip_receptor
				AND ativo = 'S' AND disponivel = 'N' )) IS NULL THEN
		RAISE NOTICE 'Número receptor % indisponivel e/ou inativo', NEW.chip_receptor;
		RAISE EXCEPTION '%', 'Numero invalido' USING ERRCODE = 22023; 
	END IF;
	
	-- Verifica se o receptor e emissores são diferentes
	IF (SELECT idnumero FROM chip WHERE NEW.chip_emissor = NEW.chip_receptor LIMIT 1) IS NOT NULL THEN
		RAISE NOTICE 'Emissor e receptor necessitam ser diferentes';
		RAISE EXCEPTION '%', 'Numero invalido' USING ERRCODE = 22023; 
	END IF;
	
	RETURN NEW;
END $$;

-- Trigger
CREATE TRIGGER validar_ligacao_tg
BEFORE INSERT ON ligacao
FOR EACH ROW
EXECUTE PROCEDURE validar_ligacao()


