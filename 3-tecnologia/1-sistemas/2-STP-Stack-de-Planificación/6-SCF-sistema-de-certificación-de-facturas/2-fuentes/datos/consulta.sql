INSERT INTO agente (
	no_agente,
	id_puesto,
	id_dependencia,
	id_ubicacion_fisica,
	ds_funcion,
	co_tipo_documento,
	nu_documento,
	co_cuit,
	fe_nacimiento,
	ds_estudios,
	ds_direccion,
	ds_telefono,
	ds_celular,
	fe_ingreso )
SELECT
	TRIM(UPPER(ds_apellido_nombres))              AS no_agente,
	(SELECT id_puesto FROM puesto
	 WHERE no_puesto = TRIM(UPPER(rh.ds_puesto))) AS id_puesto,
	(SELECT id_dependencia FROM dependencia
	 WHERE COALESCE(UPPER(no_ministerio), '') = TRIM(UPPER(rh.ds_ministerio))
	   AND COALESCE(UPPER(no_secretaria), '') = TRIM(UPPER(rh.ds_secretaria))
	   AND COALESCE(UPPER(no_subsecretaria), '') = TRIM(UPPER(rh.ds_subsecretaria))
	   AND COALESCE(UPPER(no_direccion_area), '') = TRIM(UPPER(rh.ds_direccion_area))
	   AND COALESCE(UPPER(no_area_dependencia), '') = TRIM(UPPER(rh.ds_area_dependencia))
	   AND COALESCE(UPPER(no_sector), '') = TRIM(UPPER(rh.ds_sector))
	   AND COALESCE(UPPER(no_subsector), '') = TRIM(UPPER(rh.ds_sub_sector)) ) AS id_dependencia,
	(SELECT id_ubicacion_fisica FROM ubicacion_fisica
	 WHERE no_ubicacion_fisica = TRIM(UPPER(ds_ubicacion_fisica))) AS id_ubicacion_fisica,
	TRIM(UPPER(NULLIF(ds_funcion, '')))           AS ds_funcion,
	TRIM(UPPER(NULLIF(ds_dni, '')))               AS co_tipo_documento,
	REPLACE(NULLIF(ds_nro, ''), '.', '')::BIGINT  AS nu_documento,
	TRIM(REPLACE(NULLIF(ds_cuit, ''), '.', ''))   AS co_cuit,
	NULLIF(ds_f_nacimiento, '')::DATE             AS fe_nacimiento,
	TRIM(UPPER(NULLIF(ds_estudios, '')))          AS ds_estudios,
	TRIM(UPPER(NULLIF(ds_direccion, '')))         AS ds_direccion,
	TRIM(UPPER(NULLIF(ds_telefono, '')))          AS ds_telefono,
	TRIM(UPPER(NULLIF(ds_celular, '')))           AS ds_celular,
	NULLIF(ds_ingreso, '')::DATE                  AS fe_ingreso
FROM stg_base_rrhh rh
WHERE LENGTH(ds_apellido_nombres) > 0
ORDER BY 1

/*
SELECT
COALESCE(TRIM(UPPER(ds_ministerio)), '.') AS ds_ministerio,
TRIM(UPPER(ds_secretaria))='' AS ds_secretaria,
ds_subsecretaria,
ds_direccion_area,
ds_area_dependencia,
ds_sector,
ds_sub_sector,
ds_puesto,
ds_funcion,
ds_ubicacion_fisica,
ds_entrega_banelcos,
ds_apellido_nombres,
ds_dni,
ds_nro,
ds_cuit,
ds_f_nacimiento,
ds_estudios,
ds_direccion,
ds_telefono,
ds_celular,
ds_lm_at,
ds_tipo,
ds_ingreso,
ds_vto_contrato,
ds_fin_contrato,
ds_categ_lm,
ds_universidad,
ds_convenio_at,
ds_mayo_2016,
ds_junio_7p,
ds_julio_10p,
ds_agosto_14p,
ds_sept,
ds_oct,
ds_nov,
ds_dic,
ds_posible_letra,
ds_presup_2017
FROM stg_base_rrhh
*/
