
CREATE SEQUENCE public.ods_persona_sq;

CREATE TABLE public.ods_persona (
                id_persona INTEGER NOT NULL DEFAULT nextval('public.ods_persona_sq'),
                co_dni_cuit VARCHAR(20) NOT NULL,
                co_legajo VARCHAR(20),
                no_persona VARCHAR(100) NOT NULL,
                no_direccion VARCHAR(100),
                no_dependencia VARCHAR(100),
                no_sector VARCHAR(100),
                no_area VARCHAR(100),
                no_puesto VARCHAR(100),
                no_tarea VARCHAR(100),
                CONSTRAINT ods_persona_pk PRIMARY KEY (id_persona)
);
COMMENT ON TABLE public.ods_persona IS 'Personas que trabajan en el CCK.';
COMMENT ON COLUMN public.ods_persona.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.ods_persona.co_dni_cuit IS 'Número de DNI o CUIT de la persona.';
COMMENT ON COLUMN public.ods_persona.co_legajo IS 'Legajo de la persona.';
COMMENT ON COLUMN public.ods_persona.no_persona IS 'Nombre de la persona.';
COMMENT ON COLUMN public.ods_persona.no_direccion IS 'Dirección en la que trabaja la persona.';
COMMENT ON COLUMN public.ods_persona.no_dependencia IS 'Dependencia en la que trabaja la persona.';
COMMENT ON COLUMN public.ods_persona.no_sector IS 'Sector en que trabaja la persona.';
COMMENT ON COLUMN public.ods_persona.no_area IS 'Área dentro del sector.';
COMMENT ON COLUMN public.ods_persona.no_puesto IS 'Puesto dentro del área.';
COMMENT ON COLUMN public.ods_persona.no_tarea IS 'Tarea dentro del área.';


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
                id_persona INTEGER,
                fe_fecha_lectura TIMESTAMP,
                co_lugar CHAR(1) DEFAULT 'C',
                co_origen CHAR(1) DEFAULT 'M',
                no_tipo_acreditacion VARCHAR(100) NOT NULL,
                no_empresa_area VARCHAR(100),
                no_usuario VARCHAR(10),
                ds_usuario VARCHAR(50),
                co_lector INTEGER,
                ds_observaciones VARCHAR(400) DEFAULT NULL::character varying,
                id_carga BIGINT DEFAULT 0,
                fe_creacion TIMESTAMP DEFAULT now() NOT NULL,
                fe_carga TIMESTAMP,
                CONSTRAINT ods_lectura_pk PRIMARY KEY (id_lectura)
);
COMMENT ON TABLE public.ods_lectura IS 'Lecturas de ingreso y egreso de las personas en el centro cultural.';
COMMENT ON COLUMN public.ods_lectura.id_lectura IS 'Identificador único de la lectura.';
COMMENT ON COLUMN public.ods_lectura.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.ods_lectura.fe_fecha_lectura IS 'Fecha y Hora de la lectura.';
COMMENT ON COLUMN public.ods_lectura.co_lugar IS 'Código de lugar.';
COMMENT ON COLUMN public.ods_lectura.co_origen IS 'Código de origen de lectura.';
COMMENT ON COLUMN public.ods_lectura.no_tipo_acreditacion IS 'Nombre del tipo de acreditación.';
COMMENT ON COLUMN public.ods_lectura.no_empresa_area IS 'Nombre de la Empresa o Área de la lectura.';
COMMENT ON COLUMN public.ods_lectura.no_usuario IS 'Usuário de la lectura.';
COMMENT ON COLUMN public.ods_lectura.ds_usuario IS 'Descripción de usuário de la lectura.';
COMMENT ON COLUMN public.ods_lectura.co_lector IS 'Código de lector.';
COMMENT ON COLUMN public.ods_lectura.ds_observaciones IS 'Observaciones de la lectura.';
COMMENT ON COLUMN public.ods_lectura.id_carga IS 'Identicifador de la carga.';
COMMENT ON COLUMN public.ods_lectura.fe_creacion IS 'Fecha de Creación del registro.';
COMMENT ON COLUMN public.ods_lectura.fe_carga IS 'Fecha de carga del registro en el DW.';


ALTER SEQUENCE public.ods_lectura_sq OWNED BY public.ods_lectura.id_lectura;

CREATE INDEX ods_lectura_ix
 ON public.ods_lectura
 ( id_persona, fe_fecha_lectura, id_carga );

ALTER TABLE public.ods_lectura ADD CONSTRAINT ods_persona_lectura_fk
FOREIGN KEY (id_persona)
REFERENCES public.ods_persona (id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
