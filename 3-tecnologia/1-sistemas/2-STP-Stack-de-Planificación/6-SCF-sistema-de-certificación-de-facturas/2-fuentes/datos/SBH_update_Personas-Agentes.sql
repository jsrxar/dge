--SET CLIENT_ENCODING TO 'UTF8';

----------------------------------------   CARGANDO ODS DESDE STG   ----------------------------------------
--###################
--####  Persona  ####
--###################
INSERT INTO ods_persona (
    co_dni_cuit,
    no_persona,
    no_sector,
    no_area, 
    no_puesto
)
SELECT DISTINCT
    tx_dni            co_dni_cuit,
    tx_persona        no_persona,
    tx_sector_area    no_sector,
    'NO IDENTIFICADO' no_area,
    'NO IDENTIFICADO' no_puesto
FROM (
    SELECT DISTINCT
        TRIM(tx_dni)          tx_dni,
        MAX(TRIM(tx_persona)) tx_persona,
        UPPER(MAX(TRIM(tx_empresa_area))) tx_sector_area
    FROM stg_lecturas
    WHERE co_estado_proceso = 'C'
      AND COALESCE(tx_dni, '0') > '0'
      AND tx_dni NOT IN (SELECT co_dni_cuit FROM ods_persona)
    GROUP BY
        tx_dni ) pe;

--###################
--####  Lectura  ####
--###################
DELETE FROM ods_lectura fl
USING stg_lecturas le
WHERE le.co_estado_proceso = 'C'
  AND fl.id_persona        = ( SELECT MAX(id_persona) FROM ods_persona WHERE co_dni_cuit = TRIM(le.tx_dni) )
  AND fl.fe_fecha_lectura  = le.fe_fecha_hora;
  
INSERT INTO ods_lectura (
    id_carga,
    id_persona,
    fe_fecha_lectura,
    co_lugar,
    co_origen,
    no_tipo_acreditacion,
    no_empresa_area,
    no_usuario,
    co_lector,
    ds_observaciones )
SELECT
    id_carga,
    ( SELECT MAX(id_persona) FROM ods_persona WHERE co_dni_cuit = TRIM(le.tx_dni) ) AS id_persona,
    fe_fecha_hora           AS fe_fecha_lectura,
    'C'                     AS co_lugar,
    'A'                     AS co_origen,
    TRIM(tx_tipo_acreditac) AS no_tipo_acreditacion,
    TRIM(tx_empresa_area)   AS no_empresa_area,
    TRIM(tx_usuario)        AS no_usuario,
    TRIM(tx_lector)::INT    AS co_lector,
    TRIM(tx_observacion)    AS ds_observaciones
FROM stg_lecturas le
WHERE co_estado_proceso = 'C';

UPDATE stg_lecturas
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C';

--UPDATE stg_lecturas SET co_estado_proceso = 'C';

----------------------------------------   CARGANDO ODS DESDE FACTURAS   ----------------------------------------
--###################
--####  Persona  ####
--###################
INSERT INTO ods_persona (
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	no_area,
	no_puesto
)
SELECT
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	'NO IDENTIFICADO' no_area,
	no_puesto
FROM dblink ('dbname=sfmycp port=5432 host=127.0.0.1 user=facturas password=F4ct#r4s@2016',
	'SELECT
		TRIM(SPLIT_PART(ag.co_cuit, ''-'', 2))::BIGINT::TEXT AS co_dni_cuit,
		ag.no_agente AS no_persona,
		COALESCE(de.no_direccion_area,
		 COALESCE(de.no_subsecretaria,
		 COALESCE(de.no_secretaria, de.no_ministerio))) AS no_direccion,
		COALESCE(de.no_area_dependencia,
		 COALESCE(de.no_direccion_area,
		 COALESCE(de.no_subsecretaria,
		 COALESCE(de.no_secretaria, de.no_ministerio)))) AS no_dependencia,
		pu.no_puesto AS no_puesto
	FROM facturas.agente ag
	LEFT JOIN facturas.dependencia de ON de.id_dependencia = ag.id_dependencia
	LEFT JOIN facturas.puesto pu ON pu.id_puesto = ag.id_puesto
	WHERE LENGTH(ag.co_cuit) = 13') AS ag (
		co_dni_cuit    TEXT,
		no_persona     TEXT,
		no_direccion   TEXT,
		no_dependencia TEXT,
		no_puesto      TEXT)
WHERE NOT EXISTS (SELECT 1 FROM ods_persona WHERE co_dni_cuit = ag.co_dni_cuit);

UPDATE ods_persona pe
SET
	no_persona     = COALESCE(ag.no_persona, pe.no_persona),
	no_direccion   = COALESCE(ag.no_direccion, pe.no_direccion),
	no_dependencia = COALESCE(ag.no_dependencia, pe.no_dependencia),
	no_puesto      = COALESCE(ag.no_puesto, pe.no_puesto)
FROM dblink ('dbname=sfmycp port=5432 host=127.0.0.1 user=facturas password=F4ct#r4s@2016',
	'SELECT
		TRIM(SPLIT_PART(ag.co_cuit, ''-'', 2))::BIGINT::TEXT AS co_dni_cuit,
		ag.no_agente AS no_persona,
		COALESCE(de.no_direccion_area,
		 COALESCE(de.no_subsecretaria,
		 COALESCE(de.no_secretaria, de.no_ministerio))) AS no_direccion,
		COALESCE(de.no_area_dependencia,
		 COALESCE(de.no_direccion_area,
		 COALESCE(de.no_subsecretaria,
		 COALESCE(de.no_secretaria, de.no_ministerio)))) AS no_dependencia,
		pu.no_puesto AS no_puesto
	FROM facturas.agente ag
	LEFT JOIN facturas.dependencia de ON de.id_dependencia = ag.id_dependencia
	LEFT JOIN facturas.puesto pu ON pu.id_puesto = ag.id_puesto
	WHERE LENGTH(ag.co_cuit) = 13') AS ag (
		co_dni_cuit    TEXT,
		no_persona     TEXT,
		no_direccion   TEXT,
		no_dependencia TEXT,
		no_puesto      TEXT)
WHERE ag.co_dni_cuit = pe.co_dni_cuit;
