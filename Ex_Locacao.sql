CREATE DATABASE Ex_Locacao;
USE Ex_Locacao;

CREATE TABLE Cliente(
	num_cadastro	INT				NOT NULL	IDENTITY(5501,1),
	nome			VARCHAR(70)		NOT NULL,
	logradouro		VARCHAR(150)	NOT NULL,
	num				INT				NOT NULL	CHECK(num > 0),
	cep				CHAR(8)			NULL		CHECK(LEN(cep) = 8)
	
	PRIMARY KEY(num_cadastro)
);

CREATE TABLE Estrela(
	id				INT				NOT NULL	IDENTITY(9901,1),
	nome 			VARCHAR(50)		NOT NULL
	
	PRIMARY KEY(id)
);

CREATE TABLE Filme(
	id 				INT					NOT NULL		IDENTITY(1001,1),
	titulo			VARCHAR(40)			NOT NULL,
	ano				INT					NULL			CHECK(ano <= 2021)
	
	PRIMARY KEY(id)
);

CREATE TABLE DVD(
	num				INT					NOT NULL		IDENTITY(10001,1),
	data_fabricacao	DATE				NULL 			CHECK(data_fabricacao < GETDATE()),
	filme_id		INT					NOT NULL
	
	PRIMARY KEY (num)
	FOREIGN KEY (filme_id) REFERENCES Filme(id)
);

CREATE TABLE Locacao( 
	DVDnum				INT				NOT NULL,
	ClienteNum_cadastro	INT				NOT NULL,
	data_locacao		DATE			NOT NULL		DEFAULT(GETDATE()),
	data_devolucao		DATE			NOT NULL,
	valor				DECIMAL(7,2)	NOT NULL		CHECK(valor > 0)
	
	PRIMARY KEY(DVDnum, ClienteNum_cadastro, data_locacao)
	FOREIGN KEY(DVDnum) REFERENCES DVD(num),
	FOREIGN KEY(ClienteNum_cadastro) REFERENCES Cliente(num_cadastro),
	
	CONSTRAINT devolucao
		CHECK(data_devolucao > data_locacao)
	
);

CREATE TABLE Filme_Estrela(
	Filmeid				INT				NOT NULL,
	Estrelaid			INT				NOT NULL
	
	PRIMARY KEY(Filmeid, Estrelaid)
	FOREIGN KEY(Filmeid) REFERENCES	Filme(id),
	FOREIGN KEY(Estrelaid) REFERENCES Estrela(id)
);

ALTER TABLE Estrela
ADD nome_real	VARCHAR(50) NULL;

ALTER TABLE Filme ALTER COLUMN  titulo	VARCHAR(80)	NOT NULL	

INSERT INTO Filme (titulo, ano) VALUES
('Whiplash',2015),
('Birdman',2015),
('Interestelar',2014),
('A Culpa é das estrelas',2014),
('Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso',2014),
('Sing',2016);

INSERT INTO Estrela (nome, nome_real) VALUES 
('Micheal Keaton','Michael John Douglas'),
('Emma Stone','Emma Jean Stone'),
('MIlles Teller',NULL),
('Steve Carell','Steven John Carell'),
('Jennifer Garner','Jennifer Anne Garner');

INSERT INTO Filme_Estrela VALUES
(1002,9901),
(1002,9902),
(1001,9903),
(1005,9904),
(1005,9905)

INSERT INTO DVD (data_fabricacao, filme_id) VALUES
('2020-12-02',1001),
('2019-10-18',1002),
('2020-04-03',1003),
('2020-12-02',1001),
('2019-10-18',1004),
('2020-04-03',1002),
('2020-12-02',1005),
('2019-10-18',1002),
('2020-04-03',1003);

INSERT INTO Cliente (nome, logradouro, num, cep) VALUES
('Matilde Luz', 'Rua Síria', 150, '03086040'),
('Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
('Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
('Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
('Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110');

INSERT INTO Locacao VALUES
(10001, 5502, '2021-02-18','2021-02-21', 3.50),
(10009, 5502, '2021-02-18','2021-02-21', 3.50),
(10002, 5503, '2021-02-18','2021-02-19', 3.50),
(10002, 5505, '2021-02-20','2021-02-23', 3.00),
(10004, 5505, '2021-02-20','2021-02-23', 3.00),
(10005, 5505, '2021-02-24','2021-02-26', 3.00),
(10001, 5501, '2021-02-24','2021-02-26', 3.50),
(10008, 5501, '2021-02-24','2021-02-26', 3.50)

UPDATE Cliente SET cep = '08411150' WHERE num_cadastro = 5503;

UPDATE Cliente SET cep = '02918190' WHERE num_cadastro = 5504;

UPDATE Locacao SET valor = 3.25
WHERE data_locacao = '2021-02-18' AND ClienteNum_cadastro = 5502

UPDATE Locacao SET valor = 3.10
WHERE data_locacao = '2021-02-24' AND ClienteNum_cadastro = 5501

UPDATE DVD SET data_fabricacao = '2019-07-14' 
WHERE num = 10005;

UPDATE Estrela SET nome = 'Miles Teller' 
WHERE id = 9903
--escrevi errado D:

UPDATE Estrela SET nome_real = 'Miles Alexander Teller'
WHERE nome LIKE '%Miles Teller%';

DELETE FROM Filme 
WHERE titulo = 'Sing';


/*
 * EXERCÍCIOS 27/05/2025
 */

--Informações do Cliente, do filme e da locação
SELECT 	c.num_cadastro,c.nome,
		CONVERT(VARCHAR(10),l.data_locacao, 103) AS data_locacao,
		DATEDIFF(DAY, l.data_locacao, l.data_devolucao) AS dias_alugados,
		f.titulo, f.ano
FROM Cliente c
INNER JOIN Locacao l
ON c.num_cadastro = l.ClienteNum_cadastro
INNER JOIN DVD d
ON d.num = l.DVDnum
INNER JOIN Filme f
ON d.filme_id = f.id
WHERE c.nome LIKE '%Matilde%';

--Nomes da estrela e titulo do filme
SELECT e.nome, e.nome_real, f.titulo
FROM Estrela e
INNER JOIN Filme_Estrela fe
ON e.id = fe.Estrelaid
INNER JOIN Filme f
ON f.id = fe.Filmeid
WHERE f.ano = 2015;

--Titulo do filme e data de fabricação do dvd com diferença de anos
SELECT 	f.titulo,
		CONVERT(VARCHAR(10), d.data_fabricacao, 103),
		CASE
			WHEN (YEAR(GETDATE()) - f.ano) > 6
			THEN 
				CAST(YEAR(GETDATE()) - f.ano AS VARCHAR(2)) + ' anos'
			ELSE 
				CAST(YEAR(GETDATE()) - f.ano AS VARCHAR(2))
			END AS diferenca
FROM Filme f
INNER JOIN DVD d
ON f.id = d.filme_id


/*
 * EXERCÍCIOS 03/06/2025
 */

--1
SELECT 	c.num_cadastro, c.nome, f.titulo, 
		CONVERT(VARCHAR(10), d.data_fabricacao, 103) AS data_fabricacao, 
		l.valor 
FROM Cliente c
INNER JOIN Locacao l 
ON c.num_cadastro = l.ClienteNum_cadastro 
INNER JOIN DVD d 
ON l.DVDnum = d.num 
INNER JOIN Filme f 
ON d.filme_id = f.id
WHERE d.data_fabricacao = (SELECT MAX(data_fabricacao) FROM DVD);

--2
SELECT  c.num_cadastro, c.nome, 
    	CONVERT(VARCHAR(10), l.data_locacao, 103) AS data_locacao, 
    	COUNT(l.DVDnum) AS qtd
FROM Cliente c
INNER JOIN Locacao l ON c.num_cadastro = l.ClienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao;

--3
SELECT  c.num_cadastro, c.nome, 
    	CONVERT(VARCHAR(10), l.data_locacao, 103) AS data_locacao, 
    	SUM(l.valor) AS valor_total
FROM Cliente c
INNER JOIN Locacao l ON c.num_cadastro = l.ClienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, l.data_locacao;

--4
SELECT  c.num_cadastro, c.nome, 
    	CONCAT(c.logradouro, ', ', c.num) AS Endereco, 
    	CONVERT(VARCHAR(10), l.data_locacao, 103) AS data_locacao
FROM Cliente c
INNER JOIN Locacao l ON c.num_cadastro = l.ClienteNum_cadastro
GROUP BY c.num_cadastro, c.nome, c.logradouro, c.num, l.data_locacao
HAVING COUNT(l.DVDnum) > 2;

