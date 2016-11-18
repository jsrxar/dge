------------------------------ Crea Secuencia Cargas ------------------------------
CREATE SEQUENCE facturas.stg_carga_nro_sq;
ALTER TABLE facturas.stg_carga_nro_sq OWNER TO facturas;

------------------------------ Funciones Generales ------------------------------
/* Valida mes */
CREATE OR REPLACE FUNCTION facturas.fn_valida_mes(IN p_mes TEXT, IN p_form TEXT DEFAULT 'YYYY-MM') RETURNS BIGINT
	LANGUAGE plpgsql AS $valida_mes$
BEGIN
	RETURN TO_CHAR(TO_DATE(p_mes, p_form), 'YYYYMM')::BIGINT;
EXCEPTION WHEN others THEN
	RETURN NULL;
END
$valida_mes$;

/* Validar número con separador */
CREATE OR REPLACE FUNCTION facturas.fn_valida_numero(IN p_numero TEXT, IN p_pos INT, IN p_sep TEXT DEFAULT '-') RETURNS INTEGER
	LANGUAGE plpgsql AS $valida_numero$
BEGIN
	RETURN SPLIT_PART(p_numero, p_sep, p_pos)::INTEGER;
EXCEPTION WHEN others THEN
	RETURN NULL;
END
$valida_numero$;

/* Validar encriptado */
CREATE OR REPLACE FUNCTION facturas.fn_valida_encrypt(IN ds_importe TEXT, IN pKey TEXT) RETURNS BYTEA
	LANGUAGE plpgsql AS $valida_encrypt$
BEGIN
	RETURN fn_encrypt(ds_importe::NUMERIC::TEXT::BYTEA, pKey);
EXCEPTION WHEN others THEN
	RETURN NULL;
END
$valida_encrypt$;

/* Numera las cargas de facturas desde XLS */
CREATE OR REPLACE FUNCTION facturas.fn_xls_numera_carga(IN p_full BOOLEAN DEFAULT FALSE) RETURNS TEXT
	LANGUAGE plpgsql AS $xls_numera_carga$
DECLARE
	r_cargas RECORD;
	v_cargas INTEGER := 0;
BEGIN
	FOR r_cargas IN
		SELECT
			nextval('stg_carga_nro_sq'::regclass) AS nu_carga,
			no_archivo,
			fe_carga
		FROM facturas.stg_xls_facturas
		WHERE p_full IS TRUE
		   OR nu_carga IS NULL
		GROUP BY fe_carga, no_archivo
		ORDER BY fe_carga
	LOOP
		UPDATE facturas.stg_xls_facturas
		SET nu_carga = r_cargas.nu_carga
		WHERE no_archivo = r_cargas.no_archivo
		  AND fe_carga   = r_cargas.fe_carga;
		v_cargas = v_cargas + 1;
	END LOOP;

	RETURN 'Cargas numeradas: ' || v_cargas::TEXT;
END;
$xls_numera_carga$;

/* Procesa los registros generados por una carga desde una planilla Excel */
CREATE OR REPLACE FUNCTION facturas.fn_xls_procesa_cargas(IN pKey TEXT DEFAULT NULL) RETURNS INTEGER
	LANGUAGE plpgsql AS $xls_procesa_cargas$
DECLARE
	v_mensajes HSTORE;
	v_cantidad INTEGER;
	v_error    TEXT;
BEGIN
	/* Estados del proceso de carga:
		C: Cargada, sin procesar
		X: Reprocesar
		N: Normalizada
		P: Procesada
		E: Error (se agrega mensaje)
		R: Rechazada (se agrega mensaje)
	*/

	-- Arma los mensajes de error / rechazo
	v_mensajes =
		'"ERR_CUI_NULL"=>"No se reconoce el CUIT",
		 "ERR_CUI_INEX"=>"No se encuentra el agente con CUIT \"%s\"",
		 "ERR_AGE_NULL"=>"No se reconoce el Nombre del Agente",
		 "ERR_AGE_DIFE"=>"No coincide el nombre de agente \"%s\" con \"%s\"",
		 "ERR_MES_FORM"=>"No se puede cargar el mes \"%s\" con formato \"YYYY-MM\"",
		 "ERR_HON_INEX"=>"No se encuentra el honorario del mes \"%s\" del agente \"%s\"",
		 "ERR_VAL_CRYP"=>"No se puede interpretar el monto \"%s\" como numérico",
		 "ERR_FAC_NULL"=>"No se reconoce el número de la Factura",
		 "WRN_FAC_DIFE"=>"El monto de la factura no coincide con el honorario",
		 "RCH_FAC_EXIS"=>"La factura ya se encuentra cargada",
		 "RCH_FAC_ANTE"=>"Se carga una nueva factura para este honorario: %s%s",
		 "CRG_FAC_CORR"=>"Carga OK"';

	/* Para volver a poner una carga como disponible para procesar
	UPDATE facturas.stg_xls_facturas
	SET
		nm_no_agente = NULL, nm_nu_pto_venta = NULL, nm_nu_factura = NULL, nm_va_factura = NULL,
		nm_id_agente = NULL, nm_id_tipo_honora = NULL, nm_id_honorario = NULL, nm_mensaje = NULL,
		nu_carga = NULL, co_estado_proceso = 'C'
	WHERE fe_carga = '2016-11-15 16:19:41.91'
	*/

	-- Numera las cargas
	PERFORM facturas.fn_xls_numera_carga();

	-- Normalizando los valores
	BEGIN
		UPDATE facturas.stg_xls_facturas st
		SET
			fe_reproc         = CASE WHEN fl_reproc THEN NOW() END,
			nm_co_cuit        = TRIM(ds_cuit),
			nm_no_agente      = INITCAP(TRIM(REPLACE(REPLACE(ds_nombre, ',', ''), '  ', ' '))),
			nm_id_tipo_honora = fn_valida_mes(ds_mes),
			nm_nu_pto_venta   = fn_valida_numero(ds_factura_numero, 1),
			nm_nu_factura     = fn_valida_numero(ds_factura_numero, 2),
			nm_va_factura     = fn_valida_encrypt(ds_importe, pKey),
			fl_reproc         = FALSE,
			co_estado_proceso = 'N'
		WHERE (co_estado_proceso = 'C' OR fl_reproc)
		  AND nu_carga IS NOT NULL;
	EXCEPTION WHEN others THEN
		RAISE NOTICE 'Error (%) al normalizar carga desde XLS: %', SQLSTATE, SQLERRM;
		RETURN -1;
	END;

	-- Verifica la exisrtencia del CUIT
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = v_mensajes -> 'ERR_CUI_NULL'
	WHERE co_estado_proceso = 'N'
	  AND nm_co_cuit IS NULL;

	-- Verifica la exisrtencia del Nombre
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = v_mensajes -> 'ERR_AGE_NULL'
	WHERE co_estado_proceso = 'N'
	  AND COALESCE(nm_no_agente, '') = '';

	-- Verifica la exisrtencia del Mes (honorario)
	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_MES_FORM', ds_mes)
	WHERE co_estado_proceso = 'N'
	  AND nm_id_tipo_honora IS NULL;

	-- Verifica la exisrtencia del Valor
	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_VAL_CRYP', ds_importe)
	WHERE co_estado_proceso = 'N'
	  AND nm_va_factura IS NULL;

	-- Verifica la exisrtencia del Número de Factura
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = v_mensajes -> 'ERR_FAC_NULL'
	WHERE co_estado_proceso = 'N'
	  AND (nm_nu_pto_venta IS NULL
	    OR nm_nu_factura   IS NULL);

	-- Obtiene el Agente
	UPDATE facturas.stg_xls_facturas st
	SET nm_id_agente = ag.id_agente
	FROM facturas.agente ag
	WHERE st.co_estado_proceso = 'N'
	  AND ag.co_cuit = st.nm_co_cuit
	  AND (LEVENSHTEIN(st.nm_no_agente, ag.no_agente) <= 1
	    OR STRPOS(st.nm_no_agente, ag.no_agente) > 0 );

	-- Verifica el Agente
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_AGE_DIFE', st.nm_no_agente, ag.no_agente)
	FROM facturas.agente ag
	WHERE st.co_estado_proceso = 'N'
	  AND st.nm_id_agente IS NULL
	  AND ag.co_cuit = st.nm_co_cuit;

	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_CUI_INEX', nm_co_cuit)
	WHERE co_estado_proceso = 'N'
	  AND nm_id_agente IS NULL;

	-- Obtiene el Honorario
	UPDATE facturas.stg_xls_facturas st
	SET
		nm_id_honorario =
			(SELECT ho.id_honorario FROM facturas.honorario ho
			 LEFT JOIN facturas.contrato co ON ho.id_contrato = co.id_contrato
			 WHERE ho.id_tipo_honorario = st.nm_id_tipo_honora
			   AND co.id_agente = st.nm_id_agente)
	WHERE co_estado_proceso = 'N';

	-- Verifica el Honorario
	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_HON_INEX', ds_mes, nm_no_agente)
	WHERE co_estado_proceso = 'N'
	  AND nm_id_honorario IS NULL;

	-- Rechazan las facturas ya cargadas (iguales)
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'R',
		nm_mensaje        = v_mensajes -> 'RCH_FAC_EXIS'
	WHERE co_estado_proceso = 'N'
	  AND EXISTS (
		SELECT 1 FROM facturas.factura
		WHERE id_honorario = st.nm_id_honorario
		  AND nu_pto_venta = st.nm_nu_pto_venta
		  AND nu_factura   = st.nm_nu_factura
		  AND va_factura   = st.nm_va_factura
		  AND fl_rechazo   = FALSE );

	-- Marca como Rechazada si existe una factura diferente asociada al honorario
	UPDATE facturas.factura fa
	SET
		fl_rechazo = TRUE,
		ds_comentario = FORMAT(v_mensajes -> 'RCH_FAC_ANTE', TO_CHAR(NOW(), 'DD/MM/YYYY HH24:MI'), COALESCE('. ' || ds_comentario, ''))
	FROM facturas.stg_xls_facturas st
	WHERE st.co_estado_proceso = 'N'
	  AND st.nm_id_honorario = fa.id_honorario
	  AND fa.fl_rechazo = FALSE;

	-- Se agrega comentario a facturas con monto diferente al honorario, pero se cargan igualmente (se podrían rechazar)
	UPDATE facturas.stg_xls_facturas fa
	SET
		nm_mensaje        = v_mensajes -> 'WRN_FAC_DIFE'
	FROM facturas.honorario ho
	WHERE fa.co_estado_proceso = 'N'
	  AND fa.nm_id_honorario   = ho.id_honorario
	  AND fa.nm_va_factura    != ho.va_honorario;

	-- Carga las facturas en la tabla de facturas
	INSERT INTO facturas.factura (
		id_carga,
		id_honorario,
		nu_pto_venta,
		nu_factura,
		fe_factura, 
		fe_carga,
		va_factura,
		ds_comentario )
	SELECT
		id_carga,
		nm_id_honorario,
		nm_nu_pto_venta,
		nm_nu_factura,
		fe_modif, 
		fe_carga,
		nm_va_factura,
		CASE WHEN nm_mensaje IS NOT NULL OR ds_observaciones IS NOT NULL THEN
			TRIM(COALESCE(nm_mensaje || '. ', '') || COALESCE(ds_observaciones, '')) END
	FROM facturas.stg_xls_facturas st
	WHERE co_estado_proceso = 'N';

	-- Actualiza estado de Cargado a Procesado
	WITH procesado AS (
		UPDATE facturas.stg_xls_facturas
		SET co_estado_proceso = 'P'
		WHERE co_estado_proceso = 'N'
		RETURNING 1
	) SELECT count(*) INTO v_cantidad FROM procesado;
    
	RETURN v_cantidad;
EXCEPTION WHEN others THEN
	RAISE NOTICE 'Error (%) al normalizar carga desde XLS: %', SQLSTATE, SQLERRM;
	RETURN -1;
END;
$xls_procesa_cargas$;

/* Encriptado de datos con algoritmo AES y clave privada */
CREATE OR REPLACE FUNCTION facturas.fn_encrypt(IN pVal BYTEA, IN pKey TEXT DEFAULT NULL) RETURNS BYTEA
	LANGUAGE plpgsql AS $encrypt$
DECLARE
	vKey BYTEA;
	vVal VARCHAR;
BEGIN
	IF LENGTH(pVal) <> 16 THEN
		vVal = CONVERT_FROM(pVal,'SQL_ASCII');
		vKey = RPAD(COALESCE(COALESCE(pKey, SPLIT_PART(CURRENT_SETTING('application_name'), ';', 2)), 'x'), 24, '*')::BYTEA;
		IF STRPOS(vVal, '$') > 0 THEN
			RETURN ENCRYPT(vVal::MONEY::TEXT::BYTEA, vKey, 'AES');
		ELSE
			RETURN ENCRYPT(vVal::NUMERIC::MONEY::TEXT::BYTEA, vKey, 'AES');
		END IF;
	ELSE
		RETURN pVal;
	END IF;
	RETURN pVal;
EXCEPTION WHEN others THEN
	RETURN NULL;
END;
$encrypt$;

------------------------------ Funciones de Triggers ------------------------------
CREATE OR REPLACE FUNCTION facturas.fn_factura_tg() RETURNS trigger
	LANGUAGE plpgsql AS $factura_tg$
BEGIN
	IF (TG_OP='UPDATE') THEN
		IF OLD.va_factura <> NEW.va_factura THEN
			NEW.va_factura = facturas.fn_encrypt(NEW.va_factura);
		END IF;
	ELSIF (TG_OP='INSERT') THEN
		NEW.va_factura = facturas.fn_encrypt(NEW.va_factura);
	END IF;
	NEW.id_convenio_at = (
		SELECT co.id_convenio_at
		FROM facturas.honorario ho
		LEFT JOIN facturas.contrato co ON co.id_contrato = ho.id_contrato
		WHERE ho.id_honorario = NEW.id_honorario );
	NEW.id_ubicacion_fisica = (
		SELECT ag.id_ubicacion_fisica
		FROM facturas.honorario ho
		LEFT JOIN facturas.contrato co ON co.id_contrato = ho.id_contrato
		LEFT JOIN facturas.agente ag ON ag.id_agente = co.id_agente
		WHERE ho.id_honorario = NEW.id_honorario );
	RETURN NEW;
END;
$factura_tg$;

CREATE OR REPLACE FUNCTION facturas.fn_honorario_tg() RETURNS trigger
	LANGUAGE plpgsql AS $honorario_tg$
BEGIN
	IF (TG_OP='UPDATE') THEN
		IF OLD.va_honorario <> NEW.va_honorario THEN
			NEW.va_honorario = facturas.fn_encrypt(NEW.va_honorario);
		END IF;
	ELSIF (TG_OP='INSERT') THEN
		NEW.va_honorario = facturas.fn_encrypt(NEW.va_honorario);
	END IF;
	RETURN NEW;
END;
$honorario_tg$;

------------------------------ Creando Triggers ------------------------------
DROP TRIGGER IF EXISTS tg_factura ON facturas.factura;
DROP TRIGGER IF EXISTS tg_honorario ON facturas.honorario;
CREATE TRIGGER tg_factura BEFORE INSERT OR UPDATE ON facturas.factura
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_factura_tg();
CREATE TRIGGER tg_honorario BEFORE INSERT OR UPDATE ON facturas.honorario
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_honorario_tg();

------------------------------ Auditoria de Tablas ------------------------------
SELECT audit.audit_table('facturas.agente');
SELECT audit.audit_table('facturas.categoria_lm');
SELECT audit.audit_table('facturas.certificacion');
SELECT audit.audit_table('facturas.contrato');
SELECT audit.audit_table('facturas.convenio_at');
SELECT audit.audit_table('facturas.dependencia');
SELECT audit.audit_table('facturas.factura');
SELECT audit.audit_table('facturas.honorario');
SELECT audit.audit_table('facturas.puesto');
SELECT audit.audit_table('facturas.tipo_honorario');
SELECT audit.audit_table('facturas.tipo_contrato');
SELECT audit.audit_table('facturas.ubicacion_fisica');
SELECT audit.audit_table('stg_xls_facturas', 'true', 'true',
	'{co_estado_proceso, fe_reproc, fe_carga, fe_modif, nm_co_cuit, nm_no_agente, nm_nu_pto_venta, nm_nu_factura, nm_va_factura, nm_id_agente, nm_id_tipo_honora, nm_id_honorario, nm_mensaje}'::text[],
	'UPDATE OR DELETE');

/*
UPDATE factura SET id_factura = id_factura;
*/
