SELECT
	generate_series(tp.fe_inicio, '2016-03-31', (pe.va_frecuencia::text || ' days')::interval)::date fe_fecha,
	ta.ds_referencia    AS de_tipo_accion,
	es.ds_referencia    AS ds_espacio,
	pe.no_periodicidad  AS ds_periodicidad,
	me.ds_metodologia   AS ds_metodologia,
	tp.ds_detalle       AS ds_detalle
FROM sga_tarea_plan tp
LEFT JOIN sga_accion ac       ON ac.id_accion = tp.id_accion
LEFT JOIN sga_tipo_accion ta  ON ta.id_tipo_accion = ac.id_tipo_accion
LEFT JOIN sga_espacio es      ON es.id_espacio = tp.id_espacio
LEFT JOIN sga_metodologia me  ON me.id_metodologia = ac.id_metodologia
LEFT JOIN sga_periodicidad pe ON pe.id_periodicidad = tp.id_periodicidad

