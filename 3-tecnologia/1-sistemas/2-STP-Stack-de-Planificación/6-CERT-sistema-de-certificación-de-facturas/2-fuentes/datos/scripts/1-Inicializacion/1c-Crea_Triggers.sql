CREATE OR REPLACE FUNCTION fn_factura_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.id_convenio_at = (
    SELECT co.id_convenio_at
    FROM salario sa LEFT JOIN contrato co ON co.id_contrato = sa.id_contrato
    WHERE sa.id_salario = NEW.id_salario );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_factura_i ON factura;
CREATE TRIGGER tg_factura_i BEFORE INSERT ON factura
    FOR EACH ROW EXECUTE PROCEDURE fn_factura_tg();
DROP TRIGGER IF EXISTS tg_factura_u ON factura;
CREATE TRIGGER tg_factura_u BEFORE UPDATE ON factura
    FOR EACH ROW EXECUTE PROCEDURE fn_factura_tg();

/*
UPDATE factura SET id_factura = id_factura;
*/