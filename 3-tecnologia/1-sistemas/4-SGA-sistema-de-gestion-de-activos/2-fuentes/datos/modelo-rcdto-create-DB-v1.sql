
CREATE TABLE public.ods_origen_lectura (
                id_origen_lectura SMALLINT NOT NULL,
                co_origen_lectura CHAR(1) NOT NULL,
                no_origen_lectura VARCHAR(100) NOT NULL,
                CONSTRAINT ods_origen_lectura_pk PRIMARY KEY (id_origen_lectura)
);
COMMENT ON TABLE public.ods_origen_lectura IS 'Origen de las lecturas.';
COMMENT ON COLUMN public.ods_origen_lectura.id_origen_lectura IS 'Identificador único del origen de lectura.';
COMMENT ON COLUMN public.ods_origen_lectura.co_origen_lectura IS 'Código del origen de la lectura.';
COMMENT ON COLUMN public.ods_origen_lectura.no_origen_lectura IS 'Nombre del origen de la lectura.';


CREATE UNIQUE INDEX ods_origen_lectura_uk
 ON public.ods_origen_lectura
 ( co_origen_lectura );

CREATE SEQUENCE public.ods_lugar_sq;

CREATE TABLE public.ods_lugar (
                id_lugar INTEGER NOT NULL DEFAULT nextval('public.ods_lugar_sq'),
                co_lugar CHAR(1) NOT NULL,
                no_lugar VARCHAR(100) NOT NULL,
                ds_direccion VARCHAR(100),
                CONSTRAINT ods_lugar_pk PRIMARY KEY (id_lugar)
);
COMMENT ON TABLE public.ods_lugar IS 'Lugares donde fueron realizadas las lecturas.';
COMMENT ON COLUMN public.ods_lugar.id_lugar IS 'Identificador único de lugar de lectura.';
COMMENT ON COLUMN public.ods_lugar.co_lugar IS 'Código de ifentificación única del lugar.';
COMMENT ON COLUMN public.ods_lugar.no_lugar IS 'Nombre del lugar de lectura.';
COMMENT ON COLUMN public.ods_lugar.ds_direccion IS 'Dirección del lugar.';


ALTER SEQUENCE public.ods_lugar_sq OWNED BY public.ods_lugar.id_lugar;

CREATE UNIQUE INDEX ods_lugar_uk
 ON public.ods_lugar
 ( co_lugar );

CREATE SEQUENCE public.ods_tipo_insumo_sq;

CREATE TABLE public.ods_tipo_insumo (
                id_tipo_insumo INTEGER NOT NULL DEFAULT nextval('public.ods_tipo_insumo_sq'),
                no_tipo_insumo VARCHAR(100) NOT NULL,
                CONSTRAINT ods_tipo_insumo_pk PRIMARY KEY (id_tipo_insumo)
);
COMMENT ON TABLE public.ods_tipo_insumo IS 'Tipo de insumo.';
COMMENT ON COLUMN public.ods_tipo_insumo.id_tipo_insumo IS 'Identificador único del tipo de insumo.';
COMMENT ON COLUMN public.ods_tipo_insumo.no_tipo_insumo IS 'Nombre del tipo de insumo.';


ALTER SEQUENCE public.ods_tipo_insumo_sq OWNED BY public.ods_tipo_insumo.id_tipo_insumo;

CREATE SEQUENCE public.ods_origen_sq;

CREATE TABLE public.ods_origen (
                id_origen INTEGER NOT NULL DEFAULT nextval('public.ods_origen_sq'),
                no_origen VARCHAR(100) NOT NULL,
                CONSTRAINT ods_origen_pk PRIMARY KEY (id_origen)
);
COMMENT ON TABLE public.ods_origen IS 'Origen de la especificación de la actividad/procedimiento.';
COMMENT ON COLUMN public.ods_origen.id_origen IS 'Identificador único de origen.';
COMMENT ON COLUMN public.ods_origen.no_origen IS 'Nombre del origen de la actividad/procedimiento.';


ALTER SEQUENCE public.ods_origen_sq OWNED BY public.ods_origen.id_origen;

CREATE SEQUENCE public.ods_insumo_sq;

CREATE TABLE public.ods_insumo (
                id_insumo INTEGER NOT NULL DEFAULT nextval('public.ods_insumo_sq'),
                no_insumo VARCHAR(100) NOT NULL,
                id_tipo_insumo INTEGER NOT NULL,
                CONSTRAINT ods_insumo_pk PRIMARY KEY (id_insumo)
);
COMMENT ON TABLE public.ods_insumo IS 'Insumos necesarios para realizar la tarea.';
COMMENT ON COLUMN public.ods_insumo.id_insumo IS 'Identificador único del insumo.';
COMMENT ON COLUMN public.ods_insumo.no_insumo IS 'Nombre del insumo.';
COMMENT ON COLUMN public.ods_insumo.id_tipo_insumo IS 'Identificador único del tipo de insumo.';


ALTER SEQUENCE public.ods_insumo_sq OWNED BY public.ods_insumo.id_insumo;

CREATE SEQUENCE public.ods_procedimiento_sq;

CREATE TABLE public.ods_procedimiento (
                id_procedimiento INTEGER NOT NULL DEFAULT nextval('public.ods_procedimiento_sq'),
                no_procedimiento VARCHAR(100) NOT NULL,
                ds_procedimiento VARCHAR(4000),
                id_origen INTEGER,
                CONSTRAINT ods_procedimiento_pk PRIMARY KEY (id_procedimiento)
);
COMMENT ON TABLE public.ods_procedimiento IS 'Procedimiento de realización de la actividad.';
COMMENT ON COLUMN public.ods_procedimiento.id_procedimiento IS 'Identificador único de procedimiento.';
COMMENT ON COLUMN public.ods_procedimiento.no_procedimiento IS 'Nombre del procedimiento.';
COMMENT ON COLUMN public.ods_procedimiento.ds_procedimiento IS 'Descripción del procedimiento.';
COMMENT ON COLUMN public.ods_procedimiento.id_origen IS 'Identificador único de origen.';


ALTER SEQUENCE public.ods_procedimiento_sq OWNED BY public.ods_procedimiento.id_procedimiento;

CREATE SEQUENCE public.ods_periodicidad_sq;

CREATE TABLE public.ods_periodicidad (
                id_periodicidad INTEGER NOT NULL DEFAULT nextval('public.ods_periodicidad_sq'),
                no_periodicidad VARCHAR(100) NOT NULL,
                CONSTRAINT ods_periodicidad_pk PRIMARY KEY (id_periodicidad)
);
COMMENT ON TABLE public.ods_periodicidad IS 'Periodicidad de realización de una tarea.';
COMMENT ON COLUMN public.ods_periodicidad.id_periodicidad IS 'Identificador único de la periodicidad.';
COMMENT ON COLUMN public.ods_periodicidad.no_periodicidad IS 'Nombre de la periodicidad.';


ALTER SEQUENCE public.ods_periodicidad_sq OWNED BY public.ods_periodicidad.id_periodicidad;

CREATE SEQUENCE public.ods_actividad_sq;

CREATE TABLE public.ods_actividad (
                id_actividad INTEGER NOT NULL DEFAULT nextval('public.ods_actividad_sq'),
                no_actividad VARCHAR(100) NOT NULL,
                id_procedimiento INTEGER NOT NULL,
                id_origen INTEGER NOT NULL,
                id_actividad_padre INTEGER,
                CONSTRAINT ods_actividad_pk PRIMARY KEY (id_actividad)
);
COMMENT ON TABLE public.ods_actividad IS 'Actividades a realizar sobre los bienes.';
COMMENT ON COLUMN public.ods_actividad.id_actividad IS 'Identificador único de la actividad.';
COMMENT ON COLUMN public.ods_actividad.no_actividad IS 'Nombre de la actividad a realizar sobre el bien.';
COMMENT ON COLUMN public.ods_actividad.id_procedimiento IS 'Identificador único de procedimiento.';
COMMENT ON COLUMN public.ods_actividad.id_origen IS 'Identificador único de origen.';
COMMENT ON COLUMN public.ods_actividad.id_actividad_padre IS 'Identificador único de la actividad contenedora.';


ALTER SEQUENCE public.ods_actividad_sq OWNED BY public.ods_actividad.id_actividad;

CREATE TABLE public.ods_requiere (
                id_actividad INTEGER NOT NULL,
                id_insumo INTEGER NOT NULL,
                CONSTRAINT ods_requiere_pk PRIMARY KEY (id_actividad, id_insumo)
);
COMMENT ON TABLE public.ods_requiere IS 'Insumos requeridos para la realización de una actividad.';
COMMENT ON COLUMN public.ods_requiere.id_actividad IS 'Identificador único de la actividad.';
COMMENT ON COLUMN public.ods_requiere.id_insumo IS 'Identificador único del insumo.';


CREATE SEQUENCE public.ods_tipo_bien_sq;

CREATE TABLE public.ods_tipo_bien (
                id_tipo_bien INTEGER NOT NULL DEFAULT nextval('public.ods_tipo_bien_sq'),
                no_tipo_bien VARCHAR(100) NOT NULL,
                id_tipo_bien_padre INTEGER,
                CONSTRAINT ods_tipo_bien_pk PRIMARY KEY (id_tipo_bien)
);
COMMENT ON TABLE public.ods_tipo_bien IS 'Tipo de bien.';
COMMENT ON COLUMN public.ods_tipo_bien.id_tipo_bien IS 'Identificador único del tipo de bien.';
COMMENT ON COLUMN public.ods_tipo_bien.no_tipo_bien IS 'Nombre del tipo de bien.';
COMMENT ON COLUMN public.ods_tipo_bien.id_tipo_bien_padre IS 'Identificador único del tipo de bien padre (supertipo).';


ALTER SEQUENCE public.ods_tipo_bien_sq OWNED BY public.ods_tipo_bien.id_tipo_bien;

CREATE TABLE public.ods_ejecuta (
                id_tipo_bien INTEGER NOT NULL,
                id_actividad INTEGER NOT NULL,
                CONSTRAINT ods_ejecuta_pk PRIMARY KEY (id_tipo_bien, id_actividad)
);
COMMENT ON TABLE public.ods_ejecuta IS 'Actividades que pueden ser realizadas sobre el tipo de bien.';
COMMENT ON COLUMN public.ods_ejecuta.id_tipo_bien IS 'Identificador único del tipo de bien.';
COMMENT ON COLUMN public.ods_ejecuta.id_actividad IS 'Identificador único de la actividad.';


CREATE SEQUENCE public.ods_empresa_sq;

CREATE TABLE public.ods_empresa (
                id_empresa INTEGER NOT NULL DEFAULT nextval('public.ods_empresa_sq'),
                no_empresa VARCHAR(100) NOT NULL,
                CONSTRAINT ods_empresa_pk PRIMARY KEY (id_empresa)
);
COMMENT ON TABLE public.ods_empresa IS 'Empresas que trabajan en el centro cultural.';
COMMENT ON COLUMN public.ods_empresa.id_empresa IS 'Identificador único de Empresa.';
COMMENT ON COLUMN public.ods_empresa.no_empresa IS 'Nombre de la Empresa.';


ALTER SEQUENCE public.ods_empresa_sq OWNED BY public.ods_empresa.id_empresa;

CREATE UNIQUE INDEX ods_empresa_uk
 ON public.ods_empresa
 ( no_empresa );

CREATE SEQUENCE public.ods_tipo_persona_sq;

CREATE TABLE public.ods_tipo_persona (
                id_tipo_persona INTEGER NOT NULL DEFAULT nextval('public.ods_tipo_persona_sq'),
                no_tipo_persona VARCHAR(100) NOT NULL,
                CONSTRAINT ods_tipo_persona_pk PRIMARY KEY (id_tipo_persona)
);
COMMENT ON TABLE public.ods_tipo_persona IS 'Tipos de personas.';
COMMENT ON COLUMN public.ods_tipo_persona.id_tipo_persona IS 'Identificador único del tipo de persona.';
COMMENT ON COLUMN public.ods_tipo_persona.no_tipo_persona IS 'Nombre del tipo de persona.';


ALTER SEQUENCE public.ods_tipo_persona_sq OWNED BY public.ods_tipo_persona.id_tipo_persona;

CREATE UNIQUE INDEX ods_tipo_persona_uk
 ON public.ods_tipo_persona
 ( no_tipo_persona );

CREATE SEQUENCE public.ods_area_sq;

CREATE TABLE public.ods_area (
                id_area INTEGER NOT NULL DEFAULT nextval('public.ods_area_sq'),
                no_area VARCHAR(100) NOT NULL,
                id_area_padre INTEGER,
                CONSTRAINT ods_area_pk PRIMARY KEY (id_area)
);
COMMENT ON TABLE public.ods_area IS 'Áreas dentro del centro cultural.';
COMMENT ON COLUMN public.ods_area.id_area IS 'Identificador único de Área.';
COMMENT ON COLUMN public.ods_area.no_area IS 'Nombre de Área.';
COMMENT ON COLUMN public.ods_area.id_area_padre IS 'Identificador único de Área Padre.';


ALTER SEQUENCE public.ods_area_sq OWNED BY public.ods_area.id_area;

CREATE UNIQUE INDEX ods_area_uk
 ON public.ods_area
 ( no_area );

CREATE SEQUENCE public.ods_persona_sq;

CREATE TABLE public.ods_persona (
                id_persona INTEGER NOT NULL DEFAULT nextval('public.ods_persona_sq'),
                id_tipo_persona INTEGER NOT NULL,
                co_dni_cuit VARCHAR(20) NOT NULL,
                co_legajo VARCHAR(20),
                no_persona VARCHAR(100) NOT NULL,
                id_empresa INTEGER,
                id_area INTEGER,
                CONSTRAINT ods_persona_pk PRIMARY KEY (id_persona)
);
COMMENT ON TABLE public.ods_persona IS 'Personas que trabajan en el CCK.';
COMMENT ON COLUMN public.ods_persona.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.ods_persona.id_tipo_persona IS 'Identificador único del tipo de persona.';
COMMENT ON COLUMN public.ods_persona.co_dni_cuit IS 'Número de DNI o CUIT de la persona.';
COMMENT ON COLUMN public.ods_persona.co_legajo IS 'Legajo de la persona.';
COMMENT ON COLUMN public.ods_persona.no_persona IS 'Nombre de la persona.';
COMMENT ON COLUMN public.ods_persona.id_empresa IS 'Identificador único de Empresa o Área.';
COMMENT ON COLUMN public.ods_persona.id_area IS 'Identificador único de Área.';


ALTER SEQUENCE public.ods_persona_sq OWNED BY public.ods_persona.id_persona;

CREATE INDEX ods_persona_ix
 ON public.ods_persona
 ( co_dni_cuit, co_legajo );

CREATE UNIQUE INDEX ods_persona_uk
 ON public.ods_persona
 ( co_dni_cuit, co_legajo );

CREATE SEQUENCE public.ods_lectura_sq;

CREATE TABLE public.ods_lectura (
                id_lectura BIGINT NOT NULL DEFAULT nextval('public.ods_lectura_sq'),
                id_persona INTEGER NOT NULL,
                id_lugar INTEGER NOT NULL,
                id_origen_lectura SMALLINT NOT NULL,
                fe_fecha_lectura TIMESTAMP NOT NULL,
                no_usuario VARCHAR(10),
                ds_usuario VARCHAR(50),
                co_lector INTEGER,
                ds_observaciones VARCHAR(400) DEFAULT NULL::character varying,
                id_carga BIGINT DEFAULT 0 NOT NULL,
                CONSTRAINT ods_lectura_pk PRIMARY KEY (id_lectura)
);
COMMENT ON TABLE public.ods_lectura IS 'Lecturas de ingreso y egreso de las personas en el centro cultural.';
COMMENT ON COLUMN public.ods_lectura.id_lectura IS 'Identificador único de la lectura.';
COMMENT ON COLUMN public.ods_lectura.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.ods_lectura.id_lugar IS 'Identificador único de lugar de lectura.';
COMMENT ON COLUMN public.ods_lectura.id_origen_lectura IS 'Identificador único del origen de lectura.';
COMMENT ON COLUMN public.ods_lectura.fe_fecha_lectura IS 'Fecha y Hora de la lectura.';
COMMENT ON COLUMN public.ods_lectura.no_usuario IS 'Usuário de la lectura.';
COMMENT ON COLUMN public.ods_lectura.ds_usuario IS 'Descripción de usuário de la lectura.';
COMMENT ON COLUMN public.ods_lectura.co_lector IS 'Código de lector.';
COMMENT ON COLUMN public.ods_lectura.ds_observaciones IS 'Observaciones de la lectura.';
COMMENT ON COLUMN public.ods_lectura.id_carga IS 'Identicifador de la carga.';


ALTER SEQUENCE public.ods_lectura_sq OWNED BY public.ods_lectura.id_lectura;

CREATE UNIQUE INDEX ods_lectura_uk
 ON public.ods_lectura
 ( id_persona, fe_fecha_lectura );

CREATE INDEX ods_lectura_ix
 ON public.ods_lectura
 ( fe_fecha_lectura, id_lugar );

CREATE SEQUENCE public.ods_tipo_espacio_sq;

CREATE TABLE public.ods_tipo_espacio (
                id_tipo_espacio SMALLINT NOT NULL DEFAULT nextval('public.ods_tipo_espacio_sq'),
                no_tipo_espacio VARCHAR(100) NOT NULL,
                CONSTRAINT ods_tipo_espacio_pk PRIMARY KEY (id_tipo_espacio)
);
COMMENT ON TABLE public.ods_tipo_espacio IS 'Tipo de espacio físico dentro del centro cultural.';
COMMENT ON COLUMN public.ods_tipo_espacio.id_tipo_espacio IS 'Identificador único del tipo de espacio.';
COMMENT ON COLUMN public.ods_tipo_espacio.no_tipo_espacio IS 'Nombre del tipo de espacio.';


ALTER SEQUENCE public.ods_tipo_espacio_sq OWNED BY public.ods_tipo_espacio.id_tipo_espacio;

CREATE SEQUENCE public.ods_espacio_sq;

CREATE TABLE public.ods_espacio (
                id_espacio INTEGER NOT NULL DEFAULT nextval('public.ods_espacio_sq'),
                id_tipo_espacio SMALLINT NOT NULL,
                id_espacio_contenedor INTEGER,
                co_espacio VARCHAR(5) NOT NULL,
                no_espacio VARCHAR(100) NOT NULL,
                nu_planta SMALLINT,
                co_plano VARCHAR(50),
                CONSTRAINT ods_espacio_pk PRIMARY KEY (id_espacio)
);
COMMENT ON TABLE public.ods_espacio IS 'Espacios físicos dentro del centro cultural.';
COMMENT ON COLUMN public.ods_espacio.id_espacio IS 'Identificador único del espacio.';
COMMENT ON COLUMN public.ods_espacio.id_tipo_espacio IS 'Identificador único del tipo de espacio.';
COMMENT ON COLUMN public.ods_espacio.id_espacio_contenedor IS 'Identificador único del espacio contenedor (padre).';
COMMENT ON COLUMN public.ods_espacio.co_espacio IS 'Código de espacio.';
COMMENT ON COLUMN public.ods_espacio.no_espacio IS 'Nombre del espacio.';
COMMENT ON COLUMN public.ods_espacio.nu_planta IS 'Número de planta.';
COMMENT ON COLUMN public.ods_espacio.co_plano IS 'Codificación del espacio en los planos de Espacio Físico.';


ALTER SEQUENCE public.ods_espacio_sq OWNED BY public.ods_espacio.id_espacio;

CREATE SEQUENCE public.ods_bien_sq;

CREATE TABLE public.ods_bien (
                id_bien INTEGER NOT NULL DEFAULT nextval('public.ods_bien_sq'),
                id_tipo_bien INTEGER NOT NULL,
                id_espacio INTEGER NOT NULL,
                ds_observacion VARCHAR(400),
                CONSTRAINT ods_bien_pk PRIMARY KEY (id_bien)
);
COMMENT ON TABLE public.ods_bien IS 'Bienes del centro cultural.';
COMMENT ON COLUMN public.ods_bien.id_bien IS 'Identificador único del bien.';
COMMENT ON COLUMN public.ods_bien.id_tipo_bien IS 'Identificador único del tipo de bien.';
COMMENT ON COLUMN public.ods_bien.id_espacio IS 'Identificador único del espacio.';
COMMENT ON COLUMN public.ods_bien.ds_observacion IS 'Observaciones del bien.';


ALTER SEQUENCE public.ods_bien_sq OWNED BY public.ods_bien.id_bien;

CREATE SEQUENCE public.ods_tarea_plan_sq;

CREATE TABLE public.ods_tarea_plan (
                id_tarea_plan INTEGER NOT NULL DEFAULT nextval('public.ods_tarea_plan_sq'),
                id_periodicidad INTEGER,
                id_bien INTEGER,
                id_actividad INTEGER NOT NULL,
                ds_insumos VARCHAR(4000),
                CONSTRAINT ods_tarea_plan_pk PRIMARY KEY (id_tarea_plan)
);
COMMENT ON TABLE public.ods_tarea_plan IS 'Planificación de tareas a realizar sobre el bien.';
COMMENT ON COLUMN public.ods_tarea_plan.id_tarea_plan IS 'Identificador único de la planificación de la tarea.';
COMMENT ON COLUMN public.ods_tarea_plan.id_periodicidad IS 'Identificador único de la periodicidad.';
COMMENT ON COLUMN public.ods_tarea_plan.id_bien IS 'Identificador único del bien.';
COMMENT ON COLUMN public.ods_tarea_plan.id_actividad IS 'Identificador único de la actividad.';
COMMENT ON COLUMN public.ods_tarea_plan.ds_insumos IS 'Detalle de insumos necesarios para la realización de la tarea.';


ALTER SEQUENCE public.ods_tarea_plan_sq OWNED BY public.ods_tarea_plan.id_tarea_plan;

CREATE SEQUENCE public.ods_tarea_sq;

CREATE TABLE public.ods_tarea (
                id_tarea INTEGER NOT NULL DEFAULT nextval('public.ods_tarea_sq'),
                id_tarea_plan INTEGER NOT NULL,
                fe_ejecucion TIMESTAMP,
                fl_realizada BOOLEAN DEFAULT true,
                ds_observaciones VARCHAR(4000),
                CONSTRAINT ods_tarea_pk PRIMARY KEY (id_tarea)
);
COMMENT ON TABLE public.ods_tarea IS 'Tarea ejecutada sobre el bien.';
COMMENT ON COLUMN public.ods_tarea.id_tarea IS 'Identificador único de la tarea.';
COMMENT ON COLUMN public.ods_tarea.id_tarea_plan IS 'Identificador único de la planificación de la tarea.';
COMMENT ON COLUMN public.ods_tarea.fe_ejecucion IS 'Fecha y hora de ejecución de la tarea.';
COMMENT ON COLUMN public.ods_tarea.fl_realizada IS 'Define si la tarea fue realizada o no.';
COMMENT ON COLUMN public.ods_tarea.ds_observaciones IS 'Observaciones de la realización de la tarea.';


ALTER SEQUENCE public.ods_tarea_sq OWNED BY public.ods_tarea.id_tarea;

CREATE TABLE public.ods_realiza (
                id_persona INTEGER NOT NULL,
                id_tarea INTEGER NOT NULL,
                CONSTRAINT ods_realiza_pk PRIMARY KEY (id_persona, id_tarea)
);
COMMENT ON TABLE public.ods_realiza IS 'Persona que realiza la tarea.';
COMMENT ON COLUMN public.ods_realiza.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.ods_realiza.id_tarea IS 'Identificador único de la tarea.';


CREATE TABLE public.ods_ocupa (
                id_espacio INTEGER NOT NULL,
                id_area INTEGER NOT NULL,
                CONSTRAINT ods_ocupa_pk PRIMARY KEY (id_espacio, id_area)
);
COMMENT ON TABLE public.ods_ocupa IS 'Espacio ocupado por un área del centro cultural.';
COMMENT ON COLUMN public.ods_ocupa.id_espacio IS 'Identificador único de espacios.';
COMMENT ON COLUMN public.ods_ocupa.id_area IS 'Identificador único de Área.';


ALTER TABLE public.ods_lectura ADD CONSTRAINT ods_origen_lectura_lectura_fk
FOREIGN KEY (id_origen_lectura)
REFERENCES public.ods_origen_lectura (id_origen_lectura)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_lectura ADD CONSTRAINT ods_lugar_lectura_fk
FOREIGN KEY (id_lugar)
REFERENCES public.ods_lugar (id_lugar)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_insumo ADD CONSTRAINT ods_tipo_insumo_insumo_fk
FOREIGN KEY (id_tipo_insumo)
REFERENCES public.ods_tipo_insumo (id_tipo_insumo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_procedimiento ADD CONSTRAINT ods_origen_procedimiento_fk
FOREIGN KEY (id_origen)
REFERENCES public.ods_origen (id_origen)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_actividad ADD CONSTRAINT ods_origen_actividad_fk
FOREIGN KEY (id_origen)
REFERENCES public.ods_origen (id_origen)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_requiere ADD CONSTRAINT ods_insumo_requiere_fk
FOREIGN KEY (id_insumo)
REFERENCES public.ods_insumo (id_insumo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_actividad ADD CONSTRAINT ods_procedimiento_actividad_fk
FOREIGN KEY (id_procedimiento)
REFERENCES public.ods_procedimiento (id_procedimiento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_tarea_plan ADD CONSTRAINT ods_periodicidad_tarea_plan_fk
FOREIGN KEY (id_periodicidad)
REFERENCES public.ods_periodicidad (id_periodicidad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_actividad ADD CONSTRAINT ods_actividad_actividad_fk
FOREIGN KEY (id_actividad_padre)
REFERENCES public.ods_actividad (id_actividad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_tarea_plan ADD CONSTRAINT ods_actividad_tarea_plan_fk
FOREIGN KEY (id_actividad)
REFERENCES public.ods_actividad (id_actividad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_ejecuta ADD CONSTRAINT ods_actividad_ejecuta_fk
FOREIGN KEY (id_actividad)
REFERENCES public.ods_actividad (id_actividad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_requiere ADD CONSTRAINT ods_actividad_requiere_fk
FOREIGN KEY (id_actividad)
REFERENCES public.ods_actividad (id_actividad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_bien ADD CONSTRAINT ods_tipo_bien_bien_fk
FOREIGN KEY (id_tipo_bien)
REFERENCES public.ods_tipo_bien (id_tipo_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_tipo_bien ADD CONSTRAINT ods_tipo_bien_tipo_bien_fk
FOREIGN KEY (id_tipo_bien_padre)
REFERENCES public.ods_tipo_bien (id_tipo_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_ejecuta ADD CONSTRAINT ods_tipo_bien_ejecuta_fk
FOREIGN KEY (id_tipo_bien)
REFERENCES public.ods_tipo_bien (id_tipo_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_persona ADD CONSTRAINT ods_empresa_persona_fk
FOREIGN KEY (id_empresa)
REFERENCES public.ods_empresa (id_empresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_persona ADD CONSTRAINT ods_tipo_persona_persona_fk
FOREIGN KEY (id_tipo_persona)
REFERENCES public.ods_tipo_persona (id_tipo_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_persona ADD CONSTRAINT ods_area_persona_fk
FOREIGN KEY (id_area)
REFERENCES public.ods_area (id_area)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_ocupa ADD CONSTRAINT ods_area_ocupa_fk
FOREIGN KEY (id_area)
REFERENCES public.ods_area (id_area)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_area ADD CONSTRAINT ods_area_area_fk
FOREIGN KEY (id_area_padre)
REFERENCES public.ods_area (id_area)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_lectura ADD CONSTRAINT ods_persona_lectura_fk
FOREIGN KEY (id_persona)
REFERENCES public.ods_persona (id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_realiza ADD CONSTRAINT ods_persona_realiza_fk
FOREIGN KEY (id_persona)
REFERENCES public.ods_persona (id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_espacio ADD CONSTRAINT ods_tipo_espacio_espacio_fk
FOREIGN KEY (id_tipo_espacio)
REFERENCES public.ods_tipo_espacio (id_tipo_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_ocupa ADD CONSTRAINT ods_espacio_ocupa_fk
FOREIGN KEY (id_espacio)
REFERENCES public.ods_espacio (id_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_espacio ADD CONSTRAINT ods_espacio_espacio_fk
FOREIGN KEY (id_espacio_contenedor)
REFERENCES public.ods_espacio (id_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_bien ADD CONSTRAINT ods_espacio_bien_fk
FOREIGN KEY (id_espacio)
REFERENCES public.ods_espacio (id_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_tarea_plan ADD CONSTRAINT ods_bien_tarea_plan_fk
FOREIGN KEY (id_bien)
REFERENCES public.ods_bien (id_bien)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_tarea ADD CONSTRAINT ods_tarea_plan_tarea_fk
FOREIGN KEY (id_tarea_plan)
REFERENCES public.ods_tarea_plan (id_tarea_plan)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ods_realiza ADD CONSTRAINT ods_tarea_realiza_fk
FOREIGN KEY (id_tarea)
REFERENCES public.ods_tarea (id_tarea)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
