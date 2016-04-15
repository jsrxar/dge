SELECT
	dfe.fe_fecha,
	dfe.no_mes || ' ' || dfe.nu_anio::text no_mes,
	dfe.nu_dia,
	dfe.no_dia_semana || ' ' || dfe.nu_dia::text || ' de ' || dfe.no_mes no_dia,
	dth.no_turno,
	CASE 
		WHEN dth.id_tipo_hora = 3 THEN 36
		WHEN MAX(turno) = 8 THEN 37
		WHEN MAX(turno) = 12 THEN 70 END nu_requerimiento,
	COUNT(DISTINCT ftu.id_persona)         nu_personas,
	CASE 
		WHEN dth.id_tipo_hora = 3 THEN COUNT(DISTINCT ftu.id_persona)-36
		WHEN MAX(turno) = 8 THEN COUNT(DISTINCT ftu.id_persona)-37
		WHEN MAX(turno) = 12 THEN COUNT(DISTINCT ftu.id_persona)-70 END nu_diferencia,
	CASE 
		WHEN dth.id_tipo_hora = 2 AND MAX(turno) = 8 THEN '06:00 a 14:00'
		WHEN dth.id_tipo_hora = 2 AND MAX(turno) = 12 THEN '06:00 a 18:00'
		WHEN dth.id_tipo_hora = 3 THEN '14:00 a 22:00'
		WHEN dth.id_tipo_hora = 4 THEN '22:00 a 06:00'
		WHEN dth.id_tipo_hora = 5 THEN '18:00 a 06:00'
		ELSE '' END                    ds_banda,
	SUBSTR(COALESCE(AVG(ftu.fe_hora_fin - ftu.fe_hora_inicio), '0')::text, 1, 8)      va_horas_media,
	SUBSTR(COALESCE(AVG(ftu.fe_hora_fin - ftu.fe_hora_inicio)-'8:', '0')::text, 1, 11) va_desvio,
	COALESCE(MAX(inc.nu_lecturas), 0)      nu_inconsistencias
FROM
	( SELECT id_fecha, id_tipo_hora, 8 turno
	  FROM dim_tipo_hora dth, dim_fecha dfe
	  WHERE id_fecha BETWEEN 20160101 AND 20160199 --${Mes} AND ${Mes}+98
	    AND fl_fin_semana = 'No'
	    AND id_tipo_hora IN (2, 3, 4)
	  UNION ALL
	  SELECT id_fecha, id_tipo_hora, 12 turno
	  FROM dim_tipo_hora dth, dim_fecha dfe
	  WHERE id_fecha BETWEEN 20160101 AND 20160199 --${Mes} AND ${Mes}+98
	    AND fl_fin_semana = 'Si'
	    AND id_tipo_hora IN (2, 5) ) fec
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
		WHERE id_fecha_inicio BETWEEN 20160101 AND 20160199 --${Mes} AND ${Mes}+98
		  AND dea.no_empresa_area LIKE '%IMPECABLE%' ) ftu -- '%' || ${Empresa} || '%' ) ftu
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
			INNER JOIN dim_fecha ON dim_fecha.id_Fecha = id_fecha_inicio
		WHERE no_empresa_area LIKE '%IMPECABLE%' -- '%' || ${Empresa} || '%'
		  AND id_tipo_hora = 0
		  AND fl_fin_semana = 'No'
		  AND id_fecha_inicio BETWEEN 20160101 AND 20160199 --${Mes} AND ${Mes}+98
		GROUP BY
			id_fecha_inicio,
			CASE
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '0600' AND '1359' THEN 2
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '1400' AND '2159' THEN 3
				ELSE 4 END
		UNION ALL
		SELECT
			id_fecha_inicio,
			CASE
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '0600' AND '1759' THEN 2
				ELSE 5 END id_tipo_hora,
			COUNT(0) nu_lecturas
		FROM
			fac_turnos INNER JOIN dim_empresa_area
			 ON dim_empresa_area.id_empresa_area = fac_turnos.id_empresa_area
			INNER JOIN dim_fecha ON dim_fecha.id_Fecha = id_fecha_inicio
		WHERE no_empresa_area LIKE '%IMPECABLE%' -- '%' || ${Empresa} || '%'
		  AND id_tipo_hora = 0
		  AND fl_fin_semana = 'Si'
		  AND id_fecha_inicio BETWEEN 20160101 AND 20160199 --${Mes} AND ${Mes}+98
		GROUP BY
			id_fecha_inicio,
			CASE
				WHEN TO_CHAR(fe_hora_inicio, 'HH24MI') BETWEEN '0600' AND '1759' THEN 2
				ELSE 5 END ) inc
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
	CASE dth.id_tipo_hora WHEN 0 THEN 99 ELSE dth.id_tipo_hora END