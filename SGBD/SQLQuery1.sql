create database Seminar1226sgbd;

use Seminar1226sgbd;

create table Copaci
(
	cod_c int primary key identity,
	soi varchar(30),
	inaltime int,
	data_plantarii date,
	regiune_geo varchar(20),
	nr_de_cuiburi int
)