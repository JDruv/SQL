-- 1) Creare una funzione ‘output_password’ che stampi in output il nome
--    utente e la relativa password di ogni utente in un’unica stringa. Utilizzare cursore.

CREATE OR REPLACE FUNCTION output_password()
RETURNS TEXT -- La funzione restituisce un singolo valore di tipo TEXTO
LANGUAGE plpgsql
AS $$
DECLARE
    rec_account RECORD;
    risultato_stringa TEXT := '';
    cur_accounts CURSOR FOR
        SELECT username, password FROM account ORDER BY user_id;
BEGIN
    OPEN cur_accounts;
    LOOP
        FETCH cur_accounts INTO rec_account;
        EXIT WHEN NOT FOUND;
        IF risultato_stringa != '' THEN
            risultato_stringa := risultato_stringa || ', ';
        END IF;
        risultato_stringa := risultato_stringa || 
                             '(' || rec_account.username || ' ' || rec_account.password || ')';
        
    END LOOP;
    CLOSE cur_accounts;
 
    RETURN risultato_stringa;
END;
$$;

-- 2) Creare una funzione ‘aggiorna_password’ che effettui
--    l’aggiornamento dell’utente Mario con la nuova password ‘qzerty’.
--    Utilizzare una struttura di controllo e una stringa esplicativa come output.

CREATE OR REPLACE FUNCTION aggiorna_password()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE account
    SET password = 'qzerty'
    WHERE username = 'Mario';

    IF FOUND THEN
        RETURN 'SUCCESSO: La password per l''utente "Mario" è stata aggiornata a "qzerty"';
    ELSE
        RETURN 'ATTENZIONE: Utente "Mario" non trovato. Nessun aggiornamento eseguito.';
    END IF;
END;
$$;

-- 3) Creare una funzione ‘concat_row_count’ che, passati tabella,
--    colonna e password ‘abcde’, restituisca il conteggio delle righe con la
--    stessa password. Utilizzare EXECUTE e la funzione format per effettuare il row count.

CREATE OR REPLACE FUNCTION concat_row_count(
    nome_tabella TEXT,
    nome_colonna TEXT,
    valore_password TEXT
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    conteggio INTEGER;
    query_sql TEXT;
BEGIN
    query_sql := format('SELECT count(*) FROM %I WHERE %I = %L', nome_tabella, nome_colonna, valore_password);
    EXECUTE query_sql INTO conteggio;
    RETURN conteggio;
END;
$$;

-- 4) Creare una funzione ‘calcola_somma’ che calcoli la somma degli importi e
   -- aggiorni la colonna somma fornendo in output una stringa di conferma
   -- operazione. Creare due versioni della stessa funzione utilizzando sia il
   -- cursore esplicito che il cursore FOR.
CREATE OR REPLACE FUNCTION calcola_somma_esplicito()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    somma_progressiva NUMERIC(6,2) := 0;
    riga_persona RECORD;
    cur_persone CURSOR FOR
        SELECT id, importo FROM persone ORDER BY id;
BEGIN
    OPEN cur_persone;
    LOOP
        FETCH cur_persone INTO riga_persona;
        EXIT WHEN NOT FOUND;
        somma_progressiva := somma_progressiva + riga_persona.importo;
        UPDATE persone SET somma = somma_progressiva WHERE id = riga_persona.id;
        
    END LOOP;
    CLOSE cur_persone;
    
    RETURN 'La somma degli utenti è stata aggiornata';
END;
$$;

-- 4b)

CREATE OR REPLACE FUNCTION calcola_somma_for()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    somma_progressiva NUMERIC(6,2) := 0;
    riga_persona RECORD;
BEGIN
    FOR riga_persona IN SELECT id, importo FROM persone ORDER BY id LOOP
        somma_progressiva := somma_progressiva + riga_persona.importo;
        UPDATE persone SET somma = somma_progressiva WHERE id = riga_persona.id;
        
    END LOOP;
    
    RETURN 'La somma degli utenti è stata aggiornata';
END;
$$;

-- LAB 9 4) Creare una funzione chiamata ‘popola_tabella_rossi’ che riempia la
-- tabella persone_rossi con le sole persone il cui cognome è ‘Rossi’
-- altrimenti riempia persone_altre. Utilizzare una stringa di output che
-- confermi l’avvenuto inserimento. Controllare successivamente che la
-- tabella contenga effettivamente i dati richiesti.

CREATE OR REPLACE FUNCTION popola_tabella_rossi()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    riga_persona RECORD;
BEGIN
    TRUNCATE TABLE persone_rossi, persone_altre;
    FOR riga_persona IN SELECT * FROM persone_nuove LOOP

        IF riga_persona.cognome = 'Rossi' THEN
            INSERT INTO persone_rossi (id, nome, cognome)
            VALUES (riga_persona.id, riga_persona.nome, riga_persona.cognome);
        ELSE
            INSERT INTO persone_altre (id, nome, cognome)
            VALUES (riga_persona.id, riga_persona.nome, riga_persona.cognome);
        END IF;
        
    END LOOP;
    RETURN 'Insert eseguita con successo!';
END;
$$;