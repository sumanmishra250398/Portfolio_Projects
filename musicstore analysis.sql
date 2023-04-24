--basic
--1.senior most employee based on job title
SELECT * FROM employee
ORDER BY levels desc
LIMIT 1;

--2.Which countries have the most Invoices
SELECT billing_country,COUNT(*) FROM invoice
GROUP BY billing_country
ORDER BY COUNT(*) DESC
LIMIT 1;

--3.What are top 3 values of total invoice
SELECT total FROM invoice
ORDER BY TOTAL DESC
LIMIT 3;

--4.city has the best customers i.e Write a query that returns one city that 
----has the highest sum of invoice totals
SELECT billing_city,SUM(total) FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) desc
LIMIT 1;

--5.Who is the best customer i.e Write a query that returns the person who has spent the most money

select customer.customer_id,first_name,last_name,SUM(total) from invoice
INNER JOIN customer ON
     invoice.customer_id=customer.customer_id
group by customer.customer_id
order by SUM(total) desc
limit 1;

--medium
 /* 1.Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A */

select DISTINCT customer.email, customer.first_name, customer.last_name,genre.name from customer 
INNER JOIN invoice ON 
       customer.customer_id=invoice.customer_id
 INNER JOIN invoice_line ON 
        invoice.Invoice_id=  invoice_line.Invoice_id
 INNER JOIN track ON 
         invoice_line.Track_id=track.Track_id
     AND invoice_line.unit_price=track.unit_price
 INNER JOIN genre ON 
          genre.Genre_id = track.Genre_id
 where genre.name='Rock'
 order by customer.email asc;
 
 --2. Let's invite the artists who have written the most rock music in our dataset. Write a 
 --query that returns the Artist name and total track count of the top 10 rock bands

select artist.name,count(*) from artist 
 INNER JOIN album ON
  artist.artist_id = album.artist_id
 INNER JOIN track ON 
   album.album_id = track.album_id
 INNER JOIN genre ON 
    track.genre_id=genre.genre_id
    where genre.name='Rock'
   group by artist.name
   order by count(*) desc
   LIMIT 10;
   
--3. Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the 
--longest songs listed first

select name,milliseconds from track
  where milliseconds >(select avg(milliseconds) from track)
  order by milliseconds desc;
  
 ---Advanced 
 --1. We want to find out the most popular music Genre for each country. We determine the 
 --most popular genre as the genre with the highest amount of purchases. Write a query 
 --that returns each country along with the top Genre. For countries where the maximum 
 --number of purchases is shared return all Genre
  WITH countrywise_genre AS (
  select 
    c.country, 
    g.name, 
    sum(il.quantity) as gerewise_sales, 
    rank() over (
      partition by country 
      order by 
        sum(il.quantity) desc
    ) as ranks 
  from 
    genre g 
    INNER JOIN track t ON g.Genre_id = t.Genre_id 
    INNER JOIN invoice_line il ON il.track_id = t.track_id 
    INNER JOIN invoice i ON il.invoice_id = i.invoice_id 
    INNER JOIN customer c ON c.customer_id = i.customer_id 
  group by 
    c.country, 
    g.name
) 
select 
  country, 
  name 
from 
  countrywise_genre 
where 
  ranks = 1;
      
      
--2. Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amount

  WITH mostspending_customer AS(
  SELECT 
    c.country, 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    sum(total), 
    rank() over (
      partition by c.country 
      order by 
        sum(total) desc
    ) 
  from 
    customer c 
    INNER JOIN invoice i ON c.customer_id = i.customer_id 
  group by 
    c.country, 
    c.customer_id, 
    c.first_name, 
    c.last_name
) 
select 
  country, 
  first_name, 
  last_name, 
  sum 
from 
  mostspending_customer 
where 
  rank = 1;
          
   
   
 
 
