/**********************************************************************/
-- ESERCIZI QUERY DATABASE DVD RENTAL DRUV CHERIS JHURRY --
/*********************************************************************/

---
-- 1. Elenca i film con la loro categoria
---
SELECT
  f.title AS titolo_film,
  c.name AS nome_categoria
FROM
  film AS f
JOIN
  film_category AS fc ON f.film_id = fc.film_id
JOIN
  category AS c ON fc.category_id = c.category_id;

---
-- 2. Mostra gli attori che hanno recitato in "Academy Dinosaur"
---
SELECT
  a.first_name,
  a.last_name
FROM
  actor AS a
JOIN
  film_actor AS fa ON a.actor_id = fa.actor_id
JOIN
  film AS f ON fa.film_id = f.film_id
WHERE
  f.title = 'Academy Dinosaur';

---
-- 3. Clienti con la loro città e paese
---
SELECT
  c.first_name,
  c.last_name,
  ci.city,
  co.country
FROM
  customer AS c
JOIN
  address AS a ON c.address_id = a.address_id
JOIN
  city AS ci ON a.city_id = ci.city_id
JOIN
  country AS co ON ci.country_id = co.country_id;

---
-- 4. Mostra tutti i film e la loro lingua (anche se la lingua è NULL)
---
SELECT
  f.title,
  l.name AS lingua
FROM
  film AS f
LEFT JOIN
  language AS l ON f.language_id = l.language_id;

---
-- 5. Film con durata maggiore di 120 minuti
---
SELECT
  title,
  length AS durata_film
FROM
  film
WHERE
  length > 120;

---
-- 6. Categorie con media durata dei film maggiore di 100 minuti
---
SELECT
  c.name
FROM
  category AS c
WHERE (
  SELECT AVG(f.length)
  FROM film AS f
  JOIN film_category AS fc ON f.film_id = fc.film_id
  WHERE fc.category_id = c.category_id
) > 100;

---
-- 7. Città con almeno 2 clienti
---
SELECT
  ci.city
FROM
  city AS ci
WHERE (
  SELECT COUNT(cu.customer_id)
  FROM customer AS cu
  JOIN address AS a ON cu.address_id = a.address_id
  WHERE a.city_id = ci.city_id
) >= 2;

---
-- 8. Film più lunghi della durata media
---
SELECT
  title,
  length
FROM
  film
WHERE
  length > (SELECT AVG(length) FROM film);

---
-- 9. Clienti che hanno noleggiato almeno un film
---
SELECT
  first_name,
  last_name
FROM
  customer
WHERE EXISTS (
  SELECT 1
  FROM rental
  WHERE rental.customer_id = customer.customer_id
);

---
-- 10. Attori che NON hanno recitato in nessun film
---
SELECT
  first_name,
  last_name
FROM
  actor
WHERE NOT EXISTS (
  SELECT 1
  FROM film_actor
  WHERE film_actor.actor_id = actor.actor_id
);

---
-- 11. Film noleggiati da clienti residenti in Italia
---
SELECT DISTINCT
  f.title AS titolo_film
FROM
  country AS co
JOIN
  city AS ci ON co.country_id = ci.country_id
JOIN
  address AS a ON ci.city_id = a.city_id
JOIN
  customer AS c ON a.address_id = c.address_id
JOIN
  rental AS r ON c.customer_id = r.customer_id
JOIN
  inventory AS i ON r.inventory_id = i.inventory_id
JOIN
  film AS f ON i.film_id = f.film_id
WHERE
  co.country = 'Italy';

---
-- 12. Mostra il film più noleggiato
---
SELECT
  f.title AS titolo_film,
  COUNT(r.rental_id) AS numero_noleggi
FROM
  rental AS r
JOIN
  inventory AS i ON r.inventory_id = i.inventory_id
JOIN
  film AS f ON i.film_id = f.film_id
GROUP BY
  f.title
ORDER BY
  numero_noleggi DESC
LIMIT 1;

---
-- 13. Visualizza tutti i dati dei clienti
---
SELECT * FROM customer;

---
-- 14. Visualizza solo nome e cognome dei clienti
---
SELECT
  first_name,
  last_name
FROM
  customer;

---
-- 15. Trova tutti i clienti attivi
---
SELECT
  first_name,
  last_name
FROM
  customer
WHERE
  activebool = TRUE;

---
-- 16. Elenca tutti i titoli dei film
---
SELECT title FROM film;

---
-- 17. Trova tutti i film della categoria 'Action'
---
SELECT
  f.title
FROM
  film AS f
JOIN
  film_category AS fc ON f.film_id = fc.film_id
JOIN
  category AS c ON fc.category_id = c.category_id
WHERE
  c.name = 'Action';

---
-- 18. Trova i clienti che vivono in Canada
---
SELECT
  c.first_name,
  c.last_name
FROM
  customer AS c
JOIN
  address AS a ON c.address_id = a.address_id
JOIN
  city AS ci ON a.city_id = ci.city_id
JOIN
  country AS co ON ci.country_id = co.country_id
WHERE
  co.country = 'Canada';

---
-- 19. Conta quanti film ci sono in totale
---
SELECT COUNT(*) AS totale_film FROM film;

---
-- 20. Conta quanti clienti sono attivi
---
SELECT COUNT(*) AS clienti_attivi FROM customer WHERE activebool = TRUE;

---
-- 21. Elenca tutti i nomi di città (senza duplicati)
---
SELECT DISTINCT city FROM city;

---
-- 22. Mostra i primi 10 clienti in ordine alfabetico
---
SELECT
  last_name,
  first_name
FROM
  customer
ORDER BY
  last_name,
  first_name
LIMIT 10;

---
-- 23. Elenca i 5 film più lunghi per durata
---
SELECT
  title AS titolo,
  length AS durata
FROM
  film
ORDER BY
  durata DESC
LIMIT 5;




