
USE sakila;

#1a
SELECT first_name, last_name
FROM actor;

#1b
SELECT CONCAT(UCASE(first_name), ' ', UCASE(last_name)) AS 'Actor Name'
FROM actor;

#2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name like '%Joe%';

#2b
SELECT last_name
FROM actor
WHERE last_name like '%GEN%';

#2c
SELECT last_name, first_name
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;

#2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER TABLE actor 
ADD COLUMN middle_name
VARCHAR(120);

SELECT first_name, middle_name, last_name
FROM actor;

#3b
ALTER TABLE actor
MODIFY middle_name blob;

#3c
ALTER TABLE actor
DROP COLUMN middle_name;

#4a
SELECT last_name, COUNT(last_name) AS 'Count by Last Name'
FROM actor
GROUP BY last_name;

#4b
SELECT last_name, COUNT(last_name) AS 'Count by Last Name'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

#4c
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO';

#4d
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'HARPO' and last_name = 'WILLIAMS';

UPDATE actor
SET first_name =
	CASE 
		WHEN first_name = 'HARPO'
			THEN 'GROUCHO'
		ELSE 'MUCHO GROUCHO'
	END
WHERE actor_id = 172;

#5a 

SHOW COLUMNS from sakila.address;

SHOW CREATE TABLE sakila.address;

/*

'CREATE TABLE `address` (\n  `address_id` smallint(5) unsigned 
NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) 
NOT NULL,\n  `address2` varchar(50) 
DEFAULT NULL,\n  `district` varchar(20) 
NOT NULL,\n  `city_id` smallint(5) unsigned 
NOT NULL,\n  `postal_code` varchar(10) 
DEFAULT NULL,\n  `phone` varchar(20) 
NOT NULL,\n  `location` geometry NOT NULL,\n  `last_update` timestamp 
NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  
PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  
SPATIAL KEY `idx_location` (`location`),\n  
CONSTRAINT `fk_address_city` 
FOREIGN KEY (`city_id`) 
REFERENCES `city` (`city_id`) 
ON UPDATE CASCADE\n) 
ENGINE=InnoDB 
AUTO_INCREMENT=606 
DEFAULT CHARSET=utf8'
*/

#6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address
ON address.address_id = staff.address_id;

#6b
 SELECT staff.first_name, staff.last_name, staff.staff_id, SUM(amount) as 'Total Amount'
 FROM staff
 INNER JOIN payment
 ON payment.staff_id = staff.staff_id
 GROUP BY staff.staff_id;

#6c

SELECT title, count(actor_id) AS 'No. of Actors'
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

#6d
SELECT title, COUNT(film_id) AS 'No. of Copies'
FROM film
WHERE title = 'Hunchback Impossible';

#6e
SELECT customer.last_name, SUM(amount) AS 'Total Paid by Customer'
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id;

#7a
SELECT title
FROM film
WHERE language_id IN
	(SELECT language_id
    FROM language
    WHERE name = 'English')
AND title LIKE 'K%' OR title LIKE 'Q%';
  
#7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
    FROM film_actor
	WHERE film_id IN 
		(SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'));

#7c
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
LEFT JOIN address
ON customer.address_id = address.address_id
LEFT JOIN city
ON city.city_id = address.city_id
LEFT JOIN country
ON country.country_id = city.country_id
WHERE country = 'Canada';

#7d
SELECT * 
FROM film
WHERE film_id IN
	(SELECT film_id FROM film_category
    WHERE category_id IN
		(SELECT category_id FROM category
        WHERE name = 'Family'));

#7e
SELECT film.title, COUNT(rental.rental_id) AS 'No. of Rentals'
FROM film
RIGHT JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental
ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

#7f
SELECT store.store_id, sum(amount) as 'Revenue' 
FROM store
RIGHT JOIN staff
ON staff.store_id = staff.store_id
LEFT JOIN payment 
ON staff.staff_id = payment.staff_id
GROUP BY staff.store_id;

#7g
SELECT store.store_id, city.city, country.country 
FROM store
JOIN address
ON store.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id;

#7h
SELECT category.name, sum(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental 
ON rental.inventory_id = inventory.inventory_id
JOIN payment
ON payment.rental_id = rental.rental_id
GROUP BY name;

#8a
CREATE VIEW Top_Five_Genre AS
SELECT category.name, sum(payment.amount) as 'Gross Revenue' 
FROM category
JOIN film_category 
ON category.category_id = film_category.category_id
JOIN inventory 
ON film_category.film_id = inventory.film_id
JOIN rental
ON rental.inventory_id = inventory.inventory_id
JOIN payment
ON payment.rental_id = rental.rental_id
GROUP BY name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8b
SELECT *
FROM Top_Five_Genre;

#8c
DROP VIEW Top_Five_Genre;