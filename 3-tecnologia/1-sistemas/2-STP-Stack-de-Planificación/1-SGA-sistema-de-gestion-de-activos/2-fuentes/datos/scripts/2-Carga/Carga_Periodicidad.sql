SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE CIARDI   ----------------------------------------
-- Carga archivo a Stage
COPY stg_periodicidad (
	tx_accion,
	tx_bien,
	tx_espacio,
	tx_cat_bien,
	tx_cat_espacio,
	tx_tipo_accion,
	tx_metodologia,
	tx_frecuencia,
	tx_frecuencia_req,
	tx_duracion,
	tx_qt_recursos )
FROM 'C:\archivos\periodicidad_limpieza.csv' USING DELIMITERS ';' WITH NULL AS '' CSV HEADER;
UPDATE stg_periodicidad SET no_archivo = 'periodicidad limpieza.xlsx', fe_carga = now(), co_estado_proceso = 'C';

INSERT INTO sga_tipo_espacio (
	no_tipo_espacio )
SELECT DISTINCT
	TRIM(tx_espacio)
FROM stg_periodicidad
WHERE tx_espacio IS NOT NULL;

INSERT INTO sga_tipo_espacio (
	no_tipo_espacio,
	id_tipo_espacio_padre )
SELECT DISTINCT
	TRIM(tx_cat_espacio),
	(SELECT id_tipo_espacio FROM sga_tipo_espacio WHERE no_tipo_espacio = TRIM(tx_espacio))
FROM stg_periodicidad
WHERE tx_cat_espacio IS NOT NULL;

INSERT INTO sga_tipo_bien(
	no_tipo_bien )
SELECT DISTINCT
	TRIM(tx_bien)
FROM stg_periodicidad
WHERE tx_bien IS NOT NULL;

INSERT INTO sga_tipo_bien(
	no_tipo_bien,
	id_tipo_bien_padre )
SELECT DISTINCT
	TRIM(tx_cat_bien),
	(SELECT id_tipo_bien FROM sga_tipo_bien WHERE no_tipo_bien = TRIM(tx_bien))
FROM stg_periodicidad
WHERE tx_cat_bien IS NOT NULL;

INSERT INTO sga_actividad (
	no_actividad )
SELECT DISTINCT
	TRIM(tx_accion)
FROM stg_periodicidad
WHERE tx_accion IS NOT NULL;

INSERT INTO sga_actividad (
	no_actividad,
	id_actividad_padre )
SELECT DISTINCT
	TRIM(tx_tipo_accion),
	(SELECT id_actividad FROM sga_actividad WHERE no_actividad = TRIM(tx_accion))
FROM stg_periodicidad
WHERE tx_tipo_accion IS NOT NULL;

INSERT INTO sga_metodologia (
	no_metodologia,
	ds_metodologia,
	id_origen )
SELECT DISTINCT
	CASE WHEN LENGTH(TRIM(tx_metodologia)) > 97 THEN
	  SUBSTR(UPPER(TRIM(tx_metodologia)), 1, 97) || '...'
	  ELSE UPPER(TRIM(tx_metodologia)) END,
	TRIM(tx_metodologia),
	1 id_origen  -- Pliego
FROM stg_periodicidad
WHERE tx_metodologia IS NOT NULL;

INSERT INTO sga_accion (
	id_tipo_espacio,
	id_tipo_bien,
	id_actividad,
	id_origen,
	id_metodologia,
	id_periodicidad,
	fl_a_demanda )
SELECT DISTINCT
	-- Consulta Tipo de Espacio
	COALESCE(
		( SELECT id_tipo_espacio
		  FROM sga_tipo_espacio
		  WHERE no_tipo_espacio = TRIM(tx_cat_espacio)
			AND id_tipo_espacio_padre = (
				SELECT id_tipo_espacio
				FROM sga_tipo_espacio
				WHERE no_tipo_espacio = TRIM(tx_espacio)
				  AND id_tipo_espacio_padre IS NULL ) ),
		( SELECT id_tipo_espacio
		  FROM sga_tipo_espacio
		  WHERE no_tipo_espacio = TRIM(tx_espacio)
			AND id_tipo_espacio_padre IS NULL ) ) id_tipo_espacio,
	-- Consulta Tipo de Bien
	COALESCE(
		( SELECT id_tipo_bien
		  FROM sga_tipo_bien
		  WHERE no_tipo_bien = TRIM(tx_cat_bien)
			AND id_tipo_bien_padre = (
				SELECT id_tipo_bien
				FROM sga_tipo_bien
				WHERE no_tipo_bien = TRIM(tx_bien)
				  AND id_tipo_bien_padre IS NULL ) ),
		( SELECT id_tipo_bien
		  FROM sga_tipo_bien
		  WHERE no_tipo_bien = TRIM(tx_bien)
		    AND id_tipo_bien_padre IS NULL )) id_tipo_bien,
	-- Consulta Actividad
	COALESCE(
		( SELECT id_actividad
		  FROM sga_actividad
		  WHERE no_actividad = TRIM(tx_tipo_accion)
		    AND id_actividad_padre = (
				SELECT id_actividad
				FROM sga_actividad
				WHERE no_actividad = TRIM(tx_accion)
				  AND id_actividad_padre IS NULL ) ),
		( SELECT id_actividad
		  FROM sga_actividad
		  WHERE no_actividad = TRIM(tx_accion)
		    AND id_actividad_padre IS NULL ) ) id_actividad,
	-- Origen: Pliego
	1 id_origen,
	-- Consulta Metodologia
	( SELECT id_metodologia
	  FROM sga_metodologia
	  WHERE ds_metodologia = TRIM(tx_metodologia) ) id_metodologia,
	-- Consulta Frecuencia (Periodicidad)
	CASE TRIM(tx_frecuencia)
		WHEN '2 veces por mañana' THEN 2
		WHEN 'diaria, a demanda' THEN 5
		WHEN 'diario' THEN 5
		WHEN 'semanal, a demanda'  THEN 6
		ELSE ( SELECT id_periodicidad
		       FROM sga_periodicidad
		       WHERE LOWER(no_periodicidad) = LOWER(TRIM(tx_frecuencia)) ) END id_periodicidad,
	-- Verifica si puede ser ejecutada A Demanda
	CASE WHEN LOWER(tx_frecuencia) LIKE '%a demanda%' THEN true ELSE false END fl_a_demanda
FROM stg_periodicidad
WHERE tx_metodologia IS NOT NULL;
