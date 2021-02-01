CREATE OR REPLACE FUNCTION gerar_fatura(mes integer, ano integer)
RETURNS VOID
AS $$
DECLARE
	rec record;
	operadora_igual record;
	operadora_diferente record;
	t_min_ex numeric;
	tx_roaming numeric;
	cont integer;
	total numeric;
	refe date;
BEGIN
	SELECT COUNT(idnumero) FROM chip INTO cont; --Saber quantos números existem em chip
	
	--For para varrer a tabela junto com o record
	FOR rec IN SELECT ch.idnumero numero, cp.idplano idplano, pl.valor valor_plano, pl.fminin fminin, 
	pl.fminout fminout, SUM(pl.fminin + pl.fminout) AS pl_min_total
	FROM cliente_chip ch JOIN chip cp ON ch.idnumero = cp.idnumero JOIN plano pl ON pl.idplano = cp.idplano
	JOIN plano_tarifa pt ON pt.idplano = pl.idplano
	JOIN tarifa ta ON ta.idtarifa = pt.idtarifa
	GROUP BY numero, cp.idplano, pl.valor,  pl.fminin, pl.fminout LOOP
	--Cálculo da taxa de minutos excedidos - franquia pra mesma operadora + op. diferente multi. pela tx de min excedido
	t_min_ex := ((gerar_t_min_in(rec.numero) + gerar_t_min_out(rec.numero)) - rec.pl_min_total) * get_tx_minuto_ex(rec.idplano);
	IF t_min_ex IS NULL OR t_min_ex < 0 THEN 
		--Por estarmos gerando fatura a partir da tabela chip, é preciso ver se houve taxa de min excedida,
		--caso não, o valor pago será o da franquia contratada
		t_min_ex := 0; 
	END IF;
	--Cálculo da tx_roaming
	tx_roaming := get_tx_roaming(rec.idplano) * abs(get_qnt_regiao_diferente(rec.numero));
	IF tx_roaming IS NULL THEN 
		tx_roaming := 0;
	END IF;
	--Soma das taxas + plano básico
	total := t_min_ex + tx_roaming + rec.valor_plano;
	refe := ano||'-'||mes||'-'||'01';
 	INSERT INTO fatura VALUES(refe, rec.numero, rec.valor_plano, gerar_t_min_in(rec.numero), 
							   gerar_t_min_out(rec.numero), t_min_ex, tx_roaming, total);
	
	END LOOP;
	
END

 $$
LANGUAGE plpgsql;

