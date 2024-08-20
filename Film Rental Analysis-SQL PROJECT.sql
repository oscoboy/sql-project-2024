USE SAKILA;
-- 1. Find all the movies which have a rating of PG and length greater than 50 minutes.

-- ANSWER
SELECT title, description, length, rating
FROM film
WHERE length > 50 AND rating = 'PG'
ORDER BY length;

-- 2. Find the total payment received on or after 2006-01-01.

--  ANSWER
SELECT sum(amount) AS 'total payment received'
FROM payment
WHERE payment_date >= '2006-01-01';

-- 3. Which actors have the last name ‘Hopkins’?

-- ANSWER
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name = 'Hopkins';

-- 4. Which last names are not repeated?

-- ANSWER
SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT('actor_id') = 1
ORDER BY last_name ASC;

-- 5. How many unique last names are there?

-- ANSWER
SELECT COUNT(DISTINCT last_name) AS 'unique last name'
FROM actor;

-- 6. Which actor has appeared in the most films? And show the number of films.

-- ANSWER
SELECT a.actor_id, a.first_name, a.last_name, COUNT('film_id') AS film_count
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

-- 7. When is ‘Academy Dinosaur’ due?

-- ANSWER
SELECT f.film_id, rental_date, return_date AS due_date
FROM rental r
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film f
ON i.film_id = f.film_id
WHERE f.title = 'Academy Dinosaur';

-- 8. What is the average running time for all the films?

-- ANSWER
SELECT AVG(length) AS 'average running time'
FROM film;

-- 9. What is the average running time for all the films by category?

-- ANSWER
SELECT cat.category_id, cat.name AS category_name, AVG(f.length) AS 'average running time'
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category cat 
ON fc.category_id = cat.category_id
GROUP BY cat.category_id;

-- 10. What does the query below do and why does it return an empty set?
-- select * from film natural join inventory;

-- ANSWER
-- i. 
/*
The query "select * from film natural join inventory" performs a natural join between columns with the same name in both tables(i.e. FILM and INVETORY TABLES) and combines rows 
where these columns have equal values.
*/

-- ii. 
/*
The query returns an empty set because there are no matching records in both tables.
*/

-- 11. What is the total revenue of all stores?

-- ANSWER
SELECT SUM(amount) AS 'total revenue'
FROM payment;

-- 12. Write a query to get all the full names of customers that have rented sci-fi 
-- movies more than 2 times. Arrange these names in alphabetical order.

-- ANSWER
SELECT CONCAT_WS(' ', c.first_name, c.last_name) AS 'full name'
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film f 
ON i.film_id = f.film_id
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category cat 
ON fc.category_id = cat.category_id
WHERE cat.name = 'Sci-Fi'
GROUP BY c.customer_id
HAVING COUNT(c.customer_id) > 2
ORDER BY 'full name' ASC;

-- 13. Write a query to find the city which generated the maximum revenue for the business.

-- ANSWER
SELECT city
FROM (
	SELECT city_id, city, SUM(amount) AS total_revenue
	FROM city c
	INNER JOIN customer cu
	ON c.city_id = cu.address_id
	INNER JOIN payment p
	ON cu.customer_id = p.customer_id
	GROUP BY city_id
	ORDER BY total_revenue DESC
    ) AS city_revenue
ORDER BY total_revenue DESC
LIMIT 1;

-- 14. Find the names (first and last) of all the actors and customers whose first name 
-- is the same as the first name of the actor with ID 8. Do not return the actor with ID 8 
-- himself.

-- ANSWER
SELECT first_name, last_name
FROM (
    SELECT first_name, last_name 
    FROM actor 
	WHERE actor_id != 8
    UNION
    SELECT first_name, last_name 
    FROM customer
) AS names
	WHERE first_name = (
		SELECT first_name 
        FROM actor 
        WHERE actor_id = 8);

-- 15. In how many film categories is the average difference between the film replacement 
-- cost and the rental rate larger than 17?

-- ANSWER
SELECT COUNT(category_id) AS category_count
FROM (
    SELECT category_id
    FROM film
    INNER JOIN film_category
    ON film.film_id = film_category.film_id
    GROUP BY category_id
    HAVING AVG(replacement_cost - rental_rate) > 17
) AS categories;