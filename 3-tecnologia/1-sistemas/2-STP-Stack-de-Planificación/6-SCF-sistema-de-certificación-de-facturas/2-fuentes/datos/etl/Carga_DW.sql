--SET CLIENT_ENCODING TO 'UTF8';

-- Elimina facturas ya cargadas
UPDATE factura fa
SET
	fl_rechazo = TRUE,
	ds_comentario = TRIM('Se vuelve a cargar esta factura: ' || NOW()::TEXT ||'. ' || COALESCE(ds_comentario, ''))
WHERE EXISTS (
	SELECT 1
	FROM stg_xls_facturas st
	INNER JOIN honorario ho ON ho.id_tipo_honorario = TO_CHAR(TO_DATE(st.ds_mes, 'YYYY-MM'), 'YYYYMM')::BIGINT
	INNER JOIN contrato co ON ho.id_contrato = co.id_contrato
	INNER JOIN agente ag ON co.id_agente = ag.id_agente AND ag.co_cuit = TRIM(st.ds_cuit)
	WHERE ho.id_honorario = fa.id_honorario
	  AND st.co_estado_proceso = 'C' );

-- Marca los errores
UPDATE stg_xls_facturas st
SET co_estado_proceso = 'E'
WHERE co_estado_proceso = 'C'
  AND NOT EXISTS
	(SELECT 1 FROM honorario ho
	 LEFT JOIN contrato co ON ho.id_contrato = co.id_contrato
	 LEFT JOIN agente ag ON co.id_agente = ag.id_agente
	 WHERE ho.id_tipo_honorario = TO_CHAR(TO_DATE(st.ds_mes, 'YYYY-MM'), 'YYYYMM')::BIGINT
	   AND ag.co_cuit = TRIM(st.ds_cuit));

-- Carga las facturas
INSERT INTO factura (
	id_honorario,
	nu_pto_venta,
	nu_factura,
	fe_factura, 
	fe_carga,
	va_factura,
	ds_comentario )
SELECT
	(SELECT ho.id_honorario FROM honorario ho
	 LEFT JOIN contrato co ON ho.id_contrato = co.id_contrato
	 LEFT JOIN agente ag ON co.id_agente = ag.id_agente
	 WHERE ho.id_tipo_honorario = TO_CHAR(TO_DATE(st.ds_mes, 'YYYY-MM'), 'YYYYMM')::BIGINT
	   AND ag.co_cuit = TRIM(st.ds_cuit)) AS id_honorario,
	SPLIT_PART(ds_factura_numero, '-', 1)::INTEGER AS nu_pto_venta,
	SPLIT_PART(ds_factura_numero, '-', 2)::INTEGER AS nu_factura,
	fe_modif   AS fe_factura, 
	fe_carga   AS fe_carga,
	ds_importe::NUMERIC AS va_factura,
	TRIM(ds_observaciones) AS ds_comentario
FROM stg_xls_facturas st
WHERE co_estado_proceso = 'C';

-- Actualiza estado a de Cargado a Procesado
UPDATE stg_xls_facturas
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C';
