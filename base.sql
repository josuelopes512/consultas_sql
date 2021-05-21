-- CRIA TABELA
CREATE TABLE produto
(
--  NOME TIPO RESTRIÇÃO
	codigo INT PRIMARY KEY,
	nome VARCHAR(40) UNIQUE NOT NULL,
	preco FLOAT CHECK(preco > 0 AND preco <= 99999)
);

CREATE TABLE venda
(
	codigo_venda INT PRIMARY KEY,
	codigo_produto INT REFERENCES produto(codigo),
	quantidade INT
	
);

-- APAGA TABELA
DROP TABLE produto;
DROP TABLE venda;

-- INSERE VALOR NA TABELA
INSERT INTO produto VALUES (15,'pendrive',50);
INSERT INTO venda VALUES (1,12,8);

-- VISUALIZA/CONSULTA TABELA
SELECT * FROM produto;
SELECT * FROM venda;

-- APAGA LINHAS DA TABELA
DELETE FROM produto WHERE codigo = 15
DELETE FROM venda WHERE codigo_produto = 1

-- ATUALIZA/MODIFICA VALORES
--WHERE -> QUANDO
UPDATE produto SET preco = 80 WHERE codigo = 15