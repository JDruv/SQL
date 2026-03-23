-- 1) Creare una funzione chiamata ‘aggiungi_un_numero’ che dato un
--    numero intero in input che contenga cifre da 0 a 8, estragga un numero
--    che alle singole cifre aggiunge 1.
CREATE OR REPLACE FUNCTION aggiungi_un_numero(numero_input INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    numero_testo TEXT;
    nuovo_numero_testo TEXT := '';
    cifra_attuale INTEGER;
    i INTEGER;
BEGIN
    numero_testo := numero_input::TEXT;
    
    FOR i IN 1..length(numero_testo) LOOP
        cifra_attuale := substring(numero_testo, i, 1)::INTEGER + 1;
        nuovo_numero_testo := nuovo_numero_testo || cifra_attuale::TEXT;
    END LOOP;
    
    RETURN nuovo_numero_testo::INTEGER;
END;
$$;

SELECT aggiungi_un_numero(568);


-- 2) Creare una funzione chiamata 'aggiungi_numero_pari_disp' che dato un
--    numero in input che contenga cifre da 0 a 7, estragga un numero e alle
--    singole cifre dispari aggiunge 1, mentre alle pari 2.
CREATE OR REPLACE FUNCTION aggiungi_numero_pari_disp(numero_input INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    numero_testo TEXT;
    nuovo_numero_testo TEXT := '';
    cifra_attuale INTEGER;
    nuova_cifra INTEGER;
    i INTEGER;
BEGIN
    numero_testo := numero_input::TEXT;
    
    FOR i IN 1..length(numero_testo) LOOP
        cifra_attuale := substring(numero_testo, i, 1)::INTEGER;
        
        IF cifra_attuale % 2 = 0 THEN
            nuova_cifra := cifra_attuale + 2;
        ELSE
            nuova_cifra := cifra_attuale + 1;
        END IF;
        
        nuovo_numero_testo := nuovo_numero_testo || nuova_cifra::TEXT;
    END LOOP;
    
    RETURN nuovo_numero_testo::INTEGER;
END;
$$;

SELECT aggiungi_numero_pari_disp(326);


-- 3) Creare una funzione chiamata 'estrai_dispari' che data in input una
--    stringa, estagga un'altra stringa contenente i soli caratteri in posizione
--    dispari di quella fornita in output.
CREATE OR REPLACE FUNCTION estrai_dispari(stringa_input TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    stringa_risultato TEXT := '';
    i INTEGER;
BEGIN
    FOR i IN 1..length(stringa_input) LOOP
        
        IF i % 2 != 0 THEN
            stringa_risultato := stringa_risultato || substring(stringa_input, i, 1);
        END IF;
        
    END LOOP;
    
    RETURN stringa_risultato;
END;
$$;

SELECT estrai_dispari('ronaldo');


-- 4) Creare una funzione chiamata 'count_tabelle' che effettui il conteggio
--    delle righe delle singole tabelle persone, account e persone_rossi e mostri
--    in output un'unica riga con i conteggi singoli più il totale delle righe delle tre tabelle.
CREATE OR REPLACE FUNCTION count_tabelle()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    count_persone INTEGER;
    count_account INTEGER;
    count_rossi INTEGER;
    count_totale INTEGER;
BEGIN
    SELECT count(*) INTO count_persone FROM persone;
    SELECT count(*) INTO count_account FROM account;
    SELECT count(*) INTO count_rossi FROM persone_rossi;
    
    count_totale := count_persone + count_account + count_rossi;
    
    RETURN format(
        'Conteggi: persone(%s), account(%s), persone_rossi(%s) - Totale: %s',
        count_persone,
        count_account,
        count_rossi,
        count_totale
    );
END;
$$;

SELECT count_tabelle();


-- 5) Creare una funzione chiamata ‘somma_posizioni_alfabetiche’ che
--    data in input una stringa contenente soltanto lettere dell'alfabeto
--    italiano minuscole/maiuscole, restituisca la somma delle posizioni
--    cronologiche delle singole lettere rispetto all'alfabeto italiano.
CREATE OR REPLACE FUNCTION somma_posizioni_alfabetiche(stringa_input TEXT)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    somma_totale INTEGER := 0;
    alfabeto TEXT := 'abcdefghilmnopqrstuvz';
    carattere_corrente TEXT;
    posizione INTEGER;
    i INTEGER;
BEGIN
    FOR i IN 1..length(stringa_input) LOOP
        carattere_corrente := substring(lower(stringa_input), i, 1);
        posizione := strpos(alfabeto, carattere_corrente);
        somma_totale := somma_totale + posizione;
    END LOOP;

    RETURN somma_totale;
END;
$$;

SELECT somma_posizioni_alfabetiche('AdCe');


-- 6) Creare funzione chiamata ‘calcolo_iva’ che passato un importo netto
--    e il tipo di prodotto tra alimentari, servizi base e altri prodotti
--    (identificati dalle corrispondenti aliquote) ritorni l'iva da applicare su
--    tale importo.
CREATE OR REPLACE FUNCTION calcolo_iva(importo_netto NUMERIC, tipo_prodotto TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    aliquota NUMERIC;
    prezzo_ivato NUMERIC;
BEGIN
    CASE lower(tipo_prodotto)
        WHEN 'alimentari' THEN
            aliquota := 0.04;
        WHEN 'servizi base' THEN
            aliquota := 0.10;
        WHEN 'altri prodotti' THEN
            aliquota := 0.22;
        ELSE
            RAISE EXCEPTION 'Tipo di prodotto non valido: "%"', tipo_prodotto
                USING HINT = 'I valori permessi sono: "alimentari", "servizi base", "altri prodotti".';
    END CASE;

    prezzo_ivato := importo_netto * (1 + aliquota);

    RETURN format(
        'Aliquota applicata (%s): %s%%. Prezzo ivato finale: %s',
        initcap(tipo_prodotto),
        aliquota * 100,
        to_char(prezzo_ivato, 'FM999G999D00 €')
    );
END;
$$;

SELECT calcolo_iva(100, 'alimentari');


-- 7) Considerando il database CINEMA, scrivere una funzione PL/pgSQL
--    che accetti due parametri: un anno di inizio ed un anno di fine e ritorni
--    il numero di film prodotti tra questi due intervalli temporali.
CREATE OR REPLACE FUNCTION conta_film_per_periodo(
    anno_inizio INTEGER,
    anno_fine INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    conteggio_film INTEGER;
BEGIN
    SELECT count(*)
    INTO conteggio_film
    FROM film
    WHERE AnnoProduzione BETWEEN anno_inizio AND anno_fine;
    
    RETURN conteggio_film;
END;
$$;

SELECT conta_film_per_periodo(1990, 2000);


-- 8) Creare una funzione chiamata ‘check_codice_ISBN' che data in input
--    una stringa contenente il codice ISBN di un libro, effettui il controllo
--    sull’ultima cifra del codice restituendo ‘Codice valido’ oppure ‘Codice errato’.
CREATE OR REPLACE FUNCTION check_codice_ISBN(isbn_input TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    isbn_pulito TEXT;
    lunghezza INTEGER;
    somma BIGINT := 0;
    check_digit_calcolato INTEGER;
    check_digit_fornito INTEGER;
    check_digit_fornito_char TEXT;
    i INTEGER;
    cifra INTEGER;
BEGIN
    isbn_pulito := REPLACE(isbn_input, '-', '');
    lunghezza := length(isbn_pulito);

    IF lunghezza = 13 THEN
        FOR i IN 1..12 LOOP
            cifra := substring(isbn_pulito, i, 1)::INTEGER;
            IF i % 2 = 1 THEN
                somma := somma + cifra * 1;
            ELSE
                somma := somma + cifra * 3;
            END IF;
        END LOOP;
        
        check_digit_calcolato := (10 - (somma % 10)) % 10;
        check_digit_fornito := substring(isbn_pulito, 13, 1)::INTEGER;
        
        IF check_digit_calcolato = check_digit_fornito THEN
            RETURN 'Codice valido';
        ELSE
            RETURN 'Codice errato';
        END IF;

    ELSIF lunghezza = 10 THEN
        FOR i IN 1..9 LOOP
            cifra := substring(isbn_pulito, i, 1)::INTEGER;
            somma := somma + cifra * i;
        END LOOP;
        
        check_digit_calcolato := somma % 11;
        check_digit_fornito_char := upper(substring(isbn_pulito, 10, 1));
        
        IF check_digit_calcolato = 10 AND check_digit_fornito_char = 'X' THEN
            RETURN 'Codice valido';
        ELSIF check_digit_calcolato < 10 AND check_digit_fornito_char ~ '^[0-9]$' THEN
            IF check_digit_calcolato = check_digit_fornito_char::INTEGER THEN
                RETURN 'Codice valido';
            ELSE
                RETURN 'Codice errato';
            END IF;
        ELSE
             RETURN 'Codice errato';
        END IF;

    ELSE
        RETURN 'Codice errato (lunghezza non valida)';
    END IF;
END;
$$;

-- valido 
SELECT check_codice_ISBN('978-8-87-782702-9');
--errato
SELECT check_codice_ISBN('978-5-0250-7430-2');