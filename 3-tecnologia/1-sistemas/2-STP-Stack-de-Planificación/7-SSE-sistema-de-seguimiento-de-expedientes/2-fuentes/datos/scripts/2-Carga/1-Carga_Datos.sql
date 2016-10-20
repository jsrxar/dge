UPDATE stg_expedientes
SET ds_expediente = REPLACE(NULLIF(TRIM(REPLACE(ds_expediente, '#¡REF!', '')), ''), '  ', ' ');

INSERT INTO expediente (
	co_expediente,
	nu_expediente,
	nu_anio_expediente,
	no_caratula,
	fe_origen,
	id_proveedor,
	ds_emp_sugeridas,
	va_monto,
	va_monto_pagado,
	id_tipo_bien_servicio,
	id_tipo_contratacion,
	id_reparticion_solicitante,
	id_reparticion_destino,
	fe_responsable,
	fe_compras_ingreso,
	fe_compras_salida,
	id_sector_destino,
	id_estado,
	ds_estado,
	id_ubicacion_interna,
	co_cuit,
	ds_beneficiario,
	ds_facturas,
	ds_orden_pago,
	ds_observaciones,
	id_finalizado,
	id_cont_oc )
SELECT
	ds_expediente                                                               AS co_expediente,
	CASE WHEN strpos(ds_expediente, '/') > 0 THEN split_part(ds_expediente, '/', 1)::NUMERIC END AS nu_expediente,
	NULLIF(split_part(split_part(ds_expediente, '/', 2), ' ', 1), '')::NUMERIC  AS nu_anio_expediente,
	COALESCE(TRIM(ds_caratula), '-')                                            AS no_caratula,
	TO_DATE(NULLIF(ds_origen_fecha, '########'), 'DD/MM/YYYY')                  AS fe_origen,
	(SELECT id_proveedor FROM tmp_proveedor, proveedor
	 WHERE ds_origen = ds_proveedor AND ds_destino = no_proveedor)              AS id_proveedor,
	NULLIF(TRIM(split_part(REPLACE(ds_proveedor, 'S:A', 'S.A'), ':', 2)), '')   AS ds_emp_sugeridas,
	CASE WHEN ds_monto ~ '^[0-9.]*,[0-9]*$' THEN
	  REPLACE(REGEXP_REPLACE(ds_monto, '[-.]', '', 'g'), ',', '.')::NUMERIC END AS va_monto,
	REPLACE(REPLACE(ds_monto_pagado, '.', ''), ',', '.')::NUMERIC               AS va_monto_pagado,
	NULL                                                                        AS id_tipo_bien_servicio,
	NULL                                                                        AS id_tipo_contratacion,
	(SELECT id_reparticion FROM reparticion
	 WHERE no_reparticion = TRIM(ds_reparticion_solicitante))                   AS id_reparticion_solicitante,
	NULL                                                                        AS id_reparticion_destino,
	CASE WHEN TO_DATE(ds_responsable, 'MM/DD/YYYY') <= NOW() THEN TO_DATE(ds_responsable, 'MM/DD/YYYY')
	ELSE TO_DATE(ds_responsable, 'DD/MM/YYYY') END                              AS fe_responsable,
	NULL                                                                        AS fe_compras_ingreso,
	NULL                                                                        AS fe_compras_salida,
	NULL                                                                        AS id_sector_destino,
	(SELECT id_estado FROM estado WHERE no_estado = TRIM(UPPER(ds_estado_2)))   AS id_estado,
	NULLIF(TRIM(ds_estado_1), '')                                               AS ds_estado,
	(SELECT id_ubicacion_interna FROM ubicacion_interna
	 WHERE no_ubicacion_interna = TRIM(ds_ubicacion_interna))                   AS id_ubicacion_interna,
	NULLIF(TRIM(ds_cuit), '')                                                   AS co_cuit,
	NULLIF(TRIM(ds_nro_beneficiario), '')                                       AS ds_beneficiario,
	NULLIF(TRIM(ds_nro_facturas), '')                                           AS ds_facturas,
	NULLIF(TRIM(ds_orden_pago), '')                                             AS ds_orden_pago,
	CASE WHEN NOT ds_monto ~ '^[0-9.]*,[0-9]*$'
	  THEN 'Monto: ' || TRIM(ds_monto) || CHR(10) || TRIM(ds_observaciones_2)
	  ELSE TRIM(ds_observaciones_2) END                                         AS ds_observaciones,
	(SELECT id_finalizado FROM finalizado
	 WHERE no_finalizado = REPLACE(REPLACE(TRIM(UPPER(ds_finalizado)), '.', ''), 'PAGAR', 'PAGO')) AS id_finalizado,
	(SELECT id_cont_oc FROM cont_oc
	 WHERE no_cont_oc = TRIM(ds_cont_oc))                                       AS id_cont_oc
FROM stg_expedientes
WHERE TRIM(ds_caratula) IS NOT NULL
   OR ds_expediente     IS NOT NULL
   OR ds_origen_fecha   IS NOT NULL;
