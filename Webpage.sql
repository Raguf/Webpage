CREATE DATABASE Websyte;
USE Websyte;

-- Create tables begin

CREATE TABLE People
(
Id int primary key identity,
Name nvarchar (20)not null,
Surname nvarchar (40) not null,
Age int,
UserId int references Users(Id)
);

CREATE TABLE Users
(
Id int primary key identity ,
UserLogin nvarchar (20) unique not null,
Password nvarchar (20) not null,
Mail nvarchar (100) unique not null,
);

CREATE TABLE Posts
(
Id int primary key identity,
Content nvarchar (255) not null,
ShareDate datetime default(GETUTCDATE()),
LikeCount int,
UserId int references Users(Id),
IsDeleted bit default 0
);

CREATE TABLE Comments
(
id int primary key identity,
UserId int references Users(Id),
PostId int references Posts(Id),
LikeCount int,
IsDeleted bit default 0
);

-- Create tables finish

-- Begin to insert info to tables

INSERT INTO  Users (UserLogin,Password,Mail)
VALUES
('razamamont','razim198989','razim1989@gmail.com'),
('biznesmen56','dollar45euro','isma567@gmail.com'),
('super_driver','suret100','agdsh@gmail.com'),
('busMan9090','azeric1234','BakuBus@gmail.com'),
('minigamer','qobukend','Maqa2007@gmail.com');

INSERT INTO  People
VALUES
('Razim','Memmedov',33,1),
('?smayil','Memmedli',34,2),
('Nizami','Bilalov',37,3),
('Azer','Aliyev',30,4),
('Mehemmed','Eliyev',16,5);

INSERT INTO Posts (UserId, Content, LikeCount)
VALUES
(1,'The best car service in town',1234),
(2,'Great earnings on cryptocurrency',14325),
(4,'Improving service on buses',324),
(3,'Sport cars tuning',7001),
(5,'PUBG in the best game of 2020-2022 years',124308);

INSERT INTO  Comments (UserId, PostId, LikeCount)
VALUES
(1,1,34),
(2,2,567),
(3,3,325),
(4,4,567),
(5,5,325);

-- Finish to insert info to tables

-- Begin tasks

-- Task 1: Postlara gelen comment saylarin gösterin (Group by).

SELECT	p.Content,Count(c.Id) as 'The quantity of comments' FROM Posts as p
INNER JOIN Comments AS c
ON c.PostId=p.Id
GROUP BY p.Content

-- Task 2: Butun dataları gosteren relation qurun, View-da saxlayın.

CREATE VIEW ShowAllInfoView 
AS
SELECT u.UserLogin, u.Mail, u.Password, 
(p.Name + ' ' + p.Surname) AS Fullname, p.Age,
ps.Content, ps.ShareDate, ps.LikeCount, ps.IsDeleted,
c.PostId AS 'Commented to this post', c.LikeCount AS'Comment likes', c.IsDeleted AS DeletedOrNot
FROM Users AS u
INNER JOIN People AS p
ON p.UserId = u.Id
INNER JOIN Posts AS ps
ON ps.UserId = u.Id
INNER JOIN Comments AS c
ON c.UserId = u.Id
SELECT * FROM ShowAllInfoView 

-- Task 3:  Reyi ve ya paylasimi silen zaman ilinməsi evezine IsDeleted deyeri true olsun.

CREATE TRIGGER UpdateInsteadOfDeleteComment 
ON Comments
INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @Id int
	SELECT @Id = Id FROM deleted
	UPDATE Comments SET IsDeleted = 1 Where Id = @Id	
END

DELETE Comments WHERE Id = 5


CREATE TRIGGER UpdateInsteadOfDeletePost
ON Posts
INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @Id int
	SELECT @Id = Id FROM deleted
	UPDATE Posts SET IsDeleted = 1 Where Id = @Id	
END

DELETE Posts WHERE ID = 1

-- Task 4:  LikePost proseduru yaradın, PostId-sini daxil  etdikde uygun olaraq hemin postun like sayı 1 vahid artsın.

CREATE PROCEDURE usp_IncrementPostLikes(@Id int)
AS
UPDATE Posts SET LikeCount += 1
WHERE Posts.Id = @Id

EXEC usp_IncreasePostLikes 1
EXEC usp_IncreasePostLikes 2

-- Task 5:  ResetPassword proseduru yaradın. 
-- İstifadəçi Mail və Login deyerini (2-sinden birini) və yeni parolu parametr olaraq gondərir, 
-- uygun istifadəcinin parolu deyishsin.

CREATE PROCEDURE usp_ResetPassword (@Mail varchar(100), @NewPassword varchar(20))
AS 
UPDATE Users SET Password = @NewPassword
WHERE Users.Mail = @Mail

EXEC usp_ResetPassword @Mail = 'razim1989@gmail.com', @NewPassword = 'razim1986543'