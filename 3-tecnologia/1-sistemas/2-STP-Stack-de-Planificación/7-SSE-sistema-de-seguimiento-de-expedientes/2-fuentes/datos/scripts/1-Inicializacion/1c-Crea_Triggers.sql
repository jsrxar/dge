CREATE OR REPLACE FUNCTION fn_expediente_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  --NEW.co_expediente = nu_expediente::TEXT || '/' || nu_anio_expediente::TEXT;
  NEW.nu_expediente = CASE WHEN strpos(ds_expediente, '/') > 0 THEN split_part(ds_expediente, '/', 1)::NUMERIC END;
  NEW.nu_anio_expediente = NULLIF(split_part(split_part(ds_expediente, '/', 2), ' ', 1), '')::NUMERIC;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_expediente_i ON expediente;
CREATE TRIGGER tg_expediente_i BEFORE INSERT ON expediente
    FOR EACH ROW EXECUTE PROCEDURE fn_expediente_tg();
DROP TRIGGER IF EXISTS tg_expediente_u ON expediente;
CREATE TRIGGER tg_expediente_u BEFORE UPDATE ON expediente
    FOR EACH ROW EXECUTE PROCEDURE fn_expediente_tg();

/*
UPDATE expediente SET id_expediente = id_expediente;
*/