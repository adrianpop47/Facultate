CREATE DATABASE S2226;
GO
USE S2226;

CREATE TABLE Clienti
(cod_c INT PRIMARY KEY IDENTITY,
nume_client VARCHAR(100)
);

CREATE TABLE Comenzi (cod_com INT PRIMARY KEY IDENTITY, nr_com INT, cod_c INT FOREIGN KEY REFERENCES Clienti(cod_c), localitate_de_livrare VARCHAR(100), valoare_com INT ); INSERT INTO Clienti (nume_client) VALUES ('Bob'), ('John'),('Jack'),('Anne'); INSERT INTO Comenzi (nr_com,cod_c,localitate_de_livrare,valoare_com) VALUES (121,1,'Sibiu',1000),(122,1,'Sibiu',2000),(123,1,'Cluj-Napoca',400), (124,2,'Sibiu',2000),(125,3,'Oradea',5000),(126,NULL,'Brasov',8000); SELECT * FROM Clienti; SELECT * FROM Comenzi; SELECT * FROM Clienti C INNER JOIN Comenzi CO ON C.cod_c=CO.cod_c; SELECT * FROM Clienti C LEFT JOIN Comenzi CO ON C.cod_c=CO.cod_c; SELECT * FROM Clienti C RIGHT JOIN Comenzi CO ON C.cod_c=CO.cod_c; SELECT * FROM Clienti C FULL JOIN Comenzi CO ON C.cod_c=CO.cod_c; SELECT * FROM Comenzi; SELECT cod_c, localitate_de_livrare, COUNT(cod_com) FROM Comenzi GROUP BY cod_c, localitate_de_livrare;
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

--Afisam clientii care au comenzi --Varianta 1 SELECT C.nume_client FROM Clienti C WHERE C.cod_c IN (SELECT cod_c FROM Comenzi); --Varianta 2 SELECT DISTINCT C.nume_client FROM Clienti C INNER JOIN Comenzi CO ON C.cod_c=CO.cod_c; --Varianta 3 SELECT C.nume_client FROM Clienti C WHERE EXISTS(SELECT * FROM Comenzi CO WHERE CO.cod_c=C.cod_c)

