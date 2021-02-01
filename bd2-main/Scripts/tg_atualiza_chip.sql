--Função para atualizar a flag de chip para não disponível após ele ser atribuído a um cliente
CREATE OR REPLACE FUNCTION atualizar_cliente_chip()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE chip SET disponivel = 'N' WHERE idnumero = NEW.idnumero;
	RETURN NEW;
END $$;

--Trigger after insert
CREATE TRIGGER atualizar_cliente_chip_tg
AFTER INSERT ON cliente_chip
FOR EACH ROW
EXECUTE PROCEDURE atualizar_cliente_chip()

