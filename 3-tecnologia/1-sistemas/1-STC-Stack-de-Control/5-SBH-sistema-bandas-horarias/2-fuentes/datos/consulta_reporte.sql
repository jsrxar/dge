SELECT
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
WHERE ft.id_fecha = TO_CHAR(CURRENT_DATE - 1, 'YYYYMMDD')::BIGINT
  AND pe.no_dependencia IS NOT NULL
ORDER BY pe.no_persona