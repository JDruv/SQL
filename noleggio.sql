--5) Selezionare tutti i noleggi avventi nel mese di Giugno 2021 (usare date_part);
SELECT *
FROM inventory
WHERE date_part('year', data_noleggio) = 2021
  AND date_part('month', data_noleggio) = 6;
  
-- 6) Di ogni noleggio visualizzare l’output dell’anno, del mese e del giorno
SELECT 
    i.inventory_id,
    f.titolo,
    date_part('year', i.data_noleggio) AS anno,
    date_part('month', i.data_noleggio) AS mese,
    date_part('day', i.data_noleggio) AS giorno
FROM inventory i
JOIN film f ON i.film_id = f.film_id;


-- 7) Nuovo titolo "Ma che brutta giornata"
SELECT REPLACE(titolo, 'bella', 'brutta') AS nuovo_titolo
FROM film
WHERE titolo = 'Ma che bella giornata';

-- 8) Titolo "Una notte al museo2" senza spazi
SELECT REPLACE(titolo, ' ', '') AS senza_spazi
FROM film
WHERE titolo ILIKE 'Una notte al museo2';

-- 9) "La bella vita" con iniziale maiuscola per ogni parola
SELECT INITCAP(titolo) AS capitalizzato
FROM film
WHERE titolo = 'La bella vita';

-- 10) Visualizzare "Ma che"
SELECT SUBSTRING(titolo FROM 1 FOR 6) AS parte
FROM film
WHERE titolo = 'Ma che bella giornata';

-- 11a) Visualizzare "Luci" con SUBSTRING
SELECT SUBSTRING(titolo FROM 1 FOR 4) AS luci1
FROM film
WHERE titolo = 'Lucifer';

-- 11b) Visualizzare "Luci" con LEFT
SELECT LEFT(titolo, 4) AS luci2
FROM film
WHERE titolo = 'Lucifer';

-- 12) Visualizzare "Il primo Lucifer"
SELECT 'Il primo ' || titolo AS nuovo_titolo
FROM film
WHERE titolo = 'Lucifer';

-- 13) Visualizzare "Ma che bella giornata oggi"
SELECT titolo || ' oggi' AS nuovo_titolo
FROM film
WHERE titolo = 'Ma che bella giornata';

-- 14) Visualizzare "Una notte al museo 2" in maniera inversa
SELECT REVERSE('Una notte al museo 2') AS titolo_inverso;

-- 15) Visualizzare la data di noleggio in sole cifre senza delimitatori
SELECT f.titolo, TO_CHAR(i.data_noleggio, 'YYYYMMDD') AS data_cifre
FROM inventory i
JOIN film f ON i.film_id = f.film_id;

-- 16) Verificare se "La bella vita" e "Una notte al museo 2" sono stati noleggiati entrambi nel primo semestre
SELECT f.titolo, i.data_noleggio,
       CASE 
            WHEN date_part('month', i.data_noleggio) BETWEEN 1 AND 6 
            THEN 'Noleggiato nel primo semestre'
            ELSE 'Fuori dal primo semestre'
       END AS verifica
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.titolo IN ('La bella vita', 'Una notte al museo2');

-- 17) Verificare se "Lucifer" e "Ma che bella giornata" sono stati noleggiati nel primo trimestre
SELECT f.titolo, i.data_noleggio,
       CASE 
            WHEN date_part('month', i.data_noleggio) BETWEEN 1 AND 3 
            THEN 'Noleggiato nel primo trimestre'
            ELSE 'Fuori dal primo trimestre'
       END AS verifica
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.titolo IN ('Lucifer', 'Ma che bella giornata');

-- 18) Calcolare anni, mesi e giorni passati dal noleggio di "Una notte al museo 2" ad oggi
SELECT f.titolo, i.data_noleggio,
       age(current_date, i.data_noleggio) AS tempo_passato
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.titolo ILIKE 'Una notte al museo2';

-- 19) Giorno della settimana (numero) del noleggio di "Lucifer"
SELECT f.titolo, i.data_noleggio,
       EXTRACT(DOW FROM i.data_noleggio) AS giorno_settimana_num
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.titolo = 'Lucifer';

-- 20) Giorno della settimana (esteso) del noleggio di "Una notte al museo 2"
SELECT f.titolo, i.data_noleggio,
       TO_CHAR(i.data_noleggio, 'Day') AS giorno_settimana_nome
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.titolo = 'Una notte al museo2';

