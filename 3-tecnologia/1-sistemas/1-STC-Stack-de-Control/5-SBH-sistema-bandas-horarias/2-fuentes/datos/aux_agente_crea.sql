DROP TABLE aux_agente CASCADE;
CREATE TABLE aux_agente AS
SELECT
	no_ministerio, 
	no_secretaria, 
	no_subsecretaria, 
	no_direccion_area, 
	no_area_dependencia, 
	no_sector, 
	no_subsector, 
	ds_funcion, 
	no_ubicacion_fisica,
	no_agente, 
	co_tipo_documento, 
	nu_documento, 
	co_cuit, 
	fe_ingreso,
	no_tipo_contrato, 
	fe_inicio, 
	fe_fin
FROM dblink ('dbname=sfmycp port=5432 host=127.0.0.1 user=facturas password=F4ct#r4s@2016',
	'SELECT 
	  de.no_ministerio, 
	  de.no_secretaria, 
	  de.no_subsecretaria, 
	  de.no_direccion_area, 
	  de.no_area_dependencia, 
	  de.no_sector, 
	  de.no_subsector, 
	  ag.ds_funcion, 
	  uf.no_ubicacion_fisica,
	  ag.no_agente, 
	  ag.co_tipo_documento, 
	  ag.nu_documento::TEXT AS nu_documento, 
	  ag.co_cuit, 
	  ag.fe_ingreso,
	  tc.no_tipo_contrato, 
	  co.fe_inicio, 
	  co.fe_fin
	FROM facturas.agente ag
	LEFT JOIN facturas.ubicacion_fisica uf ON ag.id_ubicacion_fisica = uf.id_ubicacion_fisica
	LEFT JOIN facturas.dependencia      de ON ag.id_dependencia = de.id_dependencia
	LEFT JOIN facturas.contrato         co ON ag.id_agente = co.id_agente
	LEFT JOIN facturas.tipo_contrato    tc ON tc.id_tipo_contrato = co.id_tipo_contrato') AS ag (
		no_ministerio       TEXT, 
		no_secretaria       TEXT, 
		no_subsecretaria    TEXT,
		no_direccion_area   TEXT,
		no_area_dependencia TEXT,
		no_sector           TEXT,
		no_subsector        TEXT,
		ds_funcion          TEXT,
		no_ubicacion_fisica TEXT,
		no_agente           TEXT,
		co_tipo_documento   TEXT,
		nu_documento        TEXT,
		co_cuit             TEXT,
		fe_ingreso          DATE,
		no_tipo_contrato    TEXT,
		fe_inicio           DATE,
		fe_fin              DATE );
