SET CLIENT_ENCODING TO 'LATIN1';

DROP SEQUENCE public.stg_carga_espacio_sq;

DROP TABLE public.stg_espacio;

DELETE FROM sga_tipo_espacio;

CREATE SEQUENCE public.stg_carga_espacio_sq;

CREATE TABLE public.stg_espacio (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.stg_carga_sq'),
                no_archivo VARCHAR(100),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_planta VARCHAR(100),
				tx_codigo_espacio VARCHAR(100),
                tx_codificacion VARCHAR(100),
                tx_nombre VARCHAR(100),
                tx_sector VARCHAR(100),
                tx_ambiente VARCHAR(100),
                tx_tipologia_1 VARCHAR(400),
                tx_tipologia_2 VARCHAR(50),
                CONSTRAINT stg_espacio_pk PRIMARY KEY (id_carga)
);

ALTER SEQUENCE public.stg_carga_espacio_sq OWNED BY public.stg_espacio.id_carga;

----------------------------------------   PROCESO DE CIARDI   ----------------------------------------
-- Carga archivo a Stage
COPY stg_espacio (
	tx_planta,
	tx_codigo_espacio,
	tx_codificacion,
	tx_nombre,
	tx_sector,
	tx_ambiente,
	tx_tipologia_1,
	tx_tipologia_2)
FROM 'C:\archivos\rcdto-espacio.csv' USING DELIMITERS ';' WITH NULL AS '' CSV HEADER;
UPDATE stg_espacio SET no_archivo = 'rcdto-espacio.csv', fe_carga = now(), co_estado_proceso = 'C';

INSERT INTO sga_tipo_espacio (
	no_tipo_espacio )
SELECT DISTINCT
	TRIM(tx_sector)
FROM stg_espacio
WHERE tx_sector IS NOT NULL;

INSERT INTO sga_tipo_espacio (
	no_tipo_espacio,
	id_tipo_espacio_padre )
SELECT DISTINCT
	TRIM(tx_ambiente),
	(SELECT id_tipo_espacio FROM sga_tipo_espacio WHERE no_tipo_espacio = TRIM(tx_sector))
FROM stg_espacio
WHERE tx_ambiente IS NOT NULL;

INSERT INTO sga_tipo_espacio (
	no_tipo_espacio,
	id_tipo_espacio_padre )
SELECT DISTINCT
	TRIM(tx_tipologia_1),
	(
	SELECT id_tipo_espacio FROM sga_tipo_espacio WHERE no_tipo_espacio = TRIM(tx_ambiente) and ( id_tipo_espacio_padre in (SELECT id_tipo_espacio 
	FROM sga_tipo_espacio 
	WHERE no_tipo_espacio = TRIM(tx_sector)))  
	)
FROM stg_espacio
WHERE tx_tipologia_1 IS NOT NULL;


