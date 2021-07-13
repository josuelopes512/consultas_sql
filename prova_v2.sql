CREATE TABLE Pais(CodPais INT PRIMARY KEY, NomePais VARCHAR(50), Populacao INT);

CREATE TABLE Cidade(CodCidade INT PRIMARY KEY, NomeCidade VARCHAR(50), CodPais INT REFERENCES Pais(CodPais));

CREATE TABLE Universidade(CodUniv INT PRIMARY KEY, NomeUniv VARCHAR(50), CodCidade INT REFERENCES Cidade(CodCidade), NumAlunos INT);

INSERT INTO Pais VALUES(1,'Brasil',194);
INSERT INTO Pais VALUES(2,'EUA',313);
INSERT INTO Pais VALUES(3,'Japao',128);
INSERT INTO Pais VALUES(4,'Inglaterra',52);

INSERT INTO Cidade VALUES(101,'Rio de Janeiro',1);
INSERT INTO Cidade VALUES(102,'Sao Paulo',1);
INSERT INTO Cidade VALUES(103,'Toquio',3);
INSERT INTO Cidade VALUES(104,'Oxford',4);
INSERT INTO Cidade VALUES(105,'Nova York',2);
INSERT INTO Cidade VALUES(106,'Chicago',2);

INSERT INTO Universidade VALUES(1,'Oxford',104,20330);
INSERT INTO Universidade VALUES(2,'Chicago State',106,7131);
INSERT INTO Universidade VALUES(3,'USP',102,88261);
INSERT INTO Universidade VALUES(4,'UFRJ',101,45753);
INSERT INTO Universidade VALUES(5,'Puc Rio',101,17900);
INSERT INTO Universidade VALUES(6,'NYU',105,50917);


SELECT * FROM Pais
SELECT * FROM Cidade
SELECT * FROM Universidade

-- QUESTÃO 5
-- mostrar os nomes das cidades que possuem uma media de alunos maior
-- que a media geral de alunos

SELECT Cidade.NomeCidade
FROM Cidade, Universidade
WHERE Cidade.codCidade = Universidade.CodCidade
GROUP BY Cidade.NomeCidade
HAVING AVG(Universidade.NumAlunos) > (SELECT AVG(Universidade.NumAlunos) FROM Universidade)

-- QUESTÃO 6
-- Mostrar o nome dos paises quem possuem a maior quantidade de cidades



-- QUESTÃO 7
-- mostrar os nomes dos paises que possuem uma população
-- menor que a media de alunos das universidades brasileiras

SELECT Pais.NomePais
FROM Pais, Cidade, Universidade AS un
WHERE Pais.CodPais = Cidade.codpais
AND Cidade.CodCidade = un.CodCidade
GROUP BY Pais.NomePais
HAVING SUM(pais.populacao) < (SELECT AVG(un.NumAlunos)
                                FROM pais, cidade, universidade AS un
                                WHERE pais.CodPais = Cidade.codpais
                                AND cidade.CodCidade = un.CodCidade
                                AND pais.nomepais = 'Brasil')
                                

-- QUESTÃO 8
-- mostrar o nome das cidade e a quantidade de universidades que cada cidade possui.
-- mostrar zero quando a cidade não possui

SELECT Cidade.NomeCidade, COUNT(*) 
FROM cidade RIGHT JOIN universidade as un
ON un.codcidade = cidade.codcidade
GROUP BY cidade.nomecidade
HAVING COUNT(*) <= 2


