SELECT
	MIN(nu_row) AS nu_row,
	'Espacio: ' ||ds_tipo_espacio || CHR(13) ||
	'Acción: ' || de_tipo_accion || CHR(13) ||
	  'Periodicidad: ' || ds_periodicidad || CHR(13) ||
	  'Esfuerzo: ' || ds_carga || ' con ' || nu_personas::text || ' personas' || CHR(13) ||
	  'Hora: ' || ds_hora || ' (' || nu_pasada || 'º pasada)' AS de_accion_espacio,
	STRING_AGG(no_espacio, CHR(13)) AS ds_espacio,
	ds_metodologia,
	ds_detalle
FROM (
SELECT
	row_number() over () AS nu_row,
	de_tipo_accion,
	ds_tipo_espacio,
	no_espacio,
	ds_periodicidad,
	row_number() over () + 1 - rank() over (ORDER BY de_tipo_accion, ds_tipo_espacio, no_espacio) AS nu_pasada,
	split_part(fe_horas, ',', (row_number() over () + 1 - rank() over (ORDER BY de_tipo_accion, ds_tipo_espacio, no_espacio))::int)::TEXT AS ds_hora,
	TO_CHAR(tm_carga_horaria, 'HH24:MI') AS ds_carga,
	nu_personas,
	ds_metodologia,
	ds_detalle
FROM (
	SELECT
		generate_series(tp.fe_inicio, TO_DATE(${pFecha}::TEXT, 'YYYYMMDD')+1,
		  (pe.va_frecuencia::text || ' ' || pe.ds_tipo_frecuencia)::interval)::date fe_fecha,
		ta.ds_referencia    AS de_tipo_accion,
		TRIM(COALESCE((SELECT ds_referencia FROM sga_tipo_espacio WHERE id_tipo_espacio = es.id_tipo_espacio) || ' > ', ' ') ||
		  COALESCE((SELECT no_sector FROM sga_sector WHERE id_sector = es.id_sector) || ' > ', ' ') ||
		  COALESCE((SELECT no_planta FROM sga_planta WHERE id_planta = es.id_planta), ' ')) AS ds_tipo_espacio,
		es.no_espacio       AS no_espacio,
		pe.no_periodicidad  AS ds_periodicidad,
		tp.fe_horas         AS fe_horas,
		me.ds_metodologia   AS ds_metodologia,
		tp.ds_detalle       AS ds_detalle,
		tp.nu_personas      AS nu_personas,
		tp.tm_carga_horaria AS tm_carga_horaria
	FROM sga_tarea_plan tp
	LEFT JOIN sga_accion ac       ON ac.id_accion = tp.id_accion
	LEFT JOIN sga_tipo_accion ta  ON ta.id_tipo_accion = ac.id_tipo_accion
	LEFT JOIN sga_espacio es      ON es.id_espacio = tp.id_espacio
	LEFT JOIN sga_metodologia me  ON me.id_metodologia = ac.id_metodologia
	LEFT JOIN sga_periodicidad pe ON pe.id_periodicidad = tp.id_periodicidad
	WHERE (${pSector} = -1   OR es.id_sector = ${pSector})
	  AND (${pPlanta} = -100 OR es.id_planta = ${pPlanta})
	ORDER BY 2, 3, 4 ) pl
WHERE fe_fecha = TO_DATE(${pFecha}::TEXT, 'YYYYMMDD') 
ORDER BY 2, 3, 4) hs
WHERE (${pTurno} = 0 OR true = CASE
    WHEN ${pTurno} = 1 AND ds_hora BETWEEN '06:00' AND '13:59' THEN true
    WHEN ${pTurno} = 2 AND ds_hora BETWEEN '14:00' AND '21:59' THEN true
    WHEN ${pTurno} = 3 AND ds_hora >= '22:00' THEN true
    WHEN ${pTurno} = 3 AND ds_hora <  '06:00' THEN true
    ELSE false END)
GROUP BY
  de_tipo_accion,
  ds_tipo_espacio,
  ds_periodicidad,
  nu_pasada,
  ds_hora,
  ds_carga,
  nu_personas,
  ds_metodologia,
  ds_detalle
ORDER BY 1