
CREATE TABLE public.stg_personal (
                id_carga BIGINT DEFAULT nextval('carga_seq'::regclass) NOT NULL,
                no_archivo VARCHAR(100),
                co_lugar CHAR(1),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_dat_lab_dependencia VARCHAR(100),
                tx_dat_lab_secretaria VARCHAR(100),
                tx_dat_lab_subsecretaria VARCHAR(100),
                tx_dat_lab_direccion_area VARCHAR(100),
                tx_dat_lab_area_dependenc VARCHAR(100),
                tx_dat_lab_sector VARCHAR(100),
                tx_dat_lab_sub_sector VARCHAR(100),
                tx_dat_lab_puesto VARCHAR(100),
                tx_destino_direccion_gral VARCHAR(100),
                tx_destino_direccion VARCHAR(100),
                tx_destino_departamento VARCHAR(100),
                tx_destino_coord_unidad VARCHAR(100),
                tx_ubi_fis_ubic_fisica_1 VARCHAR(100),
                tx_ubi_fis_puesto VARCHAR(100),
                tx_ubi_fis_ubic_fisica_2 VARCHAR(100),
                tx_dat_per_apell_nombre VARCHAR(100),
                tx_dat_per_tipo_doc VARCHAR(5),
                tx_dat_per_nro_doc VARCHAR(20),
                tx_mod_con_tipo VARCHAR(100),
                tx_mod_con_tipo_2 VARCHAR(100),
                tx_mod_con_lm_at VARCHAR(100),
                tx_mod_con_ingreso VARCHAR(20),
                tx_mod_con_convenio_at VARCHAR(100),
                CONSTRAINT stg_personal_pk PRIMARY KEY (id_carga)
);
COMMENT ON TABLE public.stg_personal IS 'Tabla Stage de personal cargado desde planilla enviada por Recursos Humanos.';
COMMENT ON COLUMN public.stg_personal.no_archivo IS 'Nombre del archivo cargado.';
COMMENT ON COLUMN public.stg_personal.co_lugar IS 'Código de lugar.';
COMMENT ON COLUMN public.stg_personal.fe_carga IS 'Fecha y hora de carga del archivo.';
COMMENT ON COLUMN public.stg_personal.co_estado_proceso IS 'Estado de procesamiento del registro.';


CREATE SEQUENCE public.carga_seq;

CREATE TABLE public.stg_lecturas (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.carga_seq'),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                fe_fecha_hora TIMESTAMP NOT NULL,
                tx_dni VARCHAR(20),
                tx_persona VARCHAR(100),
                tx_tipo_acreditac VARCHAR(100),
                tx_empresa_area VARCHAR(100),
                tx_usuario VARCHAR(10),
                tx_lector VARCHAR(10),
                tx_observacion VARCHAR(100),
                CONSTRAINT stg_lecturas_pk PRIMARY KEY (id_carga)
);
COMMENT ON TABLE public.stg_lecturas IS 'Carga masiva de lecturas desde el sistema de Control de Accesos.';
COMMENT ON COLUMN public.stg_lecturas.id_carga IS 'Identificador único de la carga.';
COMMENT ON COLUMN public.stg_lecturas.fe_carga IS 'Fecha y hora de carga del archivo.';
COMMENT ON COLUMN public.stg_lecturas.co_estado_proceso IS 'Estado de procesamiento del registro.';
COMMENT ON COLUMN public.stg_lecturas.fe_fecha_hora IS 'Fecha y Hora de la fichada.';
COMMENT ON COLUMN public.stg_lecturas.tx_dni IS 'DNI de la persona que registra la lectura.';
COMMENT ON COLUMN public.stg_lecturas.tx_persona IS 'Persona que registra la lectura.';
COMMENT ON COLUMN public.stg_lecturas.tx_tipo_acreditac IS 'Tipo de acreditación de la persona.';
COMMENT ON COLUMN public.stg_lecturas.tx_empresa_area IS 'Empresa o Área a la que pertenece la persona.';
COMMENT ON COLUMN public.stg_lecturas.tx_usuario IS 'Usuário de regitro de la lectura.';
COMMENT ON COLUMN public.stg_lecturas.tx_lector IS 'Lector de la fichada.';
COMMENT ON COLUMN public.stg_lecturas.tx_observacion IS 'Observaciones varias sobre la lectura.';


ALTER SEQUENCE public.carga_seq OWNED BY public.stg_lecturas.id_carga;

CREATE SEQUENCE public.carga_seq;

CREATE TABLE public.stg_dto_banda (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.carga_seq'),
                no_archivo VARCHAR(100),
                co_lugar CHAR(1),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_fecha VARCHAR(12),
                tx_nombre VARCHAR(100),
                tx_entrada VARCHAR(20),
                tx_salida VARCHAR(20),
                tx_horas VARCHAR(20),
                tx_dni VARCHAR(12),
                tx_empresa_area VARCHAR(50),
                tx_tipo_acreditac VARCHAR(100),
                CONSTRAINT stg_dto_banda_pk PRIMARY KEY (id_carga)
);
COMMENT ON COLUMN public.stg_dto_banda.no_archivo IS 'Nombre del archivo cargado.';
COMMENT ON COLUMN public.stg_dto_banda.co_lugar IS 'Código de lugar.';
COMMENT ON COLUMN public.stg_dto_banda.fe_carga IS 'Fecha y hora de carga del archivo.';
COMMENT ON COLUMN public.stg_dto_banda.co_estado_proceso IS 'Estado de procesamiento del registro.';
COMMENT ON COLUMN public.stg_dto_banda.tx_dni IS 'DNI de la persona de la lectura cargada.';
COMMENT ON COLUMN public.stg_dto_banda.tx_empresa_area IS 'Empresa o Área de la lectura cargada.';


ALTER SEQUENCE public.carga_seq OWNED BY public.stg_dto_banda.id_carga;

CREATE INDEX stg_dto_banda_ix1
 ON public.stg_dto_banda
 ( tx_nombre );

CREATE INDEX stg_dto_banda_ix2
 ON public.stg_dto_banda
 ( tx_dni );

CREATE SEQUENCE public.carga_seq;

CREATE TABLE public.stg_dto_personal (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.carga_seq'),
                no_archivo VARCHAR(100),
                co_lugar CHAR(1),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_sector VARCHAR(100),
                tx_area VARCHAR(100),
                tx_puesto VARCHAR(100),
                tx_nombre VARCHAR(100),
                tx_dni VARCHAR(12),
                CONSTRAINT stg_dto_personal_pk PRIMARY KEY (id_carga)
);
COMMENT ON COLUMN public.stg_dto_personal.no_archivo IS 'Nombre del archivo cargado.';
COMMENT ON COLUMN public.stg_dto_personal.co_lugar IS 'Código de lugar.';
COMMENT ON COLUMN public.stg_dto_personal.fe_carga IS 'Fecha y hora de carga del archivo.';
COMMENT ON COLUMN public.stg_dto_personal.co_estado_proceso IS 'Estado de procesamiento del registro.';
COMMENT ON COLUMN public.stg_dto_personal.tx_dni IS 'DNI de la persona de la lectura cargada.';


ALTER SEQUENCE public.carga_seq OWNED BY public.stg_dto_personal.id_carga;

CREATE SEQUENCE public.carga_seq;

CREATE TABLE public.stg_banda_ciardi (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.carga_seq'),
                no_archivo VARCHAR(100),
                co_lugar CHAR(1),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_dia VARCHAR(20) DEFAULT NULL::character varying,
                tx_molinete VARCHAR(10) DEFAULT NULL::character varying,
                tx_tipo VARCHAR(1) DEFAULT NULL::character varying,
                tx_ds_molinete VARCHAR(20) DEFAULT NULL::character varying,
                tx_hora VARCHAR(20) DEFAULT NULL::character varying,
                tx_tarjeta VARCHAR(20) DEFAULT NULL::character varying,
                tx_agente VARCHAR(50) DEFAULT NULL::character varying,
                tx_cruce VARCHAR(20) DEFAULT NULL::character varying,
                CONSTRAINT stg_banda_ciardi_pk PRIMARY KEY (id_carga)
);
COMMENT ON COLUMN public.stg_banda_ciardi.no_archivo IS 'Nombre del archivo cargado.';
COMMENT ON COLUMN public.stg_banda_ciardi.co_lugar IS 'Código de lugar.';
COMMENT ON COLUMN public.stg_banda_ciardi.fe_carga IS 'Fecha y hora de carga del archivo.';
COMMENT ON COLUMN public.stg_banda_ciardi.co_estado_proceso IS 'Estado de procesamiento del registro.';


ALTER SEQUENCE public.carga_seq OWNED BY public.stg_banda_ciardi.id_carga;

CREATE SEQUENCE public.carga_seq;

CREATE TABLE public.stg_fichadas (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.carga_seq'),
                no_archivo VARCHAR(100),
                co_lugar CHAR(1),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_fecha VARCHAR(20),
                tx_legajo VARCHAR(20),
                tx_usuario VARCHAR(100),
                tx_entrada_hora VARCHAR(20),
                tx_entrada_usuario VARCHAR(10),
                tx_entrada_descrip VARCHAR(50),
                tx_entrada_lector VARCHAR(10),
                tx_entrada_lista VARCHAR(20),
                tx_salida_hora VARCHAR(20),
                tx_salida_usuario VARCHAR(10),
                tx_salida_descrip VARCHAR(50),
                tx_salida_lector VARCHAR(10),
                tx_salida_lista VARCHAR(20),
                tx_total_hs VARCHAR(20),
                tx_observacion VARCHAR(100),
                tx_dni VARCHAR(20),
                tx_empresa_area VARCHAR(100),
                tx_tipo_acreditac VARCHAR(100),
                CONSTRAINT stg_fichadas_pk PRIMARY KEY (id_carga)
);
COMMENT ON TABLE public.stg_fichadas IS 'Carga masiva de archivos de fichadas.';
COMMENT ON COLUMN public.stg_fichadas.no_archivo IS 'Nombre del archivo cargado.';
COMMENT ON COLUMN public.stg_fichadas.co_lugar IS 'Código de lugar.';
COMMENT ON COLUMN public.stg_fichadas.fe_carga IS 'Fecha y hora de carga del archivo.';
COMMENT ON COLUMN public.stg_fichadas.co_estado_proceso IS 'Estado de procesamiento del registro.';


ALTER SEQUENCE public.carga_seq OWNED BY public.stg_fichadas.id_carga;

CREATE SEQUENCE public.carga_seq;

CREATE TABLE public.stg_banda_horaria (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.carga_seq'),
                no_archivo VARCHAR(100),
                co_lugar CHAR(1),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_codigo VARCHAR(10) DEFAULT NULL::character varying,
                tx_tipo VARCHAR(50) DEFAULT NULL::character varying,
                tx_nombre VARCHAR(50) DEFAULT NULL::character varying,
                tx_apellido VARCHAR(50) DEFAULT NULL::character varying,
                tx_empresa_area VARCHAR(50) DEFAULT NULL::character varying,
                tx_dni_cuit VARCHAR(12) DEFAULT NULL::character varying,
                tx_art VARCHAR(50) DEFAULT NULL::character varying,
                tx_poliza VARCHAR(50) DEFAULT NULL::character varying,
                tx_vigencia_poliza VARCHAR(10) DEFAULT NULL::character varying,
                tx_visita VARCHAR(50) DEFAULT NULL::character varying,
                tx_vencimiento VARCHAR(10) DEFAULT NULL::character varying,
                tx_observaciones VARCHAR(100),
                tx_equipamiento_1 VARCHAR(100) DEFAULT NULL::character varying,
                tx_equipamiento_2 VARCHAR(100) DEFAULT NULL::character varying,
                tx_equipamiento_3 VARCHAR(100) DEFAULT NULL::character varying,
                tx_observacion_1 VARCHAR(100) DEFAULT NULL::character varying,
                tx_observacion_2 VARCHAR(100) DEFAULT NULL::character varying,
                tx_observacion_3 VARCHAR(100) DEFAULT NULL::character varying,
                tx_cantidad VARCHAR(5) DEFAULT NULL::character varying,
                tx_lectura VARCHAR(20) DEFAULT NULL::character varying,
                tx_usuario_lectura VARCHAR(5) DEFAULT NULL::character varying,
                CONSTRAINT stg_banda_horaria_pk PRIMARY KEY (id_carga)
);
COMMENT ON TABLE public.stg_banda_horaria IS 'Carga masiva de archivos de Banda Horaria CCK.';
COMMENT ON COLUMN public.stg_banda_horaria.id_carga IS 'Identificador único del registro cargado.';
COMMENT ON COLUMN public.stg_banda_horaria.no_archivo IS 'Nombre del archivo cargado.';
COMMENT ON COLUMN public.stg_banda_horaria.co_lugar IS 'Código de lugar.';
COMMENT ON COLUMN public.stg_banda_horaria.fe_carga IS 'Fecha y hora de carga del archivo.';
COMMENT ON COLUMN public.stg_banda_horaria.co_estado_proceso IS 'Estado de procesamiento del registro.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_codigo IS 'Código de carga.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_tipo IS 'Tipo de la lectura cargada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_nombre IS 'Nombre de la persona de la lectura cargada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_apellido IS 'Apellido de la persona de la lectura cargada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_empresa_area IS 'Empresa o Área de la lectura cargada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_dni_cuit IS 'DNI o CUIT de la persona de la lectura cargada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_art IS 'ART de la persona de la lectura cargada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_poliza IS 'Póliza de ART de la persona de la lectura cargada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_vigencia_poliza IS 'Vigencia de la póliza de la pesona.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_visita IS 'Persona visitada.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_vencimiento IS 'Vencimiento de la tarjeta de ingreso.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_observaciones IS 'Observaciones principales.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_equipamiento_1 IS 'Detalle de equipamiento (1).';
COMMENT ON COLUMN public.stg_banda_horaria.tx_equipamiento_2 IS 'Detalle de equipamiento (2).';
COMMENT ON COLUMN public.stg_banda_horaria.tx_equipamiento_3 IS 'Detalle de equipamiento (3).';
COMMENT ON COLUMN public.stg_banda_horaria.tx_observacion_1 IS 'Otras observaciones (1).';
COMMENT ON COLUMN public.stg_banda_horaria.tx_observacion_2 IS 'Otras observaciones (2).';
COMMENT ON COLUMN public.stg_banda_horaria.tx_observacion_3 IS 'Otras observaciones (3).';
COMMENT ON COLUMN public.stg_banda_horaria.tx_cantidad IS 'Cantidad cargada en la lectura.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_lectura IS 'Fecha y Hora de la lectura.';
COMMENT ON COLUMN public.stg_banda_horaria.tx_usuario_lectura IS 'Usuario de la lectura.';


ALTER SEQUENCE public.carga_seq OWNED BY public.stg_banda_horaria.id_carga;
