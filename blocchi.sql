-- ESERCIZI DRUV CHERIS JHURRY --
-- 1) Stampare il numero totale degli attori italiani;
DO LANGUAGE plpgsql $$
DECLARE
	attori_italiani INTEGER;
BEGIN
   
	SELECT COUNT(*)
	INTO attori_italiani
	FROM attori
	WHERE LOWER(Nazionalita) = 'italiana';

	RAISE NOTICE 'Il numero di attori italiani è: %', attori_italiani;
END $$;

--2) Stampare titolo e incasso del film che ha incassato di più;
DO LANGUAGE plpgsql $$
DECLARE
	titolo_film_max VARCHAR;
	incasso_film_max INTEGER;
BEGIN
	SELECT
		f.Titolo,
		SUM(p.Incasso) AS incasso_totale
	INTO
		titolo_film_max,
		incasso_film_max
	FROM
		film AS f
	JOIN
		proiezioni AS p ON f.CodFilm = p.CodFilm
	GROUP BY
		f.CodFilm, f.Titolo 
	ORDER BY
		incasso_totale DESC 
	LIMIT 1; 

	RAISE NOTICE 'Il film che ha incassato di più è "%" con un totale di %.', titolo_film_max, incasso_film_max;
END $$;

--3) Selezionare titolo dei film con il codice 1210 (utilizzare il row type);
DO LANGUAGE plpgsql $$
DECLARE
	nome_film film.titolo%TYPE;
BEGIN
	SELECT titolo
	INTO nome_film
	FROM film
	WHERE CodFilm = 1210;

	RAISE NOTICE 'Il titolo del film con codice 1210 è: %', nome_film;
END $$;

-- 4) Stampare titolo e nazionalità dei film con codice 1004 e poi il nome e
   -- numero di posti della sala codice 3 (utilizzare il record type);
DO LANGUAGE plpgsql $$
DECLARE
	info RECORD;
BEGIN
	SELECT Titolo, Nazionalita
	INTO info
	FROM film
	WHERE CodFilm = 1004;
	RAISE NOTICE 'Film: %, Nazionalità: %', info.Titolo, info.Nazionalita;
	
	SELECT Nome, Posti
	INTO info
	FROM sale
	WHERE CodSala = 3;
	RAISE NOTICE 'Sala: %, Posti: %', info.Nome, info.Posti;
END $$;

-- 5) Stampare la città ed il numero totale dei posti delle sale di Napoli.
DO LANGUAGE plpgsql $$
DECLARE
	posti_totali INTEGER;
	nome_citta VARCHAR := 'Napoli';
BEGIN
	SELECT SUM(Posti)
	INTO posti_totali
	FROM sale
	WHERE citta = nome_citta;
	RAISE NOTICE 'Città: % - Posti totali: %', nome_citta, posti_totali;
END $$;

--6) Scrivere un blocco anonimo usando il for considerando l'ordine
  -- crescente dell'anno di produzione, stampi dal 4° al 7° film (titolo e anno di produzione);
DO LANGUAGE plpgsql $$
DECLARE 
	film_record RECORD;
BEGIN
    
	FOR film_record IN
		SELECT Titolo, AnnoProduzione
		FROM film
		ORDER BY AnnoProduzione
		OFFSET 3 
		LIMIT 4
	LOOP
	    
		RAISE NOTICE 'Titolo: %, Anno: %', film_record.Titolo, film_record.AnnoProduzione;
	END LOOP;
END $$;



