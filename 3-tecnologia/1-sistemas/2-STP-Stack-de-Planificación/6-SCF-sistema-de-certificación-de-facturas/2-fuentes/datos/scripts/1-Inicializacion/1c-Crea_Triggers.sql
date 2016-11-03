------------------------------ Funciones de Tablas ------------------------------
CREATE OR REPLACE FUNCTION facturas.fn_factura_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.id_convenio_at = (
    SELECT co.id_convenio_at
    FROM facturas.honorario ho
	LEFT JOIN facturas.contrato co ON co.id_contrato = ho.id_contrato
    WHERE ho.id_honorario = NEW.id_honorario );
  RETURN NEW;
END;
$$;

------------------------------ Creando Triggers ------------------------------
DROP TRIGGER IF EXISTS tg_factura ON facturas.factura;
CREATE TRIGGER tg_factura BEFORE INSERT OR UPDATE ON facturas.factura
	FOR EACH ROW EXECUTE PROCEDURE facturas.fn_factura_tg();

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
