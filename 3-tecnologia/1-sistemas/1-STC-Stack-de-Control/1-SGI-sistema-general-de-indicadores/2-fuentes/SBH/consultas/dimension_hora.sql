SELECT
	TO_CHAR(MINUTE, 'HH24MI')::BIGINT AS id_hora,	
	-- Hora (12:00 AM a 11:59 PM)
	TO_CHAR(MINUTE, 'HH12:MI AM') AS no_hora_12,
	-- Hora (00:00 a 23:59)
	TO_CHAR(MINUTE, 'HH24:MI') AS no_hora_24,
	-- Hora del día (0 - 23)
	TO_CHAR(MINUTE, 'HH12') AS nu_hora_12,
	-- Hora del día (0 - 23)
	EXTRACT(HOUR FROM MINUTE) AS nu_hora_24, 
	-- AM / PM
	TO_CHAR(MINUTE, 'AM') AS tx_am_pm,
	-- Minuto del día (0 - 1439)
	EXTRACT(MINUTE FROM MINUTE) AS nu_minuto,
	-- Minuto del día (0 - 1439)
	EXTRACT(HOUR FROM MINUTE)*60 + EXTRACT(MINUTE FROM MINUTE) AS nu_minuto_dia,
	-- Formatea cuartos de hora
	TO_CHAR(MINUTE - (EXTRACT(MINUTE FROM MINUTE)::INTEGER % 15 || 'minutes')::INTERVAL, 'hh24:mi') ||
	' – ' ||
	TO_CHAR(MINUTE - (EXTRACT(MINUTE FROM MINUTE)::INTEGER % 15 || 'minutes')::INTERVAL + '14 minutes'::INTERVAL, 'hh24:mi')
		AS tx_cuartos_hora,
	CASE
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '0500' AND '0700' THEN 'Recambio Mañana'
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '1300' AND '1500' THEN 'Recambio Tarde'
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '2100' AND '2300' THEN 'Recambio Noche'
		ELSE 'Horario Normal' END tx_impecable_tipo_hora,
	CASE
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '0600' AND '1359' THEN 'Turno Mañana'
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '1400' AND '2159' THEN 'Turno Tarde'
		ELSE 'Turno Noche' END tx_impecable_turno,
	CASE
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '0600' AND '1359' THEN '06:00 a 14:00'
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '1400' AND '2159' THEN '14:00 a 22:00'
		ELSE '22:00 a 06:00' END tx_impecable_banda
FROM (SELECT '0:00'::TIME + (SEQUENCE.MINUTE || ' minutes')::INTERVAL AS MINUTE
	FROM generate_series(0,1439) AS SEQUENCE(MINUTE)
	GROUP BY SEQUENCE.MINUTE
     ) DQ
ORDER BY 1