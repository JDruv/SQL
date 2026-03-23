-- 1) Selezionare le persone (id, nome e età) che hanno tra 30 e 45 anni.
DO LANGUAGE plpgsql $$
DECLARE
    persona RECORD;
    eta INTEGER;
BEGIN
    FOR persona IN
        SELECT id, name, birth_data FROM anag_1 ORDER BY birth_data ASC
    LOOP
        eta := EXTRACT(YEAR FROM AGE(NOW(), persona.birth_data));

        IF eta >= 30 AND eta <= 45 THEN
            RAISE NOTICE 'ID: %, Nome: %, Età: %', persona.id, persona.name, eta;
        END IF;
    END LOOP;
END $$;


-- 2) Trovare il numero totale di tutte le company che contengono la parola 'LLC'.
DO LANGUAGE plpgsql $$
DECLARE
    numero_aziende_llc INTEGER := 0;
BEGIN
    SELECT COUNT(*)
    INTO numero_aziende_llc
    FROM anag_1
    WHERE company ILIKE '%LLC%';

    RAISE NOTICE 'Il numero totale di aziende che contengono "LLC" è: %', numero_aziende_llc;
END $$;


-- 3) Produrre in output il nome, la data di nascita formattata, età e nazione.
DO LANGUAGE plpgsql $$
DECLARE
    persona RECORD;
    data_formattata TEXT;
    eta INTEGER;
BEGIN
    FOR persona IN
        SELECT
            a1.name,
            a1.birth_data,
            a2.nazione
        FROM
            anag_1 AS a1
        INNER JOIN
            anag_2 AS a2 ON a1.id = a2.id
    LOOP
        eta := EXTRACT(YEAR FROM AGE(NOW(), persona.birth_data));
        data_formattata := TO_CHAR(persona.birth_data, 'DD, TMMonth, YYYY, TMDay');

        RAISE NOTICE 'Nome: %, Data di Nascita: %, Età: % anni, Nazione: %',
                     persona.name,
                     data_formattata,
                     eta,
                     persona.nazione;
    END LOOP;
END $$;


-- 4) Trovare il numero totale di tutte le persone nate in Francia.
DO LANGUAGE plpgsql $$
DECLARE
    conteggio_francesi INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO conteggio_francesi
    FROM anag_2
    WHERE LOWER(nazione) = 'france';

    RAISE NOTICE 'Il numero totale di persone nate in Francia è: %', conteggio_francesi;
END $$;


-- 5) Selezionare id, nome e nazione delle persone brasiliane il cui nome inizia per K.
DO LANGUAGE plpgsql $$
DECLARE
    persona RECORD;
BEGIN
    FOR persona IN
        SELECT
            a1.id,
            a1.name,
            a2.nazione
        FROM
            anag_1 AS a1
        INNER JOIN
            anag_2 AS a2 ON a1.id = a2.id
        WHERE
            LOWER(a2.nazione) = 'brazil' AND a1.name ILIKE 'K%'
    LOOP
        RAISE NOTICE 'ID: %, Nome: %, Nazione: %', persona.id, UPPER(persona.name), persona.nazione;
    END LOOP;
END $$;


-- 6) Verificare le persone nate in un anno bisestile.
DO LANGUAGE plpgsql $$
DECLARE
    persona RECORD;
    anno INTEGER;
BEGIN
    FOR persona IN SELECT id, name, birth_data FROM anag_1 LOOP
        anno := EXTRACT(YEAR FROM persona.birth_data);

        IF ((anno % 4 = 0) AND (anno % 100 != 0)) OR (anno % 400 = 0) THEN
            RAISE NOTICE 'ID: %, Nome: %, Anno Bisestile: %', persona.id, persona.name, anno;
        END IF;
    END LOOP;
END $$;


-- 7) Contare quante persone sono nate per ogni anno (versione date_part).
DO LANGUAGE plpgsql $$
DECLARE
    risultato RECORD;
BEGIN
    FOR risultato IN
        SELECT
            date_part('year', birth_data) AS anno,
            COUNT(*) AS conteggio
        FROM anag_1
        GROUP BY anno
        ORDER BY anno DESC
    LOOP
        RAISE NOTICE 'Anno: %, Persone Nate: %', risultato.anno::INTEGER, risultato.conteggio;
    END LOOP;
END $$;


-- 7) Contare quante persone sono nate per ogni anno (versione to_char).
DO LANGUAGE plpgsql $$
DECLARE
    risultato RECORD;
BEGIN
    FOR risultato IN
        SELECT
            to_char(birth_data, 'YYYY') AS anno,
            COUNT(*) AS conteggio
        FROM anag_1
        GROUP BY anno
        ORDER BY anno DESC
    LOOP
        RAISE NOTICE 'Anno: %, Persone Nate: %', risultato.anno, risultato.conteggio;
    END LOOP;
END $$;

-- 8) Contare le persone la cui iniziale è la lettera J.
DO LANGUAGE plpgsql $$
DECLARE
    conteggio_iniziale_j INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO conteggio_iniziale_j
    FROM anag_1
    WHERE name ILIKE 'J%';

    RAISE NOTICE 'Il numero di persone il cui nome inizia con J è: %', conteggio_iniziale_j;
END $$;


-- 9) Visualizzare i nomi delle persone trovate nel punto precedente.
DO LANGUAGE plpgsql $$
DECLARE
    persona RECORD;
BEGIN
    FOR persona IN
        SELECT name
        FROM anag_1
        WHERE name ILIKE 'J%'
    LOOP
        RAISE NOTICE 'Nome trovato: %', persona.name;
    END LOOP;
END $$;


-- 10) Eseguire un update e verificare il numero di righe impattate.
DO LANGUAGE plpgsql $$
DECLARE
    righe_modificate INTEGER;
BEGIN
    UPDATE anag_1
    SET name = 'Pippo'
    WHERE birth_data > '2018-01-01';

    GET DIAGNOSTICS righe_modificate = ROW_COUNT;

    RAISE NOTICE 'UPDATE completato. Numero di righe modificate: %', righe_modificate;
END $$;


-- 11) Estrarre il dominio da ogni indirizzo email.
DO LANGUAGE plpgsql $$
DECLARE
    persona RECORD;
    dominio TEXT;
BEGIN
    FOR persona IN
        SELECT id, name, email
        FROM anag_1
        ORDER BY id
    LOOP
        dominio := split_part(persona.email, '@', 2);
        RAISE NOTICE 'ID: %, Nome: %, Dominio: %', persona.id, persona.name, dominio;
    END LOOP;
END $$;


-- 12) Contare ogni dominio di indirizzo email.
DO LANGUAGE plpgsql $$
DECLARE
    risultato RECORD;
BEGIN
    FOR risultato IN
        SELECT
            split_part(email, '@', 2) AS dominio,
            COUNT(*) AS conteggio
        FROM anag_1
        GROUP BY dominio
        ORDER BY conteggio DESC
    LOOP
        RAISE NOTICE 'Dominio: %, Conteggio: %', risultato.dominio, risultato.conteggio;
    END LOOP;
END $$;

