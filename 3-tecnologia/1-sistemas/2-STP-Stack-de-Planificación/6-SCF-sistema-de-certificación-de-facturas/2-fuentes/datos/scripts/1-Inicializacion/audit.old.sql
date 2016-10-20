------------------------------ Auditoria ------------------------------
DROP TABLE IF EXISTS audit.auditoria CASCADE;
CREATE TABLE audit.auditoria (
    no_esquema      TEXT NOT NULL,
    no_tabla        TEXT NOT NULL,
    no_usuario      TEXT,
    fe_ejecucion    TIMESTAMP WITH TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ds_cliente_dir  INET,
    co_ejecucion    TEXT NOT NULL CHECK (co_ejecucion IN ('I','D','U')),
    ds_ejecucion    TEXT,
    ds_datos_viejos TEXT,
    ds_datos_nuevos TEXT
) WITH (fillfactor=100);
 
REVOKE ALL ON audit.auditoria FROM public;
GRANT SELECT ON audit.auditoria TO public;
 
CREATE INDEX auditoria_no_tabla_idx     ON audit.auditoria(no_tabla);
CREATE INDEX auditoria_fe_ejecucion_idx ON audit.auditoria(fe_ejecucion);
CREATE INDEX auditoria_co_ejecucion_idx ON audit.auditoria(co_ejecucion);
 
CREATE OR REPLACE FUNCTION audit.audit_modif() RETURNS TRIGGER AS $body$
DECLARE
    v_datos_viejos TEXT;
    v_datos_nuevos TEXT;
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        v_datos_viejos := ROW(OLD.*);
        v_datos_nuevos := ROW(NEW.*);
        INSERT INTO audit.auditoria (
			no_esquema,
			no_tabla,
			no_usuario,
			co_ejecucion,
			ds_datos_viejos,
			ds_datos_nuevos,
			ds_ejecucion ) 
        VALUES (
			TG_TABLE_SCHEMA::TEXT,
			TG_TABLE_NAME::TEXT,
			session_user::TEXT,
			substring(TG_OP,1,1),
			v_datos_viejos,
			v_datos_nuevos,
			current_query() );
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        v_datos_viejos := ROW(OLD.*);
        INSERT INTO audit.auditoria (
			no_esquema,
			no_tabla,
			no_usuario,
			co_ejecucion,
			ds_datos_viejos,
			ds_ejecucion )
        VALUES (
			TG_TABLE_SCHEMA::TEXT,
			TG_TABLE_NAME::TEXT,
			session_user::TEXT,
			substring(TG_OP,1,1),
			v_datos_viejos,
			current_query() );
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
        v_datos_nuevos := ROW(NEW.*);
        INSERT INTO audit.auditoria (
			no_esquema,
			no_tabla,
			no_usuario,
			co_ejecucion,
			ds_datos_nuevos,
			ds_ejecucion )
        VALUES (
			TG_TABLE_SCHEMA::TEXT,
			TG_TABLE_NAME::TEXT,
			session_user::TEXT,
			substring(TG_OP,1,1),
			v_datos_nuevos,
			current_query() );
        RETURN NEW;
    ELSE
        RAISE WARNING '[AUDIT.AUDIT_MODIF] - Otro tipo de ejecución recibido: %, a %', TG_OP, now();
        RETURN NULL;
    END IF;
 
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.AUDIT_MODIF] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %', SQLSTATE, SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.AUDIT_MODIF] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %', SQLSTATE, SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.AUDIT_MODIF] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %', SQLSTATE, SQLERRM;
        RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, audit;

------------------------------ Creando Triggers ------------------------------
DROP TRIGGER IF EXISTS au_factura ON factura;
CREATE TRIGGER au_factura AFTER INSERT OR UPDATE OR DELETE ON factura FOR EACH ROW EXECUTE PROCEDURE audit.audit_modif();

/*
UPDATE factura SET id_factura = id_factura;
*/
