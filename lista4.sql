CREATE TABLE Produto
(
--  NOME TIPO RESTRIÇÃO
	codProduto INT PRIMARY KEY NOT NULL,
	nomeProduto VARCHAR(40) UNIQUE NOT NULL,
	preco FLOAT
);

CREATE TABLE Vendedor
(
--  NOME TIPO RESTRIÇÃO
	codVendedor INT PRIMARY KEY NOT NULL,
	nomeVendedor VARCHAR(40) UNIQUE NOT NULL,
	salario INT,
	Filial VARCHAR(2)
);

CREATE TABLE Venda
(
--  NOME TIPO RESTRIÇÃO
	codVenda INT PRIMARY KEY NOT NULL,
	produto INT,
	vendedor INT,
	qtd INT,
	FOREIGN KEY (produto) REFERENCES Produto(codProduto),
	FOREIGN KEY (vendedor) REFERENCES Vendedor(codVendedor)
);

INSERT INTO Produto VALUES (10, 'Notebook', 2000);
INSERT INTO Produto VALUES (20, 'Impressora', 300);
INSERT INTO Produto VALUES (30, 'Pendrive', 50);
INSERT INTO Produto VALUES (40, 'iPhone', 1800);

INSERT INTO Vendedor VALUES (101, 'João', 1500, 'CE');
INSERT INTO Vendedor VALUES (102, 'Paulo', 4000, 'CE');
INSERT INTO Vendedor VALUES (103, 'Pedro', 3200, 'PI');
INSERT INTO Vendedor VALUES (104, 'Ana', 2500, 'RN');
INSERT INTO Vendedor VALUES (105, 'Maria', 6700, 'PI');

INSERT INTO Venda VALUES (1, 10, 102, 2);
INSERT INTO Venda VALUES (2, 40, 102, 1);
INSERT INTO Venda VALUES (3, 30, 104, 3);
INSERT INTO Venda VALUES (4, 20, 103, 4);
INSERT INTO Venda VALUES (5, 20, 104, 5);
INSERT INTO Venda VALUES (6, 40, 105, 4);

DROP TABLE Produto
DROP TABLE Vendedor
DROP TABLE Venda

SELECT * FROM Produto
SELECT * FROM Vendedor
SELECT * FROM Venda

-- a. O nome e o preço do produto mais caro da loja.
SELECT Produto.nomeProduto, Produto.preco FROM Produto
WHERE preco = (SELECT MAX(preco) FROM Produto)

-- b. A média salarial de cada filial. Mostrar apenas as filiais com média superior a R$ 3.000,00.
SELECT Vendedor.filial, AVG(salario) as media FROM vendedor
GROUP BY Vendedor.filial HAVING AVG(salario) > 3000

-- c. A média de unidades vendidas de cada produto. Mostrar o nome do produto e a quantidade média.


-- d. O volume total de vendas realizado por cada vendedor. Obs.: o valor de cada venda é (preco * qtd).


-- e. O volume total de vendas realizado por cada filial.


-- f. O volume total de dinheiro vendido por cada vendedor. Mostrar apenas os vendedores (os nomes) que 
-- venderam mais de R$ 1.000,00. Ordenar do vendedor que mais vendeu para o que menos vendeu.


-- g. O maior valor de venda realizado por cada vendedor. Mostrar o nome do mesmo e o valor máximo.


-- h. Os nomes dos vendedores e o máximo de produtos vendidos que cada um já realizou em uma venda.


-- i. O nome de cada produto e a sua quantidade total vendida. Mostrar ZERO quando o produto não tiver sido 
-- vendido.


-- j. O número de vendas realizadas por cada vendedor (mostrar o nome do mesmo). Mostrar ZERO quando o 
-- vendedor não tiver realizado nenhuma venda





