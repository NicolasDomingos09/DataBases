CREATE DATABASE EX_Projects;

USE EX_Projects;

CREATE TABLE users(
	id			int				IDENTITY(1,1),
	name		VARCHAR(45),
	username	VARCHAR(45)		UNIQUE,
	password	VARCHAR(45)		DEFAULT('123mudar'),
	email		VARCHAR(45)

	PRIMARY KEY (id)
);

CREATE TABLE projects(
	id				INT			IDENTITY(10001,1),
	name			VARCHAR(45),
	description		VARCHAR(45),
	date_project	date		CHECK(date_project > '2014-09-01')
	PRIMARY KEY (id)
);

CREATE TABLE users_has_projects(
	users_id	INT NOT NULL,
	projects_id	INT NOT NULL
	
	PRIMARY KEY(users_id, projects_id)
	FOREIGN KEY(users_id) REFERENCES users(id),
	FOREIGN KEY(projects_id) REFERENCES projects(id)
);

ALTER TABLE users 
DROP CONSTRAINT UQ__users__F3DBC572D3650CFC;

ALTER TABLE users
ALTER COLUMN username VARCHAR(10)

ALTER TABLE users ADD UNIQUE(username);

ALTER TABLE users ALTER COLUMN password VARCHAR(8)

INSERT INTO users(name, username, email) VALUES
('Maria','Rh_maria', 'maria@empresa.com'),
('Paulo','Ti_paulo', 'paulo@empresa.com'),
('Ana','Rh_ana', 'ana@empresa.com'),
('Clara','Ti_clara', 'clara@empresa.com'),
('Aparecido','Rh_apareci', 'aparecido@empresa.com')

UPDATE users SET password = '123@456' WHERE id = 2
UPDATE users SET password = '55!@cido' WHERE id = 5

INSERT INTO projects(name, description, date_project) VALUES
('Re-folha', 'Refatoração de Folhas','2014-09-05'),
('Manutenção PCs', 'Manutenção PCs','2014-09-06'),
('Auditoria', NULL,'2014-09-07')

INSERT INTO users_has_projects VALUES
(1,10001),
(5,10001),
(3,10003),
(4,10002),
(2,10002)

UPDATE projects SET date_project = '2014-09-12' 
WHERE name LIKE 'Manutenção%'

UPDATE users SET username = 'Rh_cido'
WHERE name Like 'Aparecido'

UPDATE users SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar'

DELETE users_has_projects 
WHERE users_id = 2 AND projects_id = 10002

INSERT INTO users(name, username, email)VALUES 
('Joao', 'Ti_joao', 'joao@empresa.com')

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM users_has_projects

INSERT INTO projects(name, description, date_project) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-09-12')


/*
 * EXERCÍCIOS 27/05/2025
 */
SELECT 	u.id AS id_user, 
		u.name, 
		u.email,
		p.id AS id_project,
		p.name,
		p.description,
		p.date_project
FROM users u INNER JOIN users_has_projects up
ON u.id = up.users_id
INNER JOIN projects p
ON up.projects_id = p.id
WHERE p.name = 'Re-folha'

SELECT p.name
FROM projects p 
LEFT OUTER JOIN users_has_projects up
ON p.id = up.projects_id
WHERE up.projects_id IS NULL

--Aplicação de left outer join
SELECT u.name
FROM users u
LEFT OUTER JOIN users_has_projects up
ON u.id = up.users_id
WHERE up.users_id IS NULL

--Aplicação de right outer join
SELECT u.name
FROM users_has_projects up
RIGHT OUTER JOIN users u
ON u.id = up.users_id
WHERE up.users_id IS NULL


/*
 * EXERCÍCIOS 03/06/2025
 */
 
--1
SELECT COUNT(p.id) AS qty_projects_no_users
FROM projects p
LEFT OUTER JOIN users_has_projects up 
ON p.id = up.projects_id
WHERE up.users_id IS NULL;

--2
SELECT 	p.id, p.name, 
		COUNT(up.users_id) AS qty_users_project
FROM projects p
INNER JOIN users_has_projects up 
ON p.id = up.projects_id
GROUP BY p.id, p.name
ORDER BY p.name ASC;
