SELECT
	dfe.fe_fecha,
	dfe.no_mes || ' ' || dfe.nu_anio::text no_mes,
	dfe.nu_dia,
	dfe.no_dia_semana || ' ' || dfe.nu_dia::text || ' de ' || dfe.no_mes no_dia,
	dth.no_turno,
	CASE dth.id_tipo_hora WHEN 0 THEN 0 ELSE 47 END nu_requerimiento,
	COUNT(DISTINCT ftu.id_persona)         nu_personas,
	CASE dth.id_tipo_hora WHEN 0 THEN 0 ELSE COUNT(DISTINCT ftu.id_persona)-47 END nu_diferencia,
	CASE dth.id_tipo_hora
		WHEN 2 THEN '06:00 a 14:00'
		WHEN 3 THEN '14:00 a 22:00'
		WHEN 4 THEN '22:00 a 06:00'
		ELSE '' END                    ds_banda,
	SUBSTR(COALESCE(AVG(ftu.fe_hora_fin - ftu.fe_hora_inicio), '0')::text, 1, 8)      va_horas_media,
	SUBSTR(COALESCE(AVG(ftu.fe_hora_fin - ftu.fe_hora_inicio)-'8:', '0')::text, 1, 11) va_desvio,
	COALESCE(MAX(inc.nu_lecturas), 0)      nu_inconsistencias
FROM
	( SELECT dfe.id_fecha, dth.id_tipo_hora
	  FROM dim_tipo_hora dth, dim_fecha dfe
	  WHERE dfe.id_fecha BETWEEN 20160100 AND 20160199
	    AND id_tipo_hora NOT IN (1) ) fec
	LEFT JOIN (
		SELECT
			ftu.id_persona,
			ftu.id_fecha_inicio,
			ftu.fe_hora_inicio,
			ftu.fe_hora_fin,
			ftu.id_tipo_hora,
			ftu.va_horas_media
		FROM
			fac_turnos ftu
			LEFT JOIN dim_empresa_area dea
			   ON dea.id_empresa_area = ftu.id_empresa_area
		WHERE dea.no_empresa_area LIKE '%IMPECABLE%' ) ftu
	   ON ftu.id_fecha_inicio = fec.id_fecha
	  AND ftu.id_tipo_hora    = fec.id_tipo_hora
	LEFT JOIN dim_tipo_hora    dth
	   ON dth.id_tipo_hora    = fec.id_tipo_hora
	LEFT JOIN dim_fecha        dfe
	   ON dfe.id_fecha        = fec.id_fecha
	LEFT JOIN (
		SELECT
			id_fecha_inicio,
			CASE
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '0600' AND '1359' THEN 2
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '1400' AND '2159' THEN 3
				ELSE 4 END id_tipo_hora,
			COUNT(0) nu_lecturas
		FROM
			fac_turnos INNER JOIN dim_empresa_area
			 ON dim_empresa_area.id_empresa_area = fac_turnos.id_empresa_area
		WHERE no_empresa_area LIKE '%IMPECABLE%'
		  AND id_tipo_hora = 0
		  AND id_fecha_inicio BETWEEN 20160100 AND 20160199
		GROUP BY
			id_fecha_inicio,
			CASE
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '0600' AND '1359' THEN 2
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '1400' AND '2159' THEN 3
				ELSE 4 END
		ORDER BY
			id_fecha_inicio ) inc
	   ON inc.id_fecha_inicio = fec.id_fecha
	  AND inc.id_tipo_hora    = fec.id_tipo_hora
GROUP BY
	dfe.nu_anio,
	dfe.no_mes,
	dfe.nu_dia,
	dfe.fe_fecha,
	dfe.no_dia_semana,
	dth.id_tipo_hora,
	dth.no_turno
ORDER BY
	dfe.fe_fecha,
	CASE dth.id_tipo_hora WHEN 0 THEN 5 ELSE dth.id_tipo_hora END

SELECT
	ftu.id_fecha_inicio,
	ftu.fe_hora_inicio,
	ftu.id_fecha_fin,
	ftu.fe_hora_fin,
	ftu.nu_lecturas,
	ftu.va_horas_total,
	ftu.va_horas_media,
	dpe.co_dni_cuit,
	dpe.co_legajo,
	dpe.no_persona,
	dpe.no_sector,
	dpe.no_area,
	dpe.no_puesto,
	dfe.id_fecha,
	dfe.fe_fecha,
	dfe.no_fecha,
	dfe.nu_anio,
	dfe.nu_mes,
	dfe.no_mes,
	dfe.nu_dia,
	dfe.nu_dia_semana,
	dfe.no_dia_semana,
	dfe.nu_semana_anio,
	dfe.nu_dia_ano,
	dfe.nu_cuatrimestre,
	dfe.fl_fin_semana,
	dfe.fl_feriado,
	dfe.no_estacion,
	dth.id_tipo_hora,
	dth.no_tipo_hora,
	dth.no_turno,
FROM
	fac_turnos ftu
	INNER JOIN dim_persona      dpe ON dpe.id_persona      = ftu.id_persona
	INNER JOIN dim_fecha        dfe ON dfe.id_fecha        = ftu.id_fecha_inicio
	INNER JOIN dim_tipo_hora    dth ON dth.id_tipo_hora    = ftu.id_tipo_hora
	INNER JOIN dim_empresa_area dea ON dea.id_empresa_area = ftu.id_empresa_area
WHERE dea.no_empresa_area LIKE '%IMPECABLE%'