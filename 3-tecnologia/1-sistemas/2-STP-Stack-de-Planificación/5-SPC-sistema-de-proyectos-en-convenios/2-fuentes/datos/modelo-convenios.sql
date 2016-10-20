
CREATE SEQUENCE public.proveedor_sq;

CREATE TABLE public.proveedor (
                id_proveedor INTEGER NOT NULL DEFAULT nextval('public.proveedor_sq'),
                no_proveedor VARCHAR(100) NOT NULL,
                tx_email_proveedor VARCHAR(100),
                tx_telefono_proveedor VARCHAR(50),
                fl_cuit BOOLEAN,
                fl_estatuto BOOLEAN,
                fl_dni BOOLEAN,
                fl_poder BOOLEAN,
                fl_sipro BOOLEAN,
                fl_cert_fiscal BOOLEAN,
                fl_cbu BOOLEAN,
                flg_cv BOOLEAN,
                va_saldo DOUBLE PRECISION DEFAULT 0 NOT NULL,
                ds_observaciones VARCHAR(400),
                CONSTRAINT proveedor_pk PRIMARY KEY (id_proveedor)
);
COMMENT ON TABLE public.proveedor IS 'Proveedor que realiza el trabajo relacionado al ítem del proyecto.';
COMMENT ON COLUMN public.proveedor.id_proveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN public.proveedor.no_proveedor IS 'Nombre del proveedor.';
COMMENT ON COLUMN public.proveedor.tx_email_proveedor IS 'E-Mail del proveedor.';
COMMENT ON COLUMN public.proveedor.tx_telefono_proveedor IS 'Número de teléfono del proveedor.';
COMMENT ON COLUMN public.proveedor.fl_cuit IS 'Número de CUIT?.';
COMMENT ON COLUMN public.proveedor.fl_estatuto IS 'Estatuto?.';
COMMENT ON COLUMN public.proveedor.fl_dni IS 'Documento Nacional de Identidad?';
COMMENT ON COLUMN public.proveedor.fl_poder IS 'Poder?';
COMMENT ON COLUMN public.proveedor.fl_sipro IS 'SIPRO?';
COMMENT ON COLUMN public.proveedor.fl_cert_fiscal IS 'Certificado Fiscal?';
COMMENT ON COLUMN public.proveedor.fl_cbu IS 'CBU?';
COMMENT ON COLUMN public.proveedor.flg_cv IS 'CV?';
COMMENT ON COLUMN public.proveedor.va_saldo IS 'Saldo con el proveedor.';
COMMENT ON COLUMN public.proveedor.ds_observaciones IS 'Observaciones generales sobre el proveedor.';


ALTER SEQUENCE public.proveedor_sq OWNED BY public.proveedor.id_proveedor;

CREATE SEQUENCE public.lugar_sq;

CREATE TABLE public.lugar (
                id_lugar INTEGER NOT NULL DEFAULT nextval('public.lugar_sq'),
                no_lugar VARCHAR(100) NOT NULL,
                CONSTRAINT lugar_pk PRIMARY KEY (id_lugar)
);
COMMENT ON TABLE public.lugar IS 'Lugar en que se realiza el proyecto.';
COMMENT ON COLUMN public.lugar.id_lugar IS 'Identificador único del lugar.';
COMMENT ON COLUMN public.lugar.no_lugar IS 'Nombre del lugar donde se realiza el proyecto.';


ALTER SEQUENCE public.lugar_sq OWNED BY public.lugar.id_lugar;

CREATE SEQUENCE public.espacio_sq;

CREATE TABLE public.espacio (
                id_espacio INTEGER NOT NULL DEFAULT nextval('public.espacio_sq'),
                no_espacio VARCHAR(100) NOT NULL,
                id_lugar INTEGER,
                CONSTRAINT espacio_pk PRIMARY KEY (id_espacio)
);
COMMENT ON TABLE public.espacio IS 'Espacio dentro del lugar donde se realiza el proyecto.';
COMMENT ON COLUMN public.espacio.id_espacio IS 'Identificador único del espacio.';
COMMENT ON COLUMN public.espacio.no_espacio IS 'Nombre del espacio.';
COMMENT ON COLUMN public.espacio.id_lugar IS 'Identificador único del lugar.';


ALTER SEQUENCE public.espacio_sq OWNED BY public.espacio.id_espacio;

CREATE SEQUENCE public.tipo_documento_sq;

CREATE TABLE public.tipo_documento (
                id_tipo_documento INTEGER NOT NULL DEFAULT nextval('public.tipo_documento_sq'),
                no_tipo_documento VARCHAR(100) NOT NULL,
                CONSTRAINT tipo_documento_pk PRIMARY KEY (id_tipo_documento)
);
COMMENT ON TABLE public.tipo_documento IS 'Tipo del documento cargado.';
COMMENT ON COLUMN public.tipo_documento.id_tipo_documento IS 'Identificador único del tipo de documento.';
COMMENT ON COLUMN public.tipo_documento.no_tipo_documento IS 'Nombre del tipo de documento.';


ALTER SEQUENCE public.tipo_documento_sq OWNED BY public.tipo_documento.id_tipo_documento;

CREATE SEQUENCE public.tipo_item_sq;

CREATE TABLE public.tipo_item (
                id_tipo_item INTEGER NOT NULL DEFAULT nextval('public.tipo_item_sq'),
                no_tipo_item VARCHAR(100) NOT NULL,
                CONSTRAINT tipo_item_pk PRIMARY KEY (id_tipo_item)
);
COMMENT ON TABLE public.tipo_item IS 'Tipo o rubro del item de pago del proyecto.';
COMMENT ON COLUMN public.tipo_item.id_tipo_item IS 'Identificador único del tipo de ítem.';
COMMENT ON COLUMN public.tipo_item.no_tipo_item IS 'Nombre del tipo de ítem.';


ALTER SEQUENCE public.tipo_item_sq OWNED BY public.tipo_item.id_tipo_item;

CREATE SEQUENCE public.tipo_proyecto_sq;

CREATE TABLE public.tipo_proyecto (
                id_tipo_proyecto INTEGER NOT NULL DEFAULT nextval('public.tipo_proyecto_sq'),
                no_tipo_proyecto VARCHAR(100) NOT NULL,
                CONSTRAINT tipo_proyecto_pk PRIMARY KEY (id_tipo_proyecto)
);
COMMENT ON TABLE public.tipo_proyecto IS 'Tipo de proyecto.';
COMMENT ON COLUMN public.tipo_proyecto.id_tipo_proyecto IS 'Identificador único del tipo de proyecto.';
COMMENT ON COLUMN public.tipo_proyecto.no_tipo_proyecto IS 'Nombre del tipo de proyecto.';


ALTER SEQUENCE public.tipo_proyecto_sq OWNED BY public.tipo_proyecto.id_tipo_proyecto;

CREATE SEQUENCE public.organismo_sq;

CREATE TABLE public.organismo (
                id_organismo INTEGER NOT NULL DEFAULT nextval('public.organismo_sq'),
                no_organismo VARCHAR(100) NOT NULL,
                co_cuit VARCHAR(15),
                tx_direccion VARCHAR(200),
                ds_observaciones VARCHAR(400),
                CONSTRAINT organismo_pk PRIMARY KEY (id_organismo)
);
COMMENT ON TABLE public.organismo IS 'Organismo relacionado a los convenios y pagos de los proyectos.';
COMMENT ON COLUMN public.organismo.id_organismo IS 'Identificador único del organismo.';
COMMENT ON COLUMN public.organismo.no_organismo IS 'Nombre del organismo.';
COMMENT ON COLUMN public.organismo.co_cuit IS 'Número de CUIT del organismo.';
COMMENT ON COLUMN public.organismo.tx_direccion IS 'Dirección del organismo.';
COMMENT ON COLUMN public.organismo.ds_observaciones IS 'Observaciones generales sobre el organismo.';


ALTER SEQUENCE public.organismo_sq OWNED BY public.organismo.id_organismo;

CREATE SEQUENCE public.area_requirente_sq;

CREATE TABLE public.area_requirente (
                id_area_requirente INTEGER NOT NULL DEFAULT nextval('public.area_requirente_sq'),
                no_area_requirente VARCHAR(100) NOT NULL,
                CONSTRAINT area_requirente_pk PRIMARY KEY (id_area_requirente)
);
COMMENT ON TABLE public.area_requirente IS 'Área requirente del proyecto.';
COMMENT ON COLUMN public.area_requirente.id_area_requirente IS 'Identificador único del área requirente.';
COMMENT ON COLUMN public.area_requirente.no_area_requirente IS 'Nombre del área requirente.';


ALTER SEQUENCE public.area_requirente_sq OWNED BY public.area_requirente.id_area_requirente;

CREATE SEQUENCE public.convenio_sq;

CREATE TABLE public.convenio (
                id_convenio INTEGER NOT NULL DEFAULT nextval('public.convenio_sq'),
                no_convenio VARCHAR(100) NOT NULL,
                id_organismo INTEGER NOT NULL,
                va_monto DOUBLE PRECISION,
                ds_descripcion VARCHAR(400),
                CONSTRAINT convenio_pk PRIMARY KEY (id_convenio)
);
COMMENT ON TABLE public.convenio IS 'Convenios.';
COMMENT ON COLUMN public.convenio.id_convenio IS 'Identificador único del convenio.';
COMMENT ON COLUMN public.convenio.no_convenio IS 'Nombre del convenio.';
COMMENT ON COLUMN public.convenio.id_organismo IS 'Identificador único del organismo.';
COMMENT ON COLUMN public.convenio.va_monto IS 'Valor del convenio.';
COMMENT ON COLUMN public.convenio.ds_descripcion IS 'Descripción del convenio.';


ALTER SEQUENCE public.convenio_sq OWNED BY public.convenio.id_convenio;

CREATE SEQUENCE public.proyecto_sq;

CREATE TABLE public.proyecto (
                id_proyecto INTEGER NOT NULL DEFAULT nextval('public.proyecto_sq'),
                nu_proyecto INTEGER,
                no_proyecto VARCHAR(100) NOT NULL,
                id_tipo_proyecto INTEGER NOT NULL,
                id_convenio INTEGER NOT NULL,
                id_area_requirente INTEGER,
                id_lugar INTEGER,
                va_monto_proyecto DOUBLE PRECISION,
                tx_cronograma VARCHAR(200),
                ds_observaciones VARCHAR(400),
                CONSTRAINT proyecto_pk PRIMARY KEY (id_proyecto)
);
COMMENT ON TABLE public.proyecto IS 'Proyecto enmarcado dentro del convenio con un organismo.';
COMMENT ON COLUMN public.proyecto.id_proyecto IS 'Identificador único del proyecto.';
COMMENT ON COLUMN public.proyecto.nu_proyecto IS 'Número del proyecto en la planilla.';
COMMENT ON COLUMN public.proyecto.no_proyecto IS 'Nombre del proyecto.';
COMMENT ON COLUMN public.proyecto.id_tipo_proyecto IS 'Identificador único del tipo de proyecto.';
COMMENT ON COLUMN public.proyecto.id_convenio IS 'Identificador único del convenio.';
COMMENT ON COLUMN public.proyecto.id_area_requirente IS 'Identificador único del área requirente.';
COMMENT ON COLUMN public.proyecto.id_lugar IS 'Identificador único del lugar.';
COMMENT ON COLUMN public.proyecto.va_monto_proyecto IS 'Monto del proyecto sin comisión.';
COMMENT ON COLUMN public.proyecto.tx_cronograma IS 'Cronograma del proyecto.';
COMMENT ON COLUMN public.proyecto.ds_observaciones IS 'Observaciones generales sobre el proyecto.';


ALTER SEQUENCE public.proyecto_sq OWNED BY public.proyecto.id_proyecto;

CREATE SEQUENCE public.factura_sq;

CREATE TABLE public.factura (
                id_factura INTEGER NOT NULL DEFAULT nextval('public.factura_sq'),
                id_proyecto INTEGER,
                nu_factura VARCHAR(20) NOT NULL,
                fe_factura DATE NOT NULL,
                nu_cuota INTEGER,
                va_factura DOUBLE PRECISION NOT NULL,
                CONSTRAINT factura_pk PRIMARY KEY (id_factura)
);
COMMENT ON TABLE public.factura IS 'Factura relacionada al pago del proyecto.';
COMMENT ON COLUMN public.factura.id_factura IS 'Identificador único de la factura.';
COMMENT ON COLUMN public.factura.id_proyecto IS 'Identificador único del proyecto.';
COMMENT ON COLUMN public.factura.nu_factura IS 'Número de la factura.';
COMMENT ON COLUMN public.factura.fe_factura IS 'Fecha de la factura.';
COMMENT ON COLUMN public.factura.nu_cuota IS 'Número de cuota de la factura.';
COMMENT ON COLUMN public.factura.va_factura IS 'Importe total facturado.';


ALTER SEQUENCE public.factura_sq OWNED BY public.factura.id_factura;

CREATE SEQUENCE public.item_sq;

CREATE TABLE public.item (
                id_item INTEGER NOT NULL DEFAULT nextval('public.item_sq'),
                id_proyecto INTEGER NOT NULL,
                id_proveedor INTEGER,
                id_espacio INTEGER,
                id_tipo_item INTEGER NOT NULL,
                no_item VARCHAR(100),
                va_importe DOUBLE PRECISION DEFAULT 0 NOT NULL,
                va_iva DOUBLE PRECISION DEFAULT 0 NOT NULL,
                va_monto_item DOUBLE PRECISION DEFAULT 0 NOT NULL,
                id_organismo INTEGER,
                tx_estado VARCHAR(100),
                tx_expediente VARCHAR(100),
                id_factura INTEGER,
                CONSTRAINT item_pk PRIMARY KEY (id_item)
);
COMMENT ON TABLE public.item IS 'Ítem de pago dentro del proyecto.';
COMMENT ON COLUMN public.item.id_item IS 'Identificador único del ítem.';
COMMENT ON COLUMN public.item.id_proyecto IS 'Identificador único del proyecto.';
COMMENT ON COLUMN public.item.id_proveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN public.item.id_espacio IS 'Identificador único del espacio.';
COMMENT ON COLUMN public.item.id_tipo_item IS 'Identificador único del tipo de ítem.';
COMMENT ON COLUMN public.item.no_item IS 'Detalle del ítem.';
COMMENT ON COLUMN public.item.va_importe IS 'Importe del ítem.';
COMMENT ON COLUMN public.item.va_iva IS 'Valor de IVA sobre el importe del ítem.';
COMMENT ON COLUMN public.item.va_monto_item IS 'Monto total del ítem del proyecto.';
COMMENT ON COLUMN public.item.id_organismo IS 'Identificador único del organismo.';
COMMENT ON COLUMN public.item.tx_estado IS 'Estado del ítem.';
COMMENT ON COLUMN public.item.tx_expediente IS 'Expediente relacionado con el ítem del proyecto.';
COMMENT ON COLUMN public.item.id_factura IS 'Identificador único de la factura.';


ALTER SEQUENCE public.item_sq OWNED BY public.item.id_item;

CREATE SEQUENCE public.documento_sq;

CREATE TABLE public.documento (
                id_documento INTEGER NOT NULL DEFAULT nextval('public.documento_sq'),
                no_documento VARCHAR(100),
                id_tipo_documento INTEGER NOT NULL,
                id_proyecto INTEGER NOT NULL,
                fi_archivo BYTEA,
                CONSTRAINT documento_pk PRIMARY KEY (id_documento)
);
COMMENT ON TABLE public.documento IS 'Documento relacionado con el proyecto.';
COMMENT ON COLUMN public.documento.id_documento IS 'Identificador único del documento.';
COMMENT ON COLUMN public.documento.no_documento IS 'Nombre del documento.';
COMMENT ON COLUMN public.documento.id_tipo_documento IS 'Identificador único del tipo de documento.';
COMMENT ON COLUMN public.documento.id_proyecto IS 'Identificador único del proyecto.';
COMMENT ON COLUMN public.documento.fi_archivo IS 'Archivo del documento.';


ALTER SEQUENCE public.documento_sq OWNED BY public.documento.id_documento;

ALTER TABLE public.item ADD CONSTRAINT proveedor_item_fk
FOREIGN KEY (id_proveedor)
REFERENCES public.proveedor (id_proveedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.proyecto ADD CONSTRAINT lugar_proyecto_fk
FOREIGN KEY (id_lugar)
REFERENCES public.lugar (id_lugar)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.espacio ADD CONSTRAINT lugar_espacio_fk
FOREIGN KEY (id_lugar)
REFERENCES public.lugar (id_lugar)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.item ADD CONSTRAINT espacio_item_fk
FOREIGN KEY (id_espacio)
REFERENCES public.espacio (id_espacio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.documento ADD CONSTRAINT tipo_documento_documento_fk
FOREIGN KEY (id_tipo_documento)
REFERENCES public.tipo_documento (id_tipo_documento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.item ADD CONSTRAINT tipo_item_item_fk
FOREIGN KEY (id_tipo_item)
REFERENCES public.tipo_item (id_tipo_item)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.proyecto ADD CONSTRAINT tipo_proyecto_proyecto_fk
FOREIGN KEY (id_tipo_proyecto)
REFERENCES public.tipo_proyecto (id_tipo_proyecto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.convenio ADD CONSTRAINT organismo_convenio_fk
FOREIGN KEY (id_organismo)
REFERENCES public.organismo (id_organismo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.item ADD CONSTRAINT organismo_item_fk
FOREIGN KEY (id_organismo)
REFERENCES public.organismo (id_organismo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.proyecto ADD CONSTRAINT area_requirente_proyecto_fk
FOREIGN KEY (id_area_requirente)
REFERENCES public.area_requirente (id_area_requirente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.proyecto ADD CONSTRAINT convenio_proyecto_fk
FOREIGN KEY (id_convenio)
REFERENCES public.convenio (id_convenio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.documento ADD CONSTRAINT proyecto_documento_fk
FOREIGN KEY (id_proyecto)
REFERENCES public.proyecto (id_proyecto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.item ADD CONSTRAINT proyecto_item_fk
FOREIGN KEY (id_proyecto)
REFERENCES public.proyecto (id_proyecto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.factura ADD CONSTRAINT proyecto_factura_fk
FOREIGN KEY (id_proyecto)
REFERENCES public.proyecto (id_proyecto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.item ADD CONSTRAINT factura_item_fk
FOREIGN KEY (id_factura)
REFERENCES public.factura (id_factura)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
