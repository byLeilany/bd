-- 2.3) a)
/*
SELECT DISTINCT al.AlbumId, t.TrackId, COUNT(pt.PlaylistId)
	from Album al
    Inner Join Track t ON t.AlbumId = al.AlbumId
    Inner join PlaylistTrack pt on pt.TrackId = t.TrackId
    GROUP by al.AlbumId, t.TrackId
    HAVING COUNT(pt.PlaylistId) = (SELECT COUNT(p.PlaylistId) from Playlist p)
*/

-- b)
/*
SELECT kdos.ArtistId, kdos.Name
FROM (SELECT k.ArtistId, k.Name, COUNT(*) as 'songsEnPlaylist' 
      FROM (SELECT a.ArtistId, a.Name, pt.PlaylistId 
            FROM Album al
            INNER JOIN Artist a ON al.ArtistId = a.ArtistId
            Inner Join Track t ON t.AlbumId = al.AlbumId
            Inner join PlaylistTrack pt on pt.TrackId = t.TrackId) k
       GROUP by k.ArtistId, k.Name) kdos
 WHERE kdos.songsEnPlaylist = ( SELECT MIN(songsEnPlaylist) FROM (SELECT k.ArtistId, k.Name, COUNT(*) as 'songsEnPlaylist' 
                                                                  FROM (SELECT a.ArtistId, a.Name, pt.PlaylistId 
                                                                        FROM Album al
                                                                        INNER JOIN Artist a ON al.ArtistId = a.ArtistId
                                                                        Inner Join Track t ON t.AlbumId = al.AlbumId
                                                                        Inner join PlaylistTrack pt on pt.TrackId = t.TrackId) k
                                                                   GROUP by k.ArtistId, k.Name)
 )
 */
 
 --2.4) a) quiero playlist que NO tengan NIGNUN track de los artistas X e Y.
 -- no lo hice en AR ni en CRT

/*
SELECT * FROM Playlist p
EXCEPT
SELECT DISTINCT pt.PlaylistId, p.Name
	from Album al
    Inner Join Track t ON t.AlbumId = al.AlbumId
    Inner join PlaylistTrack pt on pt.TrackId = t.TrackId
 	INNER JOIN Playlist p ON p.PlaylistId  = pt.PlaylistId
    INNER JOIN Artist a ON a.ArtistId = al.ArtistId
    WHERE a.Name IN ('Black Sabbath','Chico Buarque')
*/

-- b) quiero ctes que compraron tracks de 1 UNICO genero
/*

INSERT INTO [Customer] ([CustomerId], [FirstName], [LastName], [Address], [City], [Country], [PostalCode], [Phone], [Email], [SupportRepId]) VALUES (6969, 'ho', 'La', '3,Raj Bhavan Road', 'Bangalore', 'India', '560001', '+91 080 22289999', 'puja_srivastava@yahoo.in', 3);

INSERT INTO [Invoice] ([InvoiceId], [CustomerId], [InvoiceDate], [BillingAddress], [BillingCity], [BillingCountry], [BillingPostalCode], [Total]) VALUES (1000, 6969, '2013-12-22 00:00:00', '12,Community Centre', 'Delhi', 'India', '110017', 1.99);
INSERT INTO [Invoice] ([InvoiceId], [CustomerId], [InvoiceDate], [BillingAddress], [BillingCity], [BillingCountry], [BillingPostalCode], [Total]) VALUES (1001, 6969, '2013-12-22 00:00:00', '12,Community Centre', 'Delhi', 'India', '110017', 1.99);

INSERT INTO [InvoiceLine] ([InvoiceLineId], [InvoiceId], [TrackId], [UnitPrice], [Quantity]) VALUES (3000, 1000, 2, 1.99, 1);
INSERT INTO [InvoiceLine] ([InvoiceLineId], [InvoiceId], [TrackId], [UnitPrice], [Quantity]) VALUES (3001, 1000, 4, 1.99, 1);

INSERT INTO [InvoiceLine] ([InvoiceLineId], [InvoiceId], [TrackId], [UnitPrice], [Quantity]) VALUES (3002, 1001, 6, 1.99, 1);

SELECT k.CustomerId, k.FirstName, k.LastName, COUNT(*) as "GenreDistintos"
FROM (SELECT DISTINCT cteLinea.CustomerId, cteLinea.FirstName, cteLinea.LastName, g.GenreId
                FROM (SELECT c.CustomerId, c.FirstName, c.LastName, il.TrackId, i.InvoiceId, il.InvoiceLineId
                      FROM Customer c
                      INNER JOIN Invoice i ON i.CustomerId = c.CustomerId
                      INNER JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId) cteLinea
                INNER join Track t ON t.TrackId = cteLinea.TrackId
                INNER join Genre g ON t.GenreId = g.GenreId
    	ORDER BY cteLinea.CustomerId) k
GROUP BY k.CustomerId, k.FirstName, k.LastName
HAVING COUNT(*) = 1
ORDER BY COUNT(*) 
*/

-- 2.5)
/*
CREATE TABLE [Actor]
(
    [idActor] INTEGER  NOT NULL,
    [nombreActor] NVARCHAR(160)  NOT NULL,
    [edad] INTEGER  NOT NULL,
    CONSTRAINT [PK_Actor] PRIMARY KEY  ([idActor])
);

CREATE TABLE [Genero]
(
    [idGenero] INTEGER  NOT NULL,
    [nombreGenero] NVARCHAR(160)  NOT NULL,
    CONSTRAINT [PK_Genero] PRIMARY KEY  ([idGenero])
);

CREATE TABLE [Serie]
(
    [idSerie] INTEGER  NOT NULL,
    [nombreSerie] NVARCHAR(160)  NOT NULL,
    [idGenero] INTEGER  NOT NULL,
  	[aInicio] DATE  NOT NULL,
  	[aFin] DATE  NOT NULL,
    CONSTRAINT [PK_Serie] PRIMARY KEY  ([idSerie]),
    FOREIGN KEY ([idGenero]) REFERENCES [Genero] ([idGenero]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE [Canal]
(
    [idCanal] INTEGER  NOT NULL,
    [nombreCanal] NVARCHAR(160)  NOT NULL,
    CONSTRAINT [PK_Canal] PRIMARY KEY  ([idCanal])
);

CREATE TABLE [ParticipaEn]
(
    [idActor] INTEGER  NOT NULL,
    [idSerie] INTEGER  NOT NULL,
    CONSTRAINT [PK_PlaylistTrack] PRIMARY KEY  ([idActor], [idSerie]),
    FOREIGN KEY ([idActor]) REFERENCES [Actor] ([idActor]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([idSerie]) REFERENCES [Serie] ([idSerie]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);


 CREATE TABLE [Transmite]
(
    [idCanal] INTEGER  NOT NULL,
    [idSerie] INTEGER  NOT NULL,
    CONSTRAINT [PK_Transmite] PRIMARY KEY  ([idCanal], [idSerie]),
    FOREIGN KEY ([idCanal]) REFERENCES [Canal] ([idCanal]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ([idSerie]) REFERENCES [Serie] ([idSerie]) 
		ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO [Actor] ([idActor], [nombreActor], [edad]) VALUES (1, 'Ryan Gosling', 42);
INSERT INTO [Actor] ([idActor], [nombreActor], [edad]) VALUES (2, 'Emma Stone', 34);
INSERT INTO [Actor] ([idActor], [nombreActor], [edad]) VALUES (3, 'Margot Robbie', 33);
INSERT INTO [Actor] ([idActor], [nombreActor], [edad]) VALUES (4, 'Timothée Chalamet', 27);


INSERT INTO [Genero] ([idGenero], [nombreGenero]) VALUES (1, '<3');
INSERT INTO [Genero] ([idGenero], [nombreGenero]) VALUES (2, 'jajas');

INSERT INTO [Canal] ([idCanal], [nombreCanal]) VALUES (1, 'Canal 13');
INSERT INTO [Canal] ([idCanal], [nombreCanal]) VALUES (2, 'TNT');

INSERT INTO [Serie] ([idSerie], [nombreSerie], [idGenero], [aInicio], [aFin]) VALUES (1, 'La La Land', 1, '2014-06-05', '2019-12-09');
INSERT INTO [Serie] ([idSerie], [nombreSerie], [idGenero], [aInicio], [aFin]) VALUES (2, 'Crazy, Stupid, Love', 2, '2011-03-08', '2011-07-29');
INSERT INTO [Serie] ([idSerie], [nombreSerie], [idGenero], [aInicio], [aFin]) VALUES (3, 'Barbie', 2, '2009-01-01', '2023-07-20');
INSERT INTO [Serie] ([idSerie], [nombreSerie], [idGenero], [aInicio], [aFin]) VALUES (4, 'Paper Man', 2, '2009-01-01', '2009-01-01');
INSERT INTO [Serie] ([idSerie], [nombreSerie], [idGenero], [aInicio], [aFin]) VALUES (5, 'Paper Man', 2, '2012-01-01', '2012-01-01');


INSERT INTO [ParticipaEn] ([idActor], [idSerie]) VALUES (1, 1);
INSERT INTO [ParticipaEn] ([idActor], [idSerie]) VALUES (1, 2);
INSERT INTO [ParticipaEn] ([idActor], [idSerie]) VALUES (2, 1);
INSERT INTO [ParticipaEn] ([idActor], [idSerie]) VALUES (2, 2);
INSERT INTO [ParticipaEn] ([idActor], [idSerie]) VALUES (3, 3);
INSERT INTO [ParticipaEn] ([idActor], [idSerie]) VALUES (3, 3);
INSERT INTO [ParticipaEn] ([idActor], [idSerie]) VALUES (2, 4);



INSERT INTO [Transmite] ([idCanal], [idSerie]) VALUES (1, 3);
INSERT INTO [Transmite] ([idCanal], [idSerie]) VALUES (1, 1);
INSERT INTO [Transmite] ([idCanal], [idSerie]) VALUES (1, 2);
INSERT INTO [Transmite] ([idCanal], [idSerie]) VALUES (1, 3);
*/

-- a)
/*
SELECT ac.nombreActor FROM
    (SELECT a.idActor, a.nombreActor
    FROM Actor a
    WHERE a.edad > 35) ac
    INNER JOIN ParticipaEn pe ON pe.idActor = ac.idActor
    INNER JOIN Serie s ON s.idSerie = pe.idSerie
	WHERE s.nombreSerie = 'La La Land'
*/

-- b)
/*
SELECT eso.idCanal, eso.nombreCanal, COUNT(*) as 'cantSeriesJajas'
FROM (select c.idCanal, c.nombreCanal, g.idGenero
      from Canal c
      INNER JOIN Transmite t On t.idCanal = c.idCanal
      INNER JOIN Serie s ON s.idSerie = t.idSerie
      INNER JOIN Genero g ON g.idGenero = s.idGenero
      WHERE g.idGenero = 2) eso
GROUP BY eso.idCanal, eso.nombreCanal
HAVING COUNT(*) = (SELECT COUNT(*) as 'cantPelis' FROM Serie s WHERE s.idGenero = 2)
*/

-- c)
/*
SELECT a.nombreActor 
from Actor a
INNER JOIN ParticipaEn p ON p.idActor = a.idActor
INNER JOIN Serie s ON s.idSerie = p.idSerie
WHERE s.aFin >= '2020-01-01' AND a.nombreActor in (SELECT ac.nombreActor FROM
                                                      (SELECT a.idActor, a.nombreActor
                                                      FROM Actor a
                                                      WHERE a.edad > 30) ac
                                                      INNER JOIN ParticipaEn pe ON pe.idActor = ac.idActor
                                                      INNER JOIN Serie s ON s.idSerie = pe.idSerie
                                                      WHERE s.nombreSerie = 'La La Land') 
*/
-- d)
/*
SELECT * from Actor a
where a.nombreActor NOT IN (SELECT a.nombreActor
                            from Actor a
                            INNER JOIN ParticipaEn p ON p.idActor = a.idActor
                            INNER JOIN Serie s ON s.idSerie = p.idSerie
                            WHERE s.aFin >= '2020-01-01')
                     AND a.nombreActor in (SELECT ac.nombreActor FROM
                                                      (SELECT a.idActor, a.nombreActor
                                                      FROM Actor a
                                                      WHERE a.edad > 30) ac
                                                      INNER JOIN ParticipaEn pe ON pe.idActor = ac.idActor
                                                      INNER JOIN Serie s ON s.idSerie = pe.idSerie
                                                      WHERE s.nombreSerie = 'La La Land') 
*/

-- e)
/*
select s.idSerie
    from Serie s
    WHERE s.ainicio = (select MIN( s.ainicio ) from Serie s)
*/

-- f)
/*
SELECT p.idActor 
FROM (SELECT k.idActor, COUNT(*) AS 'cantSeries'
       FROM (SELECT a.idActor, p.idSerie
                FROM Actor a
                INNER JOIN ParticipaEn p ON p.idActor = a.idActor) k
      GROUP BY k.idActor
      HAVING cantSeries >= 2) p
*/
-- g)
/*
SELECT p.idSerie 
	FROM (SELECT s.idSerie, s.nombreSerie FROM Serie s) p
    GROUP by p.nombreSerie
	HAVING COUNT(p.nombreSerie) >= 2
*/

-- h)
/*
SELECT c.nombreCanal
	FROM Canal c
	INNER JOIN Transmite t ON t.idCanal = c.idCanal
	WHERE t.idSerie IN (SELECT p.idSerie 
                            FROM (SELECT s.idSerie, s.nombreSerie FROM Serie s) p
                            GROUP by p.nombreSerie
                            HAVING COUNT(p.nombreSerie) >= 2)
*/

--i)
/*
SELECT k.idSerie, k.nombreSerie
FROM (SELECT s.idSerie, s.nombreSerie, AVG (edad) as 'avgEdad'
        FROM Serie s
        INNER JOIN ParticipaEn pe ON pe.idSerie = s.idSerie
        INNER JOIN Actor a ON a.idActor = pe.idActor
        GROUP BY s.idSerie, s.nombreSerie) k
WHERE k.avgEdad = (SELECT MAX( kDos.avgEdad ) 
                  FROM (SELECT s.idSerie, s.nombreSerie, AVG (edad) as 'avgEdad'
                          FROM Serie s
                          INNER JOIN ParticipaEn pe ON pe.idSerie = s.idSerie
                          INNER JOIN Actor a ON a.idActor = pe.idActor
                          GROUP BY s.idSerie, s.nombreSerie) kDos)
*/

-- j)
/*
SELECT g.idGenero, g.nombreGenero 
    FROM Genero g
    INNER JOIN Serie s ON s.idGenero = g.idGenero
    INNER JOIN ParticipaEn pe ON pe.idSerie = s.idSerie
	INNER JOIN Actor a ON a.idActor = pe.idActor
    WHERE a.edad = (SELECT MIN (a.edad)	FROM Actor a)
*/




