use Inchisoare
go

select * from Detinuti
select * from PersoaneContact
select * from ContactDetinuti

go
create or alter function validareDetinut(@idCelula int,@dataIncarcerare date,@dataEliberare date)
returns int
as begin
	declare @ok int
	set @ok=1
	if(not exists(select * from Celule where IdCelula=@idCelula) or @dataIncarcerare > GETDATE() or @dataIncarcerare > @dataEliberare)
	begin
		set @ok=0;
	end
	return @ok
end


go
create or alter procedure procDetinuti
(@idCelula int,
@dataIncarcerare date,
@dataEliberare date)
as begin
	if(dbo.validareDetinut(@idCelula,@dataIncarcerare, @dataEliberare)=0)
	begin
		print 'Detinut invalid'
	end
	else
	begin
		insert into Detinuti(IdCelula,DataIncarcerare, DataEliberare) values (@idCelula, @dataIncarcerare, @dataEliberare)
		select * from Detinuti
		update Detinuti set DataEliberare=@dataEliberare where IdCelula=@idCelula
		delete from Detinuti where IdCelula=@idCelula
		print 'Operatiile CRUD pt tabela Detinuti au fost efectuate cu succes!'
	end
end

go
select * from Detinuti
exec procDetinuti 20, '2020-02-02', '2040-02-02' --eroare idCelula
exec procDetinuti 2, '2030-02-02', '2040-02-02' --eroare dataIncarcerare
exec procDetinuti 2, '2020-02-02', '2010-02-02' --eroare dataEliberare
exec procDetinuti 2, '2020-02-02', '2040-02-02' --succes
select * from Detinuti

go
create or alter function validarePersoaneContact(@cnp numeric(13,0),@nume varchar(50),@prenume varchar(50),@telefon varchar(15))
returns int
as begin
	declare @ok int
	set @ok=1
	if(LEN(@nume) > 50 or LEN(@prenume) > 50 or LEN(@telefon) > 15)
	begin
		set @ok=0;
	end
	return @ok
end

go
create or alter procedure procPersoaneContact
(@cnp numeric(13,0),
@nume varchar(50),
@prenume varchar(50),
@telefon varchar(15))
as begin
	if(dbo.validarePersoaneContact(@cnp,@nume,@prenume,@telefon)=0)
	begin
		print 'Persoana contact invalida'
	end
	else
	begin
		insert into PersoaneContact(CNP,Nume,Prenume, Telefon) 
		values (@cnp, @nume,@prenume,@telefon)
		select * from PersoaneContact
		update PersoaneContact set CNP='9999999999999' where Nume=@nume
		delete from PersoaneContact where Nume=@nume
		print 'Operatiile CRUD pt tabela PersoaneContact au fost efectuate cu succes!'
	end
end	

select * from PersoaneContact
exec procPersoaneContact '1111111111112','a','a',743668975
exec procPersoaneContact '1111111111113','a','a',743668975
exec procPersoaneContact '1111111111114','a','a',743668975
select * from PersoaneContact


go
create or alter function validareContactDetinuti(@idContact int,@idDetinut int)
returns int
as begin
	declare @ok int
	set @ok=1
	if(not exists(select * from PersoaneContact where IdContact=@idContact) or not exists(select * from Detinuti where IdDetinut=@idDetinut) or exists(select * from ContactDetinuti where @idContact=IdContact and @idDetinut = IdDetinut))
	begin
		set @ok=0;
	end
	return @ok
end


go
create or alter procedure procContactDetinuti
(@idContact int,
@idDetinut int)
as begin
	if(dbo.validareContactDetinuti(@idContact,@idDetinut)=0 or not exists(select * from PersoaneContact where IdContact=@idContact + 1))
	begin
		print 'Contact detinut invalid'
	end
	else
	begin
		insert into ContactDetinuti(IdContact, IdDetinut) values (@idContact, @idDetinut)
		select * from ContactDetinuti
		update ContactDetinuti set IdContact=@idContact + 1 where IdContact=@idContact and IdDetinut = @idDetinut
		delete from ContactDetinuti where IdContact = @idContact + 1 and IdDetinut=@idDetinut
		print 'Operatiile CRUD pt tabela ContactDetinuti au fost efectuate cu succes!'
	end
end

select * from ContactDetinuti
exec procContactDetinuti 1,1 -- eroare
exec procContactDetinuti 1001,1001
exec procContactDetinuti 1002,1002
exec procContactDetinuti 1003,1003
select * from ContactDetinuti

go
create or alter view firstView as
select c.Nume
from PersoaneContact c INNER JOIN ContactDetinuti cd on c.IdContact=cd.IdContact  
INNER JOIN Detinuti d on d.IdDetinut=cd.IdDetinut
where c.Nume like 'Nume100%'

go
select * from firstView order by Nume

CREATE NONCLUSTERED INDEX IX_PersoaneContactNume ON PersoaneContact(Nume);


go
create or alter view secondView as
select d.IdDetinut, d.DataIncarcerare
from Detinuti d INNER JOIN ContactDetinuti cd ON d.IdDetinut=cd.IdDetinut
where d.DataIncarcerare like '20%'

go
select * from secondView order by DataIncarcerare

CREATE NONCLUSTERED INDEX IX_DetinutiDataIncarcerare ON Detinuti(DataIncarcerare);

	