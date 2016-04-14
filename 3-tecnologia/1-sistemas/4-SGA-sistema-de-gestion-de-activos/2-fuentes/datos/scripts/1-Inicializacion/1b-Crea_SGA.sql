
CREATE SEQUENCE public.sga_sector_sq;

CREATE TABLE public.sga_sector (
                id_sector SMALLINT NOT NULL DEFAULT nextval('public.sga_sector_sq'),
                no_sector VARCHAR(50) NOT NULL,
                CONSTRAINT sga_sector_pk PRIMARY KEY (id_sector)
);
COMMENT ON TABLE public.sga_sector IS 'Sector del edificio en que se encuentra el área.';
COMMENT ON COLUMN public.sga_sector.id_sector IS 'Identificador único del sector.';
COMMENT ON COLUMN public.sga_sector.no_sector IS 'Nombre del sector (noble, ibndustrial, etc.).';


ALTER SEQUENCE public.sga_sector_sq OWNED BY public.sga_sector.id_sector;

CREATE SEQUENCE public.sga_planta_sq;

CREATE TABLE public.sga_planta (
                id_planta SMALLINT NOT NULL DEFAULT nextval('public.sga_planta_sq'),
                no_planta VARCHAR(100) NOT NULL,
                CONSTRAINT sga_planta_pk PRIMARY KEY (id_planta)
);
COMMENT ON TABLE public.sga_planta IS 'Planta en la que se encuentra el espacio.';
COMMENT ON COLUMN public.sga_planta.id_planta IS 'Identificador único de la planta.';
COMMENT ON COLUMN public.sga_planta.no_planta IS 'Nombre de la planta.';


ALTER SEQUENCE public.sga_planta_sq OWNED BY public.sga_planta.id_planta;

CREATE SEQUENCE public.sga_tipo_accion_sq;

CREATE TABLE public.sga_tipo_accion (
                id_tipo_accion INTEGER NOT NULL DEFAULT nextval('public.sga_tipo_accion_sq'),
                no_tipo_accion VARCHAR(100) NOT NULL,
                id_tipo_accion_padre INTEGER,
                ds_referencia VARCHAR(400),
                CONSTRAINT sga_tipo_accion_pk PRIMARY KEY (id_tipo_accion)
);
COMMENT ON TABLE public.sga_tipo_accion IS 'Tipo de acciones a realizar sobre los bienes.';
COMMENT ON COLUMN public.sga_tipo_accion.id_tipo_accion IS 'Identificador único del tipo de acción.';
COMMENT ON COLUMN public.sga_tipo_accion.no_tipo_accion IS 'Nombre del tipo de acción que se puede realizar sobre el bien.';
COMMENT ON COLUMN public.sga_tipo_accion.id_tipo_accion_padre IS 'Identificador único del tipo de acción contenedora.';
COMMENT ON COLUMN public.sga_tipo_accion.ds_referencia IS 'Referencia del registro.';


ALTER SEQUENCE public.sga_tipo_accion_sq OWNED BY public.sga_tipo_accion.id_tipo_accion;

CREATE SEQUENCE public.sga_origen_sq;

CREATE TABLE public.sga_origen (
                id_origen INTEGER NOT NULL DEFAULT nextval('public.sga_origen_sq'),
                no_origen VARCHAR(100) NOT NULL,
                CONSTRAINT sga_origen_pk PRIMARY KEY (id_origen)
);
COMMENT ON TABLE public.sga_origen IS 'Origen de la especificación de la actividad/procedimiento.';
COMMENT ON COLUMN public.sga_origen.id_origen IS 'Identificador único de origen.';
COMMENT ON COLUMN public.sga_origen.no_origen IS 'Nombre del origen de la actividad/procedimiento.';


ALTER SEQUENCE public.sga_origen_sq OWNED BY public.sga_origen.id_origen;

CREATE SEQUENCE public.sga_procedimiento_sq;

CREATE TABLE public.sga_metodologia (
                id_metodologia INTEGER NOT NULL DEFAULT nextval('public.sga_procedimiento_sq'),
                no_metodologia VARCHAR(100) NOT NULL,
                ds_metodologia VARCHAR(4000),
                id_origen INTEGER,
                CONSTRAINT sga_metodologia_pk PRIMARY KEY (id_metodologia)
);
COMMENT ON TABLE public.sga_metodologia IS 'Metodología de realización de la actividad.';
COMMENT ON COLUMN public.sga_metodologia.id_metodologia IS 'Identificador único de una metodología.';
COMMENT ON COLUMN public.sga_metodologia.no_metodologia IS 'Nombre de la metodología.';
COMMENT ON COLUMN public.sga_metodologia.ds_metodologia IS 'Descripción del metodología.';
COMMENT ON COLUMN public.sga_metodologia.id_origen IS 'Identificador único de origen.';


ALTER SEQUENCE public.sga_procedimiento_sq OWNED BY public.sga_metodologia.id_metodologia;

CREATE SEQUENCE public.sga_periodicidad_sq;

CREATE TABLE public.sga_periodicidad (
                id_periodicidad INTEGER NOT NULL DEFAULT nextval('public.sga_periodicidad_sq'),
                no_periodicidad VARCHAR(100) NOT NULL,
                va_frecuencia REAL DEFAULT 1 NOT NULL,
                ds_tipo_frecuencia VARCHAR(20) NOT NULL,
                CONSTRAINT sga_periodicidad_pk PRIMARY KEY (id_periodicidad)
);
COMMENT ON TABLE public.sga_periodicidad IS 'Periodicidad de realización de una tarea.';
COMMENT ON COLUMN public.sga_periodicidad.id_periodicidad IS 'Identificador único de la periodicidad.';
COMMENT ON COLUMN public.sga_periodicidad.no_periodicidad IS 'Nombre de la periodicidad.';
COMMENT ON COLUMN public.sga_periodicidad.va_frecuencia IS 'Frecuencia (en días) de realización de la actividad.';
COMMENT ON COLUMN public.sga_periodicidad.ds_tipo_frecuencia IS 'Unidad en que es medida la frecuencia de ejecución.';


ALTER SEQUENCE public.sga_periodicidad_sq OWNED BY public.sga_periodicidad.id_periodicidad;

CREATE SEQUENCE public.sga_tipo_bien_sq;

CREATE TABLE public.sga_tipo_bien (
                id_tipo_bien INTEGER NOT NULL DEFAULT nextval('public.sga_tipo_bien_sq'),
                no_tipo_bien VARCHAR(100) NOT NULL,
                id_tipo_bien_padre INTEGER,
                ds_referencia VARCHAR(400),
                CONSTRAINT sga_tipo_bien_pk PRIMARY KEY (id_tipo_bien)
);
COMMENT ON TABLE public.sga_tipo_bien IS 'Tipo de bien.';
COMMENT ON COLUMN public.sga_tipo_bien.id_tipo_bien IS 'Identificador único del tipo de bien.';
COMMENT ON COLUMN public.sga_tipo_bien.no_tipo_bien IS 'Nombre del tipo de bien.';
COMMENT ON COLUMN public.sga_tipo_bien.id_tipo_bien_padre IS 'Identificador único del tipo de bien padre (supertipo).';
COMMENT ON COLUMN public.sga_tipo_bien.ds_referencia IS 'Referencia del registro.';


ALTER SEQUENCE public.sga_tipo_bien_sq OWNED BY public.sga_tipo_bien.id_tipo_bien;

CREATE SEQUENCE public.sga_tipo_espacio_sq;

CREATE TABLE public.sga_tipo_espacio (
                id_tipo_espacio SMALLINT NOT NULL DEFAULT nextval('public.sga_tipo_espacio_sq'),
                no_tipo_espacio VARCHAR(100) NOT NULL,
                id_tipo_espacio_padre SMALLINT,
                ds_referencia VARCHAR(400),
                CONSTRAINT sga_tipo_espacio_pk PRIMARY KEY (id_tipo_espacio)
);
COMMENT ON TABLE public.sga_tipo_espacio IS 'Tipo de espacio físico dentro del centro cultural.';
COMMENT ON COLUMN public.sga_tipo_espacio.id_tipo_espacio IS 'Identificador único del tipo de espacio.';
COMMENT ON COLUMN public.sga_tipo_espacio.no_tipo_espacio IS 'Nombre del tipo de espacio.';
COMMENT ON COLUMN public.sga_tipo_espacio.id_tipo_espacio_padre IS 'Identificador único del tipo de espacio padre (supertipo).';
COMMENT ON COLUMN public.sga_tipo_espacio.ds_referencia IS 'Referencia del registro.';


ALTER SEQUENCE public.sga_tipo_espacio_sq OWNED BY public.sga_tipo_espacio.id_tipo_espacio;

CREATE SEQUENCE public.sga_accion_sq;

CREATE TABLE public.sga_accion (
                id_accion INTEGER NOT NULL DEFAULT nextval('public.sga_accion_sq'),
                id_tipo_espacio SMALLINT,
                id_tipo_bien INTEGER,
                id_tipo_accion INTEGER,
                id_sector SMALLINT,
                id_origen INTEGER DEFAULT 2,
                id_metodologia INTEGER,
                id_periodicidad INTEGER,
                fl_a_demanda BOOLEAN,
                fe_horas VARCHAR(600),
                nu_personas SMALLINT,
                tm_carga_horaria TIME,
                ds_referencia VARCHAR(400),
                CONSTRAINT sga_accion_pk PRIMARY KEY (id_accion)
);
COMMENT ON TABLE public.sga_accion IS 'Actividad específica a realizar sobre un tipo de bien y un espacio.';
COMMENT ON COLUMN public.sga_accion.id_accion IS 'Identificador único de la acción.';
COMMENT ON COLUMN public.sga_accion.id_tipo_espacio IS 'Identificador único del tipo de espacio.';
COMMENT ON COLUMN public.sga_accion.id_tipo_bien IS 'Identificador único del tipo de bien.';
COMMENT ON COLUMN public.sga_accion.id_tipo_accion IS 'Identificador único del tipo de acción.';
COMMENT ON COLUMN public.sga_accion.id_sector IS 'Identificador único del sector.';
COMMENT ON COLUMN public.sga_accion.id_origen IS 'Identificador único de origen.';
COMMENT ON COLUMN public.sga_accion.id_metodologia IS 'Identificador único de la metodología.';
COMMENT ON COLUMN public.sga_accion.id_periodicidad IS 'Identificador único de la periodicidad.';
COMMENT ON COLUMN public.sga_accion.fl_a_demanda IS 'Indicador de si la actividad puede ser realizada a demanda.';
COMMENT ON COLUMN public.sga_accion.fe_horas IS 'Horarios de ejecución de las tareas.';
COMMENT ON COLUMN public.sga_accion.nu_personas IS 'Cantidad de personas necesarias para la realización de la tarea.';
COMMENT ON COLUMN public.sga_accion.tm_carga_horaria IS 'Tiempo estimado de ejecución de la acción.';
COMMENT ON COLUMN public.sga_accion.ds_referencia IS 'Referencia del registro.';


ALTER SEQUENCE public.sga_accion_sq OWNED BY public.sga_accion.id_accion;

CREATE SEQUENCE public.sga_espacio_sq;

CREATE TABLE public.sga_espacio (
                id_espacio INTEGER NOT NULL DEFAULT nextval('public.sga_espacio_sq'),
                id_tipo_espacio SMALLINT NOT NULL,
                id_espacio_contenedor INTEGER,
                id_sector SMALLINT,
                id_planta SMALLINT,
                co_espacio VARCHAR(50) NOT NULL,
                no_espacio VARCHAR(100) NOT NULL,
                co_plano VARCHAR(50),
                ds_referencia VARCHAR(400),
                CONSTRAINT sga_espacio_pk PRIMARY KEY (id_espacio)
);
COMMENT ON TABLE public.sga_espacio IS 'Espacios físicos dentro del centro cultural.';
COMMENT ON COLUMN public.sga_espacio.id_espacio IS 'Identificador único del espacio.';
COMMENT ON COLUMN public.sga_espacio.id_tipo_espacio IS 'Identificador único del tipo de espacio.';
COMMENT ON COLUMN public.sga_espacio.id_espacio_contenedor IS 'Identificador único del espacio contenedor (padre).';
COMMENT ON COLUMN public.sga_espacio.id_sector IS 'Identificador único del sector.';
COMMENT ON COLUMN public.sga_espacio.id_planta IS 'Identificador único de la planta.';
COMMENT ON COLUMN public.sga_espacio.co_espacio IS 'Código de espacio.';
COMMENT ON COLUMN public.sga_espacio.no_espacio IS 'Nombre del espacio.';
COMMENT ON COLUMN public.sga_espacio.co_plano IS 'Codificación del espacio en los planos de Espacio Físico.';
COMMENT ON COLUMN public.sga_espacio.ds_referencia IS 'Referencia del registro.';


ALTER SEQUENCE public.sga_espacio_sq OWNED BY public.sga_espacio.id_espacio;

CREATE SEQUENCE public.sga_bien_sq;

CREATE TABLE public.sga_bien (
                id_bien INTEGER NOT NULL DEFAULT nextval('public.sga_bien_sq'),
                id_tipo_bien INTEGER NOT NULL,
                id_espacio INTEGER NOT NULL,
                nu_cantidad INTEGER DEFAULT 1,
                ds_observacion VARCHAR(400),
                CONSTRAINT sga_bien_pk PRIMARY KEY (id_bien)
);
COMMENT ON TABLE public.sga_bien IS 'Bienes del centro cultural.';
COMMENT ON COLUMN public.sga_bien.id_bien IS 'Identificador único del bien.';
COMMENT ON COLUMN public.sga_bien.id_tipo_bien IS 'Identificador único del tipo de bien.';
COMMENT ON COLUMN public.sga_bien.id_espacio IS 'Identificador único del espacio.';
COMMENT ON COLUMN public.sga_bien.nu_cantidad IS 'Cantidad de bienes del tipo dentro del espacio.';
COMMENT ON COLUMN public.sga_bien.ds_observacion IS 'Observaciones del bien.';


ALTER SEQUENCE public.sga_bien_sq OWNED BY public.sga_bien.id_bien;

CREATE SEQUENCE public.sga_tarea_plan_sq;

CREATE TABLE public.sga_tarea_plan (
                id_tarea_plan INTEGER NOT NULL DEFAULT nextval('public.sga_tarea_plan_sq'),
                id_accion INTEGER NOT NULL,
                id_espacio INTEGER,
                id_bien INTEGER,
                id_periodicidad INTEGER,
                fe_inicio TIMESTAMP,
                ds_detalle VARCHAR(4000),
                fe_horas VARCHAR(600),
                nu_personas SMALLINT,
                tm_carga_horaria TIME,
                ds_referencia VARCHAR(400),
                CONSTRAINT sga_tarea_plan_pk PRIMARY KEY (id_tarea_plan)
);
COMMENT ON TABLE public.sga_tarea_plan IS 'Planificación de tareas a realizar sobre el bien.';
COMMENT ON COLUMN public.sga_tarea_plan.id_tarea_plan IS 'Identificador único de la planificación de la tarea.';
COMMENT ON COLUMN public.sga_tarea_plan.id_accion IS 'Identificador único de la acción.';
COMMENT ON COLUMN public.sga_tarea_plan.id_espacio IS 'Identificador único del espacio.';
COMMENT ON COLUMN public.sga_tarea_plan.id_bien IS 'Identificador único del bien.';
COMMENT ON COLUMN public.sga_tarea_plan.id_periodicidad IS 'Identificador único de la periodicidad.';
COMMENT ON COLUMN public.sga_tarea_plan.fe_inicio IS 'Fecha de início de la planificación de la tarea.';
COMMENT ON COLUMN public.sga_tarea_plan.ds_detalle IS 'Detalles adicionales necesarios para la realización de la tarea.';
COMMENT ON COLUMN public.sga_tarea_plan.fe_horas IS 'Horarios de ejecución de las tareas.';
COMMENT ON COLUMN public.sga_tarea_plan.nu_personas IS 'Cantidad de personas necesarias para la realización de la tarea.';
COMMENT ON COLUMN public.sga_tarea_plan.tm_carga_horaria IS 'Tiempo estimado de ejecución de la acción.';
COMMENT ON COLUMN public.sga_tarea_plan.ds_referencia IS 'Referencia del registro.';


ALTER SEQUENCE public.sga_tarea_plan_sq OWNED BY public.sga_tarea_plan.id_tarea_plan;

ALTER TABLE public.sga_espacio ADD CONSTRAINT sga_sector_sga_espacio_fk
FOREIGN KEY (id_sector)
REFERENCES public.sga_sector (id_sector)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_accion ADD CONSTRAINT sga_sector_sga_accion_fk
FOREIGN KEY (id_sector)
REFERENCES public.sga_sector (id_sector)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_espacio ADD CONSTRAINT sga_planta_sga_espacio_fk
FOREIGN KEY (id_planta)
REFERENCES public.sga_planta (id_planta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_tipo_accion ADD CONSTRAINT sga_tipo_accion_tipo_accion_fk
FOREIGN KEY (id_tipo_accion_padre)
REFERENCES public.sga_tipo_accion (id_tipo_accion)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_accion ADD CONSTRAINT sga_tipo_accion_accion_fk
FOREIGN KEY (id_tipo_accion)
REFERENCES public.sga_tipo_accion (id_tipo_accion)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_metodologia ADD CONSTRAINT sga_origen_procedimiento_fk
FOREIGN KEY (id_origen)
REFERENCES public.sga_origen (id_origen)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_accion ADD CONSTRAINT sga_origen_actividad_fk
FOREIGN KEY (id_origen)
REFERENCES public.sga_origen (id_origen)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_accion ADD CONSTRAINT sga_procedimiento_actividad_fk
FOREIGN KEY (id_metodologia)
REFERENCES public.sga_metodologia (id_metodologia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_tarea_plan ADD CONSTRAINT sga_periodicidad_tarea_plan_fk
FOREIGN KEY (id_periodicidad)
REFERENCES public.sga_periodicidad (id_periodicidad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_accion ADD CONSTRAINT sga_periodicidad_sga_actividad_fk
FOREIGN KEY (id_periodicidad)
REFERENCES public.sga_periodicidad (id_periodicidad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_bien ADD CONSTRAINT sga_tipo_bien_bien_fk
FOREIGN KEY (id_tipo_bien)
REFERENCES public.sga_tipo_bien (id_tipo_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_tipo_bien ADD CONSTRAINT sga_tipo_bien_tipo_bien_fk
FOREIGN KEY (id_tipo_bien_padre)
REFERENCES public.sga_tipo_bien (id_tipo_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_accion ADD CONSTRAINT sga_tipo_bien_sga_accion_fk
FOREIGN KEY (id_tipo_bien)
REFERENCES public.sga_tipo_bien (id_tipo_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_espacio ADD CONSTRAINT sga_tipo_espacio_espacio_fk
FOREIGN KEY (id_tipo_espacio)
REFERENCES public.sga_tipo_espacio (id_tipo_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_accion ADD CONSTRAINT sga_tipo_espacio_sga_actividad_fk
FOREIGN KEY (id_tipo_espacio)
REFERENCES public.sga_tipo_espacio (id_tipo_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_tipo_espacio ADD CONSTRAINT sga_tipo_espacio_sga_tipo_espacio_fk
FOREIGN KEY (id_tipo_espacio_padre)
REFERENCES public.sga_tipo_espacio (id_tipo_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_tarea_plan ADD CONSTRAINT sga_actividad_tarea_plan_fk
FOREIGN KEY (id_accion)
REFERENCES public.sga_accion (id_accion)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_espacio ADD CONSTRAINT sga_espacio_espacio_fk
FOREIGN KEY (id_espacio_contenedor)
REFERENCES public.sga_espacio (id_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_bien ADD CONSTRAINT sga_espacio_bien_fk
FOREIGN KEY (id_espacio)
REFERENCES public.sga_espacio (id_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_tarea_plan ADD CONSTRAINT sga_espacio_sga_tarea_plan_fk
FOREIGN KEY (id_espacio)
REFERENCES public.sga_espacio (id_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.sga_tarea_plan ADD CONSTRAINT sga_bien_tarea_plan_fk
FOREIGN KEY (id_bien)
REFERENCES public.sga_bien (id_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
