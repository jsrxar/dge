SELECT
	to_char(datum, 'IYYY-IW') aaa,
	MIN(datum) AS fe_fecha_ini,
	MAX(datum) AS fe_fecha_fin,
	to_char(datum, '"Semana" IW "del" IYYY') no_semana,
	to_char(MIN(datum), '"("DD/MM/YY "a "') || to_char(MAX(datum), 'DD/MM/YY")"') nu_semana_2
FROM (
	SELECT (2011 || '-01-01')::DATE -7 +SEQUENCE.DAY AS datum
	FROM generate_series(0,380) AS SEQUENCE(DAY)
	GROUP BY SEQUENCE.DAY
     ) DQ
WHERE
  EXTRACT(year FROM datum) = 2011
  OR ( EXTRACT(year FROM datum) = 2011-1 AND EXTRACT(week FROM datum) = EXTRACT(week FROM (2011 || '-01-01')::DATE))
  OR ( EXTRACT(year FROM datum) = 2011+1 AND EXTRACT(week FROM datum) = EXTRACT(week FROM (2011 || '-12-31')::DATE))
GROUP BY to_char(datum, 'IYYY-IW'), to_char(datum, '"Semana" IW "del" IYYY')
ORDER BY 1
