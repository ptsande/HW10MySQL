use sakila;
SELECT first_name, last_name FROM actor;

SELECT CONCAT(first_name,' ', last_name) AS Actor_Name FROM actor;

SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "joe";

SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%GEN%";

SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;
