SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE FICHADAS   ----------------------------------------
-- Carga archivos a Stage
COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/fichadas generales 1-05 a 31-05.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'fichadas generales 1-05 a 31-05.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/fichadas generales 1-06 a 1-07 SIN BLANCOS.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'fichadas generales 1-06 a 1-07 SIN BLANCOS.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/fichadas generales 2-07 a 31-07 SIN BLANCOS.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'fichadas generales 2-07 a 31-07 SIN BLANCOS.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/fichadas generales 1-08 a 31-08 SIN BLANCOS.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'fichadas generales 1-08 a 31-08 SIN BLANCOS.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/fichadas generales 1-9 a 30-9 blanco.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'fichadas generales 1-9 a 30-9 blanco.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/fichadas generales 1-10 a 31-10.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'fichadas generales 1-10 a 31-10.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/Fichadas Generales 1-11 a 30-11.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'Fichadas Generales 1-11 a 30-11.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

COPY stg_fichadas ( tx_fecha, tx_legajo, tx_usuario, tx_entrada_hora, tx_entrada_usuario, tx_entrada_descrip,
  tx_entrada_lector, tx_entrada_lista, tx_salida_hora, tx_salida_usuario, tx_salida_descrip, tx_salida_lector,
  tx_salida_lista, tx_total_hs, tx_observacion, tx_dni, tx_empresa_area, tx_tipo_acreditac )
FROM 'C:/archivos/fichadas/fichadas generales 1-12 a 15-01.csv' USING DELIMITERS ',' WITH CSV HEADER;
UPDATE stg_fichadas SET no_archivo = 'fichadas generales 1-12 a 15-01.xlsx', co_lugar = 'C', fe_carga = now(), co_estado_proceso = 'C'
WHERE fe_carga IS NULL;

-- Creando tabla temporal auxiliar (descomentar TRUNC y DROP si ya existe)
--TRUNCATE TABLE tmp_fichadas;
--DROP TABLE tmp_fichadas CASCADE;

CREATE GLOBAL TEMPORARY TABLE tmp_fichadas
  ON COMMIT PRESERVE ROWS AS
SELECT
	id_carga id_carga1,
	(SELECT id_lugar FROM dim_lugar WHERE co_lugar = fi.co_lugar) id_lugar1,
	TO_CHAR(TO_DATE(tx_fecha, 'DD/MM/YYYY'), 'YYYYMMDD')::BIGINT id_fecha1,
	COALESCE((SELECT MAX(id_persona) FROM dim_persona WHERE co_dni_cuit = TRIM(tx_dni) AND co_dni_cuit != '0'), 
	COALESCE((SELECT MAX(id_persona) FROM dim_persona WHERE co_dni_cuit = '0' AND COALESCE(TRIM(tx_dni), '0') = '0' AND co_legajo = COALESCE(tx_legajo, '0')), 0)) id_persona1,
	COALESCE((SELECT MAX(id_tipo_persona) FROM dim_tipo_persona WHERE no_tipo_persona = TRIM(REPLACE(tx_tipo_acreditac, '  ', ' '))), 0) id_tipo_persona1,
	COALESCE((SELECT MAX(id_empresa_area) FROM dim_empresa_area WHERE no_empresa_area = TRIM(REPLACE(tx_empresa_area, '  ', ' '))), 0) id_empresa_area1,
	LPAD(tx_entrada_hora, 5, '0') fe_hora1,
	TRIM(tx_entrada_usuario) no_usuario1,
	TRIM(tx_entrada_descrip) ds_usuario1,
	tx_entrada_lector::INTEGER co_lector1,
	TRIM(tx_observacion) ds_observaciones1
FROM stg_fichadas fi
WHERE co_estado_proceso = 'C';

INSERT INTO tmp_fichadas
SELECT
	id_carga,
	(SELECT id_lugar FROM dim_lugar WHERE co_lugar = fi.co_lugar),
	TO_CHAR(TO_DATE(tx_fecha, 'DD/MM/YYYY'), 'YYYYMMDD')::BIGINT,
	COALESCE((SELECT MAX(id_persona) FROM dim_persona WHERE co_dni_cuit = TRIM(tx_dni) AND co_dni_cuit != '0'), 
	COALESCE((SELECT MAX(id_persona) FROM dim_persona WHERE co_dni_cuit = '0' AND COALESCE(TRIM(tx_dni), '0') = '0' AND co_legajo = COALESCE(tx_legajo, '0')), 0)),
	COALESCE((SELECT MAX(id_tipo_persona) FROM dim_tipo_persona WHERE no_tipo_persona = TRIM(REPLACE(tx_tipo_acreditac, '  ', ' '))), 0),
	COALESCE((SELECT MAX(id_empresa_area) FROM dim_empresa_area WHERE no_empresa_area = TRIM(REPLACE(tx_empresa_area, '  ', ' '))), 0),
	LPAD(tx_salida_hora, 5, '0'),
	TRIM(tx_salida_usuario),
	TRIM(tx_salida_descrip),
	tx_salida_lector::INTEGER,
	TRIM(tx_observacion)
FROM stg_fichadas fi
WHERE co_estado_proceso = 'C'
AND TRIM(tx_salida_usuario) IS NOT NULL;

-- Elimina valores de Hechos viejos
DELETE FROM fac_lectura le
USING tmp_fichadas fi
WHERE id_fecha   = fi.id_fecha1
  AND id_persona = fi.id_persona1
  AND fe_hora    = fi.fe_hora1||':00';

-- Carga lecturas de ENTRADA
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
	co_lector,
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
	fe_hora1||':00' fe_hora,
	MAX(no_usuario1) no_usuario,
	MAX(ds_usuario1) ds_usuario,
	MAX(co_lector1) co_lector,
	MAX(ds_observaciones1) ds_observaciones
FROM tmp_fichadas fi
GROUP BY
	id_fecha1,
	id_persona1,
	fe_hora1;

UPDATE stg_fichadas
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C';

--TRUNCATE TABLE tmp_fichadas;
--DROP TABLE tmp_fichadas CASCADE;

SELECT fn_Carga_Totales();