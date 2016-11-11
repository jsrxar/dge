------------------------------ Funciones de Tablas ------------------------------
CREATE OR REPLACE FUNCTION facturas.fn_encrypt(pVal BYTEA) RETURNS BYTEA
    LANGUAGE plpgsql
    AS $$
DECLARE
  vKey BYTEA;
  vVal VARCHAR;
BEGIN
  vVal = CONVERT_FROM(pVal,'SQL_ASCII');
  IF LENGTH(vVal) <> 16 THEN
    vKey = RPAD(COALESCE(SPLIT_PART(CURRENT_SETTING('application_name'), ';', 2), 'x'), 24, '*')::BYTEA;
    IF STRPOS(vVal, '$') > 0 THEN
      RETURN ENCRYPT(vVal::MONEY::TEXT::BYTEA, vKey, 'AES');
    ELSE
      RETURN ENCRYPT(vVal::NUMERIC::MONEY::TEXT::BYTEA, vKey, 'AES');
    END IF;
  ELSE
    RETURN pVal;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION facturas.fn_factura_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vVal VARCHAR;
  vKey BYTEA;
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
$$;

CREATE OR REPLACE FUNCTION facturas.fn_honorario_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  vVal VARCHAR;
  vKey BYTEA;
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
$$;

------------------------------ Creando Triggers ------------------------------
DROP TRIGGER IF EXISTS tg_factura ON facturas.factura;
DROP TRIGGER IF EXISTS tg_honorario ON facturas.honorario;
CREATE TRIGGER tg_factura BEFORE INSERT OR UPDATE ON facturas.factura
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_factura_tg();
CREATE TRIGGER tg_honorario BEFORE INSERT OR UPDATE ON facturas.honorario
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_honorario_tg();

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

/*
UPDATE factura SET id_factura = id_factura;
*/
