
CREATE TABLE public.stg_base_rrhh (
                ds_ministerio VARCHAR(100),
                ds_secretaria VARCHAR(100),
                ds_subsecretaria VARCHAR(100),
                ds_direccion_area VARCHAR(100),
                ds_area_dependencia VARCHAR(100),
                ds_sector VARCHAR(100),
                ds_sub_sector VARCHAR(100),
                ds_puesto VARCHAR(100),
                ds_funcion VARCHAR(200),
                ds_ubicacion_fisica VARCHAR(100),
                ds_entrega_banelcos VARCHAR(100),
                ds_apellido_nombres VARCHAR(100),
                ds_dni VARCHAR(20),
                ds_nro VARCHAR(20),
                ds_cuit VARCHAR(20),
                ds_f_nacimiento VARCHAR(20),
                ds_estudios VARCHAR(20),
                ds_direccion VARCHAR(20),
                ds_telefono VARCHAR(20),
                ds_celular VARCHAR(20),
                ds_lm_at VARCHAR(50),
                ds_tipo VARCHAR(20),
                ds_ingreso VARCHAR(20),
                ds_vto_contrato VARCHAR(20),
                ds_fin_contrato VARCHAR(20),
                ds_categ_lm VARCHAR(20),
                ds_universidad VARCHAR(50),
                ds_convenio_at VARCHAR(50),
                ds_mayo_2016 VARCHAR(20),
                ds_junio_7p VARCHAR(20),
                ds_julio_10p VARCHAR(20),
                ds_agosto_14p VARCHAR(20),
                ds_sept VARCHAR(20),
                ds_oct VARCHAR(20),
                ds_nov VARCHAR(20),
                ds_dic VARCHAR(20),
                ds_posible_letra VARCHAR(20),
                ds_presup_2017 VARCHAR(20)
);
COMMENT ON TABLE public.stg_base_rrhh IS 'Base de datos de origen de RRHH.';


CREATE TABLE public.mes (
                id_mes INTEGER NOT NULL,
                nu_mes SMALLINT NOT NULL,
                no_mes VARCHAR(20) NOT NULL,
                nu_anio_mes SMALLINT NOT NULL,
                va_pct_aumento REAL,
                CONSTRAINT mes_pk PRIMARY KEY (id_mes)
);
COMMENT ON TABLE public.mes IS 'Mes de pago del salario.';
COMMENT ON COLUMN public.mes.id_mes IS 'Identificador único del mes del salario.';
COMMENT ON COLUMN public.mes.nu_mes IS 'Número de mes.';
COMMENT ON COLUMN public.mes.no_mes IS 'Nombre del mes del salario.';
COMMENT ON COLUMN public.mes.nu_anio_mes IS 'Año del mes.';
COMMENT ON COLUMN public.mes.va_pct_aumento IS 'Porcentaje de aumento en el mes.';


CREATE SEQUENCE public.convenio_at_sq;

CREATE TABLE public.convenio_at (
                id_convenio_at INTEGER NOT NULL DEFAULT nextval('public.convenio_at_sq'),
                no_convenio_at VARCHAR(100),
                ds_universidad VARCHAR(200),
                CONSTRAINT convenio_at_pk PRIMARY KEY (id_convenio_at)
);
COMMENT ON TABLE public.convenio_at IS 'Convenio de los contratos de Asistencia Técnica.';
COMMENT ON COLUMN public.convenio_at.id_convenio_at IS 'Identificador único del convenio de Asistencia Técnica.';
COMMENT ON COLUMN public.convenio_at.no_convenio_at IS 'Nombre del convenio de Asistencia Técnica.';
COMMENT ON COLUMN public.convenio_at.ds_universidad IS 'Universidad con la que se encuentra firmado el convenio.';


ALTER SEQUENCE public.convenio_at_sq OWNED BY public.convenio_at.id_convenio_at;

CREATE TABLE public.tipo_contrato (
                id_tipo_contrato INTEGER NOT NULL,
                co_tipo_contrato CHAR(2) NOT NULL,
                no_tipo_contrato VARCHAR(100) NOT NULL,
                CONSTRAINT tipo_contrato_pk PRIMARY KEY (id_tipo_contrato)
);
COMMENT ON TABLE public.tipo_contrato IS 'Tipo de contrato de los agentes (AT o LM).';
COMMENT ON COLUMN public.tipo_contrato.id_tipo_contrato IS 'Identificador único del tipo de contrato de los agentes.';
COMMENT ON COLUMN public.tipo_contrato.co_tipo_contrato IS 'Código del tipo de contrato (AT o LM).';
COMMENT ON COLUMN public.tipo_contrato.no_tipo_contrato IS 'Nombre del tipo de contrato.';


CREATE TABLE public.categoria_lm (
                id_categoria_lm INTEGER NOT NULL,
                co_categoria_lm VARCHAR(3) NOT NULL,
                co_letra_lm CHAR(1) NOT NULL,
                co_nivel_lm SMALLINT NOT NULL,
                ds_categoria_lm VARCHAR(1000),
                CONSTRAINT categoria_lm_pk PRIMARY KEY (id_categoria_lm)
);
COMMENT ON TABLE public.categoria_lm IS 'Categoría asignada a los agentes contratados por Ley Marco.';
COMMENT ON COLUMN public.categoria_lm.id_categoria_lm IS 'Identificador único de la categoría de Ley Marco.';
COMMENT ON COLUMN public.categoria_lm.co_categoria_lm IS 'Código de la categoría de Ley Marco.';
COMMENT ON COLUMN public.categoria_lm.co_letra_lm IS 'Letra de la categoría de Ley Marco.';
COMMENT ON COLUMN public.categoria_lm.co_nivel_lm IS 'Nivel de la categoría de Ley Marco.';
COMMENT ON COLUMN public.categoria_lm.ds_categoria_lm IS 'Descripción de la categoría de Ley Marco.';


CREATE SEQUENCE public.ubicacion_fisica_sq;

CREATE TABLE public.ubicacion_fisica (
                id_ubicacion_fisica INTEGER NOT NULL DEFAULT nextval('public.ubicacion_fisica_sq'),
                no_ubicacion_fisica VARCHAR(100) NOT NULL,
                ds_direccion VARCHAR(400),
                CONSTRAINT ubicacion_fisica_pk PRIMARY KEY (id_ubicacion_fisica)
);
COMMENT ON TABLE public.ubicacion_fisica IS 'Ubicación física de la dependencia en la que trabaja el agente.';
COMMENT ON COLUMN public.ubicacion_fisica.id_ubicacion_fisica IS 'Identificador único de la ubicación física.';
COMMENT ON COLUMN public.ubicacion_fisica.no_ubicacion_fisica IS 'Nombre de la ubicación física.';
COMMENT ON COLUMN public.ubicacion_fisica.ds_direccion IS 'Dirección de la ubicación física.';


ALTER SEQUENCE public.ubicacion_fisica_sq OWNED BY public.ubicacion_fisica.id_ubicacion_fisica;

CREATE SEQUENCE public.dependencia_sq;

CREATE TABLE public.dependencia (
                id_dependencia INTEGER NOT NULL DEFAULT nextval('public.dependencia_sq'),
                no_ministerio VARCHAR(100) NOT NULL,
                no_secretaria VARCHAR(100),
                no_subsecretaria VARCHAR(100),
                no_direccion_area VARCHAR(100),
                no_area_dependencia VARCHAR(100),
                no_sector VARCHAR(100),
                no_subsector VARCHAR(100),
                id_ubicacion_fisica INTEGER,
                CONSTRAINT dependencia_pk PRIMARY KEY (id_dependencia)
);
COMMENT ON TABLE public.dependencia IS 'Dependencia gubernamental a la que pertenece el agente.';
COMMENT ON COLUMN public.dependencia.id_dependencia IS 'Identificador único de la dependencia gubernamental.';
COMMENT ON COLUMN public.dependencia.no_ministerio IS 'Nombre del Ministerio.';
COMMENT ON COLUMN public.dependencia.no_secretaria IS 'Nombre de la Secretaría.';
COMMENT ON COLUMN public.dependencia.no_subsecretaria IS 'Nombre de la Sub Secretaría.';
COMMENT ON COLUMN public.dependencia.no_direccion_area IS 'Nombre de la Dirección o del Área.';
COMMENT ON COLUMN public.dependencia.no_area_dependencia IS 'Nombre del Área o de la Dependencia.';
COMMENT ON COLUMN public.dependencia.no_sector IS 'Nombre del Sector.';
COMMENT ON COLUMN public.dependencia.no_subsector IS 'Nombre del Sub Sector.';
COMMENT ON COLUMN public.dependencia.id_ubicacion_fisica IS 'Ubicación Física.';


ALTER SEQUENCE public.dependencia_sq OWNED BY public.dependencia.id_dependencia;

CREATE SEQUENCE public.puesto_sq;

CREATE TABLE public.puesto (
                id_puesto INTEGER NOT NULL DEFAULT nextval('public.puesto_sq'),
                no_puesto VARCHAR(100) NOT NULL,
                id_dependencia INTEGER,
                CONSTRAINT puesto_pk PRIMARY KEY (id_puesto)
);
COMMENT ON TABLE public.puesto IS 'Puesto en el que se desenvuelve el agente.';
COMMENT ON COLUMN public.puesto.id_puesto IS 'Identificador único del puesto del agente.';
COMMENT ON COLUMN public.puesto.no_puesto IS 'Nombre del puesto del agente.';
COMMENT ON COLUMN public.puesto.id_dependencia IS 'Dependencia gubernamental.';


ALTER SEQUENCE public.puesto_sq OWNED BY public.puesto.id_puesto;

CREATE SEQUENCE public.agente_sq;

CREATE TABLE public.agente (
                id_agente INTEGER NOT NULL DEFAULT nextval('public.agente_sq'),
                no_agente VARCHAR(100) NOT NULL,
                id_puesto INTEGER,
                id_dependencia INTEGER NOT NULL,
                id_ubicacion_fisica INTEGER,
                ds_funcion VARCHAR(200),
                co_tipo_documento VARCHAR(5),
                nu_documento BIGINT,
                ar_documento BYTEA,
                co_cuit VARCHAR(20),
                fe_nacimiento DATE,
                ds_estudios VARCHAR(200),
                ds_direccion VARCHAR(200),
                ds_telefono VARCHAR(20),
                ds_celular VARCHAR(20),
                fe_ingreso DATE,
                ar_cv_agente BYTEA,
                CONSTRAINT agente_pk PRIMARY KEY (id_agente)
);
COMMENT ON TABLE public.agente IS 'Agente que presta servicios.';
COMMENT ON COLUMN public.agente.id_agente IS 'Identificador único del agente que presta servicios.';
COMMENT ON COLUMN public.agente.no_agente IS 'Nombre del agente que presta servicios.';
COMMENT ON COLUMN public.agente.id_puesto IS 'Puesto del agente.';
COMMENT ON COLUMN public.agente.id_dependencia IS 'Dependencia gubernamental del agente.';
COMMENT ON COLUMN public.agente.id_ubicacion_fisica IS 'Ubicación física de traajo del agente.';
COMMENT ON COLUMN public.agente.ds_funcion IS 'Función del agente en el puesto.';
COMMENT ON COLUMN public.agente.co_tipo_documento IS 'Tipo de documento del agente.';
COMMENT ON COLUMN public.agente.nu_documento IS 'Número de documento del agente.';
COMMENT ON COLUMN public.agente.ar_documento IS 'Archivo de imagen digital del documento del agente.';
COMMENT ON COLUMN public.agente.co_cuit IS 'Número de CUIT del agente.';
COMMENT ON COLUMN public.agente.fe_nacimiento IS 'Fecha de nacimiento del agente.';
COMMENT ON COLUMN public.agente.ds_estudios IS 'Estudios del agente.';
COMMENT ON COLUMN public.agente.ds_direccion IS 'Dirección del agente.';
COMMENT ON COLUMN public.agente.ds_telefono IS 'Teléfono del agente.';
COMMENT ON COLUMN public.agente.ds_celular IS 'Teléfono celular del agente.';
COMMENT ON COLUMN public.agente.fe_ingreso IS 'Fecha de ingreso del agente.';
COMMENT ON COLUMN public.agente.ar_cv_agente IS 'Archivo del CV del agente.';


ALTER SEQUENCE public.agente_sq OWNED BY public.agente.id_agente;

CREATE SEQUENCE public.contrato_sq;

CREATE TABLE public.contrato (
                id_contrato INTEGER NOT NULL DEFAULT nextval('public.contrato_sq'),
                id_agente INTEGER NOT NULL,
                fe_inicio DATE,
                fe_fin DATE,
                id_tipo_contrato INTEGER NOT NULL,
                id_categoria_lm INTEGER,
                id_convenio_at INTEGER,
                CONSTRAINT contrato_pk PRIMARY KEY (id_contrato)
);
COMMENT ON TABLE public.contrato IS 'Contrato con el agente.';
COMMENT ON COLUMN public.contrato.id_contrato IS 'Identificador único del contrato con el agente.';
COMMENT ON COLUMN public.contrato.id_agente IS 'Agente que presta servicios.';
COMMENT ON COLUMN public.contrato.fe_inicio IS 'Fecha de inicio del contrato.';
COMMENT ON COLUMN public.contrato.fe_fin IS 'Fecha de vencimiento del contrato.';
COMMENT ON COLUMN public.contrato.id_tipo_contrato IS 'Tipo del contrato con el agete.';
COMMENT ON COLUMN public.contrato.id_categoria_lm IS 'Identificador único de la categoría de Ley Marco.';
COMMENT ON COLUMN public.contrato.id_convenio_at IS 'Identificador único del convenio de Asistencia Técnica.';


ALTER SEQUENCE public.contrato_sq OWNED BY public.contrato.id_contrato;

CREATE SEQUENCE public.salario_sq;

CREATE TABLE public.salario (
                id_salario INTEGER NOT NULL DEFAULT nextval('public.salario_sq'),
                id_agente INTEGER NOT NULL,
                id_mes INTEGER NOT NULL,
                id_contrato INTEGER NOT NULL,
                va_salario REAL NOT NULL,
                CONSTRAINT salario_pk PRIMARY KEY (id_salario)
);
COMMENT ON TABLE public.salario IS 'Salario del mes del agente.';
COMMENT ON COLUMN public.salario.id_salario IS 'Identificador único del salario del agente en un mes.';
COMMENT ON COLUMN public.salario.id_agente IS 'Agente que presta servicios.';
COMMENT ON COLUMN public.salario.id_mes IS 'Mes del salario.';
COMMENT ON COLUMN public.salario.id_contrato IS 'Contrato con el agente.';
COMMENT ON COLUMN public.salario.va_salario IS 'Valor del salario del agente en el mes.';


ALTER SEQUENCE public.salario_sq OWNED BY public.salario.id_salario;

CREATE SEQUENCE public.factura_sq;

CREATE TABLE public.factura (
                id_factura INTEGER NOT NULL DEFAULT nextval('public.factura_sq'),
                id_salario INTEGER NOT NULL,
                nu_pto_venta INTEGER,
                nu_factura INTEGER,
                fe_factura DATE,
                fe_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP  NOT NULL,
                va_factura REAL,
                ar_factura BYTEA,
                fl_rechazo BOOLEAN DEFAULT FALSE NOT NULL,
                ds_comentario VARCHAR(400),
                CONSTRAINT factura_pk PRIMARY KEY (id_factura)
);
COMMENT ON TABLE public.factura IS 'Factura del agente asociada a un salario mensual.';
COMMENT ON COLUMN public.factura.id_factura IS 'Identificador único de la factura del agente.';
COMMENT ON COLUMN public.factura.id_salario IS 'Salario del agente al que afecta la factura.';
COMMENT ON COLUMN public.factura.nu_pto_venta IS 'Número del punto de venta de la factura.';
COMMENT ON COLUMN public.factura.nu_factura IS 'Número de la factura.';
COMMENT ON COLUMN public.factura.fe_factura IS 'Fecha de la factura.';
COMMENT ON COLUMN public.factura.fe_carga IS 'Fecha de carga de la factura.';
COMMENT ON COLUMN public.factura.va_factura IS 'Monto de la factura.';
COMMENT ON COLUMN public.factura.ar_factura IS 'Archivo de imagen de la factura.';
COMMENT ON COLUMN public.factura.fl_rechazo IS 'Indicador de rechazo de la factura.';
COMMENT ON COLUMN public.factura.ds_comentario IS 'Comentario de la factura.';


ALTER SEQUENCE public.factura_sq OWNED BY public.factura.id_factura;

ALTER TABLE public.salario ADD CONSTRAINT mes_salario_fk
FOREIGN KEY (id_mes)
REFERENCES public.mes (id_mes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.contrato ADD CONSTRAINT convenio_at_contrato_fk
FOREIGN KEY (id_convenio_at)
REFERENCES public.convenio_at (id_convenio_at)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.contrato ADD CONSTRAINT tipo_contrato_contrato_fk
FOREIGN KEY (id_tipo_contrato)
REFERENCES public.tipo_contrato (id_tipo_contrato)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.contrato ADD CONSTRAINT categoria_lm_contrato_fk
FOREIGN KEY (id_categoria_lm)
REFERENCES public.categoria_lm (id_categoria_lm)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.dependencia ADD CONSTRAINT ubicacion_fisica_dependencia_fk
FOREIGN KEY (id_ubicacion_fisica)
REFERENCES public.ubicacion_fisica (id_ubicacion_fisica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.agente ADD CONSTRAINT ubicacion_fisica_agente_fk
FOREIGN KEY (id_ubicacion_fisica)
REFERENCES public.ubicacion_fisica (id_ubicacion_fisica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.puesto ADD CONSTRAINT dependencia_puesto_fk
FOREIGN KEY (id_dependencia)
REFERENCES public.dependencia (id_dependencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.agente ADD CONSTRAINT dependencia_agente_fk
FOREIGN KEY (id_dependencia)
REFERENCES public.dependencia (id_dependencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.agente ADD CONSTRAINT puesto_agente_fk
FOREIGN KEY (id_puesto)
REFERENCES public.puesto (id_puesto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.contrato ADD CONSTRAINT agente_contrato_fk
FOREIGN KEY (id_agente)
REFERENCES public.agente (id_agente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.salario ADD CONSTRAINT agente_salario_fk
FOREIGN KEY (id_agente)
REFERENCES public.agente (id_agente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.salario ADD CONSTRAINT contrato_salario_fk
FOREIGN KEY (id_contrato)
REFERENCES public.contrato (id_contrato)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.factura ADD CONSTRAINT salario_factura_fk
FOREIGN KEY (id_salario)
REFERENCES public.salario (id_salario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
