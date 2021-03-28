USE Inchisoare;
go

CREATE TABLE Versiuni
(Versiune int)

INSERT INTO Versiuni
(Versiune)
VALUES(0);

GO
--modifica tipul unei coloane
CREATE PROCEDURE proc1 AS
BEGIN
	ALTER TABLE Cladiri
	ALTER COLUMN NrEtaje bigint;
	UPDATE Versiuni
	SET Versiune = Versiune + 1;
	PRINT 'Coloana NrEtaje din tabela Cladiri a revenit la forma initiala'
END

GO
--modifica tipul unei coloane inapoi;
CREATE PROCEDURE proc1_undo AS
BEGIN
	ALTER TABLE Cladiri
	ALTER COLUMN NrEtaje int;
	UPDATE Versiuni
	SET Versiune = Versiune - 1;
	PRINT 'Coloana NrEtaje din tabela Cladiri a fost modificata'
END

GO
--adauga o costrângere de “valoare implicita” pentru un câmp;
CREATE PROCEDURE proc2 AS
BEGIN
	ALTER TABLE Celule
	ADD CONSTRAINT capacitateDefault DEFAULT 3 FOR Capacitate;
	UPDATE Versiuni
	SET Versiune = Versiune + 1;
	PRINT 'Valoarea implicita pentru capacitatea unei celule a fost setata'
END

GO
--sterge o costrângere de “valoare implicita” pentru un câmp;
CREATE PROCEDURE proc2_undo AS
BEGIN
	ALTER TABLE Celule
	DROP CONSTRAINT capacitateDefault;
	UPDATE Versiuni
	SET Versiune = Versiune - 1;
	PRINT 'Valoarea implicita pentru capacitatea unei celule a fost stearsa'
END

GO
--creeaza o tabela;
CREATE PROCEDURE proc3 AS
BEGIN
	CREATE TABLE DosareMedicaleDetinuti(
	IdDosar INT PRIMARY KEY,
	IdDetinut INT
	);
	UPDATE Versiuni
	SET Versiune = Versiune + 1;
	PRINT 'A fost creeata tabela DosareMedicaleDetinuti'
END

GO
--sterge o tabela;
CREATE PROCEDURE proc3_undo AS
BEGIN
	DROP TABLE DosareMedicaleDetinuti;
	UPDATE Versiuni
	SET Versiune = Versiune - 1;
	PRINT 'A fost stearsa tabela DosareMedicaleDetinuti'
END


GO
-- adauga un câmp nou;
CREATE PROCEDURE proc4 AS
BEGIN
	ALTER TABLE Detinuti
	ADD Infractiune varchar(30);
	UPDATE Versiuni
	SET Versiune = Versiune + 1;
	print 'Coloana Infractiune a fost adaugata la tabela Detinuti'
END

GO
--sterge un câmp;
CREATE PROCEDURE proc4_undo AS
BEGIN
	ALTER TABLE Detinuti
	DROP COLUMN Infractiune;
	UPDATE Versiuni
	SET Versiune = Versiune - 1;
	print 'Coloana Infractiune a fost stearsa din tabela Detinuti'
END


GO
-- creeaza o constrângere de cheie straina.
CREATE PROCEDURE proc5 AS
BEGIN
	ALTER TABLE DosareMedicaleDetinuti
	ADD CONSTRAINT fk_dosar FOREIGN KEY (IdDetinut) REFERENCES Detinuti(IdDetinut);
	UPDATE Versiuni
	SET Versiune = Versiune + 1;
	PRINT 'Cheia straina fk_dosar a fost adaugat la tabela DosareMedicaleDetinuti'
END

GO
-- sterge o constrângere de cheie straina.
CREATE PROCEDURE proc5_undo AS
BEGIN
	ALTER TABLE DosareMedicaleDetinuti
	DROP CONSTRAINT fk_dosar;
	UPDATE Versiuni
	SET Versiune = Versiune - 1;
	PRINT 'Cheia straina fk_dosar a fost stearsa din tabela DosareMedicaleDetinuti'
END


GO
CREATE PROCEDURE updateVersiune @versiune int AS
BEGIN 
	DECLARE @versiuneCurenta int;
	DECLARE @versiuneChar CHAR;
	SET @versiuneCurenta = (SELECT Versiune FROM Versiuni);

	IF @versiune < 0 OR @versiune > 5
	BEGIN
		RAISERROR ('Nu exista aceasta versiune!', 10, 1);
	END
	ELSE
	BEGIN
		IF @versiuneCurenta = @versiune
		BEGIN
			RAISERROR ('Baza de date este deja la aceasta versiune', 10, 1);
		END
		ELSE
		BEGIN
			DECLARE @procedura varchar(20);
			IF @versiune<@versiuneCurenta
			BEGIN
				WHILE @versiune<@versiuneCurenta
				BEGIN
					SET @versiuneChar = CAST(@versiuneCurenta AS CHAR);
					SET @procedura = 'proc' + @versiuneChar  + '_' + 'undo';
					exec @procedura;
					SET @versiuneCurenta = @versiuneCurenta - 1;
				END
			END
			ELSE
			BEGIN
			WHILE @versiune>@versiuneCurenta
				BEGIN
					SET @versiuneCurenta = @versiuneCurenta + 1;
					SET @versiuneChar = CAST(@versiuneCurenta AS CHAR);
					SET @procedura = 'proc' + @versiuneChar;
					exec @procedura;
				END
			END
		END
	END
END

EXEC updateVersiune 2;

