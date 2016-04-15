CREATE OR REPLACE FUNCTION fn_Carga_Totales() RETURNS INTEGER AS
$BODY$
DECLARE
    aux INTEGER;
BEGIN
	--DELETE FROM fac_totales;
	INSERT INTO fac_totales (
		id_lectura,
		id_persona,
		id_fecha,
		id_lugar,
		id_tipo_acreditacion, 
		id_empresa_area,
		nu_lecturas,
		nu_persona_dias,
		fe_hora_min,
		fe_hora_max, 
		va_hora_min,
		va_hora_max, 
		va_horas_total,
		va_horas_media,
		ds_observaciones )
	SELECT
		MAX(id_lectura)           AS id_lectura,
		id_persona                AS id_persona,
		TO_CHAR(fe_hora - interval '4 hour', 'YYYYMMDD')::BIGINT AS id_fecha,
		MAX(id_lugar)             AS id_lugar,
		MAX(id_tipo_acreditacion) AS id_tipo_acreditacion,
		MAX(id_empresa_area)      AS id_empresa_area,
		COUNT(0)                  AS nu_lecturas,
		CASE WHEN COUNT(0) > 1 THEN 1 ELSE 0 END AS nu_persona_dias,
		MIN(fe_hora)              AS fe_hora_min,
		MAX(fe_hora)              AS fe_hora_max,
		EXTRACT(epoch FROM MIN(fe_hora)::time)/(60*60) AS va_hora_min,
		EXTRACT(epoch FROM MAX(fe_hora)::time)/(60*60) AS va_hora_max,
		EXTRACT(epoch FROM (MAX(fe_hora)-MIN(fe_hora)))/(60*60) AS va_horas_total,
		CASE WHEN COUNT(0) > 1 THEN
			EXTRACT(epoch FROM (MAX(fe_hora)-MIN(fe_hora)))/(60*60)
			ELSE NULL END     AS va_horas_media,
		LEFT('Origen: ' || STRING_AGG((
			SELECT co_origen FROM dim_origen
			WHERE id_origen = fl.id_origen), ', '), 400) AS ds_observaciones
	FROM fac_lectura fl
	WHERE fl_procesado = FALSE
	GROUP BY
		id_persona,
		TO_CHAR(fe_hora - interval '4 hour', 'YYYYMMDD');

	RETURN 1;
END
$BODY$
LANGUAGE 'plpgsql' ;

/* SELECT fn_Carga_Totales(); */

CREATE OR REPLACE FUNCTION fn_Carga_Turnos() RETURNS INTEGER AS
$BODY$
DECLARE
    aux INTEGER;
BEGIN
	--DELETE FROM fac_turnos;
	--UPDATE fac_lectura SET fl_procesado = FALSE;
	--##############################################################################
	--####    CARGA DEL TURNO MAÑANA - NORMAL                                    ###
	--##############################################################################
	INSERT INTO fac_turnos (
		id_persona,
		id_fecha_inicio,
		fe_hora_inicio,
		id_origen_inicio,
		id_fecha_fin,
		fe_hora_fin,
		id_origen_fin,
		id_turno,
		id_turno_inicio,
		id_tipo_hora,
		id_empresa_area,
		nu_lecturas,
		va_horas_total,
		va_horas_media )
	SELECT
		ini.id_persona,
		ini.id_fecha,
		ini.fe_hora,
		ini.id_origen,
		fin.id_fecha,
		fin.fe_hora,
		fin.id_origen,
		ini.id_tipo_hora,
		CASE WHEN TO_CHAR(ini.fe_hora, 'HH24') < '06' THEN 3 ELSE 1 END id_turno_inicio,
		ini.id_tipo_hora,
		ini.id_empresa_area,
		( SELECT COUNT(0) FROM fac_lectura
		  WHERE fl_procesado = FALSE
		    AND id_persona = ini.id_persona
		    AND id_fecha BETWEEN ini.id_fecha AND fin.id_fecha
		    AND fe_hora  BETWEEN ini.fe_hora AND fin.fe_hora ) nu_lecturas,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_total,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_media
	FROM
		fac_lectura ini
		INNER JOIN fac_lectura fin
			ON  fin.id_persona = ini.id_persona
			AND fin.id_fecha   = ini.id_fecha
	WHERE ini.fl_procesado = FALSE
	  AND ini.id_tipo_hora = 1  -- Mañana
	  AND ini.fe_hora = (
		SELECT MIN(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = ini.id_persona
		  AND id_fecha     = ini.id_fecha
		  AND id_tipo_hora = ini.id_tipo_hora )
	  AND fin.fl_procesado = FALSE
	  AND fin.id_tipo_hora = 2  -- Tarde
	  AND fin.fe_hora = (
		SELECT MAX(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = fin.id_persona
		  AND id_fecha     = fin.id_fecha
		  AND id_tipo_hora = fin.id_tipo_hora );

	UPDATE fac_lectura le
	SET fl_procesado = TRUE
	FROM fac_turnos tu
	WHERE le.fl_procesado = FALSE
	  AND tu.id_turno   = 1  -- Mañana
	  AND le.id_persona = tu.id_persona
	  AND le.id_fecha BETWEEN tu.id_fecha_inicio AND tu.id_fecha_fin
	  AND le.fe_hora  BETWEEN tu.fe_hora_inicio AND tu.fe_hora_fin;

	--##############################################################################
	--####    CARGA DEL TURNO TARDE - NORMAL                                     ###
	--##############################################################################
	INSERT INTO fac_turnos (
		id_persona,
		id_fecha_inicio,
		fe_hora_inicio,
		id_origen_inicio,
		id_fecha_fin,
		fe_hora_fin,
		id_origen_fin,
		id_turno,
		id_turno_inicio,
		id_tipo_hora,
		id_empresa_area,
		nu_lecturas,
		va_horas_total,
		va_horas_media )
	SELECT
		ini.id_persona,
		ini.id_fecha,
		ini.fe_hora,
		ini.id_origen,
		fin.id_fecha,
		fin.fe_hora,
		fin.id_origen,
		ini.id_tipo_hora,
		CASE WHEN TO_CHAR(ini.fe_hora, 'HH24') < '14' THEN 1 ELSE 2 END id_turno_inicio,
		ini.id_tipo_hora,
		ini.id_empresa_area,
		( SELECT COUNT(0) FROM fac_lectura
		  WHERE fl_procesado = FALSE
		    AND id_persona = ini.id_persona
		    AND id_fecha BETWEEN ini.id_fecha AND fin.id_fecha
		    AND fe_hora  BETWEEN ini.fe_hora AND fin.fe_hora ) nu_lecturas,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_total,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_media
	FROM
		fac_lectura ini
		INNER JOIN fac_lectura fin
			ON  fin.id_persona = ini.id_persona
			AND fin.id_fecha   = ini.id_fecha
	WHERE ini.fl_procesado = FALSE
	  AND ini.id_tipo_hora = 2  -- Tarde
	  AND ini.fe_hora = (
		SELECT MIN(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = ini.id_persona
		  AND id_fecha     = ini.id_fecha
		  AND id_tipo_hora = ini.id_tipo_hora )
	  AND fin.fl_procesado = FALSE
	  AND fin.id_tipo_hora = 3  -- Noche
	  AND fin.fe_hora = (
		SELECT MAX(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = fin.id_persona
		  AND id_fecha     = fin.id_fecha
		  AND id_tipo_hora = fin.id_tipo_hora );

	UPDATE fac_lectura le
	SET fl_procesado = TRUE
	FROM fac_turnos tu
	WHERE le.fl_procesado = FALSE
	  AND tu.id_turno   = 2  -- Tarde
	  AND le.id_persona = tu.id_persona
	  AND le.id_fecha BETWEEN tu.id_fecha_inicio AND tu.id_fecha_fin
	  AND le.fe_hora  BETWEEN tu.fe_hora_inicio AND tu.fe_hora_fin;

	--##############################################################################
	--####    CARGA DEL TURNO NOCHE - NORMAL                                     ###
	--##############################################################################
	INSERT INTO fac_turnos (
		id_persona,
		id_fecha_inicio,
		fe_hora_inicio,
		id_origen_inicio,
		id_fecha_fin,
		fe_hora_fin,
		id_origen_fin,
		id_turno,
		id_turno_inicio,
		id_tipo_hora,
		id_empresa_area,
		nu_lecturas,
		va_horas_total,
		va_horas_media )
	SELECT
		ini.id_persona,
		ini.id_fecha,
		ini.fe_hora,
		ini.id_origen,
		fin.id_fecha,
		fin.fe_hora,
		fin.id_origen,
		ini.id_tipo_hora,
		CASE WHEN TO_CHAR(ini.fe_hora, 'HH24') < '22' THEN 2 ELSE 3 END id_turno_inicio,
		ini.id_tipo_hora,
		ini.id_empresa_area,
		( SELECT COUNT(0) FROM fac_lectura
		  WHERE fl_procesado = FALSE
		    AND id_persona = ini.id_persona
		    AND id_fecha BETWEEN ini.id_fecha AND fin.id_fecha
		    AND fe_hora  BETWEEN ini.fe_hora AND fin.fe_hora ) nu_lecturas,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_total,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_media
	FROM
		fac_lectura ini
		INNER JOIN fac_lectura fin
			ON  fin.id_persona = ini.id_persona
			AND fin.id_fecha   = TO_CHAR(ini.id_fecha::TEXT::DATE+1,'YYYYMMDD')::BIGINT
	WHERE ini.fl_procesado = FALSE
	  AND ini.id_tipo_hora = 3  -- Noche
	  AND ini.fe_hora = (
		SELECT MIN(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = ini.id_persona
		  AND id_fecha     = ini.id_fecha
		  AND id_tipo_hora = ini.id_tipo_hora )
	  AND fin.fl_procesado = FALSE
	  AND fin.id_tipo_hora = 1  -- Mañana
	  AND fin.fe_hora = (
		SELECT MAX(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = fin.id_persona
		  AND id_fecha     = fin.id_fecha
		  AND id_tipo_hora = fin.id_tipo_hora );

	UPDATE fac_lectura le
	SET fl_procesado = TRUE
	FROM fac_turnos tu
	WHERE le.fl_procesado = FALSE
	  AND tu.id_turno   = 3  -- Noche
	  AND le.id_persona = tu.id_persona
	  AND le.id_fecha BETWEEN tu.id_fecha_inicio AND tu.id_fecha_fin
	  AND le.fe_hora  BETWEEN tu.fe_hora_inicio AND tu.fe_hora_fin;

	--##############################################################################
	--####    CARGA DEL TURNO MAÑANA - FIN DE SEMANA ANTES DEL 22/02/2016        ###
	--##############################################################################
	INSERT INTO fac_turnos (
		id_persona,
		id_fecha_inicio,
		fe_hora_inicio,
		id_origen_inicio,
		id_fecha_fin,
		fe_hora_fin,
		id_origen_fin,
		id_turno,
		id_turno_inicio,
		id_tipo_hora,
		id_empresa_area,
		nu_lecturas,
		va_horas_total,
		va_horas_media )
	SELECT
		ini.id_persona,
		ini.id_fecha,
		ini.fe_hora,
		ini.id_origen,
		fin.id_fecha,
		fin.fe_hora,
		fin.id_origen,
		4,  -- Mañana (FS)
		CASE WHEN TO_CHAR(ini.fe_hora, 'HH24') < '06' THEN 5 ELSE 4 END id_turno_inicio,
		ini.id_tipo_hora,
		ini.id_empresa_area,
		( SELECT COUNT(0) FROM fac_lectura
		  WHERE fl_procesado = FALSE
		    AND id_persona = ini.id_persona
		    AND id_fecha BETWEEN ini.id_fecha AND fin.id_fecha
		    AND fe_hora  BETWEEN ini.fe_hora AND fin.fe_hora ) nu_lecturas,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_total,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_media
	FROM
		fac_lectura ini
		INNER JOIN fac_lectura fin
			ON  fin.id_persona = ini.id_persona
			AND fin.id_fecha   = ini.id_fecha
	WHERE ini.fl_procesado = FALSE
	  AND ini.id_tipo_hora = 1  -- Mañana
	  AND ini.fe_hora = (
		SELECT MIN(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = ini.id_persona
		  AND id_fecha     = ini.id_fecha
		  AND id_tipo_hora = ini.id_tipo_hora )
	  AND fin.fl_procesado = FALSE
	  AND fin.id_tipo_hora = 4  -- Tarde/Noche
	  AND fin.fe_hora = (
		SELECT MAX(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = fin.id_persona
		  AND id_fecha     = fin.id_fecha
		  AND id_tipo_hora = fin.id_tipo_hora );

	UPDATE fac_lectura le
	SET fl_procesado = TRUE
	FROM fac_turnos tu
	WHERE le.fl_procesado = FALSE
	  AND tu.id_turno   = 4  -- Mañana (FS)
	  AND le.id_persona = tu.id_persona
	  AND le.id_fecha BETWEEN tu.id_fecha_inicio AND tu.id_fecha_fin
	  AND le.fe_hora  BETWEEN tu.fe_hora_inicio AND tu.fe_hora_fin;

	--##############################################################################
	--####    CARGA DEL TURNO NOCHE - FIN DE SEMANA ANTES DEL 22/02/2016         ###
	--##############################################################################
	INSERT INTO fac_turnos (
		id_persona,
		id_fecha_inicio,
		fe_hora_inicio,
		id_origen_inicio,
		id_fecha_fin,
		fe_hora_fin,
		id_origen_fin,
		id_turno,
		id_turno_inicio,
		id_tipo_hora,
		id_empresa_area,
		nu_lecturas,
		va_horas_total,
		va_horas_media )
	SELECT
		ini.id_persona,
		ini.id_fecha,
		ini.fe_hora,
		ini.id_origen,
		fin.id_fecha,
		fin.fe_hora,
		fin.id_origen,
		5,  -- Noche (FS)
		CASE WHEN TO_CHAR(ini.fe_hora, 'HH24') < '18' THEN 4 ELSE 5 END id_turno_inicio,
		ini.id_tipo_hora,
		ini.id_empresa_area,
		( SELECT COUNT(0) FROM fac_lectura
		  WHERE fl_procesado = FALSE
		    AND id_persona = ini.id_persona
		    AND id_fecha BETWEEN ini.id_fecha AND fin.id_fecha
		    AND fe_hora  BETWEEN ini.fe_hora AND fin.fe_hora ) nu_lecturas,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_total,
		EXTRACT(epoch FROM (fin.fe_hora-ini.fe_hora))/(60*60) va_horas_media
	FROM
		fac_lectura ini
		INNER JOIN fac_lectura fin
			ON  fin.id_persona = ini.id_persona
			AND fin.id_fecha   = TO_CHAR(ini.id_fecha::TEXT::DATE+1,'YYYYMMDD')::BIGINT
	WHERE ini.fl_procesado = FALSE
	  AND ini.id_tipo_hora = 4  -- Tarde/Noche
	  AND ini.fe_hora = (
		SELECT MIN(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = ini.id_persona
		  AND id_fecha     = ini.id_fecha
		  AND id_tipo_hora = ini.id_tipo_hora )
	  AND fin.fl_procesado = FALSE
	  AND fin.id_tipo_hora = 1  -- Mañana
	  AND fin.fe_hora = (
		SELECT MAX(fe_hora)
		FROM fac_lectura
		WHERE id_persona   = fin.id_persona
		  AND id_fecha     = fin.id_fecha
		  AND id_tipo_hora = fin.id_tipo_hora );

	UPDATE fac_lectura le
	SET fl_procesado = TRUE
	FROM fac_turnos tu
	WHERE le.fl_procesado = FALSE
	  AND tu.id_turno   = 5  -- Noche (FS)
	  AND le.id_persona = tu.id_persona
	  AND le.id_fecha BETWEEN tu.id_fecha_inicio AND tu.id_fecha_fin
	  AND le.fe_hora  BETWEEN tu.fe_hora_inicio AND tu.fe_hora_fin;

	--##############################################################################
	--####    CARGA DE INCONSISTENCIAS                                           ###
	--##############################################################################
	INSERT INTO fac_turnos (
		id_persona,
		id_fecha_inicio,
		fe_hora_inicio,
		id_origen_inicio,
		id_turno,
		id_turno_inicio,
		id_tipo_hora,
		id_empresa_area,
		nu_lecturas,
		va_horas_total,
		va_horas_media )
	SELECT
		id_persona,
		id_fecha,
		fe_hora,
		id_origen,
		0 id_turno,
		CASE
			-- Sábado anterior al 22/02/2016 (turno 12h)
			WHEN (SELECT nu_dia_semana FROM dim_fecha WHERE id_fecha = le.id_fecha) = 6 AND id_fecha < 20160222 THEN
			CASE
				WHEN TO_CHAR(fe_hora, 'HH24') < '06' THEN 3
				WHEN TO_CHAR(fe_hora, 'HH24') < '18' THEN 4
				ELSE 5 END
			-- Domingo anterior al 22/02/2016 (turno 12h)
			WHEN (SELECT nu_dia_semana FROM dim_fecha WHERE id_fecha = le.id_fecha) = 7 AND id_fecha < 20160222 THEN
			CASE
				WHEN TO_CHAR(fe_hora, 'HH24') < '06' THEN 5
				WHEN TO_CHAR(fe_hora, 'HH24') < '18' THEN 4
				ELSE 5 END
			-- Lunes anterior al 22/02/2016 (turno 8h)
			WHEN (SELECT nu_dia_semana FROM dim_fecha WHERE id_fecha = le.id_fecha) = 1 AND id_fecha < 20160222 THEN
			CASE
				WHEN TO_CHAR(fe_hora, 'HH24') < '06' THEN 5
				WHEN TO_CHAR(fe_hora, 'HH24') < '14' THEN 1
				WHEN TO_CHAR(fe_hora, 'HH24') < '22' THEN 2
				ELSE 3 END
			-- Otro tipo de fecha (turno 8hs)
			WHEN TO_CHAR(fe_hora, 'HH24') < '06' THEN 3
			WHEN TO_CHAR(fe_hora, 'HH24') < '14' THEN 1
			WHEN TO_CHAR(fe_hora, 'HH24') < '22' THEN 2
			ELSE 3 END id_turno_inicio,
		id_tipo_hora,
		id_empresa_area,
		1 nu_lecturas,
		0 va_horas_total,
		0 va_horas_media
	FROM fac_lectura le
	WHERE fl_procesado = FALSE;

	UPDATE fac_lectura
	SET fl_procesado = TRUE
	WHERE fl_procesado = FALSE;

	RETURN 1;
END
$BODY$
LANGUAGE 'plpgsql' ;

/* SELECT fn_Carga_Turnos(); */
