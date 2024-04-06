/*
@author Karl Samuel Kassis

This is an sql file to put your queries for SQL coursework. 
You can write your comment in sqlite with -- or /* * /

To read the sql and execute it in the sqlite, simply
type .read sqlcwk.sql on the terminal after sqlite3 musicstore.db.
*/

/* =====================================================
   WARNNIG: DO NOT REMOVE THE DROP VIEW
   Dropping existing views if exists
   =====================================================
*/
DROP VIEW IF EXISTS vNoCustomerEmployee; 
DROP VIEW IF EXISTS v10MostSoldMusicGenres; 
DROP VIEW IF EXISTS vTopAlbumEachGenre; 
DROP VIEW IF EXISTS v20TopSellingArtists; 
DROP VIEW IF EXISTS vTopCustomerEachGenre; 

/*
============================================================================
Task 1: Complete the query for vNoCustomerEmployee.
DO NOT REMOVE THE STATEMENT "CREATE VIEW vNoCustomerEmployee AS"
============================================================================
*/
CREATE VIEW vNoCustomerEmployee AS
select EmployeeId,FirstName,LastName,Title
   from employees
   Where NOT EmployeeId IN (select distinct SupportRepId from customers);
/*SELECT * from vNoCustomerEmployee;
/*
============================================================================
Task 2: Complete the query for v10MostSoldMusicGenres
DO NOT REMOVE THE STATEMENT "CREATE VIEW v10MostSoldMusicGenres AS"
============================================================================
*/
CREATE VIEW v10MostSoldMusicGenres AS
select genres.Name as Genre,sum(Quantity) AS Sales
   from ((tracks inner join invoice_items on invoice_items.TrackId=tracks.TrackId) left join genres on tracks.GenreId=genres.GenreId)
   group by tracks.GenreId
   Order by Sales desc
   limit 10
;

   

/*SELECT * from v10MostSoldMusicGenres;
/*
============================================================================
Task 3: Complete the query for vTopAlbumEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopAlbumEachGenre AS"
============================================================================
*/
CREATE VIEW vTopAlbumEachGenre AS
select b as [Genre],a as [Album],d as Artist,max(c) as [Sales]
   from (
      select albums.title as [a],genres.Name as [b],sum(invoice_items.Quantity) as [c],artists.name as [d],genres.genreId as [e]
      from tracks 
      join invoice_items on invoice_items.TrackId=tracks.TrackId
      join genres on tracks.GenreId=genres.GenreId
      join albums on albums.albumId=tracks.albumId
      join artists on albums.ArtistId=artists.ArtistId
      group by albums.albumId,genres.genreId)
   group by e;
/*SELECT * from vTopAlbumEachGenre;
/*
============================================================================
Task 4: Complete the query for v20TopSellingArtists
DO NOT REMOVE THE STATEMENT "CREATE VIEW v20TopSellingArtists AS"
============================================================================
*/

CREATE VIEW v20TopSellingArtists AS
select c as Artist,count(b) as TotalAlbum,sum(a) as TrackSold
   from (
      select sum(invoice_items.quantity) as [a],albums.title as [b],artists.name as [c]
      from tracks 
      join invoice_items on invoice_items.TrackId=tracks.TrackId
      join genres on tracks.GenreId=genres.GenreId
      join albums on albums.albumId=tracks.albumId
      join artists on albums.ArtistId=artists.ArtistId
      group by albums.title)
   group by c
   order by sum(a) desc
   limit 20;

/*SELECT * from v20TopSellingArtists;
/*
============================================================================
Task 5: Complete the query for vTopCustomerEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopCustomerEachGenre AS" 
============================================================================
*/
CREATE VIEW vTopCustomerEachGenre AS
select a as Genre,b as TopSpender,round(max(c),2) as TotalSpending
   from(
   SELECT genres.name as a, customers.FirstName||' '||customers.LastName as b, sum(invoice_items.quantity*invoice_items.unitprice) as c
      from invoice_items 
      join invoices on invoice_items.invoiceId=invoices.invoiceId
      join customers on customers.customerId=invoices.customerId
      join tracks on tracks.TrackId=invoice_items.TrackId
      join genres on tracks.GenreId=genres.GenreId
      group by genres.genreId,invoices.customerId)
   group by a
;
/*SELECT * from vTopCustomerEachGenre;