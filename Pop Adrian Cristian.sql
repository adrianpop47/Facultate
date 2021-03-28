--1 PK, 0FK : PersoaneContact
--1 PK, 1FK	: Detinuti
--2 PK      : ContactDetinuti

USE Inchisoare;
go

insert into Tables(Name)
values ('PersoaneContact'),('Detinuti'),('ContactDetinuti');
go

--View1 - o tabela
create or alter view View1 as
	select Nume, Prenume
	from PersoaneContact
go


--View2 - doua tabele
create or alter view View2 as
	select IdDetinut, Nume, Prenume
	from ContactDetinuti Inner Join PersoaneContact on ContactDetinuti.IdContact = PersoaneContact.IdContact;
go

--View3 - doua tabele si group by
create or alter view View3 as
	select c.nume, c.prenume, count(*) [Nr Contacte]
	from PersoaneContact c inner Join ContactDetinuti cd on c.IdContact = cd.IdContact
	group by c.Nume, c.Prenume;
go

go
Insert into Views(Name)
values ('View1'),('View2'),('View3');
go

insert into Tests(Name)
values ('insertTable'), ('deleteTable'), ('selectView');
go

Insert into TestViews(TestID, ViewID)
VALUES (3,1),(3,2),(3,3);
go

insert into TestTables(TestID, TableID, NoOfRows, Position)
values (1, 1, 1000, 1), (1, 2, 1000, 2), (1, 3, 1000, 3), (2, 3, 0, 1),(2, 2, 0, 2), (2, 1, 0, 3); 
go


--contact detinuti
create procedure deleteTable1
as begin
	delete from ContactDetinuti;
end
go

--detinuti
create or alter procedure deleteTable2
as begin
	exec deleteTable1
	delete from CartiIdentitate;
	delete from MuncaDetinuti
	delete from Detinuti;
	DBCC CHECKIDENT ('Detinuti', RESEED, 0)
end
go


--persoane contact
create or alter procedure deleteTable3
as begin
	exec deleteTable1
	delete from PersoaneContact;
	DBCC CHECKIDENT ('PersoaneContact', RESEED, 0)  
end
go


--insert in PersoaneContact
Create or alter procedure insertTable1 
as begin 
	DECLARE @id int; --IdContact
	DECLARE @cnp numeric(13); --CNP
	DECLARE @nume varchar(25); --nume si prenume
	DECLARE @NoOfRows int;
	SET @NoOfRows = (SELECT NoOfRows FROM TestTables where TestID = 1 AND Position = 1);
	SET @id = 1;
	WHILE @id <= @NoOfRows
		BEGIN
			SET @nume = 'Nume' + CONVERT(VARCHAR(5), @id);
			SET @cnp = 1424328548123 + @id;
			INSERT INTO PersoaneContact(CNP,Nume,Prenume,Telefon)
			VALUES (@cnp, @nume, @nume, '743768975');
			SET @id = @id + 1;
		END
end
go


--insert in Detinuti
create or alter procedure insertTable2
as begin 
	DECLARE @NoOfRows int;
	SET @NoOfRows = (SELECT NoOfRows FROM TestTables where TestID = 1 AND Position = 2);
	DECLARE @idD int; --IdDetinut
	DECLARE @idC int; --IdCelula
	SET @idD = 1;
	SET @idC = (Select top 1 IdCelula FROM Celule);
	WHILE @idD <= @NoOfRows
		BEGIN
			INSERT INTO Detinuti(IdCelula,DataIncarcerare,DataEliberare)
			VALUES (@idC,'2010-07-20','2030-07-20');
			SET @idD = @idD + 1;
		END
end
go

--insert in ContactDetinuti
Create or alter procedure insertTable3
as begin 
	DECLARE @NoOfRows int;
	DECLARE @idC int; --IdContact
	DECLARE @idD int; --IdDetinut
	DECLARE @i int;
	SET @i=1;
	SET @NoOfRows = (SELECT NoOfRows FROM TestTables where TestID = 1 AND Position = 3);
	DECLARE cursorDetinuti CURSOR 
	FOR SELECT IdDetinut from Detinuti;
	OPEN cursorDetinuti;
	DECLARE cursorContacte CURSOR
	FOR SELECT IdContact from PersoaneContact;
	OPEN cursorContacte;
	WHILE @i <= @NoOfRows
		BEGIN
			FETCH NEXT FROM cursorDetinuti INTO 
					@idD;
			FETCH NEXT FROM cursorContacte INTO 
					@idC;
			INSERT INTO ContactDetinuti(IdContact, IdDetinut)
			VALUES (@idC, @idD);
			SET @i = @i + 1;
		END
	close cursorDetinuti;
	deallocate cursorDetinuti;
	close cursorContacte;
	deallocate cursorContacte;
end
go

--test1: tabela1 + view1
create procedure test1 
as begin
	SET NOCOUNT ON; 
	DECLARE @start DATETIME;
	DECLARE @pause DATETIME;
	DECLARE @end DATETIME;
	SET @start = GETDATE();
	exec deleteTable3;
	exec insertTable1;
	SET @pause = GETDATE();
	SELECT * FROM View1;
	SET @end = GETDATE();
	Print DATEDIFF(ms,@end, @start)
	INSERT INTO TestRuns(Description, StartAt, EndAt)
	VALUES ('Delete, Insert on PersoaneContact and select on View1', @start, @end);
	DECLARE @id int;
	SET @id = (SELECT TestRunID FROM TestRuns WHERE @start = TestRuns.StartAt);
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
	VALUES (@id, 1, @start, @pause);
	INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt)
	VALUES (@id, 1, @pause, @end);	
end
go


--test2: tabela2 + View2
create procedure test2
as begin
	SET NOCOUNT ON; 
	DECLARE @start DATETIME;
	DECLARE @pause DATETIME;
	DECLARE @end DATETIME;
	SET @start = GETDATE();
	exec deleteTable2;
	exec insertTable2;
	SET @pause = GETDATE();
	SELECT * FROM View2;
	SET @end = GETDATE();
	Print DATEDIFF(ms,@end, @start)
	--insert into TestRuns
	INSERT INTO TestRuns(Description, StartAt, EndAt)
	VALUES ('Delete, Insert on Detinuti and select on View2', @start, @end);
	--insert into TestRunTables
	DECLARE @id int;
	SET @id = (SELECT TestRunID FROM TestRuns WHERE @start = TestRuns.StartAt);
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
	VALUES (@id, 2, @start, @pause);
	--insert into TestRunViews
	INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt)
	VALUES (@id, 2, @pause, @end);	
end
go


--test3: tabela3 + View3
create procedure test3
as begin
	SET NOCOUNT ON; 
	DECLARE @start DATETIME;
	DECLARE @pause DATETIME;
	DECLARE @end DATETIME;
	SET @start = GETDATE();
	exec deleteTable1;
	exec insertTable1;
	exec insertTable2;
	exec insertTable3;
	SET @pause = GETDATE();
	SELECT * FROM View3;
	SET @end = GETDATE();
	Print DATEDIFF(ms,@end, @start)
	--insert into TestRuns
	INSERT INTO TestRuns(Description, StartAt, EndAt)
	VALUES ('Delete, Insert on ContactDetinuti and select on View3', @start, @end);
	--insert into TestRunTables
	DECLARE @id int;
	SET @id = (SELECT TestRunID FROM TestRuns WHERE @start = TestRuns.StartAt);
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
	VALUES (@id, 3, @start, @pause);
	--insert into TestRunViews
	INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt)
	VALUES (@id, 3, @pause, @end);	
end
go


exec test3;
select * from TestRuns;
select * from TestRunTables;
select * from TestRunViews;