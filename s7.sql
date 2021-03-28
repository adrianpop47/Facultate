create database Seminar7
go
use Seminar7
go


create table Mesaje(
cod_mesaj int Primary Key Identity,
destinatar varchar(30),
expeditor varchar(30),
mesaj varchar(30),
dataTrimitere date,
rating int,
importanta varchar(30)
)


insert into Mesaje(destinatar,expeditor,mesaj,dataTrimitere,rating,importanta)
values ('Denisa','Oana','Salut','2020-11-1',10,'Neimportant'),
('Oana','Denisa','Hello','2020-11-1',10,'Neimportant'),
('Cristi','Bogdan','Cf','2019-11-2',9,'Important'),
('Bogdan','Cristi','Bnnnn','2019-11-3',10,'Neimportant'),
('Cristi','Bogdan','Hai la bere','2019-11-3',10,'Extrem de important'),
('Bogdan','Cristi','On my way','2019-11-3',10,'Important'),
('Alina','Gabriela','Nu vrem examen!!!','2020-1-11',10,'Foarte important'),
('Gabriela','Alina','Asta este','2020-1-11',10,'Neimportant')
go



create view vwMesaje with schemabinding as
select destinatar, expeditor, mesaj, rating
from dbo.Mesaje
where importanta='Neimportant'
go


select* from vwMesaje
go



alter table Mesaje
drop column mesaj
go



create unique clustered index ix_vwMesaje on
vwMesaje(destinatar,expeditor,mesaj)	
go

select destinatar, expeditor, mesaj, rating,[rating explicit]=CASE rating
when 10 then 'Mesaj fantastic'
when 9 then 'Mesaj aproape fantastic'
when 8 then 'Mesaj nu foarte fantastic'
when 7 then 'Mesaj decent'
when 6 then 'Mesaj ok'
when 5 then 'Mesaj mediocru'
when 4 then 'Mesaj nesatisfacator'
when 3 then 'Mesaj si mai nesatisfacator'
when 2 then 'Mesaj naspa'
when 1 then 'Mesaj oribil'
else 'Nespecificat'
end 
from Mesaje

select destinatar,expeditor,mesaj,dataTrimitere,rating,importanta,categorie_rating = case
when rating < 0 then 'rating negativ'
when rating = 0 then 'rating neutru'
when rating > 0 then 'rating pozitiv'
else 'rating nespecificat'
end
from Mesaje;



insert into Mesaje(destinatar,expeditor,mesaj,dataTrimitere,rating,importanta) values
('Oana','Adriana','Ce faci?','2021-01-10',null,'Neimportant')
insert into Mesaje(destinatar,expeditor,mesaj,dataTrimitere,rating,importanta) values
('Adriana','Oana','Bineee tu?','2021-01-10',0,'Neimportant')