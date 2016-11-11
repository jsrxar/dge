
CREATE TABLE facturas.stg_xls_facturas (
                ds_nombre VARCHAR(100),
                ds_cuit VARCHAR(100),
                ds_mes VARCHAR(100),
                ds_importe VARCHAR(100),
                ds_factura_numero VARCHAR(100),
                ds_area VARCHAR(100),
                ds_observaciones VARCHAR(100)
);


CREATE TABLE facturas.stg_base_rrhh (
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
                ds_ini_contrato VARCHAR(20),
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
COMMENT ON TABLE facturas.stg_base_rrhh IS 'Base de datos de origen de RRHH.';


CREATE TABLE facturas.tipo_honorario (
                id_tipo_honorario INTEGER NOT NULL,
                no_tipo_honorario VARCHAR(20) NOT NULL,
                co_categ_honorario CHAR(1) DEFAULT 'M' NOT NULL,
                nu_mes_honorario SMALLINT,
                nu_anio_honorario SMALLINT,
                va_pct_ajuste REAL DEFAULT 0,
                CONSTRAINT tipo_honorario_pk PRIMARY KEY (id_tipo_honorario)
);
COMMENT ON TABLE facturas.tipo_honorario IS 'Tipo del honorario de pago al agente (normalmente el mes del mismo)';
COMMENT ON COLUMN facturas.tipo_honorario.id_tipo_honorario IS 'Identificador único del tipo de honorario.';
COMMENT ON COLUMN facturas.tipo_honorario.no_tipo_honorario IS 'Nombre del tipo de honorario (normalmente del mes).';
COMMENT ON COLUMN facturas.tipo_honorario.co_categ_honorario IS 'Categoría del honorário:
M=Mensual
A=Adicional
E=Extra
B=Bono
O=Otro';
COMMENT ON COLUMN facturas.tipo_honorario.nu_mes_honorario IS 'Mes del honorario.';
COMMENT ON COLUMN facturas.tipo_honorario.nu_anio_honorario IS 'Año del honorario.';
COMMENT ON COLUMN facturas.tipo_honorario.va_pct_ajuste IS 'Porcentaje de ajuste en el honorario.';


CREATE SEQUENCE facturas.convenio_at_sq;

CREATE TABLE facturas.convenio_at (
                id_convenio_at INTEGER NOT NULL DEFAULT nextval('facturas.convenio_at_sq'),
                no_convenio_at VARCHAR(100),
                ds_universidad VARCHAR(200),
                CONSTRAINT convenio_at_pk PRIMARY KEY (id_convenio_at)
);
COMMENT ON TABLE facturas.convenio_at IS 'Convenio de los contratos de Asistencia Técnica.';
COMMENT ON COLUMN facturas.convenio_at.id_convenio_at IS 'Identificador único del convenio de Asistencia Técnica.';
COMMENT ON COLUMN facturas.convenio_at.no_convenio_at IS 'Nombre del convenio de Asistencia Técnica.';
COMMENT ON COLUMN facturas.convenio_at.ds_universidad IS 'Universidad con la que se encuentra firmado el convenio.';


ALTER SEQUENCE facturas.convenio_at_sq OWNED BY facturas.convenio_at.id_convenio_at;

CREATE SEQUENCE facturas.certificacion_sq;

CREATE TABLE facturas.certificacion (
                id_certificacion INTEGER NOT NULL DEFAULT nextval('facturas.certificacion_sq'),
                id_convenio_at INTEGER NOT NULL,
                fe_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                fe_certificacion TIMESTAMP,
                co_tipo_certificacion CHAR(1) DEFAULT 'R' NOT NULL,
                co_nota VARCHAR(50),
                co_estado CHAR(1) DEFAULT 'P' NOT NULL,
                CONSTRAINT certificacion_pk PRIMARY KEY (id_certificacion)
);
COMMENT ON TABLE facturas.certificacion IS 'Lotes de certificación de facturas para enviar a la universidad.';
COMMENT ON COLUMN facturas.certificacion.id_certificacion IS 'Identificador único del lote de certificación.';
COMMENT ON COLUMN facturas.certificacion.id_convenio_at IS 'Convenio de Asistencia Técnica.';
COMMENT ON COLUMN facturas.certificacion.fe_creacion IS 'Fecha de creación del lote de certificación.';
COMMENT ON COLUMN facturas.certificacion.fe_certificacion IS 'Fecha de certificación del lote de facturas.';
COMMENT ON COLUMN facturas.certificacion.co_tipo_certificacion IS 'Tipo de Certificación:
R=Regular
C=Complementaria';
COMMENT ON COLUMN facturas.certificacion.co_nota IS 'Nota enviada por la facultad como certificación de las facturas.';
COMMENT ON COLUMN facturas.certificacion.co_estado IS 'Estado de la certificación del lote de facturas:
P - PreCertificado
C - Certificado
X - Anulado';


ALTER SEQUENCE facturas.certificacion_sq OWNED BY facturas.certificacion.id_certificacion;

CREATE TABLE facturas.tipo_contrato (
                id_tipo_contrato INTEGER NOT NULL,
                co_tipo_contrato CHAR(2) NOT NULL,
                no_tipo_contrato VARCHAR(100) NOT NULL,
                CONSTRAINT tipo_contrato_pk PRIMARY KEY (id_tipo_contrato)
);
COMMENT ON TABLE facturas.tipo_contrato IS 'Tipo de contrato de los agentes (AT o LM).';
COMMENT ON COLUMN facturas.tipo_contrato.id_tipo_contrato IS 'Identificador único del tipo de contrato de los agentes.';
COMMENT ON COLUMN facturas.tipo_contrato.co_tipo_contrato IS 'Código del tipo de contrato (AT o LM).';
COMMENT ON COLUMN facturas.tipo_contrato.no_tipo_contrato IS 'Nombre del tipo de contrato.';


CREATE TABLE facturas.categoria_lm (
                id_categoria_lm INTEGER NOT NULL,
                co_categoria_lm VARCHAR(3) NOT NULL,
                co_letra_lm CHAR(1) NOT NULL,
                co_nivel_lm SMALLINT NOT NULL,
                ds_categoria_lm VARCHAR(1000),
                CONSTRAINT categoria_lm_pk PRIMARY KEY (id_categoria_lm)
);
COMMENT ON TABLE facturas.categoria_lm IS 'Categoría asignada a los agentes contratados por Ley Marco.';
COMMENT ON COLUMN facturas.categoria_lm.id_categoria_lm IS 'Identificador único de la categoría de Ley Marco.';
COMMENT ON COLUMN facturas.categoria_lm.co_categoria_lm IS 'Código de la categoría de Ley Marco.';
COMMENT ON COLUMN facturas.categoria_lm.co_letra_lm IS 'Letra de la categoría de Ley Marco.';
COMMENT ON COLUMN facturas.categoria_lm.co_nivel_lm IS 'Nivel de la categoría de Ley Marco.';
COMMENT ON COLUMN facturas.categoria_lm.ds_categoria_lm IS 'Descripción de la categoría de Ley Marco.';


CREATE SEQUENCE facturas.ubicacion_fisica_sq;

CREATE TABLE facturas.ubicacion_fisica (
                id_ubicacion_fisica INTEGER NOT NULL DEFAULT nextval('facturas.ubicacion_fisica_sq'),
                no_ubicacion_fisica VARCHAR(100) NOT NULL,
                ds_direccion VARCHAR(400),
                CONSTRAINT ubicacion_fisica_pk PRIMARY KEY (id_ubicacion_fisica)
);
COMMENT ON TABLE facturas.ubicacion_fisica IS 'Ubicación física de la dependencia en la que trabaja el agente.';
COMMENT ON COLUMN facturas.ubicacion_fisica.id_ubicacion_fisica IS 'Identificador único de la ubicación física.';
COMMENT ON COLUMN facturas.ubicacion_fisica.no_ubicacion_fisica IS 'Nombre de la ubicación física.';
COMMENT ON COLUMN facturas.ubicacion_fisica.ds_direccion IS 'Dirección de la ubicación física.';


ALTER SEQUENCE facturas.ubicacion_fisica_sq OWNED BY facturas.ubicacion_fisica.id_ubicacion_fisica;

CREATE SEQUENCE facturas.dependencia_sq;

CREATE TABLE facturas.dependencia (
                id_dependencia INTEGER NOT NULL DEFAULT nextval('facturas.dependencia_sq'),
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
COMMENT ON TABLE facturas.dependencia IS 'Dependencia gubernamental a la que pertenece el agente.';
COMMENT ON COLUMN facturas.dependencia.id_dependencia IS 'Identificador único de la dependencia gubernamental.';
COMMENT ON COLUMN facturas.dependencia.no_ministerio IS 'Nombre del Ministerio.';
COMMENT ON COLUMN facturas.dependencia.no_secretaria IS 'Nombre de la Secretaría.';
COMMENT ON COLUMN facturas.dependencia.no_subsecretaria IS 'Nombre de la Sub Secretaría.';
COMMENT ON COLUMN facturas.dependencia.no_direccion_area IS 'Nombre de la Dirección o del Área.';
COMMENT ON COLUMN facturas.dependencia.no_area_dependencia IS 'Nombre del Área o de la Dependencia.';
COMMENT ON COLUMN facturas.dependencia.no_sector IS 'Nombre del Sector.';
COMMENT ON COLUMN facturas.dependencia.no_subsector IS 'Nombre del Sub Sector.';
COMMENT ON COLUMN facturas.dependencia.id_ubicacion_fisica IS 'Ubicación Física.';


ALTER SEQUENCE facturas.dependencia_sq OWNED BY facturas.dependencia.id_dependencia;

CREATE SEQUENCE facturas.puesto_sq;

CREATE TABLE facturas.puesto (
                id_puesto INTEGER NOT NULL DEFAULT nextval('facturas.puesto_sq'),
                no_puesto VARCHAR(100) NOT NULL,
                id_dependencia INTEGER,
                CONSTRAINT puesto_pk PRIMARY KEY (id_puesto)
);
COMMENT ON TABLE facturas.puesto IS 'Puesto en el que se desenvuelve el agente.';
COMMENT ON COLUMN facturas.puesto.id_puesto IS 'Identificador único del puesto del agente.';
COMMENT ON COLUMN facturas.puesto.no_puesto IS 'Nombre del puesto del agente.';
COMMENT ON COLUMN facturas.puesto.id_dependencia IS 'Dependencia gubernamental.';


ALTER SEQUENCE facturas.puesto_sq OWNED BY facturas.puesto.id_puesto;

CREATE SEQUENCE facturas.agente_sq;

CREATE TABLE facturas.agente (
                id_agente INTEGER NOT NULL DEFAULT nextval('facturas.agente_sq'),
                no_agente VARCHAR(100) NOT NULL,
                no_nombre VARCHAR(100),
                no_apellido VARCHAR(100),
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
                ds_cv_agente VARCHAR(10),
                fe_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                CONSTRAINT agente_pk PRIMARY KEY (id_agente)
);
COMMENT ON TABLE facturas.agente IS 'Agente que presta servicios.';
COMMENT ON COLUMN facturas.agente.id_agente IS 'Identificador único del agente que presta servicios.';
COMMENT ON COLUMN facturas.agente.no_agente IS 'Nombre y apellido del agente que presta servicios.';
COMMENT ON COLUMN facturas.agente.no_nombre IS 'Nombre del agente.';
COMMENT ON COLUMN facturas.agente.no_apellido IS 'Apellidos del agente.';
COMMENT ON COLUMN facturas.agente.id_puesto IS 'Puesto del agente.';
COMMENT ON COLUMN facturas.agente.id_dependencia IS 'Dependencia gubernamental del agente.';
COMMENT ON COLUMN facturas.agente.id_ubicacion_fisica IS 'Ubicación física de traajo del agente.';
COMMENT ON COLUMN facturas.agente.ds_funcion IS 'Función del agente en el puesto.';
COMMENT ON COLUMN facturas.agente.co_tipo_documento IS 'Tipo de documento del agente.';
COMMENT ON COLUMN facturas.agente.nu_documento IS 'Número de documento del agente.';
COMMENT ON COLUMN facturas.agente.ar_documento IS 'Archivo de imagen digital del documento del agente.';
COMMENT ON COLUMN facturas.agente.co_cuit IS 'Número de CUIT del agente.';
COMMENT ON COLUMN facturas.agente.fe_nacimiento IS 'Fecha de nacimiento del agente.';
COMMENT ON COLUMN facturas.agente.ds_estudios IS 'Estudios del agente.';
COMMENT ON COLUMN facturas.agente.ds_direccion IS 'Dirección del agente.';
COMMENT ON COLUMN facturas.agente.ds_telefono IS 'Teléfono del agente.';
COMMENT ON COLUMN facturas.agente.ds_celular IS 'Teléfono celular del agente.';
COMMENT ON COLUMN facturas.agente.fe_ingreso IS 'Fecha de ingreso del agente.';
COMMENT ON COLUMN facturas.agente.ar_cv_agente IS 'Archivo del CV del agente.';
COMMENT ON COLUMN facturas.agente.ds_cv_agente IS 'Tipo de CV del agente.';
COMMENT ON COLUMN facturas.agente.fe_carga IS 'Fecha de carga de la factura.';


ALTER SEQUENCE facturas.agente_sq OWNED BY facturas.agente.id_agente;

CREATE SEQUENCE facturas.contrato_sq;

CREATE TABLE facturas.contrato (
                id_contrato INTEGER NOT NULL DEFAULT nextval('facturas.contrato_sq'),
                id_agente INTEGER NOT NULL,
                fe_inicio DATE,
                fe_fin DATE,
                id_tipo_contrato INTEGER NOT NULL,
                id_categoria_lm INTEGER,
                id_convenio_at INTEGER,
                co_categ_contrato CHAR(1) DEFAULT 'M' NOT NULL,
                CONSTRAINT contrato_pk PRIMARY KEY (id_contrato)
);
COMMENT ON TABLE facturas.contrato IS 'Contrato con el agente.';
COMMENT ON COLUMN facturas.contrato.id_contrato IS 'Identificador único del contrato con el agente.';
COMMENT ON COLUMN facturas.contrato.id_agente IS 'Agente que presta servicios.';
COMMENT ON COLUMN facturas.contrato.fe_inicio IS 'Fecha de inicio del contrato.';
COMMENT ON COLUMN facturas.contrato.fe_fin IS 'Fecha de vencimiento del contrato.';
COMMENT ON COLUMN facturas.contrato.id_tipo_contrato IS 'Tipo del contrato con el agete.';
COMMENT ON COLUMN facturas.contrato.id_categoria_lm IS 'Identificador único de la categoría de Ley Marco.';
COMMENT ON COLUMN facturas.contrato.id_convenio_at IS 'Identificador único del convenio de Asistencia Técnica.';
COMMENT ON COLUMN facturas.contrato.co_categ_contrato IS 'Categoría del contrato:
M=Mensual
A=Adicional
E=Extra
B=Bono
O=Otro';


ALTER SEQUENCE facturas.contrato_sq OWNED BY facturas.contrato.id_contrato;

CREATE SEQUENCE facturas.honorario_sq;

CREATE TABLE facturas.honorario (
                id_honorario INTEGER NOT NULL DEFAULT nextval('facturas.honorario_sq'),
                id_tipo_honorario INTEGER NOT NULL,
                id_contrato INTEGER NOT NULL,
                va_pct_ajuste REAL DEFAULT 0,
                va_honorario BYTEA NOT NULL,
                CONSTRAINT honorario_pk PRIMARY KEY (id_honorario)
);
COMMENT ON TABLE facturas.honorario IS 'Honorario del agente (normalmente mensual).';
COMMENT ON COLUMN facturas.honorario.id_honorario IS 'Identificador único del honorario del agente.';
COMMENT ON COLUMN facturas.honorario.id_tipo_honorario IS 'Tipo del honorario (normalmente el mes del mismo).';
COMMENT ON COLUMN facturas.honorario.id_contrato IS 'Contrato con el agente.';
COMMENT ON COLUMN facturas.honorario.va_pct_ajuste IS 'Porcentaje de ajuste en el honorario.';
COMMENT ON COLUMN facturas.honorario.va_honorario IS 'Valor del honorario del agente.';


ALTER SEQUENCE facturas.honorario_sq OWNED BY facturas.honorario.id_honorario;

CREATE SEQUENCE facturas.factura_sq;

CREATE TABLE facturas.factura (
                id_factura INTEGER NOT NULL DEFAULT nextval('facturas.factura_sq'),
                id_honorario INTEGER NOT NULL,
                nu_pto_venta INTEGER,
                nu_factura INTEGER,
                fe_factura DATE,
                fe_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                va_factura BYTEA NOT NULL,
                ar_factura BYTEA,
                ar_constancia_opcion BYTEA,
                ar_informe_tareas BYTEA,
                ar_comprobante_cae_cai BYTEA,
                id_convenio_at INTEGER,
                id_certificacion INTEGER,
                fl_rechazo BOOLEAN DEFAULT FALSE NOT NULL,
                ds_comentario VARCHAR(400),
                id_ubicacion_fisica INTEGER,
                CONSTRAINT factura_pk PRIMARY KEY (id_factura)
);
COMMENT ON TABLE facturas.factura IS 'Factura del agente asociada a un honorario mensual.';
COMMENT ON COLUMN facturas.factura.id_factura IS 'Identificador único de la factura del agente.';
COMMENT ON COLUMN facturas.factura.id_honorario IS 'Honorario del agente al que afecta la factura.';
COMMENT ON COLUMN facturas.factura.nu_pto_venta IS 'Número del punto de venta de la factura.';
COMMENT ON COLUMN facturas.factura.nu_factura IS 'Número de la factura.';
COMMENT ON COLUMN facturas.factura.fe_factura IS 'Fecha de la factura.';
COMMENT ON COLUMN facturas.factura.fe_carga IS 'Fecha de carga de la factura.';
COMMENT ON COLUMN facturas.factura.va_factura IS 'Monto de la factura.';
COMMENT ON COLUMN facturas.factura.ar_factura IS 'Archivo de imagen de la factura.';
COMMENT ON COLUMN facturas.factura.ar_constancia_opcion IS 'Constancia de Opción, del Régimen Simplificado para Pequeños Contribuyentes (AFIP).';
COMMENT ON COLUMN facturas.factura.ar_informe_tareas IS 'Informe de Tareas del agente.';
COMMENT ON COLUMN facturas.factura.ar_comprobante_cae_cai IS 'Constatación de Comprobantes con CAE / CAI.';
COMMENT ON COLUMN facturas.factura.id_convenio_at IS 'Convenio de Asistencia Técnica asociado a la factura.';
COMMENT ON COLUMN facturas.factura.id_certificacion IS 'Lote de certificación de las facturas.';
COMMENT ON COLUMN facturas.factura.fl_rechazo IS 'Indicador de rechazo de la factura.';
COMMENT ON COLUMN facturas.factura.ds_comentario IS 'Comentario de la factura.';
COMMENT ON COLUMN facturas.factura.id_ubicacion_fisica IS 'Ubicación física de traajo del agente.';


ALTER SEQUENCE facturas.factura_sq OWNED BY facturas.factura.id_factura;

ALTER TABLE facturas.honorario ADD CONSTRAINT tipo_honorario_honorario_fk
FOREIGN KEY (id_tipo_honorario)
REFERENCES facturas.tipo_honorario (id_tipo_honorario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.contrato ADD CONSTRAINT convenio_at_contrato_fk
FOREIGN KEY (id_convenio_at)
REFERENCES facturas.convenio_at (id_convenio_at)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.certificacion ADD CONSTRAINT convenio_at_certificacion_fk
FOREIGN KEY (id_convenio_at)
REFERENCES facturas.convenio_at (id_convenio_at)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.factura ADD CONSTRAINT convenio_at_factura_fk
FOREIGN KEY (id_convenio_at)
REFERENCES facturas.convenio_at (id_convenio_at)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.factura ADD CONSTRAINT certificacion_factura_fk
FOREIGN KEY (id_certificacion)
REFERENCES facturas.certificacion (id_certificacion)
ON DELETE SET NULL
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.contrato ADD CONSTRAINT tipo_contrato_contrato_fk
FOREIGN KEY (id_tipo_contrato)
REFERENCES facturas.tipo_contrato (id_tipo_contrato)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.contrato ADD CONSTRAINT categoria_lm_contrato_fk
FOREIGN KEY (id_categoria_lm)
REFERENCES facturas.categoria_lm (id_categoria_lm)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.dependencia ADD CONSTRAINT ubicacion_fisica_dependencia_fk
FOREIGN KEY (id_ubicacion_fisica)
REFERENCES facturas.ubicacion_fisica (id_ubicacion_fisica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.agente ADD CONSTRAINT ubicacion_fisica_agente_fk
FOREIGN KEY (id_ubicacion_fisica)
REFERENCES facturas.ubicacion_fisica (id_ubicacion_fisica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.puesto ADD CONSTRAINT dependencia_puesto_fk
FOREIGN KEY (id_dependencia)
REFERENCES facturas.dependencia (id_dependencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.agente ADD CONSTRAINT dependencia_agente_fk
FOREIGN KEY (id_dependencia)
REFERENCES facturas.dependencia (id_dependencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.agente ADD CONSTRAINT puesto_agente_fk
FOREIGN KEY (id_puesto)
REFERENCES facturas.puesto (id_puesto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.contrato ADD CONSTRAINT agente_contrato_fk
FOREIGN KEY (id_agente)
REFERENCES facturas.agente (id_agente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.honorario ADD CONSTRAINT contrato_honorario_fk
FOREIGN KEY (id_contrato)
REFERENCES facturas.contrato (id_contrato)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE facturas.factura ADD CONSTRAINT honorario_factura_fk
FOREIGN KEY (id_honorario)
REFERENCES facturas.honorario (id_honorario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
