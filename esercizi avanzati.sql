-- 1) Estrarre il nome e cognome di tutti gli studenti in un’unica stringa. Ordinamento per cognome;
DO $$
DECLARE
    rec RECORD;
    cur_studenti CURSOR FOR
        SELECT nome, cognome
        FROM studenti
        ORDER BY cognome;
BEGIN
    OPEN cur_studenti;
    LOOP
        FETCH cur_studenti INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Nominativo: % %', rec.nome, rec.cognome;
    END LOOP;
    CLOSE cur_studenti;
END $$;

-- 2) Selezionare nome, cognome e voto esame degli studenti. Ordinamento per cognome;
DO $$
DECLARE
    rec RECORD;
    cur_voti CURSOR FOR
        SELECT s.nome, s.cognome, e.voto
        FROM studenti s
        JOIN esami e ON s.matricola = e.matricola_studente
        ORDER BY s.cognome;
BEGIN
    OPEN cur_voti;
    LOOP
        FETCH cur_voti INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Studente: % %, Voto: %', rec.nome, rec.cognome, rec.voto;
    END LOOP;
    CLOSE cur_voti;
END $$;

-- 3) Selezionare nome, cognome, voto, titolo e sigla del corso;
DO $$
DECLARE
    rec RECORD;
    cur_dettagli_esami CURSOR FOR
        SELECT
            s.nome,
            s.cognome,
            e.voto,
            c.titolo,
            c.sigla
        FROM studenti s
        JOIN esami e ON s.matricola = e.matricola_studente
        JOIN corsi c ON e.sigla_corso = c.sigla
        ORDER BY s.cognome;
BEGIN
    OPEN cur_dettagli_esami;
    LOOP
        FETCH cur_dettagli_esami INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Studente: % %, Voto: %, Corso: % (%)',
                     rec.nome, rec.cognome, rec.voto, rec.titolo, rec.sigla;
    END LOOP;
    CLOSE cur_dettagli_esami;
END $$;

-- 4) Selezionare nome, cognome, voto, titolo e sigla del corso, nome e cognome dei docenti. 
--    Ordinamento per cognome docente. Gli output delle persone dev’essere formattato in un’unica colonna ‘nominativo’;
DO $$
DECLARE
    rec RECORD;
    cur_completo CURSOR FOR
        SELECT
            s.nome || ' ' || s.cognome AS nominativo_studente,
            e.voto,
            c.titolo,
            c.sigla,
            d.nome || ' ' || d.cognome AS nominativo_docente
        FROM studenti s
        JOIN esami e ON s.matricola = e.matricola_studente
        JOIN corsi c ON e.sigla_corso = c.sigla
        JOIN docenti d ON c.id_docente = d.id
        ORDER BY d.cognome;
BEGIN
    OPEN cur_completo;
    LOOP
        FETCH cur_completo INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Studente: %, Voto: %, Corso: % (%), Docente: %',
                     rec.nominativo_studente, rec.voto, rec.titolo, rec.sigla, rec.nominativo_docente;
    END LOOP;
    CLOSE cur_completo;
END $$;

-- 5) Contare il numero totali di corsi tenuti da ogni docente. Ordinare per ID;
DO $$
DECLARE
    rec RECORD;
    cur_conteggio_corsi CURSOR FOR
        SELECT
            d.id,
            d.nome,
            d.cognome,
            COUNT(c.sigla) AS numero_corsi
        FROM docenti d
        LEFT JOIN corsi c ON d.id = c.id_docente
        GROUP BY d.id
        ORDER BY d.id;
BEGIN
    OPEN cur_conteggio_corsi;
    LOOP
        FETCH cur_conteggio_corsi INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Docente: % % (ID: %), Corsi tenuti: %',
                     rec.nome, rec.cognome, rec.id, rec.numero_corsi;
    END LOOP;
    CLOSE cur_conteggio_corsi;
END $$;

-- 6) Calcolare la media dei voti degli studenti. Ordinamento per media decrescente.
DO $$
DECLARE
    rec RECORD;
    cur_media_voti CURSOR FOR
        SELECT
            s.nome,
            s.cognome,
            AVG(e.voto) AS media_voti
        FROM studenti s
        JOIN esami e ON s.matricola = e.matricola_studente
        GROUP BY s.matricola
        ORDER BY media_voti DESC;
BEGIN
    OPEN cur_media_voti;
    LOOP
        FETCH cur_media_voti INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Studente: % %, Media Voti: %',
                     rec.nome, rec.cognome, ROUND(rec.media_voti, 2);
    END LOOP;
    CLOSE cur_media_voti;
END $$;

-- 7) Scrivere un semplice blocco anonimo che mostri in output il datatype
--    delle colonne ‘titolo’ di Corsi e ‘data_nascita’ di Studenti;
DO $$
DECLARE
    tipo_dato_titolo VARCHAR;
    tipo_dato_nascita VARCHAR;
BEGIN
    SELECT data_type INTO tipo_dato_titolo
    FROM information_schema.columns
    WHERE table_name = 'corsi' AND column_name = 'titolo';

    SELECT data_type INTO tipo_dato_nascita
    FROM information_schema.columns
    WHERE table_name = 'studenti' AND column_name = 'data_nascita';

    RAISE NOTICE 'Il datatype della colonna "titolo" in Corsi è: %', tipo_dato_titolo;
    RAISE NOTICE 'Il datatype della colonna "data_nascita" in Studenti è: %', tipo_dato_nascita;
END $$;

-- 8) Scrivere un blocco anonimo che mostri a video il nome e cognome di
--    tutti i docenti ordinati per ID. Utilizzare rowtype;
DO $$
DECLARE
    riga_docente docenti%ROWTYPE;
BEGIN
    FOR riga_docente IN
        SELECT * FROM docenti ORDER BY id
    LOOP
        RAISE NOTICE 'Docente: % %', riga_docente.nome, riga_docente.cognome;
    END LOOP;
END $$;

-- 9) Scrivere un blocco anonimo che mostri a video il conteggio totale degli esami svolti;
DO $$
DECLARE
    conteggio_esami INTEGER;
BEGIN
    SELECT COUNT(*) INTO conteggio_esami FROM esami;
    RAISE NOTICE 'Il numero totale di esami svolti è: %', conteggio_esami;
END $$;

-- 10) Scrivere un blocco anonimo che mostri a video nome, cognome e
--     voto di tutti gli studenti il cui nome inizia per ‘G’;
DO $$
DECLARE
    rec RECORD;
    cur_studenti_g CURSOR FOR
        SELECT s.nome, s.cognome, e.voto
        FROM studenti s
        JOIN esami e ON s.matricola = e.matricola_studente
        WHERE s.nome LIKE 'G%';
BEGIN
    OPEN cur_studenti_g;
    LOOP
        FETCH cur_studenti_g INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Studente: % %, Voto: %', rec.nome, rec.cognome, rec.voto;
    END LOOP;
    CLOSE cur_studenti_g;
END $$;

-- 11) Tramite un blocco anonimo mostrare in output tutti i dati delle scuole
--     presenti utilizzando il ciclo LOOP base;
DO $$
DECLARE
    rec_scuola scuole%ROWTYPE;
    cur_scuole CURSOR FOR SELECT * FROM scuole;
BEGIN
    OPEN cur_scuole;
    LOOP
        FETCH cur_scuole INTO rec_scuola;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'ID: %, Nome: %, Città: %, Titolo: %',
                     rec_scuola.id, rec_scuola.nome, rec_scuola.citta, rec_scuola.titolo;
    END LOOP;
    CLOSE cur_scuole;
END $$;

-- 12) Tramite un blocco anonimo mostrare in output tutti i dati dei
--     dipartimenti presenti utilizzando il ciclo WHILE;
DO $$
DECLARE
    rec_dip dipartimenti%ROWTYPE;
    cur_dipartimenti CURSOR FOR SELECT * FROM dipartimenti ORDER BY id;
BEGIN
    OPEN cur_dipartimenti;
    FETCH cur_dipartimenti INTO rec_dip;
    WHILE FOUND LOOP
        RAISE NOTICE 'ID: %, Nome: %', rec_dip.id, rec_dip.nome;
        FETCH cur_dipartimenti INTO rec_dip;
    END LOOP;
    CLOSE cur_dipartimenti;
END $$;

-- 13)

-- 14) Scrivere un blocco anonimo che mostri in output la descrizione dei
--     voti di Giulia con ‘Ottimo’ per i voti da 27 a 30, ‘Buono’ per i voti da 22
--     a 26 e ‘Sufficiente’ per i restanti.
DO $$
DECLARE
    rec_esame RECORD;
    descrizione_voto VARCHAR(20);
BEGIN
    RAISE NOTICE '--- Voti della studentessa Giulia Verdi ---';
    
    FOR rec_esame IN
        SELECT c.titolo, e.voto
        FROM esami e
        JOIN studenti s ON e.matricola_studente = s.matricola
        JOIN corsi c ON e.sigla_corso = c.sigla
        WHERE s.nome = 'Giulia' AND s.cognome = 'Verdi'
    LOOP
        descrizione_voto := CASE
            WHEN rec_esame.voto BETWEEN 27 AND 30 THEN 'Ottimo'
            WHEN rec_esame.voto BETWEEN 22 AND 26 THEN 'Buono'
            ELSE 'Sufficiente'
        END;
        
        RAISE NOTICE 'Corso: %, Voto: % -> (%)', rec_esame.titolo, rec_esame.voto, descrizione_voto;
    END LOOP;
END $$;


-- 15) Scrivere un blocco anonimo che prende come variabile una query
--     (nome e cognome del docente) ed effettui l’ordinamento per nome se
--     il sort_type è pari a 1 e per cognome se invece è 2. Messaggio di
--     errore altrimenti. Tramite un ciclo FOR (execute query) stampare i risultati.
DO $$
DECLARE
    sort_type INTEGER := 1;
    query_dinamica TEXT;
    rec_docente RECORD;
BEGIN
    query_dinamica := 'SELECT nome, cognome FROM docenti ';

    IF sort_type = 1 THEN
        query_dinamica := query_dinamica || 'ORDER BY nome';
        RAISE NOTICE '--- Docenti ordinati per NOME ---';
    ELSIF sort_type = 2 THEN
        query_dinamica := query_dinamica || 'ORDER BY cognome';
        RAISE NOTICE '--- Docenti ordinati per COGNOME ---';
    ELSE
        RAISE WARNING 'Errore: sort_type non valido. Usare 1 per nome, 2 per cognome.';
        RETURN;
    END IF;

    FOR rec_docente IN EXECUTE query_dinamica
    LOOP
        RAISE NOTICE 'Docente: % %', rec_docente.nome, rec_docente.cognome;
    END LOOP;
END $$;