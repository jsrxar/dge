SELECT
	de_tipo_accion,
	ds_espacio,
	MAX(CASE nu_dia WHEN 1 THEN no_dia END)          dia_1_nombre,
	MAX(CASE nu_dia WHEN 1 THEN ds_periodicidad END) dia_1_periodicidad,
	MAX(CASE nu_dia WHEN 2 THEN no_dia END)          dia_2_nombre,
	MAX(CASE nu_dia WHEN 2 THEN ds_periodicidad END) dia_2_periodicidad,
	MAX(CASE nu_dia WHEN 3 THEN no_dia END)          dia_3_nombre,
	MAX(CASE nu_dia WHEN 3 THEN ds_periodicidad END) dia_3_periodicidad,
	MAX(CASE nu_dia WHEN 4 THEN no_dia END)          dia_4_nombre,
	MAX(CASE nu_dia WHEN 4 THEN ds_periodicidad END) dia_4_periodicidad,
	MAX(CASE nu_dia WHEN 5 THEN no_dia END)          dia_5_nombre,
	MAX(CASE nu_dia WHEN 5 THEN ds_periodicidad END) dia_5_periodicidad,
	MAX(CASE nu_dia WHEN 6 THEN no_dia END)          dia_6_nombre,
	MAX(CASE nu_dia WHEN 6 THEN ds_periodicidad END) dia_6_periodicidad,
	MAX(CASE nu_dia WHEN 7 THEN no_dia END)          dia_7_nombre,
	MAX(CASE nu_dia WHEN 7 THEN ds_periodicidad END) dia_7_periodicidad
FROM (
	SELECT
		fe_fecha,
		de_tipo_accion,
		ds_espacio,
		EXTRACT(isodow FROM fe_fecha)   AS nu_dia,
		TO_CHAR(fe_fecha, 'TMDy DD/MM') AS no_dia,
		ds_periodicidad
	FROM (
		SELECT DISTINCT
			generate_series(tp.fe_inicio, TO_DATE('2016-20', 'IYYY-IW')+7,
				(pe.va_frecuencia::text || ' days')::interval)::date fe_fecha,
			ta.ds_referencia    AS de_tipo_accion,
			es.ds_referencia    AS ds_espacio,
			pe.no_periodicidad  AS ds_periodicidad
		FROM sga_tarea_plan tp
		LEFT JOIN sga_accion ac       ON ac.id_accion = tp.id_accion
		LEFT JOIN sga_tipo_accion ta  ON ta.id_tipo_accion = ac.id_tipo_accion
		LEFT JOIN sga_espacio es      ON es.id_espacio = tp.id_espacio
		LEFT JOIN sga_periodicidad pe ON pe.id_periodicidad = tp.id_periodicidad ) tp
	WHERE TO_CHAR(fe_fecha, 'IYYY-IW') = '2016-20' ) ta
GROUP BY
	de_tipo_accion,
	ds_espacio
