--View para detalhar informações de clientes
CREATE VIEW detalhamento_cliente AS
(SELECT cl.idcliente, cl.nome, ci.uf, cc.idnumero, pl.descricao, age(cl.datacadastro) FROM cliente cl 
 JOIN cidade ci ON ci.idcidade = cl.idcidade
 JOIN cliente_chip cc ON cc.idcliente = cl.idcliente
 JOIN chip ch ON ch.idnumero = cc.idnumero 
 JOIN plano pl ON pl.idplano = ch.idplano)



-- select * FROM detalhamento_cliente

