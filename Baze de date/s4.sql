CREATE DATABASE Sem4;
GO

USE Sem4;

CREATE TABLE Tipuri(
id_tip INT PRIMARY KEY IDENTITY,
nume VARCHAR(20)
);

CREATE TABLE Produse(
id_produs INT PRIMARY KEY IDENTITY,
id_tip INT FOREIGN KEY REFERENCES Tipuri(id_tip),
nume VARCHAR(20),
pret FLOAT,
producator VARCHAR(20),
tara_de_origine VARCHAR(20)
);

CREATE OR ALTER PROCEDURE uspAdaugaTip
(@nume varchar(20))
AS BEGIN
	INSERT INTO Tipuri(nume)
	VALUES (@nume);
END

EXEC uspAdaugaTip 'curatenie';
EXEC uspAdaugaTip 'alimentare';
EXEC uspAdaugaTip 'electronice';
EXEC uspAdaugaTip 'textile';
SELECT * FROM Tipuri;

GO
CREATE FUNCTION verificaTip(@nume varchar(20))
RETURNS BIT AS
BEGIN
	DECLARE @OK BIT = 0;
	IF (EXISTS (SELECT nume FROM Tipuri WHERE nume=@nume))
		SET @OK = 1;
	RETURN @OK;
END

GO
PRINT dbo.verificaTip('electronice');
PRINT dbo.verificaTip('vestimentar');

GO
CREATE OR ALTER PROCEDURE uspAdaugaProdus
(@nume VARCHAR(20),
@pret FLOAT,
@producator VARCHAR(20),
@tara_de_origine VARCHAR(20),
@tip VARCHAR(20))
AS
BEGIN
	DECLARE @id_tip INT;
	
	IF(dbo.verificaTip(@tip) = 1)
	BEGIN
		SELECT TOP 1 @id_tip = id_tip FROM Tipuri
		WHERE nume = @tip;
	END
	ELSE
	BEGIN
		EXEC uspAdaugaTip @tip;
		SELECT TOP 1 @id_tip = id_tip FROM Tipuri
		WHERE nume = @tip;
	END

	INSERT INTO Produse(nume, pret, producator, tara_de_origine, id_tip)
	VALUES (@nume, @pret, @producator, @tara_de_origine, @id_tip);
END

EXEC uspAdaugaProdus 'IPhone 11', 3000, 'Apple', 'China', 'electronice';
SELECT * FROM Produse;

EXEC uspAdaugaProdus 'Fram Ursul Polar', 15, 'Litera', 'Romania', 'carti';
SELECT * FROM Tipuri;
SELECT * FROM Produse;

SELECT * FROM Tipuri
INNER JOIN Produse ON Produse.id_tip = Tipuri.id_tip;

go
create function returneazaProduseProducator(
@litera char(1))
returns table
as
return select nume, pret, producator from Produse where producator like @litera + '%';

go
select * from dbo.returneazaProduseProducator('A');
select * from dbo.returneazaProduseProducator('B');

go
CREATE VIEW vwTipuriProduse AS
	SELECT p.nume, p.pret, p.producator, t.nume as Tip
	FROM Tipuri t
	INNER JOIN Produse p
	ON t.id_tip = p.id_tip
	WHERE p.pret > 10 OR p.producator LIKE 'S%';

SELECT * FROM vwTipuriProduse;