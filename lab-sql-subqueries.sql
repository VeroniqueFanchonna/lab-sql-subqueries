-- USE SAKILA DATABASE
USE sakila;

-- CHALLENGE 1: Number of copies of "Hunchback Impossible"
-- Subquery finds the film_id first
SELECT COUNT(inventory_id) AS total_copies
FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'HUNCHBACK IMPOSSIBLE');

-- CHALLENGE 2: List films longer than the average length
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

-- CHALLENGE 3: Use a subquery to display all actors in "Alone Trip"
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id 
    FROM film_actor 
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'ALONE TRIP')
);

-- BONUS CHALLENGE 4: Identify all movies categorized as family films
-- Logic: film -> film_category -> category
SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id FROM film_category WHERE category_id = (
        SELECT category_id FROM category WHERE name = 'Family'
    )
);

-- BONUS CHALLENGE 5: Name and email of customers from Canada
-- Method 1: Using Subqueries
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id FROM address WHERE city_id IN (
        SELECT city_id FROM city WHERE country_id = (
            SELECT country_id FROM country WHERE country = 'Canada'
        )
    )
);

-- BONUS CHALLENGE 6: Films starred by the most prolific actor
-- 1. Find the actor with the most films, 2. Get their movies
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id FROM film_actor 
    GROUP BY actor_id 
    ORDER BY COUNT(film_id) DESC 
    LIMIT 1;
);

-- BONUS CHALLENGE 7: Films rented by the most profitable customer
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
    SELECT customer_id FROM payment 
    GROUP BY customer_id 
    ORDER BY SUM(amount) DESC 
    LIMIT 1
);

-- BONUS CHALLENGE 8: Clients who spent more than the average total_amount_spent
-- We use a subquery in the FROM clause to calculate totals per client first
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > (
    SELECT AVG(total_customer_spent) FROM (
        SELECT SUM(amount) AS total_customer_spent 
        FROM payment 
        GROUP BY customer_id
    ) AS subquery
);