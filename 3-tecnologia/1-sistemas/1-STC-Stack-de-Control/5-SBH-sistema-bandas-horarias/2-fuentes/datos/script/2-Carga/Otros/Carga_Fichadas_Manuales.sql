--SET CLIENT_ENCODING TO 'UTF8';

----------------------------------------   COMPLETANDO STAGE   ----------------------------------------
UPDATE stg_fichadas
SET
	no_archivo = '...',
	co_lugar = 'C',
	fe_carga = now(),
	co_estado_proceso = 'C',
	tx_observacion = 'Manual'
WHERE fe_carga IS NULL;

----------------------------------------   CARGANDO ODS   ----------------------------------------
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
    TRIM(tx_dni)      co_dni_cuit,
    MAX(TRIM(tx_usuario)) no_persona,
    'NO IDENTIFICADO' no_sector,
    'NO IDENTIFICADO' no_area,
    'NO IDENTIFICADO' no_puesto
FROM stg_fichadas
WHERE co_estado_proceso = 'C'
  AND tx_observacion = 'Manual'
  AND COALESCE(TRIM(tx_dni)::BIGINT, 0) > 0
  AND TRIM(tx_dni) NOT IN (SELECT co_dni_cuit FROM ods_persona)
GROUP BY
	TRIM(tx_dni);

--###################
--####  Lectura  ####
--###################
INSERT INTO ods_lectura (
    id_carga,
    id_persona,
    fe_fecha_lectura,
    co_lugar,
    co_origen,
    no_tipo_acreditacion,
    no_empresa_area,
    no_usuario,
    ds_observaciones )
SELECT
    id_carga,
    ( SELECT MAX(id_persona) FROM ods_persona WHERE co_dni_cuit = TRIM(fi.tx_dni) ) AS id_persona,
    TO_TIMESTAMP(TRIM(fi.tx_fecha) || LPAD(TRIM(fi.tx_entrada_hora), 5, '0'), 'DD/MM/YYYYHH24:MI')::timestamp without time zone AS fe_fecha_lectura,
    co_lugar                AS co_lugar,
    'M'                     AS co_origen,
    'Carga Manual'          AS no_tipo_acreditacion,
    'IMPECABLE'             AS no_empresa_area,
    'Manual'                AS no_usuario,
    'Carga Manual'          AS ds_observaciones
FROM stg_fichadas fi
WHERE co_estado_proceso = 'C'
  AND tx_observacion = 'Manual'
  AND NOT EXISTS (
  SELECT 1 FROM ods_lectura
  WHERE id_persona = ( SELECT MAX(id_persona) FROM ods_persona WHERE co_dni_cuit = TRIM(fi.tx_dni) )
    AND fe_fecha_lectura = TO_TIMESTAMP(TRIM(fi.tx_fecha) || LPAD(TRIM(fi.tx_entrada_hora), 5, '0'), 'DD/MM/YYYYHH24:MI')::timestamp without time zone );

UPDATE stg_fichadas
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C'
  AND tx_observacion = 'Manual';

----------------------------------------   CARGANDO DW - DIMENSIONES   ---------------------------------------- 
--###################
--####  Persona  ####
--###################
INSERT INTO dim_persona(
    id_persona,
    co_dni_cuit,
    no_persona,
    no_sector,
    no_area, 
    no_puesto
)
SELECT
    id_persona,
    co_dni_cuit,
    no_persona,
    no_sector,
    no_area,
    no_puesto
FROM ods_persona
WHERE id_persona NOT IN ( SELECT id_persona FROM dim_persona );

----------------------------------------   CARGANDO DW - HECHOS   ---------------------------------------- 
-- Elimina valores de Hechos viejos
DELETE FROM fac_lectura fl
USING ods_lectura le
WHERE fl.id_persona = le.id_persona
  AND fl.fe_hora    = le.fe_fecha_lectura
  AND le.fe_carga IS NULL;

-- Carga lecturas
INSERT INTO fac_lectura (
    id_origen,
    id_lugar,
    id_fecha,
    id_hora,
    id_persona,
    id_tipo_acreditacion, 
    id_tipo_hora, 
    id_empresa_area,
    nu_lecturas,
    fe_hora,
    ds_hora,
    ds_observaciones )
SELECT
    ( SELECT MAX(id_origen) FROM dim_origen WHERE co_origen = le.co_origen ) AS id_origen,
    ( SELECT MAX(id_lugar)  FROM dim_lugar  WHERE co_lugar  = le.co_lugar )  AS id_lugar,
    le.id_fecha,
    TO_CHAR(fe_fecha_lectura, 'HH24MI')::BIGINT AS id_hora,
    id_persona,
    COALESCE(
    ( SELECT MAX(id_tipo_acreditacion) FROM dim_tipo_acreditacion
      WHERE no_tipo_acreditacion = le.no_tipo_acreditacion ), 0) id_tipo_acreditacion,
    CASE
        -- Fin de semana anterior al 22/02/2016 (turno 12h)
        WHEN (SELECT fl_fin_semana FROM dim_fecha WHERE id_fecha = le.id_fecha) = 'Si' AND id_fecha < 20160222 THEN
        CASE
            WHEN TO_CHAR(fe_fecha_lectura, 'HH24MI') BETWEEN '0430' AND '0730' THEN 1
            WHEN TO_CHAR(fe_fecha_lectura, 'HH24MI') BETWEEN '1630' AND '1930' THEN 4
            ELSE 0 END
        -- Otro tipo de fecha (turno 8hs)
        WHEN TO_CHAR(fe_fecha_lectura, 'HH24MI') BETWEEN '0430' AND '0730' THEN 1
        WHEN TO_CHAR(fe_fecha_lectura, 'HH24MI') BETWEEN '1230' AND '1530' THEN 2
        WHEN TO_CHAR(fe_fecha_lectura, 'HH24MI') BETWEEN '2030' AND '2330' THEN 3
        ELSE 0 END id_tipo_hora,
    COALESCE(
    ( SELECT MAX(id_empresa_area) FROM dim_empresa_area
      WHERE no_empresa_area = le.no_empresa_area ), 0) id_empresa_area,
    1 nu_lecturas,
    fe_fecha_lectura fe_hora,
    TO_CHAR(fe_fecha_lectura, 'HH24:MI:SS') ds_hora,
    ds_observaciones
FROM (
    SELECT
        id_persona,
        fe_fecha_lectura,
        TO_CHAR(fe_fecha_lectura, 'YYYYMMDD')::BIGINT AS id_fecha,
        MAX(co_origen)            AS co_origen,
        MAX(co_lugar)             AS co_lugar,
        MAX(no_tipo_acreditacion) AS no_tipo_acreditacion,
        MAX(no_empresa_area)      AS no_empresa_area,
        MAX(ds_observaciones)     AS ds_observaciones
    FROM ods_lectura le
    WHERE id_persona IS NOT NULL
      AND fe_fecha_lectura IS NOT NULL
      AND fe_carga IS NULL
    GROUP BY
        id_persona,
        fe_fecha_lectura ) le;

UPDATE ods_lectura
SET fe_carga = now()
WHERE fe_carga IS NULL;

--SET CLIENT_ENCODING TO 'UTF8';

----------------------------------------   DW - CALCULA TOTALES   ----------------------------------------
--###################
--####  Totales  ####
--###################
UPDATE fac_lectura SET fl_procesado = FALSE
WHERE id_fecha >= TO_CHAR((SELECT MIN(fe_hora) FROM fac_lectura WHERE fl_procesado = FALSE) - INTERVAL '1 day', 'YYYYMMDD')::BIGINT
  AND fe_hora  >= DATE_TRUNC('day', (SELECT MIN(fe_hora) FROM fac_lectura WHERE fl_procesado = FALSE) - INTERVAL '1 day') + INTERVAL '4 hours';

DELETE FROM fac_totales WHERE id_fecha >= (SELECT MIN(id_fecha) FROM fac_lectura WHERE fl_procesado = FALSE);

SELECT fn_Carga_Totales();

--##################
--####  Turnos  ####
--##################
UPDATE fac_lectura SET fl_procesado = FALSE
WHERE id_fecha >= (SELECT MIN(id_fecha) FROM fac_lectura WHERE fl_procesado = FALSE);

DELETE FROM fac_turnos
WHERE id_fecha_inicio >= (SELECT MIN(id_fecha) FROM fac_lectura WHERE fl_procesado = FALSE);

UPDATE fac_lectura le SET fl_procesado = TRUE
FROM fac_turnos tu
WHERE le.fl_procesado = FALSE
  AND le.id_persona   = tu.id_persona
  AND le.id_fecha    >= tu.id_fecha_inicio
  AND le.id_fecha     = tu.id_fecha_fin
  AND le.fe_hora      = tu.fe_hora_fin;

SELECT fn_Carga_Turnos();