CREATE TABLE curso
(
	codigo_curso INT PRIMARY KEY,
	nome_curso VARCHAR(50) UNIQUE,
	carga_horaria INT CHECK(carga_horaria >= 2000)
);

INSERT INTO curso VALUES (1, 'Direito', 3400);
INSERT INTO curso VALUES (2, 'Administração', 3200);
INSERT INTO curso VALUES (3, 'Gestão de TI', 2500);
INSERT INTO curso VALUES (4, 'Computação', 3200);

CREATE TABLE aluno 
(
	matricula INT PRIMARY KEY,
	nome_aluno VARCHAR(50),
	curso_aluno INT REFERENCES curso(codigo_curso)
);

INSERT INTO aluno VALUES (1510812, 'Ana Maria', 3);
INSERT INTO aluno VALUES (1510815, 'Rui Barbosa', 2);
INSERT INTO aluno VALUES (1610244, 'Elvis Presley', 1);
INSERT INTO aluno VALUES (1610277, 'João Silva', 4);
INSERT INTO aluno VALUES (1710355, 'Silvia Santos', 3);
INSERT INTO aluno VALUES (1710767, 'Maria Mendes', 1);
INSERT INTO aluno VALUES (1820277, 'Luis Lima', 3);

CREATE TABLE disciplina
(
	codigo_disc INT PRIMARY KEY,
	nome_disc VARCHAR(50),
	creditos INT,
	curso_disc INT REFERENCES curso(codigo_curso)
);

INSERT INTO disciplina VALUES (101, 'LP1', 4, 4);
INSERT INTO disciplina VALUES (103, 'BD1', 4, 4);
INSERT INTO disciplina VALUES (105, 'SAD', 6, 3);
INSERT INTO disciplina VALUES (112, 'Direito Penal', 2, 1);
INSERT INTO disciplina VALUES (115, 'Direito Civil', 4, 1);
INSERT INTO disciplina VALUES (118, 'Empreendedorismo', 4, 2);
INSERT INTO disciplina VALUES (125, 'Planejamento', 4, 3);

CREATE TABLE status_cursada
(
	codigo_status INT PRIMARY KEY,
	nome_status VARCHAR(50)
);

INSERT INTO status_cursada VALUES (1, 'Aprovado');
INSERT INTO status_cursada VALUES (2, 'Cursando');
INSERT INTO status_cursada VALUES (3, 'Reprovado');
INSERT INTO status_cursada VALUES (4, 'Trancado');

CREATE TABLE disciplina_cursada
(
	aluno INT REFERENCES aluno(matricula),
	disciplina INT REFERENCES disciplina(codigo_disc),
	status_dc INT REFERENCES status_cursada(codigo_status),
	semestre INT,
	nota FLOAT,
	PRIMARY KEY(aluno, disciplina, semestre)
);

INSERT INTO disciplina_cursada VALUES (1510815, 118, 2, 20201, NULL);
INSERT INTO disciplina_cursada VALUES (1510812, 105, 3, 20192, 3.6);
INSERT INTO disciplina_cursada VALUES (1510812, 105, 2, 20201, NULL);
INSERT INTO disciplina_cursada VALUES (1510812, 125, 2, 20201, NULL);
INSERT INTO disciplina_cursada VALUES (1610244, 112, 3, 20191, 2.7);
INSERT INTO disciplina_cursada VALUES (1610244, 112, 1, 20192, 7.7);
INSERT INTO disciplina_cursada VALUES (1610244, 115, 2, 20201, NULL);
INSERT INTO disciplina_cursada VALUES (1610277, 101, 4, 20181, NULL);
INSERT INTO disciplina_cursada VALUES (1610277, 101, 3, 20182, 1.8);
INSERT INTO disciplina_cursada VALUES (1610277, 101, 1, 20191, 10.0);
INSERT INTO disciplina_cursada VALUES (1710767, 112, 1, 20191, 7.0);
INSERT INTO disciplina_cursada VALUES (1710767, 115, 1, 20191, 5.9);

SELECT * FROM curso
SELECT * FROM aluno
SELECT * FROM disciplina
SELECT * FROM disciplina_cursada
SELECT * FROM status_cursada

--Mostrar:
--1) Os nomes dos alunos de Direito que tiraram nota superior a 7.0 em 2019.2?
--2) Os nomes das disciplinas que nunca foram cursadas?
--3) Os nomes dos cursos que tem média de nota dos alunos superior a média de nota dos alunos do curso de Direito?
--5) Qual o nome do aluno que foi aprovado na maior quantidade de disciplinas?
--6) Os nomes e a carga horaria dos cursos que reprovaram algum aluno em 2019.2
--7) Os nomes das disciplinas que tiveram o maior número de reprovações
--8) Os nomes dos alunos que tem média de nota inferior a média de nota do curso de Computação
--10) Os nome dos cursos que possuem a maior quantidade de alunos cursando disciplina em 2020.1
--11) Qual a quantidade total de créditos aprovados por cada aluno?
--12) Qual o nome e o curso do alunos que tem a maior quantidade total de créditos aprovados?
--13) Qual o nome do curso que tem menos disciplinas trancadas do que aprovadas?

--1) Os nomes dos alunos de Direito que tiraram nota superior a 7.0 em 2019.2?
SELECT aluno.nome_aluno
FROM aluno, disciplina_cursada AS dc, curso
WHERE aluno.matricula = dc.aluno
AND curso.codigo_curso = aluno.curso_aluno
AND dc.nota > 7
AND curso.nome_curso = 'Direito'
AND dc.semestre = 20192

--2) Os nomes das disciplinas que nunca foram cursadas?
SELECT disciplina.nome_disc
FROM disciplina_cursada AS dc RIGHT JOIN disciplina
ON dc.disciplina = disciplina.codigo_disc
WHERE dc.aluno IS NULL

--3) Os nomes dos cursos que tem média de nota dos alunos superior a média de nota dos alunos
--do curso de Direito?
SELECT curso.nome_curso, AVG(dc.nota) AS media
FROM disciplina_cursada AS dc, aluno, curso
WHERE aluno.matricula = dc.aluno
AND aluno.curso_aluno = curso.codigo_curso
GROUP BY curso.nome_curso
HAVING AVG(dc.nota) > (média de nota dos alunos do curso de Direito?)

--Qual é a média de nota dos alunos do curso de Direito?
SELECT AVG(dc.nota) AS media
FROM disciplina_cursada AS dc, aluno, curso
WHERE aluno.matricula = dc.aluno
AND aluno.curso_aluno = curso.codigo_curso
AND curso.nome_curso = 'Direito'


SELECT curso.nome_curso, AVG(dc.nota) AS media
FROM disciplina_cursada AS dc, aluno, curso
WHERE aluno.matricula = dc.aluno
AND aluno.curso_aluno = curso.codigo_curso
GROUP BY curso.nome_curso
HAVING AVG(dc.nota) > (SELECT AVG(dc.nota) AS media
					   FROM disciplina_cursada AS dc, aluno, curso
					   WHERE aluno.matricula = dc.aluno
					   AND aluno.curso_aluno = curso.codigo_curso
					   AND curso.nome_curso = 'Direito')

--5) Qual o nome do aluno que foi aprovado na maior quantidade de disciplinas?
SELECT aluno.matricula, COUNT(*) AS qtd
FROM aluno, disciplina_cursada AS dc, status_cursada AS st
WHERE aluno.matricula = dc.aluno
AND dc.status_dc = st.codigo_status
AND st.nome_status = 'Aprovado'
GROUP BY aluno.matricula
HAVING COUNT(*) = (Maior número de disciplinas aprovadas por um aluno)

--Qual é o maior número de disciplinas aprovadas por um aluno?
SELECT COUNT(*) AS qtd
FROM aluno, disciplina_cursada AS dc, status_cursada AS st
WHERE aluno.matricula = dc.aluno
AND dc.status_dc = st.codigo_status
AND st.nome_status = 'Aprovado'
GROUP BY aluno.matricula

SELECT MAX(qtd)
FROM (SELECT COUNT(*) AS qtd
	  FROM aluno, disciplina_cursada AS dc, status_cursada AS st
	  WHERE aluno.matricula = dc.aluno
	  AND dc.status_dc = st.codigo_status
	  AND st.nome_status = 'Aprovado'
	  GROUP BY aluno.matricula) AS sub

SELECT aluno.nome_aluno, COUNT(*) AS qtd
FROM aluno, disciplina_cursada AS dc, status_cursada AS st
WHERE aluno.matricula = dc.aluno
AND dc.status_dc = st.codigo_status
AND st.nome_status = 'Aprovado'
GROUP BY aluno.nome_aluno
HAVING COUNT(*) = (SELECT MAX(qtd)
				  FROM (SELECT COUNT(*) AS qtd FROM aluno, disciplina_cursada AS dc,
						status_cursada AS st WHERE aluno.matricula = dc.aluno
						AND dc.status_dc = st.codigo_status
						AND st.nome_status = 'Aprovado'
						GROUP BY aluno.matricula) AS sub)

--6) Os nomes e a carga horaria dos cursos que reprovaram algum aluno em 2019.2
--Solução 1
SELECT curso.nome_curso, curso.carga_horaria
FROM curso, aluno, disciplina_cursada AS dc, status_cursada AS sc
WHERE curso.codigo_curso = aluno.curso_aluno
AND aluno.matricula = dc.aluno
AND dc.status_dc = sc.codigo_status
AND sc.nome_status = 'Reprovado'
AND dc.semestre = '20192'

--Solução 2
SELECT curso.nome_curso, curso.carga_horaria
FROM curso, aluno
WHERE curso.codigo_curso = aluno.curso_aluno
AND aluno.matricula IN (SELECT dc.aluno
					   FROM disciplina_cursada AS dc, status_cursada AS sc
					   WHERE dc.status_dc = sc.codigo_status
					   AND sc.nome_status = 'Reprovado'
					   AND dc.semestre = '20192')

--7) Os nomes das disciplinas que tiveram o maior número de reprovações
SELECT disciplina.nome_disc, COUNT(*)
FROM disciplina, disciplina_cursada AS dc, status_cursada AS sc
WHERE dc.status_dc = sc.codigo_status
AND dc.disciplina = disciplina.codigo_disc
AND sc.nome_status = 'Reprovado'
GROUP BY disciplina.nome_disc
HAVING COUNT(*) = (Qual o maior número de reprovações que uma disciplina teve?)

--Qual o maior número de reprovações que uma disciplina teve?
SELECT MAX(qtd_reprova)
FROM (SELECT COUNT(*) AS qtd_reprova
	  FROM disciplina_cursada AS dc, status_cursada AS sc
	  WHERE dc.status_dc = sc.codigo_status
	  AND sc.nome_status = 'Reprovado'
	  GROUP BY dc.disciplina) AS sub

SELECT disciplina.nome_disc, COUNT(*)
FROM disciplina, disciplina_cursada AS dc, status_cursada AS sc
WHERE dc.status_dc = sc.codigo_status
AND dc.disciplina = disciplina.codigo_disc
AND sc.nome_status = 'Reprovado'
GROUP BY disciplina.nome_disc
HAVING COUNT(*) = (SELECT MAX(qtd_reprova)
				   FROM (SELECT COUNT(*) AS qtd_reprova
				         FROM disciplina_cursada AS dc, status_cursada AS sc
						 WHERE dc.status_dc = sc.codigo_status AND sc.nome_status = 'Reprovado'
						 GROUP BY dc.disciplina) AS sub)

--8) Os nomes dos alunos que tem média de nota inferior a média de nota do curso de Computação
SELECT aluno.nome_aluno, AVG(dc.nota)
FROM disciplina_cursada AS dc, curso, aluno
WHERE dc.aluno = aluno.matricula
AND aluno.curso_aluno = curso.codigo_curso
GROUP BY aluno.nome_aluno
HAVING AVG(dc.nota) < (Qual a média de nota do curso de Computação?)

--Qual a média de nota do curso de Computação?
SELECT AVG(nota)
FROM disciplina_cursada AS dc, curso, aluno
WHERE dc.aluno = aluno.matricula
AND aluno.curso_aluno = curso.codigo_curso
AND curso.nome_curso = 'Computação'

SELECT aluno.nome_aluno, AVG(dc.nota) AS media
FROM disciplina_cursada AS dc, curso, aluno
WHERE dc.aluno = aluno.matricula
AND aluno.curso_aluno = curso.codigo_curso
GROUP BY aluno.nome_aluno
HAVING AVG(dc.nota) < (SELECT AVG(nota)
					   FROM disciplina_cursada AS dc, curso, aluno
					   WHERE dc.aluno = aluno.matricula
					   AND aluno.curso_aluno = curso.codigo_curso
					   AND curso.nome_curso = 'Computação')

--10) Os nome dos cursos que possuem a maior quantidade de alunos cursando disciplina em 2020.1
SELECT curso.nome_curso, COUNT(*) AS qtd
FROM disciplina_cursada AS dc, status_cursada AS sc, aluno, curso
WHERE dc.status_dc = sc.codigo_status
AND dc.aluno = aluno.matricula
AND aluno.curso_aluno = curso.codigo_curso
AND dc.semestre = '20201'
AND sc.nome_status = 'Cursando'
GROUP BY curso.nome_curso
HAVING COUNT(*) = (MAIOR?)

--Qual a maior quantidade de aluno cursando disciplinas por curso em 2020.1?
SELECT MAX(qtd)
FROM (SELECT COUNT(*) AS qtd
FROM disciplina_cursada AS dc, status_cursada AS sc, aluno
WHERE dc.status_dc = sc.codigo_status
AND dc.aluno = aluno.matricula
AND dc.semestre = '20201'
AND sc.nome_status = 'Cursando'
GROUP BY aluno.curso_aluno) AS sub

SELECT curso.nome_curso, COUNT(*) AS qtd
FROM disciplina_cursada AS dc, status_cursada AS sc, aluno, curso
WHERE dc.status_dc = sc.codigo_status
AND dc.aluno = aluno.matricula
AND aluno.curso_aluno = curso.codigo_curso
AND dc.semestre = '20201'
AND sc.nome_status = 'Cursando'
GROUP BY curso.nome_curso
HAVING COUNT(*) = (SELECT MAX(qtd)
				   FROM (SELECT COUNT(*) AS qtd
						 FROM disciplina_cursada AS dc, status_cursada AS sc, aluno
						 WHERE dc.status_dc = sc.codigo_status
						 AND dc.aluno = aluno.matricula
						 AND dc.semestre = '20201'
						 AND sc.nome_status = 'Cursando'
						 GROUP BY aluno.curso_aluno) AS sub)

--11) Qual a quantidade total de créditos aprovados por cada aluno?
SELECT aluno.nome_aluno, SUM(disciplina.creditos) AS total
FROM disciplina, disciplina_cursada AS dc, status_cursada AS sc, aluno
WHERE disciplina.codigo_disc = dc.disciplina
AND dc.status_dc = sc.codigo_status
AND aluno.matricula = dc.aluno
AND sc.nome_status = 'Aprovado'
GROUP BY aluno.nome_aluno

--12) Qual o nome e o curso do alunos que tem a maior quantidade total de créditos aprovados?
SELECT aluno.nome_aluno, curso.nome_curso, SUM(disciplina.creditos) AS total
FROM disciplina, disciplina_cursada AS dc, status_cursada AS sc, aluno, curso
WHERE disciplina.codigo_disc = dc.disciplina
AND dc.status_dc = sc.codigo_status
AND aluno.matricula = dc.aluno
AND aluno.curso_aluno = curso.codigo_curso
AND sc.nome_status = 'Aprovado'
GROUP BY aluno.nome_aluno, curso.nome_curso
HAVING SUM(disciplina.creditos) = (Maior quantidade total de créditos aprovados por um aluno)

--Qual a maior quantidade total de créditos aprovados por um aluno?
SELECT MAX(total)
FROM (SELECT SUM(disciplina.creditos) AS total
FROM disciplina, disciplina_cursada AS dc, status_cursada AS sc
WHERE disciplina.codigo_disc = dc.disciplina
AND dc.status_dc = sc.codigo_status
AND sc.nome_status = 'Aprovado'
GROUP BY dc.aluno) AS sub

SELECT aluno.nome_aluno, curso.nome_curso, SUM(disciplina.creditos) AS total
FROM disciplina, disciplina_cursada AS dc, status_cursada AS sc, aluno, curso
WHERE disciplina.codigo_disc = dc.disciplina
AND dc.status_dc = sc.codigo_status
AND aluno.matricula = dc.aluno
AND aluno.curso_aluno = curso.codigo_curso
AND sc.nome_status = 'Aprovado'
GROUP BY aluno.nome_aluno, curso.nome_curso

HAVING SUM(disciplina.creditos) = (SELECT MAX(total)
								   FROM (SELECT SUM(disciplina.creditos) AS total
								         FROM disciplina, disciplina_cursada AS dc, status_cursada AS sc
										 WHERE disciplina.codigo_disc = dc.disciplina
										 AND dc.status_dc = sc.codigo_status
										 AND sc.nome_status = 'Aprovado'
										 GROUP BY dc.aluno) AS sub)

--13) Qual o nome do curso que tem menos disciplinas trancadas do que aprovadas?
SELECT curso.nome_curso, COUNT(*)
FROM disciplina_cursada AS disc_aprov, status_cursada AS st_aprova, aluno AS aluno_aprov,
	 disciplina_cursada AS disc_tranc, status_cursada AS st_tranc, aluno AS aluno_tranc, curso
WHERE disc_aprov.status_dc = st_aprova.codigo_status
AND disc_tranc.status_dc = st_tranc.codigo_status
AND aluno_aprov.curso_aluno = disc_aprov.aluno
AND aluno_tranc.curso_aluno = disc_tranc.aluno
AND aluno_aprov.curso_aluno = curso.codigo_curso
AND aluno_tranc.curso_aluno = curso.codigo_curso
AND st_aprova.nome_status = 'Aprovado'
AND st_tranc.nome_status = 'Reprovado'
GROUP BY curso.nome_curso