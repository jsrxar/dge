SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE CIARDI   ----------------------------------------
-- Carga archivo a Stage
COPY stg_banda_ciardi ( tx_dia, tx_molinete, tx_tipo, tx_ds_molinete, tx_hora, tx_tarjeta, tx_agente, tx_cruce )
FROM 'C:/archivos/ciardi/Banda Horaria - Enero.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_banda_ciardi SET no_archivo = 'Banda Horaria - Enero.xlsx', co_lugar = 'M', fe_carga = now(), co_estado_proceso = 'C';

-- Creando tabla temporal auxiliar (descomentar TRUNC y DROP si ya existe)
--TRUNCATE TABLE tmp_banda_ciardi;
--DROP TABLE tmp_banda_ciardi CASCADE;

CREATE GLOBAL TEMPORARY TABLE tmp_banda_ciardi
  ON COMMIT PRESERVE ROWS AS
SELECT
	id_carga id_carga1,
	(SELECT id_lugar FROM dim_lugar WHERE co_lugar = bc.co_lugar) id_lugar1,
	TO_CHAR(TO_DATE(tx_dia, 'MM/DD/YYYY'), 'YYYYMMDD')::BIGINT id_fecha1,
	COALESCE((SELECT id_persona FROM dim_persona WHERE co_dni_cuit = '0' AND co_legajo = 'T' || TRIM(tx_tarjeta)), 0) id_persona1,
	(SELECT id_tipo_persona FROM dim_tipo_persona WHERE no_tipo_persona = 'CIARDI') id_tipo_persona1,
	(SELECT id_empresa_area FROM dim_empresa_area WHERE no_empresa_area = 'CIARDI') id_empresa_area1,
	LPAD(tx_hora, 8, '0') fe_hora1,
	TRIM(tx_molinete) no_usuario1,
	TRIM(tx_ds_molinete) ds_usuario1,
	tx_tipo ds_observaciones1
FROM stg_banda_ciardi bc
WHERE co_estado_proceso = 'C';

-- Elimina valores de Hechos viejos
DELETE FROM fac_lectura le
USING tmp_banda_ciardi fi
WHERE id_fecha   = fi.id_fecha1
  AND id_persona = fi.id_persona1
  AND fe_hora    = fi.fe_hora1;

-- Carga lecturas
INSERT INTO fac_lectura (
	id_carga,
	id_origen,
	id_lugar,
	id_fecha,
	id_persona,
	id_tipo_persona, 
	id_empresa_area,
	nu_lecturas,
	fe_hora,
	no_usuario,
	ds_usuario,
	ds_observaciones ) 
SELECT
	MAX(id_carga1) id_carga,
	1 id_origen,
	MAX(id_lugar1) id_lugar,
	id_fecha1,
	id_persona1,
	MAX(id_tipo_persona1) id_tipo_persona,
	MAX(id_empresa_area1) id_empresa_area,
	1 nu_lecturas,
	fe_hora1,
	MAX(no_usuario1) no_usuario,
	MAX(ds_usuario1) ds_usuario,
	MAX(ds_observaciones1) ds_observaciones
FROM tmp_banda_ciardi
GROUP BY
	id_fecha1,
	id_persona1,
	fe_hora1;

UPDATE stg_banda_ciardi
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C';

TRUNCATE TABLE tmp_banda_ciardi;
DROP TABLE tmp_banda_ciardi CASCADE;

SELECT fn_Carga_Totales();
