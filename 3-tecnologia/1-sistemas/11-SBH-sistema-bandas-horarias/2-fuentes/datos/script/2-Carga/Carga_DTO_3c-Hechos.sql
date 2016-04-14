SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE DTO   ----------------------------------------
--UPDATE ods_lectura SET fe_carga = NULL;

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
	( SELECT MAX(id_origen)
	  FROM dim_origen
	  WHERE co_origen = le.co_origen ) id_origen,
	( SELECT MAX(id_lugar)
	  FROM dim_lugar
	  WHERE co_lugar = le.co_lugar ) id_lugar,
	le.id_fecha,
	TO_CHAR(fe_fecha_lectura, 'HH24MI')::BIGINT id_hora,
	id_persona,
	COALESCE(
	( SELECT MAX(id_tipo_acreditacion)
	  FROM dim_tipo_acreditacion
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
	( SELECT MAX(id_empresa_area)
	  FROM dim_empresa_area
	  WHERE no_empresa_area = le.no_empresa_area ), 0) id_empresa_area,
	1 nu_lecturas,
	fe_fecha_lectura fe_hora,
	TO_CHAR(fe_fecha_lectura, 'HH24:MI:SS') ds_hora,
	ds_observaciones
FROM (
	SELECT
		id_persona,
		fe_fecha_lectura,
		TO_CHAR(fe_fecha_lectura, 'YYYYMMDD')::BIGINT id_fecha,
		MAX(co_origen) co_origen,
		MAX(co_lugar)  co_lugar,
		MAX(no_tipo_acreditacion) no_tipo_acreditacion,
		MAX(no_empresa_area)      no_empresa_area,
		MAX(ds_observaciones)     ds_observaciones
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

SELECT fn_Carga_Totales();
SELECT fn_Carga_Turnos();
