create database seminar3
go
use seminar3
go

create table Filme
(
	id int primary key identity,
	titlu varchar(30),
	durata time,
	gen varchar(30),
	regizor varchar(30),
	buget bigint
)

create procedure uspAdaugaFilme
(@titlu varchar(30),
@durata time,
@gen varchar(30),
@regizor varchar(30),
@buget bigint)
as
begin
	insert into Filme(titlu, durata, gen, regizor, buget)
	values(@titlu, @durata, @gen, @regizor, @buget);
	print 'S-a inserat filmul cu titlul ' + @titlu;
end;

exec uspAdaugaFilme 'IT Part2', '2:00:00', 'horror', 'Andy', 12000000;

exec uspAdaugaFilme 'IT', '1:50:00', 'horror', 'Andy', 12000;

exec uspAdaugaFilme 'Harry Potter', '2:00:00', 'aventura', 'David Yates', 12000000;

exec uspAdaugaFilme 'Avatar', '2:30:00', 'sf', 'James Cameron', 12000000;

exec uspAdaugaFilme 'Tenet', '2:30:00', 'sf', 'Christopher Nolan', 12000000;
select * from Filme;

create procedure uspAfiseazaFilmeGen
(@gen varchar(30)
)
as
begin
	select * from Filme
	where gen=@gen;
end;

exec uspAfiseazaFilmeGen 'sf';

create procedure uspNrFilmeRegizor
(@regizor varchar(30)
)
as
begin
	declare @nr int;
	set @nr=0;
	select @nr=COUNT(id)
	from Filme
	where regizor = @regizor
	group by regizor;

	declare @msg varchar(100)
	set @msg='Nu exista filme cu regizorul ' + @regizor;
	if (@nr=0)
		raiserror(@msg, 11, 1);
	else
		print @nr;
end;

exec uspNrFilmeRegizor 'asd';

go
create or alter procedure uspUpdate
(@titlu varchar(30),
@bugetNou bigint
)
as
begin
	update Filme
	set buget=@bugetNou
	where titlu=@titlu;

	if (@@ROWCOUNT = 0)
		raiserror('Nu s-a actualizat nimic',9,1)
	else
		print 'S-a actualizat bugetul'
end;


begin try
	exec uspUpdate 'I', 100000;
end try
begin catch
	print ERROR_MESSAGE()
	print ERROR_PROCEDURE()
	print ERROR_LINE()
end catch;