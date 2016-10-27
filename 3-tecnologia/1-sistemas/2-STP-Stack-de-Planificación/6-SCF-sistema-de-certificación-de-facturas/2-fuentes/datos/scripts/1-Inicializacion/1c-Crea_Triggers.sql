------------------------------ Funciones de Tablas ------------------------------
CREATE OR REPLACE FUNCTION fn_factura_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.id_convenio_at = (
    SELECT co.id_convenio_at
    FROM honorario ho LEFT JOIN contrato co ON co.id_contrato = ho.id_contrato
    WHERE ho.id_honorario = NEW.id_honorario );
  RETURN NEW;
END;
$$;

------------------------------ Creando Triggers ------------------------------
DROP TRIGGER IF EXISTS tg_factura ON factura;
CREATE TRIGGER tg_factura BEFORE INSERT OR UPDATE ON factura
	FOR EACH ROW EXECUTE PROCEDURE fn_factura_tg();

SELECT audit.audit_table('public.agente');
SELECT audit.audit_table('public.categoria_lm');
SELECT audit.audit_table('public.certificacion');
SELECT audit.audit_table('public.contrato');
SELECT audit.audit_table('public.convenio_at');
SELECT audit.audit_table('public.dependencia');
SELECT audit.audit_table('public.factura');
SELECT audit.audit_table('public.mes');
SELECT audit.audit_table('public.puesto');
SELECT audit.audit_table('public.honorario');
SELECT audit.audit_table('public.tipo_contrato');
SELECT audit.audit_table('public.ubicacion_fisica');

/*
UPDATE factura SET id_factura = id_factura;
*/
