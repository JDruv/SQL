CREATE TABLE Auto (
    Quantita INT,
    Costo_unitario NUMERIC(10,2),
    Totale NUMERIC(10,2)
);

CREATE TABLE Furgone (
    Quantita INT,
    Costo_unitario NUMERIC(10,2),
    Totale NUMERIC(10,2)
);

CREATE TABLE Camion (
    Quantita INT,
    Costo_unitario NUMERIC(10,2),
    Totale NUMERIC(10,2)
);

CREATE TABLE SCARICO_MERCI (
    Tipo_merce VARCHAR(50),
    Descrizione VARCHAR(100),
    Quantita INT,
    Costo_unitario NUMERIC(10,2)
);

INSERT INTO SCARICO_MERCI (Tipo_merce, Descrizione, Quantita, Costo_unitario)
VALUES
('Auto', 'Parti auto', 30, 5),
('Furgone', 'Parti furgone', 15, 7),
('Camion', 'Parti camion', 3, 11);

CREATE OR REPLACE PROCEDURE PopolaAuto()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Auto (Quantita, Costo_unitario, Totale)
    SELECT Quantita, Costo_unitario, Quantita * Costo_unitario
    FROM SCARICO_MERCI
    WHERE Tipo_merce = 'Auto';
END;
$$;


CREATE OR REPLACE PROCEDURE PopolaFurgone()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Furgone (Quantita, Costo_unitario, Totale)
    SELECT Quantita, Costo_unitario, Quantita * Costo_unitario
    FROM SCARICO_MERCI
    WHERE Tipo_merce = 'Furgone';
END;
$$;


CREATE OR REPLACE PROCEDURE PopolaCamion()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Camion (Quantita, Costo_unitario, Totale)
    SELECT Quantita, Costo_unitario, Quantita * Costo_unitario
    FROM SCARICO_MERCI
    WHERE Tipo_merce = 'Camion';
END;
$$;

CREATE OR REPLACE PROCEDURE PopolaTabelleAppoggio()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Pulire eventuali dati precedenti
    TRUNCATE TABLE Auto, Furgone, Camion;

    -- Richiamare le procedure secondarie
    CALL PopolaAuto();
    CALL PopolaFurgone();
    CALL PopolaCamion();

    RAISE NOTICE 'Tabelle di appoggio popolate con successo!';
END;
$$;


CALL PopolaTabelleAppoggio();
select * from auto;
select * from camion;
select * from furgone;
