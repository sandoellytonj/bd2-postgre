CREATE OR REPLACE FUNCTION validar_numero()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
--DECLARE ddd_valido text[] := '[0:26]={68, 82, 96, 92, 71, 85, 61, 27, 62, 98, 65, 67, 31, 91, 83, 41, 81, 86, 21, 84, 51, 69, 95, 47, 11, 79, 63}';

BEGIN
	--Verifica se o número já existe
	IF (SELECT idnumero FROM chip WHERE idnumero = NEW.idnumero) IS NOT NULL THEN
		RAISE NOTICE 'Número inválido!';
		RAISE EXCEPTION '%', 'Numero invalido' USING ERRCODE = 22023;
	END IF;
	--Verifica se o número termina com 0000 (reservado)
	IF SUBSTRING (NEW.idnumero FROM 8) = '0000' THEN
		RAISE NOTICE 'Número inválido!';
		RAISE EXCEPTION '%', 'Numero invalido' USING ERRCODE = 22023;
	END IF;
	--Verifica se o DDD é válido/existe
	IF (SELECT SUBSTRING (NEW.idnumero FROM 1 FOR 2) NOT IN('68', '82', '96', '92', '71', '85', 
'61', '27', '62', '98', '65', '67', '31',' 91', '83', '41', '81', '86', '21', '84', '51', '69', '95', '47', '11', '79', '63')) THEN
		RAISE NOTICE 'DDD inválido!';
		RAISE EXCEPTION '%', 'Numero invalido' USING ERRCODE = 22023;
	END IF;	  
	RETURN NEW;
END $$;

--Trigger para verificar o número antes de inserir em chip
CREATE TRIGGER numero_valido_tg
BEFORE INSERT ON chip
FOR EACH ROW
EXECUTE PROCEDURE validar_numero()


