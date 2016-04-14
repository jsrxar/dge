CREATE OR REPLACE FUNCTION fn_tipo_accion_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ds_referencia = TRIM(COALESCE(
    (SELECT ds_referencia FROM sga_tipo_accion WHERE id_tipo_accion = NEW.id_tipo_accion_padre) || ' | ', ' ')
    || NEW.no_tipo_accion);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_tipo_bien_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ds_referencia = TRIM(COALESCE(
    (SELECT ds_referencia FROM sga_tipo_bien WHERE id_tipo_bien = NEW.id_tipo_bien_padre) || ' | ', ' ')
    || NEW.no_tipo_bien);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_tipo_espacio_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ds_referencia = TRIM(COALESCE(
    (SELECT ds_referencia FROM sga_tipo_espacio WHERE id_tipo_espacio = NEW.id_tipo_espacio_padre) || ' | ', ' ')
    || NEW.no_tipo_espacio);
  RETURN NEW;
END;
$$;

/*
CREATE OR REPLACE FUNCTION fn_area_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ds_referencia = TRIM(COALESCE(
    (SELECT ds_referencia FROM sga_area WHERE id_area = NEW.id_area_padre) || ' | ', ' ')
    || NEW.no_area);
  RETURN NEW;
END;
$$;
*/

CREATE OR REPLACE FUNCTION fn_accion_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ds_referencia = TRIM(
    COALESCE((SELECT ds_referencia FROM sga_tipo_accion WHERE id_tipo_accion = NEW.id_tipo_accion), ' ') ||
    COALESCE(' > ' || (SELECT ds_referencia FROM sga_tipo_bien WHERE id_tipo_bien = NEW.id_tipo_bien), ' ') ||
    COALESCE(' > ' || (SELECT ds_referencia FROM sga_tipo_espacio WHERE id_tipo_espacio = NEW.id_tipo_espacio), ' ') ||
    COALESCE(' > ' || (SELECT no_sector FROM sga_sector WHERE id_sector = NEW.id_sector), ' '));
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_tarea_plan_tg_i() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    rg_espacio RECORD;
BEGIN
  NEW.ds_referencia = TRIM(
    COALESCE((SELECT ds_referencia FROM sga_accion WHERE id_accion = NEW.id_accion), NEW.id_tarea_plan::TEXT));
  IF NEW.fe_horas IS NULL THEN
    NEW.fe_horas = (SELECT fe_horas FROM sga_accion WHERE id_accion = NEW.id_accion);
  END IF;
  IF NEW.id_espacio = 0 THEN
    FOR rg_espacio IN
        SELECT es.id_espacio
        FROM sga_accion ac
        LEFT JOIN sga_espacio es
        ON es.id_tipo_espacio = ac.id_tipo_espacio
        AND es.id_sector = ac.id_sector
        WHERE ac.id_accion = NEW.id_accion
    LOOP
      IF rg_espacio.id_espacio IS NOT NULL THEN
        INSERT INTO sga_tarea_plan (
            id_espacio,
            id_accion,
            id_bien,
            id_periodicidad,
            ds_detalle,
            ds_referencia,
            fe_inicio,
            nu_personas,
            tm_carga_horaria,
            fe_horas )
        VALUES (
            rg_espacio.id_espacio,
            NEW.id_accion,
            NEW.id_bien,
            NEW.id_periodicidad,
            NEW.ds_detalle,
            NEW.ds_referencia,
            NEW.fe_inicio,
            NEW.nu_personas,
            NEW.tm_carga_horaria,
            NEW.fe_horas );
      END IF;
    END LOOP;
    RETURN NULL;
  ELSE
    RETURN NEW;
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION fn_tarea_plan_tg_u() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ds_referencia = TRIM(
    COALESCE((SELECT ds_referencia FROM sga_accion WHERE id_accion = NEW.id_accion), NEW.id_tarea_plan::TEXT));
  IF NEW.fe_horas IS NULL THEN
    IF NEW.id_accion        != OLD.id_accion
    OR NEW.id_bien          != OLD.id_bien
    OR NEW.id_periodicidad  != OLD.id_periodicidad
    OR NEW.ds_detalle       != OLD.ds_detalle
    OR NEW.ds_referencia    != OLD.ds_referencia
    OR NEW.id_espacio       != OLD.id_espacio
    OR NEW.fe_inicio        != OLD.fe_inicio
    OR NEW.nu_personas      != OLD.nu_personas
    OR NEW.tm_carga_horaria != OLD.tm_carga_horaria THEN
      NEW.fe_horas = (SELECT fe_horas FROM sga_accion WHERE id_accion = NEW.id_accion);
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION fn_espacio_tg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ds_referencia = TRIM(
    COALESCE((SELECT ds_referencia FROM sga_tipo_espacio WHERE id_tipo_espacio = NEW.id_tipo_espacio) || ' > ', ' ') ||
    COALESCE((SELECT no_sector FROM sga_sector WHERE id_sector = NEW.id_sector) || ' > ', ' ') ||
    COALESCE((SELECT no_planta FROM sga_planta WHERE id_planta = NEW.id_planta) || ' > ', ' ') ||
    COALESCE(TRIM(NEW.no_espacio)));
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_tipo_accion_i ON sga_tipo_accion;
CREATE TRIGGER tg_tipo_accion_i BEFORE INSERT ON sga_tipo_accion
    FOR EACH ROW EXECUTE PROCEDURE fn_tipo_accion_tg();
DROP TRIGGER IF EXISTS tg_tipo_accion_u ON sga_tipo_accion;
CREATE TRIGGER tg_tipo_accion_u BEFORE UPDATE ON sga_tipo_accion
    FOR EACH ROW EXECUTE PROCEDURE fn_tipo_accion_tg();

DROP TRIGGER IF EXISTS tg_tipo_bien_i ON sga_tipo_bien;
CREATE TRIGGER tg_tipo_bien_i BEFORE INSERT ON sga_tipo_bien
    FOR EACH ROW EXECUTE PROCEDURE fn_tipo_bien_tg();
DROP TRIGGER IF EXISTS tg_tipo_bien_u ON sga_tipo_bien;
CREATE TRIGGER tg_tipo_bien_u BEFORE UPDATE ON sga_tipo_bien
    FOR EACH ROW EXECUTE PROCEDURE fn_tipo_bien_tg();

DROP TRIGGER IF EXISTS tg_tipo_espacio_i ON sga_tipo_espacio;
CREATE TRIGGER tg_tipo_espacio_i BEFORE INSERT ON sga_tipo_espacio
    FOR EACH ROW EXECUTE PROCEDURE fn_tipo_espacio_tg();
DROP TRIGGER IF EXISTS tg_tipo_espacio_u ON sga_tipo_espacio;
CREATE TRIGGER tg_tipo_espacio_u BEFORE UPDATE ON sga_tipo_espacio
    FOR EACH ROW EXECUTE PROCEDURE fn_tipo_espacio_tg();

/*
DROP TRIGGER IF EXISTS tg_area_i ON sga_area;
CREATE TRIGGER tg_area_i BEFORE INSERT ON sga_area
    FOR EACH ROW EXECUTE PROCEDURE fn_area_tg();
DROP TRIGGER IF EXISTS tg_area_u ON sga_area;
CREATE TRIGGER tg_area_u BEFORE UPDATE ON sga_area
    FOR EACH ROW EXECUTE PROCEDURE fn_area_tg();
*/

DROP TRIGGER IF EXISTS tg_accion_i ON sga_accion;
CREATE TRIGGER tg_accion_i BEFORE INSERT ON sga_accion
    FOR EACH ROW EXECUTE PROCEDURE fn_accion_tg();
DROP TRIGGER IF EXISTS tg_accion_u ON sga_accion;
CREATE TRIGGER tg_accion_u BEFORE UPDATE ON sga_accion
    FOR EACH ROW EXECUTE PROCEDURE fn_accion_tg();

DROP TRIGGER IF EXISTS tg_tarea_plan_i ON sga_tarea_plan;
CREATE TRIGGER tg_tarea_plan_i BEFORE INSERT ON sga_tarea_plan
    FOR EACH ROW EXECUTE PROCEDURE fn_tarea_plan_tg_i();
DROP TRIGGER IF EXISTS tg_tarea_plan_u ON sga_tarea_plan;
CREATE TRIGGER tg_tarea_plan_u BEFORE UPDATE ON sga_tarea_plan
    FOR EACH ROW EXECUTE PROCEDURE fn_tarea_plan_tg_u();

DROP TRIGGER IF EXISTS tg_espacio_i ON sga_espacio;
CREATE TRIGGER tg_espacio_i BEFORE INSERT ON sga_espacio
    FOR EACH ROW EXECUTE PROCEDURE fn_espacio_tg();
DROP TRIGGER IF EXISTS tg_espacio_u ON sga_espacio;
CREATE TRIGGER tg_espacio_u BEFORE UPDATE ON sga_espacio
    FOR EACH ROW EXECUTE PROCEDURE fn_espacio_tg();

/*
UPDATE sga_tipo_accion  SET id_tipo_accion  = id_tipo_accion  WHERE id_tipo_accion_padre IS NOT NULL;
UPDATE sga_tipo_bien    SET id_tipo_bien    = id_tipo_bien    WHERE id_tipo_bien_padre IS NOT NULL;
UPDATE sga_tipo_espacio SET id_tipo_espacio = id_tipo_espacio WHERE id_tipo_espacio_padre IS NOT NULL;
UPDATE sga_area         SET id_area         = id_area         WHERE id_area_padre IS NOT NULL;
UPDATE sga_accion       SET id_accion       = id_accion;
UPDATE sga_tarea_plan   SET id_tarea_plan   = id_tarea_plan;
UPDATE sga_espacio      SET id_espacio      = id_espacio;
*/