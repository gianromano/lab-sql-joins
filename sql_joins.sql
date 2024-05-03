USE sakila;

-- 1. List the number of films per category.
SELECT category.category_id, category.name, COUNT(film_category.film_id) 
FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
GROUP BY category.category_id, category.name;

-- 2. Retrieve the store ID, city, and country for each store.
SELECT store.store_id, city.city, country.country
FROM store
LEFT JOIN address ON store.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id;

-- 3. Calculate the total revenue generated by each store in dollars.
SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM store
LEFT JOIN customer ON store.store_id = customer.store_id
LEFT JOIN rental ON customer.customer_id = rental.customer_id
LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY 
store.store_id;

-- 4. Determine the average running time of films for each category.
SELECT category.name, ROUND(AVG(film.length),2) AS avg_running_time
FROM category
RIGHT JOIN film_category ON category.category_id = film_category.category_id
LEFT JOIN film ON film_category.film_id = film_category.film_id
GROUP BY 
category.name;

-- BONUS
-- 5. Identify the film categories with the longest average running time.
SELECT category.name AS category_name, AVG(film.length) AS avg_running_time
FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
LEFT JOIN film ON film_category.film_id = film.film_id
GROUP BY category.name
ORDER BY avg_running_time DESC;

-- 6. Display the top 10 most frequently rented movies in descending order.
SELECT film.title AS movie_title, COUNT(rental.rental_id) AS rental_count
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC
LIMIT 10;
-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 'Yes' 
        ELSE 'No' 
    END AS can_be_rented
FROM 
    film
JOIN 
    inventory ON film.film_id = inventory.film_id
JOIN 
    store ON inventory.store_id = store.store_id
WHERE 
    film.title = 'Academy Dinosaur' 
    AND store.store_id = 1;
-- 8. Provide a list of all distinct film titles, along with their availability status in the inventory. 
SELECT 
    film.title AS film_title, 
    CASE 
        WHEN COUNT(inventory.inventory_id) > 0 THEN 'Available' 
        ELSE 'Not Available' 
    END AS availability_status
FROM 
    film
LEFT JOIN 
    inventory ON film.film_id = inventory.film_id
GROUP BY 
    film.title;


