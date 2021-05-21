-- CRIA TABELA
CREATE TABLE Cargo (
--  NOME TIPO RESTRIÇÃO
	codCargo INT PRIMARY KEY,
	nomeCargo VARCHAR(40) UNIQUE NOT NULL,
	salarioBase FLOAT
);

CREATE TABLE Empregado
(
--  NOME TIPO RESTRIÇÃO
	matricula INT PRIMARY KEY,
	nomeEmpregado VARCHAR(40) UNIQUE NOT NULL,
	codCargo INT NOT NULL,
	anoContratacao INT NOT NULL,
	bonus FLOAT DEFAULT(1),
	FOREIGN KEY (codCargo) REFERENCES Cargo(codCargo)
);

CREATE TABLE Projeto
(
--  NOME TIPO RESTRIÇÃO
	codProjeto INT PRIMARY KEY,
	nomeProjeto VARCHAR(40) UNIQUE NOT NULL,
	inicioProjeto INT NOT NULL,
	fimProjeto INT NOT NULL CHECK(fimProjeto > inicioProjeto)
);

CREATE TABLE Alocacao
(
--  NOME TIPO RESTRIÇÃO
	codAlocacao INT PRIMARY KEY,
	codProjeto INT NOT NULL,
	matriculaEmpregado INT NOT NULL,
	ingressoProjeto INT,
	saidaProjeto INT CHECK(saidaProjeto > ingressoProjeto),
	FOREIGN KEY (codProjeto) REFERENCES Projeto(codProjeto),
	FOREIGN KEY (matriculaEmpregado) REFERENCES Empregado(matricula)
);

-- INSERE VALOR NA TABELA

--Cargo
INSERT INTO Cargo VALUES (1,'Analista',7500.00);
INSERT INTO Cargo VALUES (2,'Gerente',8000.00);
INSERT INTO Cargo VALUES (3,'Programador',5200.00);
INSERT INTO Cargo VALUES (4,'Vendedor',3800.00);

--Empregado
INSERT INTO Empregado VALUES (1210,'José Marcos Silva ',3,2005,1.00);
INSERT INTO Empregado VALUES (1512,'Ana Maria Bueno',1,2006,1.00);
INSERT INTO Empregado VALUES (1798,'Ernesto Sales',2,1998,1.50);
INSERT INTO Empregado VALUES (1809,'Tatiana Mendes',3,2003,1.10);
INSERT INTO Empregado VALUES (1976,'Fábio Pereira',3,2011,1.25);

--Projeto 
INSERT INTO Projeto VALUES (10,'E-commerce',2016,2017);
INSERT INTO Projeto VALUES (20,'Business Intelligence',2017,2019);
INSERT INTO Projeto VALUES (30,'Sistema de Vendas',2018,2020);

--Alocacao
INSERT INTO Alocacao VALUES (1,20,1512,2017,2019);
INSERT INTO Alocacao VALUES (2,10,1210,2016,2017);
INSERT INTO Alocacao VALUES (3,10,1809,2016,2018);
INSERT INTO Alocacao VALUES (4,10,1512,2016,2019);
INSERT INTO Alocacao VALUES (5,30,1512,2018,NULL);
INSERT INTO Alocacao VALUES (6,20,1210,2017,NULL);
INSERT INTO Alocacao VALUES (7,30,1976,2018,NULL);

-- APAGA TABELA
DROP TABLE Alocacao;
DROP TABLE Projeto;
DROP TABLE Empregado;
DROP TABLE Cargo;

-- VISUALIZA/CONSULTA TABELA

SELECT * FROM Cargo;
SELECT * FROM Empregado;
SELECT * FROM Projeto;
SELECT * FROM Alocacao;

-- Empregado JOIN Cargo
SELECT * FROM Empregado, Cargo Where Cargo.codCargo = Empregado.codCargo

-- O nome e o cargo de cada funcionário
SELECT nomeEmpregado, nomeCargo FROM Empregado, Cargo Where Cargo.codCargo = Empregado.codCargo

-- O nome e o cargo de cada funcionário que ingressou após o ano 2005
SELECT Empregado.nomeEmpregado, Cargo.nomeCargo 
FROM Empregado, Cargo 
Where Cargo.codCargo = Empregado.codCargo 
AND anoContratacao > 2005

-- correcao
SELECT Empregado.nomeEmpregado, Cargo.nomeCargo
FROM Empregado, Cargo, Alocacao
Where Empregado.codCargo = Cargo.codCargo
AND Alocacao.matriculaEmpregado = Empregado.matricula
AND Alocacao.ingressoProjeto > 2005


-- O nome do funcionário e o nome do projeto em que ele participa
SELECT nomeEmpregado, nomeProjeto 
FROM Empregado, Alocacao, Projeto 
Where Empregado.matricula = Alocacao.matriculaEmpregado 
AND Alocacao.codProjeto = Projeto.codProjeto 

-- O nome e o salário (com o bônus) de todos os empregados, ordenando do empregado que ganha o maior 
-- salário para o que ganha o menor salário (Dica: o salário do empregado é calculado pela multiplicação do 
-- salário base pelo bônus)
SELECT Empregado.nomeEmpregado, Cargo.salarioBase + Cargo.salarioBase * Empregado.bonus/100 AS salario 
FROM Empregado, Cargo 
Where Cargo.codCargo = Empregado.codCargo 
ORDER BY salario DESC

-- O nome, ano de início e o ano final de todos os projetos da empresa que ainda têm empregados 
-- trabalhando neles (atributo SaidaProjeto não é nulo)
SELECT Empregado.nomeEmpregado, Projeto.inicioProjeto, Projeto.fimProjeto
FROM Empregado, Alocacao, Projeto 
Where Empregado.matricula = Alocacao.matriculaEmpregado 
AND Alocacao.codProjeto = Projeto.codProjeto
AND fimProjeto >= saidaProjeto
AND Projeto.saidaProjeto IS NOT NULL

--correcao
SELECT Projeto.nomeProjeto, Projeto.inicioProjeto, Projeto.fimProjeto
FROM Projeto, Alocacao
WHERE Projeto.codProjeto = Alocacao.codProjeto
AND saidaProjeto IS NOT NULL

-- Os códigos de todos os projetos da empresa que têm ou tiveram algum analista
SELECT Projeto.codProjeto
FROM Projeto, Alocacao, Empregado, Cargo 
Where Projeto.codProjeto = Alocacao.codProjeto 
AND Alocacao.matriculaEmpregado = Empregado.matricula
AND Empregado.codCargo = Cargo.codCargo
AND nomeCargo = 'Analista'

-- Nome de todos os cargos que não tem funcionários
SELECT Cargo.nomeCargo
FROM Empregado
RIGHT JOIN Cargo
ON Cargo.codCargo = Empregado.codCargo
WHERE Empregado.codCargo IS NULL

-- O nome e o cargo de todos os empregados que participam ou 
-- participaram de projetos cujo prazo de 
-- entrega ainda não expirou
SELECT Empregado.nomeEmpregado, Cargo.nomeCargo
FROM Empregado, Alocacao, Projeto, Cargo 
Where Projeto.codProjeto = Alocacao.codProjeto
AND Alocacao.matriculaEmpregado = Empregado.matricula
AND Empregado.codCargo = Cargo.codCargo
-- AND Alocacao.ingressoProjeto <= Projeto.fimProjeto
AND Alocacao.saidaProjeto <= Projeto.fimProjeto

-- O nome de todos os programadores que ingressaram em algum projeto após 2017
SELECT Empregado.nomeEmpregado
FROM Alocacao, Empregado, Cargo
Where Alocacao.ingressoProjeto > 2017
AND Alocacao.matriculaEmpregado = Empregado.matricula
AND Empregado.codCargo = Cargo.codCargo
AND Cargo.nomeCargo = 'Programador'