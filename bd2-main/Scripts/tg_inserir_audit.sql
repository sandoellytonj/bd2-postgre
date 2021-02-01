--Função para Inserir na tabela auditoria um número suspeito
CREATE OR REPLACE FUNCTION  fn_inclui_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	IF (select es.ddd from cliente_chip cc JOIN cliente c ON c.idcliente = cc.idcliente 
		JOIN cidade ci ON ci.idcidade = c.idcidade JOIN estado es ON es.uf = ci.uf
		where (substring(cc.idnumero from 1 for 2)::integer <> es.ddd) AND cc.idnumero = NEW.idnumero) IS NULL THEN
	
		insert into auditoria values (NEW.idnumero, NEW.idcliente, current_date, current_date+30);
	
	END IF;
	RETURN NEW;
END $$;


CREATE TRIGGER tg_audita_cliente
BEFORE INSERT ON cliente_chip
FOR EACH ROW
EXECUTE PROCEDURE fn_inclui_audit()