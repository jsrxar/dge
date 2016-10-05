SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE AGENTES   ----------------------------------------
UPDATE stg_personal
SET
	no_archivo = '...',
	co_lugar = 'C',
	fe_carga = now(),
	co_estado_proceso = 'C',
	tx_dat_lab_dependencia    = TRIM(tx_dat_lab_dependencia),
	tx_dat_lab_secretaria     = TRIM(tx_dat_lab_secretaria),
	tx_dat_lab_subsecretaria  = TRIM(tx_dat_lab_subsecretaria),
	tx_dat_lab_direccion_area = TRIM(tx_dat_lab_direccion_area),
	tx_dat_lab_area_dependenc = TRIM(tx_dat_lab_area_dependenc),
	tx_dat_lab_sector         = TRIM(tx_dat_lab_sector),
	tx_dat_lab_sub_sector     = TRIM(tx_dat_lab_sub_sector),
	tx_ubi_fis_ubic_fisica_1  = TRIM(tx_ubi_fis_ubic_fisica_1),
	tx_dat_per_apell_nombre   = TRIM(tx_dat_per_apell_nombre),
	tx_dat_per_tipo_doc       = TRIM(tx_dat_per_tipo_doc),
	tx_dat_per_nro_doc        = TRIM(tx_dat_per_nro_doc)
WHERE fe_carga IS NULL;

UPDATE stg_personal
SET co_estado_proceso = 'E' -- ERROR
WHERE co_estado_proceso = 'C'
  AND tx_dat_per_nro_doc IS NULL;

UPDATE stg_personal pe
SET co_estado_proceso = 'I' -- Ignorado
WHERE co_estado_proceso = 'C'
  AND EXISTS ( SELECT 1 FROM stg_personal
               WHERE co_estado_proceso = 'C'
                 AND REPLACE(tx_dat_per_nro_doc, '.', '')::BIGINT = REPLACE(pe.tx_dat_per_nro_doc, '.', '')::BIGINT
                 AND id_carga > pe.id_carga );

UPDATE ods_persona pe
SET
	no_persona     = INITCAP(tx_dat_per_apell_nombre),
	no_direccion   = COALESCE(tx_dat_lab_direccion_area,
	                 COALESCE(tx_dat_lab_subsecretaria,
	                 COALESCE(tx_dat_lab_secretaria, tx_dat_lab_dependencia))),
	no_dependencia = COALESCE(tx_dat_lab_area_dependenc,
	                 COALESCE(tx_dat_lab_direccion_area,
	                 COALESCE(tx_dat_lab_subsecretaria,
	                 COALESCE(tx_dat_lab_secretaria, tx_dat_lab_dependencia)))),
	no_puesto      = tx_dat_lab_puesto
FROM stg_personal st
WHERE pe.co_dni_cuit = (REPLACE(st.tx_dat_per_nro_doc, '.', '')::BIGINT)::TEXT
  AND st.co_estado_proceso = 'C';

INSERT INTO ods_persona(
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	no_puesto
)
SELECT
	(REPLACE(tx_dat_per_nro_doc, '.', '')::BIGINT)::TEXT co_dni_cuit,
	INITCAP(tx_dat_per_apell_nombre) no_persona,
	COALESCE(tx_dat_lab_direccion_area,
	COALESCE(tx_dat_lab_subsecretaria,
	COALESCE(tx_dat_lab_secretaria, tx_dat_lab_dependencia))) no_direccion,
	COALESCE(tx_dat_lab_area_dependenc,
	COALESCE(tx_dat_lab_direccion_area,
	COALESCE(tx_dat_lab_subsecretaria,
	COALESCE(tx_dat_lab_secretaria, tx_dat_lab_dependencia)))) no_dependencia,
	tx_dat_lab_puesto                no_puesto
FROM stg_personal pe
WHERE co_estado_proceso = 'C'
  AND NOT EXISTS ( SELECT 1 FROM ods_persona
                   WHERE co_dni_cuit = (REPLACE(pe.tx_dat_per_nro_doc, '.', '')::BIGINT)::TEXT );

UPDATE stg_personal
SET co_estado_proceso = 'P' -- Procesado
WHERE co_estado_proceso = 'C';
