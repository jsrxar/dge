------------------------------ Funciones Generales ------------------------------
/* Valida mes */
CREATE OR REPLACE FUNCTION facturas.fn_valida_mes(IN p_mes TEXT, IN p_form TEXT DEFAULT 'YYYY-MM') RETURNS DATE
	LANGUAGE plpgsql AS $valida_mes$
BEGIN
	RETURN TO_DATE(p_mes, p_form)::DATE;
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
	RETURN fn_encrypt(REPLACE(REPLACE(ds_importe,' ',''),',','.')::TEXT::BYTEA, pKey);
EXCEPTION WHEN others THEN
	RETURN NULL;
END
$valida_encrypt$;

/* Compara nombres */
CREATE OR REPLACE FUNCTION facturas.fn_compara_nombres(IN p_nom1 VARCHAR, IN p_nom2 VARCHAR) RETURNS BOOLEAN
	LANGUAGE plpgsql AS $compara_nombres$
DECLARE
	v_nom1 VARCHAR;
	v_nom2 VARCHAR;
BEGIN
	IF p_nom1 IS NULL OR p_nom2 IS NULL THEN
		RETURN FALSE;
	ELSE
		v_nom1 = TRANSLATE(UPPER(p_nom1), 'ÁÉÍÓÚÄËÏÖÜÑ, ', 'AEIOUAEIOUN');
		v_nom2 = TRANSLATE(UPPER(p_nom2), 'ÁÉÍÓÚÄËÏÖÜÑ, ', 'AEIOUAEIOUN');
		IF LEVENSHTEIN(v_nom1, v_nom2) <= 1
		OR STRPOS(v_nom1, v_nom2) > 0
		OR STRPOS(v_nom2, v_nom1) > 0 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END IF;
EXCEPTION WHEN others THEN
	RETURN FALSE;
END
$compara_nombres$;

/* Numera las cargas de facturas desde XLS */
CREATE OR REPLACE FUNCTION facturas.fn_xls_numera_carga(IN p_full BOOLEAN DEFAULT FALSE) RETURNS TEXT
	LANGUAGE plpgsql AS $xls_numera_carga$
DECLARE
	r_cargas RECORD;
	v_cargas INTEGER := 0;
BEGIN
	BEGIN
		CREATE SEQUENCE facturas.stg_carga_nro_sq;
		ALTER TABLE facturas.stg_carga_nro_sq OWNER TO facturas;
	EXCEPTION WHEN duplicate_table THEN
		NULL;
	END;

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
	-- Encripta Montos
	IF (TG_OP='UPDATE') THEN
		IF OLD.va_factura <> NEW.va_factura THEN
			NEW.va_factura = facturas.fn_encrypt(NEW.va_factura);
		END IF;
	ELSIF (TG_OP='INSERT') THEN
		NEW.va_factura = facturas.fn_encrypt(NEW.va_factura);
	END IF;

	-- Actualiza datos del Honorario
	NEW.no_tipo_honorario = (
		SELECT th.no_tipo_honorario
		FROM facturas.honorario ho
		LEFT JOIN facturas.tipo_honorario th ON th.id_tipo_honorario = ho.id_tipo_honorario
		WHERE ho.id_honorario = NEW.id_honorario );

	-- Actualiza ID del Convenio
	NEW.id_convenio_at = (
		SELECT co.id_convenio_at
		FROM facturas.honorario ho
		LEFT JOIN facturas.contrato co ON co.id_contrato = ho.id_contrato
		WHERE ho.id_honorario = NEW.id_honorario );

	-- Actualiza ID de la Ubicación Física
	NEW.id_ubicacion_fisica = (
		SELECT ag.id_ubicacion_fisica
		FROM facturas.honorario ho
		LEFT JOIN facturas.contrato co ON co.id_contrato = ho.id_contrato
		LEFT JOIN facturas.agente ag ON ag.id_agente = co.id_agente
		WHERE ho.id_honorario = NEW.id_honorario );
	RETURN NEW;
END;
$factura_tg$;

CREATE OR REPLACE FUNCTION facturas.fn_factura_tg_post() RETURNS trigger
	LANGUAGE plpgsql AS $factura_tg_post$
BEGIN
	-- Actualiza datos del Honorario
	UPDATE facturas.honorario
	SET	id_factura = CASE WHEN NOT COALESCE(NEW.fl_rechazo, false) THEN NEW.id_factura ELSE NULL END
	WHERE id_honorario = NEW.id_honorario;
	--RAISE NOTICE 'Poniendo Factura % en Honorario % (rechazo %)', NEW.id_factura, NEW.id_honorario, NEW.fl_rechazo;
	RETURN NEW;
EXCEPTION WHEN others THEN
	RETURN NEW;
END;
$factura_tg_post$;

CREATE OR REPLACE FUNCTION facturas.fn_contrato_tg() RETURNS trigger
	LANGUAGE plpgsql AS $contrato_tg$
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
$contrato_tg$;

CREATE OR REPLACE FUNCTION facturas.fn_contrato_tg_post() RETURNS trigger
	LANGUAGE plpgsql AS $contrato_tg_post$
BEGIN
	IF NEW.fl_crea_honorarios THEN
		INSERT INTO facturas.honorario(
			id_contrato,
			id_tipo_honorario,
			va_pct_ajuste,
			va_honorario )
		SELECT
			NEW.id_contrato,
			th.id_tipo_honorario,
			th.va_pct_ajuste,
			NEW.va_honorario
		FROM facturas.tipo_honorario th
		WHERE th.co_categ_honorario = COALESCE(NEW.co_categ_contrato, 'M')
		  AND NEW.va_honorario IS NOT NULL
		  AND NOT EXISTS (
			SELECT 1 FROM facturas.honorario
			WHERE id_contrato = NEW.id_contrato
			  AND id_tipo_honorario = th.id_tipo_honorario)
		  AND th.nu_anio_honorario*100+th.nu_mes_honorario BETWEEN
			TO_CHAR(NEW.fe_inicio, 'YYYYMM')::BIGINT AND
			TO_CHAR(NEW.fe_fin, 'YYYYMM')::BIGINT;
	END IF;
	RETURN NEW;
EXCEPTION WHEN others THEN
	RETURN NEW;
END;
$contrato_tg_post$;

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
DROP TRIGGER IF EXISTS tg_factura_post ON facturas.factura;
DROP TRIGGER IF EXISTS tg_contrato ON facturas.contrato;
DROP TRIGGER IF EXISTS tg_contrato_post ON facturas.contrato;
DROP TRIGGER IF EXISTS tg_honorario ON facturas.honorario;

CREATE TRIGGER tg_factura BEFORE INSERT OR UPDATE ON facturas.factura
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_factura_tg();
CREATE TRIGGER tg_factura_post AFTER INSERT OR UPDATE ON facturas.factura
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_factura_tg_post();

CREATE TRIGGER tg_contrato BEFORE INSERT OR UPDATE ON facturas.contrato
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_contrato_tg();
CREATE TRIGGER tg_contrato_post AFTER INSERT ON facturas.contrato
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_contrato_tg_post();

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
