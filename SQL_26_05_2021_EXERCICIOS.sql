CREATE TABLE produto
(
	cod_produto INT PRIMARY KEY,
	nome_produto VARCHAR(50) UNIQUE,
	preco FLOAT,
	qtd_estoque INT
);

INSERT INTO produto VALUES (11, 'Fogão', 850, 23);
INSERT INTO produto VALUES (12, 'Ventilador', 220, 124);
INSERT INTO produto VALUES (13, 'Geladeira', 1090, 39);
INSERT INTO produto VALUES (14, 'Freezer', 925, 14);
INSERT INTO produto VALUES (15, 'Microondas', 410, 87);

CREATE TABLE loja 
(
	cod_loja INT PRIMARY KEY,
	nome_loja VARCHAR(50),
	cidade VARCHAR(50)
);

INSERT INTO loja VALUES (1001, 'Loja 1', 'Fortaleza');
INSERT INTO loja VALUES (1002, 'Loja 2', 'Fortaleza');
INSERT INTO loja VALUES (1003, 'Loja 3', 'Sobral');
INSERT INTO loja VALUES (1004, 'Loja 4', 'Iguatu');
INSERT INTO loja VALUES (1005, 'Loja 5', 'Caucaia');

CREATE TABLE vendedor
(
	cod_vendedor INT PRIMARY KEY,
	nome_vendedor VARCHAR(50),
	salario FLOAT,
	cod_loja INT REFERENCES loja(cod_loja)
);

INSERT INTO vendedor VALUES (101, 'Maria Maia', 4500, 1004);
INSERT INTO vendedor VALUES (102, 'Luis Lima', 3600, 1002);
INSERT INTO vendedor VALUES (103, 'Carlos Costa', 4400, 1003);
INSERT INTO vendedor VALUES (104, 'Ana Almeida', 6250, 1003);
INSERT INTO vendedor VALUES (105, 'Sonia Silva', 4200, 1001);

CREATE TABLE venda
(
	cod_venda INT PRIMARY KEY,
	cod_vendedor INT REFERENCES vendedor(cod_vendedor),
	cod_produto INT REFERENCES produto(cod_produto),
	unidades_vendidas INT
);

INSERT INTO venda VALUES (1, 105, 13, 5);
INSERT INTO venda VALUES (2, 101, 12, 2);
INSERT INTO venda VALUES (3, 101, 11, 9);
INSERT INTO venda VALUES (4, 102, 12, 12);
INSERT INTO venda VALUES (5, 103, 15, 7);
INSERT INTO venda VALUES (6, 104, 14, 10);
INSERT INTO venda VALUES (7, 104, 13, 13);
INSERT INTO venda VALUES (8, 102, 13, 3);

--Mostrar:
--O nome da loja e a quantidade total (SUM) de unidades vendidas. Considerar apenas os produtos com quantidade em estoque
--superior a 30. Mostrar apenas as lojas com mais de 11 unidades vendidas no total
SELECT nome_loja, SUM(unidades_vendidas)
FROM loja, venda, vendedor, produto
WHERE venda.cod_vendedor = vendedor.cod_vendedor and vendedor.cod_loja = loja.cod_loja
AND venda.cod_produto = produto.cod_produto AND produto.qtd_estoque > 30
GROUP BY nome_loja
HAVING SUM(unidades_vendidas) > 11

--O nome do vendedor e o preco medio (AVG) dos produtos vendidos por ele. Considerar apenas vendedores de Sobral.
--Mostrar apenas os nomes dos vendedores cujo preco medio do produto vendido seja inferior a 600
SELECT nome_vendedor, AVG(preco)
FROM loja, venda, vendedor, produto
WHERE venda.cod_vendedor = vendedor.cod_vendedor and vendedor.cod_loja = loja.cod_loja
AND venda.cod_produto = produto.cod_produto AND loja.cidade = 'Sobral'
GROUP BY nome_vendedor
HAVING AVG(preco) < 600

--O nome da cidade e o menor (MIN) salário entre seus vendedores. Considerar apenas as vendas de produtos com preco superior a
--R$ 400. Mostrar apenas os nomes das cidades cujo menor salário do vendedor seja superior a 4300
SELECT cidade, MIN(salario)
FROM loja, venda, vendedor, produto
WHERE venda.cod_vendedor = vendedor.cod_vendedor and vendedor.cod_loja = loja.cod_loja
AND venda.cod_produto = produto.cod_produto AND produto.preco > 400
GROUP BY cidade
HAVING MIN(salario) > 4300

--O nome de cada produto e a quantidade de vendas (COUNT) em que esse produto foi vendido. Considerar apenas vendas realizadas
--em Fortaleza. Mostrar apenas os produtos que tenham sido vendidos mais de uma vez
SELECT nome_produto, COUNT(*)
FROM loja, venda, vendedor, produto
WHERE venda.cod_vendedor = vendedor.cod_vendedor and vendedor.cod_loja = loja.cod_loja
AND venda.cod_produto = produto.cod_produto AND cidade = 'Fortaleza'
GROUP BY nome_produto
HAVING COUNT(*) > 1

---------------------------------------------------------------------------------------------------------------------------
--1) (CASO 1: SUBSELECT no WHERE) Qual o nome do produto mais caro?
SELECT produto.nome_produto, preco
FROM produto
WHERE produto.preco = (SELECT MAX(preco) FROM produto)
---------------------------------------------------------------------------------------------------------------------------
--2) (CASO 2: SUBSELECT no HAVING) Quais as cidades que possuem média salarial superior a média salarial da empresa?
SELECT cidade, AVG(salario) AS media_salarial
FROM loja, vendedor
WHERE loja.cod_loja = vendedor.cod_loja
GROUP BY cidade
HAVING AVG(salario) > (SELECT AVG(salario) FROM vendedor)
---------------------------------------------------------------------------------------------------------------------------
--3) (CASO 3: SUBSELECT no FROM) Qual o nome do vendedor que realizou a maior quantidade de vendas?
SELECT vendedor.nome_vendedor, COUNT(*) AS qtd
FROM vendedor, venda
WHERE vendedor.cod_vendedor = venda.cod_vendedor
GROUP BY vendedor.nome_vendedor
HAVING COUNT(*) = (SELECT MAX(qtd)
				   FROM (SELECT COUNT(*) AS qtd FROM vendedor, venda WHERE vendedor.cod_vendedor = venda.cod_vendedor
						 GROUP BY vendedor.nome_vendedor) AS sub)

--Quais as quantidades de vendas realizadas? (SUNCONSULTA 1)
SELECT COUNT(*) AS qtd FROM vendedor, venda WHERE vendedor.cod_vendedor = venda.cod_vendedor GROUP BY vendedor.nome_vendedor

--Qual a maior quantidade de vendas realizada? (SUNCONSULTA 2)
--SELECT MAX(qtd) FROM (SUNCONSULTA 1)
SELECT MAX(qtd) FROM (SELECT COUNT(*) AS qtd FROM vendedor, venda WHERE vendedor.cod_vendedor = venda.cod_vendedor
					  GROUP BY vendedor.nome_vendedor) AS sub1
---------------------------------------------------------------------------------------------------------------------------
--4) Qual o nome e o salário do vendedor que recebe o menor salário?
SELECT vendedor.nome_vendedor, vendedor.salario
FROM vendedor
WHERE vendedor.salario =  (SELECT MIN(salario) FROM vendedor)
---------------------------------------------------------------------------------------------------------------------------
--5) Quais os nomes dos vendedores que venderam em dinheiro (unidades_vendidas * preco) no total mais do que a soma em
--dinheiro vendida pelos vendedores de Sobral
SELECT vendedor.nome_vendedor, SUM(unidades_vendidas * preco) AS total_em_vendas
FROM venda, vendedor, produto
WHERE venda.cod_vendedor = vendedor.cod_vendedor
AND venda.cod_produto = produto.cod_produto
GROUP BY vendedor.nome_vendedor
HAVING SUM(unidades_vendidas * preco) > (SELECT SUM(unidades_vendidas * preco) FROM loja, venda, vendedor, produto
										 WHERE venda.cod_vendedor = vendedor.cod_vendedor
										 AND vendedor.cod_loja = loja.cod_loja AND venda.cod_produto = produto.cod_produto
										 AND loja.cidade = 'Sobral')

--Qual a soma em dinheiro em vendas dos vendedores de Sobral? (SUNCONSULTA 1)
SELECT SUM(unidades_vendidas * preco)
FROM loja, venda, vendedor, produto
WHERE venda.cod_vendedor = vendedor.cod_vendedor
AND vendedor.cod_loja = loja.cod_loja
AND venda.cod_produto = produto.cod_produto
AND loja.cidade = 'Sobral'
---------------------------------------------------------------------------------------------------------------------------
--6) Qual o nome da cidade que possui a maior média salarial?
SELECT cidade
FROM loja, vendedor
WHERE vendedor.cod_loja = loja.cod_loja
GROUP BY cidade
HAVING AVG(salario) = (SELECT MAX(media_salarial)
					   FROM (SELECT AVG(salario) AS media_salarial FROM loja, vendedor
						     WHERE vendedor.cod_loja = loja.cod_loja GROUP BY cidade) AS sub)

--Quais as médias salariais de cada cidade? (SUNCONSULTA 1)
SELECT AVG(salario) AS media_salarial
FROM loja, vendedor
WHERE vendedor.cod_loja = loja.cod_loja
GROUP BY cidade

--Qual a maior entre essas médias salariais das cidades? (SUNCONSULTA 2)
SELECT MAX(media_salarial)
FROM (SELECT AVG(salario) AS media_salarial FROM loja, vendedor
	  WHERE vendedor.cod_loja = loja.cod_loja GROUP BY cidade) AS sub
---------------------------------------------------------------------------------------------------------------------------