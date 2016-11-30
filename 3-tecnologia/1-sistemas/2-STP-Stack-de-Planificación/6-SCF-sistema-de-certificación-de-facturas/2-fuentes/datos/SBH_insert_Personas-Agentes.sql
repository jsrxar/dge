INSERT INTO ods_persona (
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	no_area,
	no_puesto
)
SELECT
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,SELECT
  pe.co_dni_cuit,
  pe.no_persona,
  pe.no_dependencia,
  TO_CHAR(ft.fe_hora_min, 'HH24:MI:SS') tx_hora_min,
  CASE WHEN ft.fe_hora_max != ft.fe_hora_min THEN
  	TO_CHAR(ft.fe_hora_max, 'HH24:MI:SS') END tx_hora_max,
  ft.va_hora_min,
  ft.va_hora_max,
  ft.nu_lecturas,
  1-ft.nu_persona_dias nu_personas_no,
  ft.nu_persona_dias,
  ft.va_horas_total
FROM
  fac_totales ft INNER JOIN dim_persona pe ON ft.id_persona = pe.id_persona
WHERE ft.id_fecha = TO_CHAR(CURRENT_DATE - ${Dia}, 'YYYYMMDD')::BIGINT
  AND pe.no_dependencia IS NOT NULL
ORDER BY pe.no_persona
	'NO IDENTIFICADO' no_area,
	no_puesto
FROM dblink ('dbname=sfmycp port=5432 host=127.0.0.1 user=facturas password=F4ct#r4s@2016',
	'SELECT
		TRIM(SPLIT_PART(ag.co_cuit, ''-'', 2))::BIGINT::TEXT AS co_dni_cuit,
		ag.no_agente AS no_persona,
		COALESCE(de.no_direccion_area,
		 COALESCE(de.no_subsecretaria,
		 COALESCE(de.no_secretaria, de.no_ministerio))) AS no_direccion,
		COALESCE(de.no_area_dependencia,
		 COALESCE(de.no_direccion_area,
		 COALESCE(de.no_subsecretaria,
		 COALESCE(de.no_secretaria, de.no_ministerio)))) AS no_dependencia,
		pu.no_puesto AS no_puesto
	FROM facturas.agente ag
	LEFT JOIN facturas.dependencia de ON de.id_dependencia = ag.id_dependencia
	LEFT JOIN facturas.puesto pu ON pu.id_puesto = ag.id_puesto
	WHERE LENGTH(ag.co_cuit) = 13') AS ag (
		co_dni_cuit    TEXT,
		no_persona     TEXT,
		no_direccion   TEXT,
		no_dependencia TEXT,
		no_puesto      TEXT)
WHERE NOT EXISTS (SELECT 1 FROM ods_persona WHERE co_dni_cuit = ag.co_dni_cuit);