
CREATE SEQUENCE public.stg_limpieza_banios_seq;

CREATE TABLE public.stg_limpieza_banios (
                id_limpieza_banios BIGINT NOT NULL DEFAULT nextval('public.stg_limpieza_banios_seq'),
                no_archivo VARCHAR(100),
                fe_modif TIMESTAMP,
                fe_carga TIMESTAMP DEFAULT now() NOT NULL,
                no_hoja VARCHAR(250),
                nu_fila BIGINT,
                co_estado_proceso CHAR(1) DEFAULT 'C'::bpchar NOT NULL,
                tx_fecha TEXT,
                tx_espacio TEXT,
                tx_gestion TEXT,
                tx_estado TEXT,
                tx_observacion TEXT,
                tx_turno TEXT,
                tx_supervisor TEXT,
                tx_hora TEXT,
                CONSTRAINT stg_limpieza_banios_pk PRIMARY KEY (id_limpieza_banios)
);
COMMENT ON TABLE public.stg_limpieza_banios IS 'Tabla de Stage de control de limpieza de los baños.';
COMMENT ON COLUMN public.stg_limpieza_banios.id_limpieza_banios IS 'Identificador único de tabla stage de limpieza de baños.';
COMMENT ON COLUMN public.stg_limpieza_banios.no_archivo IS 'Nombre del archivo excel cargado.';
COMMENT ON COLUMN public.stg_limpieza_banios.fe_modif IS 'Fecha de última modificación de la planilla Excel.';
COMMENT ON COLUMN public.stg_limpieza_banios.fe_carga IS 'Fecha de carga de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.no_hoja IS 'Nombre de la hoja de Excel cargada.';
COMMENT ON COLUMN public.stg_limpieza_banios.nu_fila IS 'Número de fila dentro de la planilla Excel.';
COMMENT ON COLUMN public.stg_limpieza_banios.co_estado_proceso IS 'Código del estado del registro, identifica si se encuentra cargado o no.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_fecha IS 'Valor de la columna FECHA de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_espacio IS 'Valor de la columna CODIGO ESPACIO / DESCRIPCION de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_gestion IS 'Valor de la columna GESTION de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_estado IS 'Valor de la columna ESTADO de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_observacion IS 'Valor de la columna OBSERVACIONES de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_turno IS 'Valor de la columna TURNO de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_supervisor IS 'Valor de la columna SUPERVISOR de la planilla.';
COMMENT ON COLUMN public.stg_limpieza_banios.tx_hora IS 'Valor de la columna HORARIO de la planilla.';


ALTER SEQUENCE public.stg_limpieza_banios_seq OWNED BY public.stg_limpieza_banios.id_limpieza_banios;

CREATE SEQUENCE public.dim_espacio_limpieza_seq;

CREATE TABLE public.dim_espacio_limpieza (
                id_espacio_limpieza INTEGER NOT NULL DEFAULT nextval('public.dim_espacio_limpieza_seq'),
                no_espacio_limpieza VARCHAR(100),
                CONSTRAINT dim_espacio_limpieza_pk PRIMARY KEY (id_espacio_limpieza)
);
COMMENT ON TABLE public.dim_espacio_limpieza IS 'Dimensión de espacios limpiados.';
COMMENT ON COLUMN public.dim_espacio_limpieza.id_espacio_limpieza IS 'Identificador único del espacio limpiado.';
COMMENT ON COLUMN public.dim_espacio_limpieza.no_espacio_limpieza IS 'Nombre del espacio limpiado.';


ALTER SEQUENCE public.dim_espacio_limpieza_seq OWNED BY public.dim_espacio_limpieza.id_espacio_limpieza;

CREATE SEQUENCE public.dim_estado_limpieza_seq;

CREATE TABLE public.dim_estado_limpieza (
                id_estado_limpieza INTEGER NOT NULL DEFAULT nextval('public.dim_estado_limpieza_seq'),
                no_estado_limpieza VARCHAR(100),
                no_estado_insumos VARCHAR(100),
                CONSTRAINT dim_estado_limpieza_pk PRIMARY KEY (id_estado_limpieza)
);
COMMENT ON TABLE public.dim_estado_limpieza IS 'Dimensión de estados de limpieza.';
COMMENT ON COLUMN public.dim_estado_limpieza.id_estado_limpieza IS 'Identificador único del estado de la limpieza.';
COMMENT ON COLUMN public.dim_estado_limpieza.no_estado_limpieza IS 'Nombre del estado de limpieza.';
COMMENT ON COLUMN public.dim_estado_limpieza.no_estado_insumos IS 'Estado de insumos.';


ALTER SEQUENCE public.dim_estado_limpieza_seq OWNED BY public.dim_estado_limpieza.id_estado_limpieza;

CREATE SEQUENCE public.dim_supervisor_seq;

CREATE TABLE public.dim_supervisor (
                id_supervisor INTEGER NOT NULL DEFAULT nextval('public.dim_supervisor_seq'),
                no_supervisor VARCHAR(100) NOT NULL,
                CONSTRAINT dim_supervisor_pk PRIMARY KEY (id_supervisor)
);
COMMENT ON TABLE public.dim_supervisor IS 'Dimensión de supervisores de limpieza.';
COMMENT ON COLUMN public.dim_supervisor.id_supervisor IS 'Identificador único del Supervisor.';
COMMENT ON COLUMN public.dim_supervisor.no_supervisor IS 'Nombre del supervisor de limpieza.';


ALTER SEQUENCE public.dim_supervisor_seq OWNED BY public.dim_supervisor.id_supervisor;

CREATE TABLE public.fac_limpieza_banios (
                id_limpieza_banios BIGINT NOT NULL,
                id_fecha BIGINT NOT NULL,
                id_espacio_limpieza INTEGER NOT NULL,
                id_estado_limpieza INTEGER,
                id_turno SMALLINT,
                id_supervisor INTEGER,
                nu_hora BIGINT NOT NULL,
                fl_gestion VARCHAR(2),
                ds_observaciones VARCHAR(400),
                nu_lecturas INTEGER DEFAULT 1 NOT NULL,
                CONSTRAINT fac_limpieza_banios_pk PRIMARY KEY (id_limpieza_banios)
);
COMMENT ON TABLE public.fac_limpieza_banios IS 'Tabla de hecho de limpiezas hechas en los baños.';
COMMENT ON COLUMN public.fac_limpieza_banios.id_limpieza_banios IS 'Identificador único de la tabla de hechos de limpieza de baños.';
COMMENT ON COLUMN public.fac_limpieza_banios.id_fecha IS 'Identificador único de la fecha.';
COMMENT ON COLUMN public.fac_limpieza_banios.id_espacio_limpieza IS 'Identificador único del espacio limpiado.';
COMMENT ON COLUMN public.fac_limpieza_banios.id_estado_limpieza IS 'Identificador único del estado de la limpieza.';
COMMENT ON COLUMN public.fac_limpieza_banios.id_turno IS 'Identificador único del turno.';
COMMENT ON COLUMN public.fac_limpieza_banios.id_supervisor IS 'Identificador único del Supervisor.';
COMMENT ON COLUMN public.fac_limpieza_banios.nu_hora IS 'Hora de la limpieza del espacio.';
COMMENT ON COLUMN public.fac_limpieza_banios.fl_gestion IS 'Gestión realizada del espacio.';
COMMENT ON COLUMN public.fac_limpieza_banios.ds_observaciones IS 'Observaciones de la limpieza.';
COMMENT ON COLUMN public.fac_limpieza_banios.nu_lecturas IS 'Cantidad de lecturas.';


ALTER TABLE public.fac_limpieza_banios ADD CONSTRAINT dim_espacio_limpieza_banios_fk
FOREIGN KEY (id_espacio_limpieza)
REFERENCES public.dim_espacio_limpieza (id_espacio_limpieza)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_limpieza_banios ADD CONSTRAINT dim_estado_limpieza_banios_fk
FOREIGN KEY (id_estado_limpieza)
REFERENCES public.dim_estado_limpieza (id_estado_limpieza)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_limpieza_banios ADD CONSTRAINT dim_supervisor_limpieza_banios_fk
FOREIGN KEY (id_supervisor)
REFERENCES public.dim_supervisor (id_supervisor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
