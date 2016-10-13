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
	TRIM(INITCAP(ds_apellido_nombres))            AS no_agente,
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
WHERE LENGTH(ds_apellido_nombres) > 0;

INSERT INTO contrato (
	id_agente,
	fe_inicio,
	fe_fin,
	id_tipo_contrato,
	id_categoria_lm,
	id_convenio_at )
SELECT
	(SELECT id_agente FROM agente
	 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(cn.ds_nro, '.', ''))
	   AND COALESCE(no_agente, '') = TRIM(INITCAP(cn.ds_apellido_nombres))) AS id_agente,
	NULL                                                  AS fe_inicio,
	NULLIF(cn.ds_fin_contrato, '')::DATE                  AS fe_fin,
	cn.id_tipo_contrato                                   AS id_tipo_contrato,
	(SELECT id_categoria_lm FROM categoria_lm
	 WHERE co_categoria_lm = TRIM(UPPER(cn.ds_categ_lm))) AS id_categoria_lm,
	(SELECT id_convenio_at FROM convenio_at
	 WHERE COALESCE(no_convenio_at, '') = TRIM(UPPER(cn.ds_convenio_at))
	   AND COALESCE(ds_universidad, '') = TRIM(UPPER(cn.ds_universidad))) AS id_convenio_at
FROM (
	SELECT
		(SELECT id_tipo_contrato FROM tipo_contrato
		 WHERE co_tipo_contrato = TRIM(UPPER(rh.ds_tipo))) AS id_tipo_contrato,
		ds_apellido_nombres,
		ds_nro,
		ds_fin_contrato,
		ds_categ_lm,
		ds_convenio_at,
		ds_universidad
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0 ) AS cn
WHERE id_tipo_contrato IS NOT NULL;

INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201605       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_mayo_2016::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_mayo_2016
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_mayo_2016) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_mayo_2016::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);
 
 INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201606       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_junio_7p::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_junio_7p
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_junio_7p) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_junio_7p::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);
 
 INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201607       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_julio_10p::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_julio_10p
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_julio_10p) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_julio_10p::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);
 
 INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201608       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_agosto_14p::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_agosto_14p
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_agosto_14p) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_agosto_14p::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);
 
 INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201609       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_sept::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_sept
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_sept) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_sept::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);
 
 INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201610       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_oct::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_oct
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_oct) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_oct::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);
 
 INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201611       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_nov::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_nov
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_nov) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_nov::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);
 
 INSERT INTO salario (
	id_mes,
	id_contrato,
	va_salario )
SELECT
	201612       AS id_mes,
	(SELECT id_contrato FROM contrato WHERE id_agente = cn.id_agente) AS id_contrato,
	ds_dic::MONEY::NUMERIC::FLOAT AS va_salario
FROM (
	SELECT
		(SELECT id_agente FROM agente
		 WHERE COALESCE(nu_documento::TEXT, '') = TRIM(REPLACE(rh.ds_nro, '.', ''))
		   AND COALESCE(no_agente, '') = TRIM(INITCAP(rh.ds_apellido_nombres))) AS id_agente,
		ds_dic
	FROM stg_base_rrhh AS rh
	WHERE LENGTH(ds_apellido_nombres) > 0
	  AND TRIM(ds_dic) NOT IN ('', '--', '---', '#¡REF!', '.')
 ) cn
WHERE ds_dic::MONEY::NUMERIC > 0
  AND EXISTS (SELECT 1 FROM contrato WHERE id_agente = cn.id_agente);

 
