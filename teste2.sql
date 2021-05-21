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

SELECT * FROM produto 
SELECT * FROM loja 
SELECT * FROM vendedor
SELECT * FROM venda

-- O nome da loja e a quantidade total (SUM) de unidades vendidas. 
-- Considerar apenas os produtos com quantidade em estoque superior a 30. 
-- Mostrar apenas as lojas com mais de 11 unidades vendidas no total.

SELECT loja.nome_loja, SUM(Venda.unidades_vendidas) 
FROM loja, venda, vendedor, produto
WHERE loja.cod_loja = vendedor.cod_loja 
AND vendedor.cod_vendedor = venda.cod_vendedor
AND venda.cod_produto = produto.cod_produto
AND produto.qtd_estoque > 30
GROUP BY loja.nome_loja
HAVING SUM(Venda.unidades_vendidas) > 11