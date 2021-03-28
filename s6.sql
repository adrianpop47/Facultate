create database seminar6;
use seminar6;

create table Tipuri
(
	id_tip int primary key identity,
	descriere varchar(50)
);

create table Trenuri
(
	id_tren int primary key identity,
	nume varchar(25),
	id_tip int foreign key references Tipuri(id_tip)
);

create table Statii
(
	id_statie int primary key identity,
	nume varchar(25)
);

create table Rute
(
	id_ruta int primary key identity,
	nume varchar(25),
	id_tren int foreign key references Trenuri(id_tren)
)

create table RuteStatii
(
	id_ruta int foreign key references Rute(id_ruta),
	id_statie int foreign key references Statii(id_statie),
	ora_sosire time,
	ora_plecare time,
	constraint pk_rutestatii primary key (id_ruta, id_statie)
)

create procedure adaugaTip
(@tip varchar(50))
as begin
	declare @ok as int;
	set @ok = 0;
	if(exists(select * from Tipuri where descriere = @tip))
	begin
		set @ok = 1;
	end
	if(@ok = 0)
	begin
		insert into Tipuri(descriere)
		values (@tip)
	end
end;

go

exec adaugaTip 'cu aburi'
exec adaugaTip 'cu motorina'
exec adaugaTip 'cu motorina'
exec adaugaTip 'cu electric'



create procedure adaugaTren
(@nume varchar(25),
@id_tip int
)
as begin
	if(not exists(select id_tip from Tipuri where id_tip=@id_tip)) begin
		raiserror('Nu exista acest tip', 11, 1);
	end else begin
		insert into Trenuri(nume, id_tip) values(@nume, @id_tip);
	end
end

go
exec adaugaTren 'vechi', 1;
exec adaugaTren 'Thomas', 2;
exec adaugaTren 'marfar', 4;
exec adaugaTren 'maglev', 3;

select * from trenuri;

create procedure adaugaRuta
(@nume varchar(25),
@id_tren int
)
as begin
	if(not exists(select id_tren from Trenuri where id_tren=@id_tren)) 
	begin
		raiserror('Nu exista acest tren', 11, 1);
	end 
	else
	begin
		insert into Rute(nume, id_tren) values(@nume, @id_tren);
	end
end

go
exec adaugaRuta 'Bucuresti -> Constanta', 2;
exec adaugaRuta 'Constanta -> Mangalia', 1;
exec adaugaRuta 'Bucuresti -> Constanta', 5;
exec adaugaRuta 'Iasi -> Timisoara', 3;

select * from Rute;

create procedure adaugaStatie
(@nume varchar(25))
as begin
	if(not exists(select nume from Statii where nume=@nume)) 
	begin
		insert into Statii(nume) values(@nume);
	end
end


exec adaugaStatie 'Bucuresti'
exec adaugaStatie 'Constanta'
exec adaugaStatie 'Cernavoda'
exec adaugaStatie 'Constanta'
exec adaugaStatie 'Medgidia'
exec adaugaStatie 'Mangalia'
exec adaugaStatie 'Costinesti'
exec adaugaStatie 'Eforie Nord'
exec adaugaStatie 'Eforie Sud'
exec adaugaStatie 'Neptun'
exec adaugaStatie 'Tuzla'
exec adaugaStatie 'Costinesti Tabara'
exec adaugaStatie 'Iasi'
exec adaugaStatie 'Timisoara'
exec adaugaStatie 'Cluj-Napoca'
exec adaugaStatie 'Suceava'
exec adaugaStatie 'Nasaud'
exec adaugaStatie 'Oradea'
exec adaugaStatie 'Huedin'

select * from Statii;


create procedure adaugaRutaStatie(
@id_ruta int,
@id_statie int,
@ora_sosire time,
@ora_plecare time)
as begin
    if( not exists( select * from RuteStatii where id_statie=@id_statie and id_ruta=@id_ruta))
        insert into RuteStatii(id_ruta,id_statie,ora_sosire,ora_plecare) values (@id_ruta,@id_statie,@ora_sosire,@ora_plecare)
    else
        update RuteStatii set ora_plecare=@ora_plecare, ora_sosire=@ora_sosire where id_statie=@id_statie and id_ruta=@id_ruta
end;
go

select * from Statii
select * from Rute

exec adaugaRutaStatie 1,1, '12:00', '12:30'
exec adaugaRutaStatie 1,2, '12:00', '14:30'
exec adaugaRutaStatie 1,3, '11:00', '12:30'
exec adaugaRutaStatie 1,4, '12:00', '15:30'
exec adaugaRutaStatie 2,2, '12:00', '12:30'
exec adaugaRutaStatie 2,5, '12:00', '16:30'
exec adaugaRutaStatie 2,6, '8:00', '12:30'
exec adaugaRutaStatie 2,7, '9:00', '11:30'
exec adaugaRutaStatie 2,8, '10:00', '12:30'
exec adaugaRutaStatie 2,9, '12:00', '21:00'
exec adaugaRutaStatie 2,10, '12:00', '12:30'
exec adaugaRutaStatie 3,11, '12:00', '17:30'
exec adaugaRutaStatie 3,12, '12:00', '12:30'
exec adaugaRutaStatie 3,13, '8:00', '12:30'
exec adaugaRutaStatie 3,14, '12:00', '12:30'
exec adaugaRutaStatie 3,15, '9:00', '10:30'
exec adaugaRutaStatie 3,16, '12:00', '12:30'
exec adaugaRutaStatie 3,17, '12:00', '18:30'

select * from RuteStatii
go

go
create or alter view ruteToateStatii as
select r.nume
from Rute r inner join RuteStatii rs on r.id_ruta=rs.id_ruta
group by r.id_ruta, r.nume
having count(*) = (select count(*) from Statii);



go
select * from ruteToateStatii;


exec adaugaRuta 'Deva -> Timisoara',2;
select * from Rute;
select * from Statii;
exec adaugaRutaStatie 4,1,'8:00','8:20';
exec adaugaRutaStatie 4,2,'18:00','20:20';
exec adaugaRutaStatie 4,3,'7:00','10:20';
exec adaugaRutaStatie 4,4,'8:00','8:20';
exec adaugaRutaStatie 4,5,'18:00','19:20';
exec adaugaRutaStatie 4,6,'8:00','18:20';
exec adaugaRutaStatie 4,7,'7:00','8:20';
exec adaugaRutaStatie 4,8,'9:00','15:20';
exec adaugaRutaStatie 4,9,'16:00','17:20';
exec adaugaRutaStatie 4,10,'12:00','14:20';
exec adaugaRutaStatie 4,11,'8:00','8:20';
exec adaugaRutaStatie 4,12,'11:00','12:20';
exec adaugaRutaStatie 4,13,'11:00','13:00';
exec adaugaRutaStatie 4,14,'17:00','19:20';
exec adaugaRutaStatie 4,15,'8:00','8:20';
exec adaugaRutaStatie 4,16,'8:00','8:20';
exec adaugaRutaStatie 4,17,'11:00','21:20';
exec adaugaRutaStatie 4,18,'11:00','21:20';

create or alter function intalnireTrenuri()
returns table as
return select distinct s.nume
from Statii s inner join RuteStatii rs on s.id_statie=rs.id_statie inner join RuteStatii rs2 on rs.id_statie=rs2.id_statie and rs.id_ruta!=rs2.id_ruta
where rs2.ora_sosire between rs.ora_sosire and rs.ora_plecare;



go
select * from intalnireTrenuri();
