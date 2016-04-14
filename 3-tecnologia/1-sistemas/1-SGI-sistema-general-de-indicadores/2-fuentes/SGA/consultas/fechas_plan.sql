SELECT 2015+SEQUENCE.ANO AS nu_ano
FROM generate_series(0,5) AS SEQUENCE(ANO)
GROUP BY SEQUENCE.ANO
ORDER BY 1

SELECT
	TO_CHAR(datum, 'IYYY-IW') aaa,
	TO_CHAR(datum, 'YYYYMMDD')::BIGINT as id_fecha,
	datum AS fe_fecha,
	TO_CHAR(datum, 'TMDay ') || EXTRACT(DAY FROM datum) || TO_CHAR(datum, ' "de" TMMonth') AS no_dia,
	EXTRACT(DAY FROM datum) || TO_CHAR(datum, ' TMDy') AS no_dia,
	EXTRACT(isodow FROM datum) AS nu_dia_semana,
	TO_CHAR(datum, '"Semana" IW "del" IYYY') nu_semana_anio
FROM (
	SELECT (2011 || '-01-01')::DATE -7 +SEQUENCE.DAY AS datum
	FROM generate_series(0,375) AS SEQUENCE(DAY)
	GROUP BY SEQUENCE.DAY
     ) DQ
WHERE
  EXTRACT(year FROM datum) = 2011
  OR ( EXTRACT(year FROM datum) = 2011-1 AND EXTRACT(week FROM datum) = EXTRACT(week FROM (2011 || '-01-01')::DATE))
  OR ( EXTRACT(year FROM datum) = 2011+1 AND EXTRACT(week FROM datum) = EXTRACT(week FROM (2011 || '-12-31')::DATE))
ORDER BY 2

SELECT
	TO_CHAR(datum, 'IYYY-IW') id_semana,
	MIN(datum) AS fe_fecha_ini,
	MAX(datum) AS fe_fecha_fin,
	TO_CHAR(datum, '"Semana" IW "del" IYYY') ||
	TO_CHAR(MIN(datum), ' "("DD/MM/YY "a "') || TO_CHAR(MAX(datum), 'DD/MM/YY")"') no_semana
FROM (
	SELECT (2011 || '-01-01')::DATE -7 +SEQUENCE.DAY AS datum
	FROM generate_series(0,380) AS SEQUENCE(DAY)
	GROUP BY SEQUENCE.DAY
     ) DQ
WHERE
  EXTRACT(year FROM datum) = 2011
  OR ( EXTRACT(year FROM datum) = 2011-1 AND EXTRACT(week FROM datum) = EXTRACT(week FROM (2011 || '-01-01')::DATE))
  OR ( EXTRACT(year FROM datum) = 2011+1 AND EXTRACT(week FROM datum) = EXTRACT(week FROM (2011 || '-12-31')::DATE))
GROUP BY TO_CHAR(datum, 'IYYY-IW'), TO_CHAR(datum, '"Semana" IW "del" IYYY')
ORDER BY 1

SELECT
TO_CHAR(TO_DATE('2011-01', 'IYYY-IW'), '"Semana" IW "del" IYYY - TMDay DD "de" TMMonth "de" YYYY "a "') || 
TO_CHAR(TO_DATE('2011-01', 'IYYY-IW')+6, 'TMDay DD "de" TMMonth "de" YYYY') no_semana

WHERE TO_CHAR(fe_fecha, 'IYYY-IW') = '2016-20' ) ta