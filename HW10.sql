USE sakila;
-- Q1a.  Display the first and last names of all actors from the table actor
SELECT first_name, last_name FROM actor;
-- Q1b.  Display First & Last name of all actors in a single column in Uppercase
SELECT CONCAT(first_name,' ', last_name) AS Actor_Name FROM actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "joe";
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%GEN%";
-- 2c. Find all actors whose last names contain the letters LI. Order the rows by last name and first name:
SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD COLUMN description BLOB;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) as COUNT FROM actor 
GROUP BY last_name 
ORDER BY COUNT desc;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) as COUNT FROM actor 
GROUP BY last_name 
HAVING COUNT > 1;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT actor_id FROM actor
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = 172;
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff
JOIN address
USING(address_id);
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select first_name, last_name, SUM(amount)
FROM payment
JOIN staff
USING(staff_id)
WHERE payment_date LIKE "2005-08-%"
GROUP BY staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id)
FROM film_actor
INNER JOIN film ON
film_actor.film_id = film.film_id
GROUP BY film.title;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory_id)
FROM inventory
INNER JOIN film ON
inventory.film_id = film.film_id
WHERE title = "Hunchback Impossible";
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT first_name AS "First Name",
last_name AS "Last Name",
SUM(amount) AS "Total Amount Paid"
FROM customer
JOIN payment
USING(customer_id)
GROUP BY customer_id
ORDER BY last_name;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
(
 SELECT title
 FROM film
 WHERE title like 'K%'
 OR title like 'Q%'
 AND film_id IN
 (
  SELECT language_id
  FROM language
  WHERE name LIKE '%Eng%'
 )
);
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
  (
   SELECT first_name, last_name
   FROM actor
   WHERE actor_id IN
    (
    SELECT actor_id
    FROM film_actor
    WHERE film_id IN
     (
	 SELECT film_id
	 FROM film
	 WHERE title = 'Alone Trip'
   )
  )
 );
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name,
  customer.last_name,
  customer.email,
  country.country
FROM customer
LEFT OUTER JOIN address
  ON customer.address_id=address.address_id
LEFT OUTER JOIN city
  ON address.city_id=city.city_id 
LEFT OUTER JOIN country 
  ON city.country_id=country.country_id
WHERE country LIKE 'CAN%';  
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
  (
   SELECT title
   FROM film
   WHERE film_id IN
    (
    SELECT film_id
    FROM film_category
    WHERE category_id IN
     (
	 SELECT category_id
	 FROM category
	 WHERE name = 'family'
   )
  )
 );
-- 7e. Display the most frequently rented movies in descending order.
-- Tables used:  Rental, Inventory and Film
SELECT title, COUNT(inventory_id) AS Rental_Count
FROM film
JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
GROUP BY film_id
ORDER BY rental_count DESC;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT first_name AS "First Name",
last_name AS "Last Name",
SUM(amount) AS "Total Amount Paid"
FROM customer
JOIN payment
USING(customer_id)
GROUP BY customer_id
ORDER BY last_name;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id);
-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name, COUNT(amount) AS "Gross Revenue"
FROM payment
JOIN rental USING(rental_id)
JOIN inventory USING(inventory_id)
JOIN film_category USING(film_id)
JOIN category USING(category_id)
GROUP BY name
ORDER BY amount DESC
LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_5_Genres_By_Gross_Revenue AS 
SELECT name, COUNT(amount) AS "Gross Revenue"
FROM payment
JOIN rental USING(rental_id)
JOIN inventory USING(inventory_id)
JOIN film_category USING(film_id)
JOIN category USING(category_id)
GROUP BY name
ORDER BY amount DESC
LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM Top_5_Genres_By_Gross_Revenue;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Top_5_Genres_By_Gross_Revenue;