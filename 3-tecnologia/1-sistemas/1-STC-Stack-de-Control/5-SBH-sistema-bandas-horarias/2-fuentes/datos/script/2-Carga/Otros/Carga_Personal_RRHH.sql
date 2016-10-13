SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE PERSONAL   ----------------------------------------
TRUNCATE stg_personal CASCADE;

COPY stg_personal (
	tx_dat_lab_dependencia,
	tx_dat_lab_secretaria,
	tx_dat_lab_subsecretaria,
	tx_dat_lab_direccion_area,
	tx_dat_lab_area_dependenc,
	tx_dat_lab_sector,
	tx_dat_lab_sub_sector,
	tx_dat_lab_puesto,
	tx_destino_direccion_gral,
	tx_destino_direccion,
	tx_destino_departamento,
	tx_destino_coord_unidad,
	tx_ubi_fis_ubic_fisica_1,
	tx_ubi_fis_puesto,
	tx_ubi_fis_ubic_fisica_2,
	tx_dat_per_apell_nombre,
	tx_dat_per_tipo_doc,
	tx_dat_per_nro_doc,
	tx_mod_con_tipo ,
	tx_mod_con_tipo_2,
	tx_mod_con_lm_at,
	tx_mod_con_ingreso,
	tx_mod_con_convenio_at )
FROM 'C:/archivos/personas/Base Banda Horaria 2016.csv' USING DELIMITERS ';' WITH NULL AS '' CSV HEADER;

UPDATE stg_personal
SET
	no_archivo = 'Base Banda Horaria 2016.xlsx',
	co_lugar = 'C',
	fe_carga = now(),
	co_estado_proceso = 'C' /*,
	tx_dat_lab_dependencia    = TRIM(tx_dat_lab_dependencia),
	tx_dat_lab_secretaria     = TRIM(tx_dat_lab_secretaria),
	tx_dat_lab_subsecretaria  = TRIM(tx_dat_lab_subsecretaria),
	tx_dat_lab_direccion_area = TRIM(tx_dat_lab_direccion_area),
	tx_dat_lab_area_dependenc = TRIM(tx_dat_lab_area_dependenc),
	tx_dat_lab_sector         = TRIM(tx_dat_lab_sector),
	tx_dat_lab_sub_sector     = TRIM(tx_dat_lab_sub_sector),
	tx_dat_lab_puesto         = TRIM(tx_dat_lab_puesto),
	tx_destino_direccion_gral = TRIM(tx_destino_direccion_gral),
	tx_destino_direccion      = TRIM(tx_destino_direccion),
	tx_destino_departamento   = TRIM(tx_destino_departamento),
	tx_destino_coord_unidad   = TRIM(tx_destino_coord_unidad),
	tx_ubi_fis_ubic_fisica_1  = TRIM(tx_ubi_fis_ubic_fisica_1),
	tx_ubi_fis_puesto         = TRIM(tx_ubi_fis_puesto),
	tx_ubi_fis_ubic_fisica_2  = TRIM(tx_ubi_fis_ubic_fisica_2),
	tx_dat_per_apell_nombre   = TRIM(tx_dat_per_apell_nombre),
	tx_dat_per_tipo_doc       = TRIM(tx_dat_per_tipo_doc),
	tx_dat_per_nro_doc        = TRIM(tx_dat_per_nro_doc),
	tx_mod_con_tipo           = TRIM(tx_mod_con_tipo ),
	tx_mod_con_tipo_2         = TRIM(tx_mod_con_tipo_2),
	tx_mod_con_lm_at          = TRIM(tx_mod_con_lm_at),
	tx_mod_con_ingreso        = TRIM(tx_mod_con_ingreso),
	tx_mod_con_convenio_at    = TRIM(tx_mod_con_convenio_at) */
WHERE fe_carga IS NULL;

UPDATE ods_persona pe
SET
	no_persona     = TRIM(tx_dat_per_apell_nombre),
	no_direccion   = TRIM(tx_dat_lab_direccion_area),
	no_dependencia = TRIM(tx_dat_lab_area_dependenc),
	no_puesto      = TRIM(tx_dat_lab_puesto)
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
	MAX(TRIM(tx_dat_per_apell_nombre))   no_persona,
	MAX(TRIM(tx_dat_lab_direccion_area)) no_sector,
	MAX(TRIM(tx_dat_lab_area_dependenc)) no_area,
	MAX(TRIM(tx_dat_lab_puesto))         no_puesto
FROM stg_personal
WHERE co_estado_proceso = 'C'
  AND tx_dat_per_nro_doc IS NOT NULL
  AND (REPLACE(tx_dat_per_nro_doc, '.', '')::BIGINT)::TEXT NOT IN (
	SELECT co_dni_cuit FROM ods_persona )
GROUP BY (REPLACE(tx_dat_per_nro_doc, '.', '')::BIGINT)::TEXT;

UPDATE stg_personal
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C';

UPDATE dim_persona pe
SET
	no_persona     = od.no_persona,
	no_direccion   = od.no_direccion,
	no_dependencia = od.no_dependencia,
	no_sector      = od.no_sector,
	no_area        = od.no_area,
	no_tarea       = od.no_tarea,
	no_puesto      = od.no_puesto
FROM ods_persona od
WHERE pe.id_persona = od.id_persona;

INSERT INTO dim_persona(
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	no_sector,
	no_area,
	no_tarea,
	no_puesto
)
SELECT
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	no_sector,
	no_area,
	no_tarea,
	no_puesto
FROM ods_persona
WHERE co_dni_cuit NOT IN ( SELECT co_dni_cuit FROM dim_persona );
