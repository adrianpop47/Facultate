CREATE DATABASE S2226;
GO
USE S2226;

CREATE TABLE Clienti
(cod_c INT PRIMARY KEY IDENTITY,
nume_client VARCHAR(100)
);

CREATE TABLE Comenzi
--Numarul de comenzi pentru fiecare combinatie (cod_c, localitate_de_livrare)
SELECT cod_c,localitate_de_livrare, COUNT(cod_com) [nr comenzi] FROM Comenzi
GROUP BY cod_c,localitate_de_livrare;

--Pentru fiecare localitate de livrare, se va calcula numarul total de comenzi si valoarea totala a comenzilor
SELECT localitate_de_livrare, COUNT(cod_com) [nr comenzi],
SUM(valoare_com) AS [valoare totala] FROM Comenzi
GROUP BY localitate_de_livrare;

--Pentru fiecare localitate de livrare, se va calcula numarul total de comenzi si valoarea totala a comenzilor,
--iar valoarea totala trebuie sa fie strict mai mare decat 5000
SELECT localitate_de_livrare, COUNT(cod_com) [nr comenzi],
SUM(valoare_com) AS [valoare totala] FROM Comenzi
GROUP BY localitate_de_livrare HAVING SUM(valoare_com)>5000;

--Afisam clientii care au comenzi
