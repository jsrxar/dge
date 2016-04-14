DELETE FROM dim_tipo_hora CASCADE;
DELETE FROM dim_turno CASCADE;
DELETE FROM dim_fecha CASCADE;
DELETE FROM dim_hora CASCADE;

--#####################
--####  Tipo Hora  ####
--#####################
INSERT INTO dim_tipo_hora (id_tipo_hora, no_tipo_hora, no_turno_hora) VALUES
(0, 'Horario Normal',   'Normal'),
(1, 'Horario Recambio', 'Mañana'),
(2, 'Horario Recambio', 'Tarde'),
(3, 'Horario Recambio', 'Noche'),
(4, 'Horario Recambio', 'Tarde/Noche');

--#################
--####  Turno  ####
--#################
INSERT INTO dim_turno (id_turno, no_turno, tx_banda_horaria) VALUES
(0, 'No Identificado', 'N.I.'),
(1, 'Mañana', '06:00 a 14:00'),
(2, 'Tarde',  '14:00 a 22:00'),
(3, 'Noche',  '22:00 a 06:00'),
(4, 'Mañana (FS)', '06:00 a 18:00'),
(5, 'Noche (FS)',  '18:00 a 06:00');

--#################
--####  Fecha  ####
--#################
INSERT INTO dim_fecha(
	id_fecha,
	fe_fecha,
	tx_fecha,
	nu_anio,
	nu_mes,
	no_mes,
	nu_dia,
	no_fecha,
	nu_dia_semana,
	no_dia_semana,
	nu_semana_anio,
	nu_dia_ano,
	nu_cuatrimestre,
	fl_fin_semana,
	fl_feriado,
	no_estacion )
SELECT
	to_char(datum, 'YYYYMMDD')::BIGINT as id_fecha,
	datum AS fe_fecha,
	to_char(datum, 'YYYY-MM-DD') AS tx_fecha,
	EXTRACT(YEAR FROM datum) AS nu_anio,
	EXTRACT(MONTH FROM datum) AS nu_mes,
	-- Localized month name
	to_char(datum, 'TMMonth') AS no_mes,
	EXTRACT(DAY FROM datum) AS nu_dia,
	EXTRACT(DAY FROM datum) || to_char(datum, ' "de" TMMonth "de" yyyy "("TMDay")"') AS no_dia,
	-- Localized weekday
	EXTRACT(isodow FROM datum) AS nu_dia_semana,
	to_char(datum, 'TMDay') AS no_dia_semana,
	-- ISO calendar week
	EXTRACT(week FROM datum) AS nu_semana_anio,
	EXTRACT(doy FROM datum) AS nu_dia_ano,
	to_char(datum, 'Q')::INTEGER AS nu_cuatrimestre,
	-- Weekend
	CASE WHEN EXTRACT(isodow FROM datum) IN (6, 7) THEN 'Si' ELSE 'No' END AS fl_fin_semana,
	-- Fixed holidays 
        CASE WHEN to_char(datum, 'DDMM') IN ('0101', '2403', '0204', '0105', '2505', '2006', '0907', '0812', '2512')
		THEN 'Si' ELSE 'No' END AS fl_feriado,
	-- Some periods of the year, adjust for your organisation and country
	CASE WHEN to_char(datum, 'MMDD') BETWEEN '0321' AND '0620' THEN 'Otoño'
	     WHEN to_char(datum, 'MMDD') BETWEEN '0621' AND '0920' THEN 'Invierno'
	     WHEN to_char(datum, 'MMDD') BETWEEN '0921' AND '1220' THEN 'Primavera'
		ELSE 'Verano' END AS no_estacion /*,
	-- ISO start and end of the week of this date
	datum + (1 - EXTRACT(isodow FROM datum))::INTEGER AS ds_inicio_semana,
	datum + (7 - EXTRACT(isodow FROM datum))::INTEGER AS ds_final_semana,
	-- Start and end of the month of this date
	datum + (1 - EXTRACT(DAY FROM datum))::INTEGER AS ds_inicio_mes,
	(datum + (1 - EXTRACT(DAY FROM datum))::INTEGER + '1 month'::INTERVAL)::DATE - '1 day'::INTERVAL AS ds_final_mes */
FROM (
	-- There are 3 leap years in this range, so calculate 365 * 20 + 5 records
	SELECT '2000-01-01'::DATE + SEQUENCE.DAY AS datum
	FROM generate_series(0,7305) AS SEQUENCE(DAY)
	GROUP BY SEQUENCE.DAY
     ) DQ
ORDER BY 1;

--################
--####  Hora  ####
--################
INSERT INTO dim_hora(
	id_hora,
	fe_hora,
	no_hora_12,
	no_hora_24,
	nu_hora_12,
	nu_hora_24,
	tx_am_pm,
	nu_minuto,
	nu_minuto_dia,
	tx_cuartos_hora,
	id_turno8, 
	id_turno8_tipo_hora )
SELECT
	TO_CHAR(MINUTE, 'HH24MI')::BIGINT AS id_hora,	
	MINUTE,
	-- Hora (12:00 AM a 11:59 PM)
	TO_CHAR(MINUTE, 'HH12:MI AM') AS no_hora_12,
	-- Hora (00:00 a 23:59)
	TO_CHAR(MINUTE, 'HH24:MI') AS no_hora_24,
	-- Hora del día
	TO_CHAR(MINUTE, 'HH12')::SMALLINT AS nu_hora_12,
	-- Hora del día (0 - 23)
	EXTRACT(HOUR FROM MINUTE)::SMALLINT AS nu_hora_24, 
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
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '0600' AND '1359' THEN 1
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '1400' AND '2159' THEN 2
		ELSE 3 END id_turno8,
	CASE
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '0430' AND '0730' THEN 1
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '1230' AND '1530' THEN 2
		WHEN TO_CHAR(MINUTE, 'HH24MI') BETWEEN '2030' AND '2330' THEN 3
		ELSE 0 END id_turno8_tipo_hora
FROM (SELECT '0:00'::TIME + (SEQUENCE.MINUTE || ' minutes')::INTERVAL AS MINUTE
	FROM generate_series(0,1439) AS SEQUENCE(MINUTE)
	GROUP BY SEQUENCE.MINUTE
     ) DQ
ORDER BY 1;
