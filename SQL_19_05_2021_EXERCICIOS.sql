SELECT * FROM Produto
SELECT * FROM Vendedor
SELECT * FROM Venda

--a. O nome e o preço do produto mais caro da loja.
SELECT nomeproduto, preco
FROM Produto
WHERE preco = (SELECT MAX(preco) FROM Produto)

SELECT MAX(preco) FROM Produto

--b. A média salarial de cada filial. Mostrar apenas as filiais com média superior a R$ 3.000,00.
SELECT filial, AVG(salario)
FROM Vendedor
GROUP BY filial
HAVING AVG(salario) > 3000

--c. A média de unidades vendidas de cada produto. Mostrar o nome do produto e a quantidade média.
SELECT Produto.nomeproduto, AVG(qtd)
FROM Venda, Produto
WHERE Venda.produto = Produto.codproduto
GROUP BY Produto.nomeproduto

SELECT Produto.nomeproduto, AVG(qtd)
FROM Venda JOIN Produto
ON Venda.produto = Produto.codproduto
GROUP BY Produto.nomeproduto

--d. O volume total de vendas realizado por cada vendedor. Obs.: o valor de cada venda é (preco * qtd).
SELECT Vendedor.nomevendedor, SUM(preco * qtd) AS total
FROM Venda, Produto, Vendedor
WHERE Venda.produto = Produto.codproduto AND Vendedor.codvendedor = Venda.vendedor
GROUP BY Vendedor.nomevendedor

--e. O volume total de vendas realizado por cada filial.
SELECT Vendedor.filial, SUM(preco * qtd) AS total
FROM Venda, Produto, Vendedor
WHERE Venda.produto = Produto.codproduto AND Vendedor.codvendedor = Venda.vendedor
GROUP BY Vendedor.filial

--f. O volume total de dinheiro vendido por cada vendedor. Mostrar apenas os vendedores (os nomes) que venderam mais de
--R$ 1.000,00. Ordenar do vendedor que mais vendeu para o que menos vendeu.
SELECT Vendedor.nomevendedor, SUM(preco * qtd) AS total
FROM Venda, Produto, Vendedor
WHERE Venda.produto = Produto.codproduto AND Vendedor.codvendedor = Venda.vendedor
GROUP BY Vendedor.nomevendedor
HAVING SUM(preco * qtd) > 1000
ORDER BY SUM(preco * qtd) DESC

--f2. O volume total de dinheiro vendido por cada vendedor. Mostrar apenas os vendedores (os nomes) que venderam mais de
--R$ 1.000,00. Considerar apenas os vendedores do Ceará
SELECT Vendedor.nomevendedor, SUM(preco * qtd) AS total
FROM Venda, Produto, Vendedor
WHERE Venda.produto = Produto.codproduto AND Vendedor.codvendedor = Venda.vendedor AND Vendedor.filial = 'CE'
GROUP BY Vendedor.nomevendedor
HAVING SUM(preco * qtd) > 1000

--g. O maior valor de venda realizado por cada vendedor. Mostrar o nome do mesmo e o valor máximo.
SELECT Vendedor.nomevendedor, MAX(preco * qtd) AS maximo
FROM Venda, Produto, Vendedor
WHERE Venda.produto = Produto.codproduto AND Vendedor.codvendedor = Venda.vendedor
GROUP BY Vendedor.nomevendedor

--h. Os nomes dos vendedores e o máximo de produtos vendidos que cada um já realizou em uma venda.
SELECT Vendedor.nomevendedor, MAX(qtd) AS maximo
FROM Venda, Produto, Vendedor
WHERE Venda.produto = Produto.codproduto AND Vendedor.codvendedor = Venda.vendedor
GROUP BY Vendedor.nomevendedor

--i. O nome de cada produto e a sua quantidade total vendida. Mostrar ZERO quando o produto não tiver sido vendido.
SELECT Produto.nomeproduto, SUM(ISNULL(qtd,0)) AS total
FROM Venda RIGHT JOIN Produto
ON Venda.produto = Produto.codproduto
GROUP BY Produto.nomeproduto

--j. O número de vendas realizadas por cada vendedor (mostrar o nome do mesmo). Mostrar ZERO quando o vendedor não tiver
--realizado nenhuma venda.
SELECT Vendedor.nomevendedor, COUNT(Venda.qtd) as qtd
FROM Venda RIGHT JOIN Vendedor
ON Vendedor.codvendedor = Venda.vendedor
GROUP BY Vendedor.nomevendedor