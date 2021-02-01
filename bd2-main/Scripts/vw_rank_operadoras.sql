--View para exibir os planos mais comercializados
CREATE VIEW ranking_planos AS
(SELECT pl.idplano, pl.descricao, COUNT(pl.idplano) qnt_planos, SUM(pl.valor) valor_total
FROM chip ch JOIN plano pl ON pl.idplano = ch.idplano
GROUP BY pl.idplano
ORDER BY qnt_planos DESC)

-- select * FROM ranking_planos


