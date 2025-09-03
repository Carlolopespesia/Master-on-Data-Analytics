-- 1. Crea el esquema de la BBDD
-- El programma DBeaver ya te lo crea. Solo tienes que ir a tu base de datos / Bases de datos / nombre de la base de datos / esuqemas / public 


-- 2. Muestra los nombres de todas las películas con una clasificación por edades de 'R'
SELECT title
FROM film
WHERE rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un "actor_id" entre 30 y 40
SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original
SELECT title
FROM film
WHERE language_id = original_language_id;

-- 5. Ordena las películas por duración de forma ascendente
SELECT title, length
FROM film
ORDER BY length ASC;

-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Allen%';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla "film" y muestra la clasificación junto con el recuento
SELECT rating, COUNT(*) as total_movies
FROM film
GROUP BY rating;

-- 8. Encuentra el título de todas las películas que son 'PG-13' o tienen una duración mayor a 3 horas en la tabla film
SELECT title
FROM film
WHERE rating = 'PG-13' OR length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas
SELECT MAX(replacement_cost) - MIN(replacement_cost) as variabilidad_coste
FROM film;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD
SELECT MIN(length) as duracion_min, MAX(length) as duracion_max
FROM film;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día
SELECT amount
FROM payment
ORDER BY payment_date DESC
OFFSET 2 LIMIT 1;

-- 12. Encuentra el título de las películas en la tabla "film" que no sean ni 'NC-17' ni 'G' en cuanto a su clasificación
SELECT title
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film
SELECT rating, AVG(length) as average_duration
FROM film
GROUP BY rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos
SELECT title
FROM film
WHERE length > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) as total_revenue
FROM payment;

-- 16. Muestra los 10 clientes con mayor valor de id
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título 'Egg Igby'
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Egg Igby';

-- 18. Selecciona todos los nombres de las películas únicos
SELECT DISTINCT title
FROM film;

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;

-- 20. Encuentra las categorías de películas con promedio de duración superior a 110 minutos
SELECT c.name, AVG(f.length) as avg_duration
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(EXTRACT(DAY FROM return_date - rental_date)) as avg_rental_duration
FROM rental
WHERE return_date IS NOT NULL;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices
SELECT CONCAT(first_name, ' ', last_name) as nombre_completo
FROM actor;

-- 23. Números de alquiler por día, ordenados por cantidad de forma descendente
SELECT DATE(rental_date) as fecha, COUNT(*) as num_alquileres
FROM rental
GROUP BY DATE(rental_date)
ORDER BY num_alquileres DESC;

-- 24. Encuentra las películas con una duración superior al promedio
SELECT title
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 25. Averigua el número de alquileres registrados por mes
SELECT EXTRACT(YEAR FROM rental_date) as año,
       EXTRACT(MONTH FROM rental_date) as mes,
       COUNT(*) as num_alquileres
FROM rental
GROUP BY EXTRACT(YEAR FROM rental_date), EXTRACT(MONTH FROM rental_date)
ORDER BY año, mes;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado
SELECT AVG(amount) as promedio,
       STDDEV(amount) as desviacion_estandar,
       VARIANCE(amount) as varianza
FROM payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
SELECT title
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas
SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING COUNT(*) > 40;

-- 29. Obtener todas las películas y su cantidad disponible en inventario
SELECT f.title, COUNT(i.inventory_id) as cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado
SELECT a.first_name, a.last_name, COUNT(fa.film_id) as num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 31. Obtener películas y sus actores, incluso sin actores asociados
SELECT f.title, GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name)) as actores
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title;

-- 32. Obtener actores y sus películas, incluso sin películas asociadas
SELECT a.first_name, a.last_name, GROUP_CONCAT(f.title) as peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 33. Obtener todas las películas y todos los registros de alquiler
SELECT f.title, r.rental_date
FROM film f
FULL OUTER JOIN inventory i ON f.film_id = i.film_id
FULL OUTER JOIN rental r ON i.inventory_id = r.inventory_id;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado
SELECT c.first_name, c.last_name, SUM(p.amount) as total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'
SELECT *
FROM actor
WHERE first_name = 'Johnny';

-- 36. Renombra la columna "first_name" como Nombre y "last_name" como Apellido
SELECT first_name AS Nombre, last_name AS Apellido
FROM actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor
SELECT MIN(actor_id) as id_mas_bajo, MAX(actor_id) as id_mas_alto
FROM actor;

-- 38. Cuenta cuántos actores hay en la tabla "actor"
SELECT COUNT(*) as total_actores
FROM actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente
SELECT *
FROM actor
ORDER BY last_name ASC;

-- 40. Selecciona las primeras 5 películas de la tabla "film"
SELECT *
FROM film
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos tienen el mismo nombre
SELECT first_name, COUNT(*) as cantidad
FROM actor
GROUP BY first_name
ORDER BY cantidad DESC
LIMIT 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes
SELECT r.rental_id, c.first_name, c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id;

-- 43. Muestra todos los clientes y sus alquileres, incluyendo los que no tienen
SELECT c.first_name, c.last_name, r.rental_id
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id;

-- 44. CROSS JOIN entre film y category
SELECT f.title, c.name
FROM film f
CROSS JOIN category c;
-- Esta consulta no aporta valor real porque genera un producto cartesiano entre películas y categorías,
-- creando combinaciones que no tienen sentido en el contexto del negocio.

-- 45. Actores que han participado en películas de acción
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;

-- 46. Actores que no han participado en películas
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- 47. Nombre de actores y cantidad de películas
SELECT a.first_name, a.last_name, COUNT(fa.film_id) as num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 48. Crear vista actor_num_peliculas
CREATE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) as num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 49. Número total de alquileres por cliente
SELECT c.first_name, c.last_name, COUNT(r.rental_id) as total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 50. Duración total de películas de acción
SELECT SUM(f.length) as duracion_total
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- 51. Crear tabla temporal cliente_rentas_temporal
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as total_rentas
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 52. Crear tabla temporal peliculas_alquiladas
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) as veces_alquilada
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- 53. Películas alquiladas por Tammy Sanders sin devolver
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Tammy'
AND c.last_name = 'Sanders'
AND r.return_date IS NULL
ORDER BY f.title;

-- 54. Actores que han actuado en películas de Sci-Fi
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película 'Spartacus Cheaper' se alquilara por primera vez
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name, a.first_name;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría 'Music'
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que 'Animation'
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
    SELECT category_id
    FROM category
    WHERE name = 'Animation'
)
ORDER BY f.title;

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película 'Dancing Fever'
SELECT f.title
FROM film f
WHERE f.length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER'
)
AND f.title != 'DANCING FEVER'
ORDER BY f.title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas
SELECT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría
SELECT c.name AS category_name, COUNT(r.rental_id) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.category_id, c.name
ORDER BY c.name;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006
SELECT c.name AS category_name, COUNT(f.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE EXTRACT(YEAR FROM f.release_year) = 2006
GROUP BY c.category_id, c.name
ORDER BY c.name;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
SELECT s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st
ORDER BY s.last_name, s.first_name, st.store_id;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals DESC;