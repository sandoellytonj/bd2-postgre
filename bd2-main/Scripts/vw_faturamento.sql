--View da view Faturamento
CREATE VIEW faturamento AS
(SELECT date_part('year', referencia) as ano, date_part('month', referencia) as mes, COUNT(idnumero), SUM(total) valor_total
FROM fatura
GROUP BY mes, ano
)