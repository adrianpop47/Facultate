USE Inchisoare
INSERT INTO Cladiri
(Denumire, NrEtaje, Cantina)
VALUES('A', 3, 1),('B',2,0),('Centrala',4,1);

INSERT INTO Celule
(IdCladire,Etaj,Capacitate,Tip)
VALUES(1, 2, 3, 'Maxima siguranta'),(1,1,1,'Carcera'),(2,2,3,'Normala'),(2,1,3,'Normala');

INSERT INTO Detinuti
(IdCelula, DataIncarcerare, DataEliberare)
VALUES(1, '2010-07-20', '2023-10-22'),(3, '2019-12-18', '2020-12-18'),(3, '2017-04-12', '2021-06-12'),(4, '2020-12-06', '2021-09-10');

INSERT INTO CartiIdentitate
(IdCI,CNP, Nume, Prenume, DataNasterii, Adresa)
VALUES(1,512374819234, 'Popescu', 'Vasile', '1989-07-20','Nucului 7 Bucuresti'),(2,2345712354678,'Moldovan' ,'Sorin', '1976-04-05', '407 Craiova'),(3,7564098765489,'Muresan','Vladimir','1993-08-12','Libertatii 7, Bucuresti'),(4,7564738475843,'Popescu','Grigore','1988-10-10','Crinilor 5, Braila');

INSERT INTO PersoaneContact
(CNP, Nume, Prenume, Telefon)
VALUES(1424328548123,'Balan', 'Viorel', 743768975),(4354657849382,'Mare', 'Andrei', 743567890),(4324567890345,'Sorescu','Mihai',764567839);

INSERT INTO ContactDetinuti
(IdContact, IdDetinut)
VALUES(1,2),(1,3),(2,2),(3,4);

INSERT INTO Munci
(IdMunca,Denumire, Locatie)
VALUES(1,'Sapat gropi', 'Curte'),(2,'Curatat cartofi', 'Bucatarie'),(3,'Tamplarie', 'Atelier');

INSERT INTO MuncaDetinuti
(IdMunca,IdDetinut,Data,Ora)
VALUES(1,1,'2020-12-07','18:00:00'),(1,2,'2020-11-12','19:00:00'),(3,3,'2020-12-12','15:00:00'),(1,3,'2020-12-07','18:00:00');

INSERT INTO Gardieni
(Nume,Prenume,Salar,Telefon)
VALUES('Popescu', 'Andrei',4000,0754353476),('Marginean','Gabriel',3800,0754486578),('Sorescu','Vasile',4600,0765456789);

INSERT INTO MuncaGardieni
(IdMunca, IdGardian,Data,Ora)
VALUES(1,1,'2020-12-07','18:00:00'),(1,2,'2020-11-12','19:00:00'),(3,3,'2020-12-12','15:00:00'),(2,1,'2020-12-07','18:00:00'),(3,2,'2020-12-12','15:00:00');

--1.Prenumele si numele detinutilor care muncesc in atelier
SELECT C.Prenume, C.Nume
FROM CartiIdentitate C
INNER JOIN Detinuti D ON C.IdCI=D.IdDetinut
INNER JOIN MuncaDetinuti MD ON MD.IdDetinut=D.IdDetinut
INNER JOIN Munci M ON M.IdMunca = MD.IdMunca
WHERE M.Locatie = 'Atelier';

--2.Detinutii care au cel putin o persoana de contact
SELECT C.Prenume, COUNT(PC.IdContact) AS nr_contacte
FROM CartiIdentitate C
INNER JOIN Detinuti D ON C.IdCI=D.IdDetinut
INNER JOIN ContactDetinuti CD ON CD.IdDetinut=D.IdDetinut
INNER JOIN PersoaneContact PC ON PC.IdContact=CD.IdContact
GROUP BY C.Prenume
HAVING COUNT(PC.IdContact) >=1;

--3.Detinutii care muncesc
SELECT DISTINCT C.Prenume 
FROM CartiIdentitate C
INNER JOIN Detinuti D ON C.IdCI=D.IdDetinut
INNER JOIN MuncaDetinuti MD ON MD.IdDetinut=D.IdDetinut
INNER JOIN Munci M ON M.IdMunca=MD.IdMunca;

--4.Gardienii care pazesc minim 2 munci si au salar de ce putin 4000
SELECT G.Prenume, G.Salar, COUNT(G.IdGardian) as nr_munci
FROM Gardieni G
INNER JOIN MuncaGardieni MG ON MG.IdGardian=G.IdGardian
WHERE G.Salar >= 4000
GROUP BY G.Prenume, G.Salar
HAVING COUNT(G.IdGardian) >=2;

--5.Numarul de detinuti din fiecare cladire
SELECT C.Denumire, COUNT(D.IdDetinut) AS nr_detinuti
FROM Cladiri C
INNER JOIN Celule CE ON CE.IdCladire=C.IdCladire
INNER JOIN Detinuti D ON D.IdCelula=CE.IdCelula
GROUP BY C.Denumire


--6.Cladirile in care se afla detinuti care muncesc
SELECT DISTINCT C.Denumire
FROM Cladiri C
INNER JOIN Celule CE ON CE.IdCladire=C.IdCladire
INNER JOIN Detinuti D ON D.IdCelula=CE.IdCelula
INNER JOIN MuncaDetinuti MD ON MD.IdDetinut=D.IdDetinut;


--7.Detinutii care au adresa in Bucuresti si au persoane de contact
SELECT CI.Prenume, CI.Adresa
FROM CartiIdentitate CI
INNER JOIN Detinuti D ON D.IdDetinut=CI.IdCI
INNER JOIN ContactDetinuti CD ON CD.IdDetinut=D.IdDetinut
WHERE CI.Adresa LIKE '%Bucuresti';


--8.Prenumele gardienilor care supravegheaza bucataria
SELECT G.Prenume
FROM Gardieni G
INNER JOIN MuncaGardieni MD ON MD.IdGardian=G.IdGardian
INNER JOIN Munci M ON M.IdMunca=MD.IdMunca
WHERE M.Locatie = 'Bucatarie';

--9.Numele si prenumele detinutilor care lucreaza in luna decembrie
SELECT CI.Prenume,CI.Nume, MD.Data
FROM CartiIdentitate CI
INNER JOIN Detinuti D ON D.IdDetinut=CI.IdCI
INNER JOIN MuncaDetinuti MD ON MD.IdDetinut=D.IdDetinut
WHERE MD.Data LIKE '%-12-%';

--10.Cladirile care au cantina si au detinuti
SELECT C.Denumire
FROM Cladiri C
INNER JOIN Celule CE ON CE.IdCladire=C.IdCladire
INNER JOIN Detinuti D ON D.IdCelula=CE.IdCelula
WHERE C.Cantina = 1;






