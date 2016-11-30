SELECT 
	ag.no_ministerio       AS "Ministerio",
	ag.no_secretaria       AS "Secretaría",
	ag.no_subsecretaria    AS "SubSecretaría",
	ag.no_direccion_area   AS "Dirección / Área",
	ag.no_area_dependencia AS "Área / Dependencia",
	ag.no_sector           AS "Sector",
	ag.no_subsector        AS "SubSector",
	ag.ds_funcion          AS "Función",
	ag.no_ubicacion_fisica AS "Ubicacion Física",
	ag.no_agente           AS "Nombre Agente",
	ag.co_tipo_documento   AS "Tipo Documento",
	ag.nu_documento        AS "Número Documento",
	ag.co_cuit             AS "CUIT",
	ag.fe_ingreso          AS "Fecha Ingreso",
	ag.no_tipo_contrato    AS "Contrato Vigente",
	ag.fe_inicio           AS "Fecha Início",
	ag.fe_fin              AS "Fecha Fin",
	(SELECT MAX(fe_hora)
	 FROM fac_lectura
	 WHERE id_persona = pe.id_persona) AS "Última Lectura",
	(SELECT COUNT(DISTINCT id_lectura)
	 FROM fac_totales
	 WHERE id_persona = pe.id_persona
	    AND id_fecha > 20161100 )      AS "Días Noviembre"
FROM aux_agente ag
LEFT JOIN dim_persona pe ON pe.co_dni_cuit = ag.nu_documento
ORDER BY ag.no_agente
--LEFT JOIN fac_lectura le ON pe.id_persona = le.id_persona
--LEFT JOIN fac_totales tt ON pe.id_persona = tt.id_persona
