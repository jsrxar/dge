--SET CLIENT_ENCODING TO 'UTF8';

-- Normalizando valores
UPDATE stg_xls_facturas st
SET
	ds_cuit           = TRIM(ds_cuit),
	nm_no_agente      = INITCAP(TRIM(REPLACE(REPLACE(st.ds_nombre, ',', ''), '  ', ' '))),
	nm_id_tipo_honora = TO_CHAR(TO_DATE(st.ds_mes, 'YYYY-MM'), 'YYYYMM')::BIGINT,
	nm_nu_pto_venta   = SPLIT_PART(ds_factura_numero, '-', 1)::INTEGER,
	nm_nu_factura     = SPLIT_PART(ds_factura_numero, '-', 2)::INTEGER,
	nm_va_factura     = ds_importe::NUMERIC,
	co_estado_proceso = 'N'
WHERE co_estado_proceso = 'C';

-- Se verifica la exisrtencia del CUIT
UPDATE stg_xls_facturas st
SET
	co_estado_proceso = 'E',
	nm_mensaje        = 'No se puede reconocer el CUIT'
WHERE co_estado_proceso = 'N'
  AND ds_cuit IS NULL;

-- Se verifica la exisrtencia del Nombre
UPDATE stg_xls_facturas st
SET
	co_estado_proceso = 'E',
	nm_mensaje        = 'No se puede reconocer el Nombre del Agente'
WHERE co_estado_proceso = 'N'
  AND COALESCE(nm_no_agente, '') = '';

-- Se verifica la exisrtencia del Mes (honorario)
UPDATE stg_xls_facturas
SET
	co_estado_proceso = 'E',
	nm_mensaje        = 'No se puede reconocer el mes "' || ds_mes || '" con formato YYYY-MM'
WHERE co_estado_proceso = 'N'
  AND nm_id_tipo_honora IS NULL;

-- Se verifica la exisrtencia del Número de Factura
UPDATE stg_xls_facturas st
SET
	co_estado_proceso = 'E',
	nm_mensaje        = 'No se puede reconocer el número de la factura'
WHERE co_estado_proceso = 'N'
  AND (nm_nu_pto_venta IS NULL OR nm_nu_factura IS NULL);

-- Se obtiene el Agente
UPDATE stg_xls_facturas st
SET nm_id_agente = ag.id_agente
FROM agente ag
WHERE st.co_estado_proceso = 'N'
  AND ag.co_cuit = st.ds_cuit
  AND (LEVENSHTEIN(st.nm_no_agente, ag.no_agente) <= 1
    OR STRPOS(st.nm_no_agente, ag.no_agente) > 0 );

-- Se verifica el Agente
UPDATE stg_xls_facturas st
SET
	co_estado_proceso = 'E',
	nm_mensaje        = 'No coincide el nombre de agente "' || st.nm_no_agente || '" con "' || ag.no_agente || '"'
FROM agente ag
WHERE st.co_estado_proceso = 'N'
  AND st.nm_id_agente IS NULL
  AND ag.co_cuit = st.ds_cuit;

UPDATE stg_xls_facturas
SET
	co_estado_proceso = 'E',
	nm_mensaje        = 'No se encuentra el agente con CUIT "' || ds_cuit || '"'
WHERE co_estado_proceso = 'N'
  AND nm_id_agente IS NULL;

-- Se obtiene el Honorario
UPDATE stg_xls_facturas st
SET
	nm_id_honorario =
		(SELECT ho.id_honorario FROM honorario ho
		 LEFT JOIN contrato co ON ho.id_contrato = co.id_contrato
		 WHERE ho.id_tipo_honorario = st.nm_id_tipo_honora
		   AND co.id_agente = st.nm_id_agente)
WHERE co_estado_proceso = 'N';

-- Se verifica el Honorario
UPDATE stg_xls_facturas
SET
	co_estado_proceso = 'E',
	nm_mensaje        = 'No se encuentra el honorario del mes ' || ds_mes || ' del agente ' || nm_no_agente
WHERE co_estado_proceso = 'N'
  AND nm_id_honorario IS NULL;

-- Se rechazan las facturas ya cargadas
UPDATE stg_xls_facturas st
SET
	co_estado_proceso = 'R',
	nm_mensaje        = 'La factura ya se encuentra cargada'
WHERE co_estado_proceso = 'N'
  AND EXISTS (
	SELECT 1 FROM factura
	WHERE id_honorario = st.nm_id_honorario
	  AND nu_pto_venta = st.nm_nu_pto_venta
	  AND nu_factura   = st.nm_nu_factura
	  AND va_factura   = st.nm_va_factura );

-- Si ya existe factura asociada al honorario, la marcamos como Rechazada
UPDATE factura fa
SET
	fl_rechazo = TRUE,
	ds_comentario = TRIM('Se carga una nueva factura para este honorario: ' || NOW()::TEXT ||'. ' || COALESCE(ds_comentario, ''))
FROM stg_xls_facturas st
WHERE st.co_estado_proceso = 'N'
  AND st.nm_id_honorario = fa.id_honorario
  AND fa.fl_rechazo = FALSE;

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
	nm_id_honorario,
	nm_nu_pto_venta,
	nm_nu_factura,
	fe_modif, 
	fe_carga,
	nm_va_factura,
	TRIM(ds_observaciones)
FROM stg_xls_facturas st
WHERE co_estado_proceso = 'N';

-- Actualiza estado a de Cargado a Procesado
UPDATE stg_xls_facturas
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'N';
