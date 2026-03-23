-- Pulisce la tabella se esiste già per poter rieseguire lo script
DROP TABLE IF EXISTS persone_nuove;

-- Crea e riempie la tabella in un solo comando
SELECT id, nome, cognome
INTO persone_nuove
FROM persone;

-- Pulisce le tabelle se esistono già
DROP TABLE IF EXISTS persone_rossi, persone_altre;

-- Crea la tabella vuota 'persone_rossi'
CREATE TABLE persone_rossi AS
SELECT * FROM persone_nuove WHERE 1 = 0;

-- Crea la tabella vuota 'persone_altre'
CREATE TABLE persone_altre AS
SELECT * FROM persone_nuove WHERE 1 = 0;


