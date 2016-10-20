
CREATE SEQUENCE public.artista_sq;

CREATE TABLE public.artista (
                id_artista INTEGER NOT NULL DEFAULT nextval('public.artista_sq'),
                no_artista VARCHAR(100) NOT NULL,
                fi_contrato BYTEA,
                CONSTRAINT artista_pk PRIMARY KEY (id_artista)
);
COMMENT ON TABLE public.artista IS 'Artista que se presenta en un proyecto.';
COMMENT ON COLUMN public.artista.id_artista IS 'Identificador único del artista.';
COMMENT ON COLUMN public.artista.no_artista IS 'Nombre del artista.';
COMMENT ON COLUMN public.artista.fi_contrato IS 'Archivo del contrato con el artista.';


ALTER SEQUENCE public.artista_sq OWNED BY public.artista.id_artista;

CREATE SEQUENCE public.proveedor_sq;

CREATE TABLE public.proveedor (
                id_proveedor INTEGER NOT NULL DEFAULT nextval('public.proveedor_sq'),
                no_proveedor VARCHAR(100) NOT NULL,
                fl_cuit BOOLEAN,
                fl_estatuto BOOLEAN,
                fl_dni BOOLEAN,
                fl_poder BOOLEAN,
                fl_sipro BOOLEAN,
                fl_cert_fiscal BOOLEAN,
                fl_cbu BOOLEAN,
                flg_cv BOOLEAN,
                ds_observaciones VARCHAR(400),
                CONSTRAINT proveedor_pk PRIMARY KEY (id_proveedor)
);
COMMENT ON TABLE public.proveedor IS 'Proveedor que realiza el trabajo relacionado al ítem del proyecto.';
COMMENT ON COLUMN public.proveedor.id_proveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN public.proveedor.no_proveedor IS 'Nombre del proveedor.';
COMMENT ON COLUMN public.proveedor.fl_cuit IS 'Número de CUIT?.';
COMMENT ON COLUMN public.proveedor.fl_estatuto IS 'Estatuto?.';
COMMENT ON COLUMN public.proveedor.fl_dni IS 'Documento Nacional de Identidad?';
COMMENT ON COLUMN public.proveedor.fl_poder IS 'Poder?';
COMMENT ON COLUMN public.proveedor.fl_sipro IS 'SIPRO?';
COMMENT ON COLUMN public.proveedor.fl_cert_fiscal IS 'Certificado Fiscal?';
COMMENT ON COLUMN public.proveedor.fl_cbu IS 'CBU?';
COMMENT ON COLUMN public.proveedor.flg_cv IS 'CV?';
COMMENT ON COLUMN public.proveedor.ds_observaciones IS 'Observaciones generales sobre el proveedor.';


ALTER SEQUENCE public.proveedor_sq OWNED BY public.proveedor.id_proveedor;

CREATE SEQUENCE public.contacto_sq;

CREATE TABLE public.contacto (
                id_contacto INTEGER NOT NULL DEFAULT nextval('public.contacto_sq'),
                no_contacto VARCHAR(100),
                id_proveedor INTEGER NOT NULL,
                tx_telefono_proveedor VARCHAR(50),
                tx_email_proveedor VARCHAR(100),
                CONSTRAINT contacto_pk PRIMARY KEY (id_contacto)
);
COMMENT ON TABLE public.contacto IS 'Contacto del proveedor.';
COMMENT ON COLUMN public.contacto.id_contacto IS 'Identificador único del contacto del proveedor.';
COMMENT ON COLUMN public.contacto.no_contacto IS 'Nombre del contacto del proveedor.';
COMMENT ON COLUMN public.contacto.id_proveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN public.contacto.tx_telefono_proveedor IS 'Número de teléfono del contacto del proveedor.';
COMMENT ON COLUMN public.contacto.tx_email_proveedor IS 'E-Mail del contacto del proveedor.';


ALTER SEQUENCE public.contacto_sq OWNED BY public.contacto.id_contacto;

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
                ds_organismo VARCHAR(100),
                co_cuit VARCHAR(15),
                tx_direccion VARCHAR(200),
                ds_observaciones VARCHAR(400),
                CONSTRAINT organismo_pk PRIMARY KEY (id_organismo)
);
COMMENT ON TABLE public.organismo IS 'Organismo relacionado a los convenios y pagos de los proyectos.';
COMMENT ON COLUMN public.organismo.id_organismo IS 'Identificador único del organismo.';
COMMENT ON COLUMN public.organismo.no_organismo IS 'Nombre del organismo.';
COMMENT ON COLUMN public.organismo.ds_organismo IS 'Descripción del organismo (nombre extendido).';
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
                id_organismo INTEGER,
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
                fl_estado BOOLEAN,
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
COMMENT ON COLUMN public.proyecto.fl_estado IS 'Si el estado está OK.';
COMMENT ON COLUMN public.proyecto.ds_observaciones IS 'Observaciones generales sobre el proyecto.';


ALTER SEQUENCE public.proyecto_sq OWNED BY public.proyecto.id_proyecto;

CREATE SEQUENCE public.item_sq;

CREATE TABLE public.item (
                id_item INTEGER NOT NULL DEFAULT nextval('public.item_sq'),
                id_proyecto INTEGER NOT NULL,
                id_tipo_item INTEGER,
                id_proveedor INTEGER,
                id_artista INTEGER,
                no_item VARCHAR(100),
                va_monto_item DOUBLE PRECISION DEFAULT 0,
                va_anticipo DOUBLE PRECISION DEFAULT 0,
                fl_anticipo BOOLEAN,
                va_saldo DOUBLE PRECISION DEFAULT 0,
                fi_contrato BYTEA,
                ds_observaciones VARCHAR(400),
                CONSTRAINT item_pk PRIMARY KEY (id_item)
);
COMMENT ON TABLE public.item IS 'Ítem de pago dentro del proyecto.';
COMMENT ON COLUMN public.item.id_item IS 'Identificador único del ítem.';
COMMENT ON COLUMN public.item.id_proyecto IS 'Identificador único del proyecto.';
COMMENT ON COLUMN public.item.id_tipo_item IS 'Identificador único del tipo de ítem.';
COMMENT ON COLUMN public.item.id_proveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN public.item.id_artista IS 'Identificador único del artista.';
COMMENT ON COLUMN public.item.no_item IS 'Detalle del ítem.';
COMMENT ON COLUMN public.item.va_monto_item IS 'Monto total del ítem del proyecto.';
COMMENT ON COLUMN public.item.va_anticipo IS 'Anticipo a pagar por el ítem de pago.';
COMMENT ON COLUMN public.item.fl_anticipo IS 'Pago del anticipo?.';
COMMENT ON COLUMN public.item.va_saldo IS 'Saldo con el proveedor.';
COMMENT ON COLUMN public.item.fi_contrato IS 'Archivo del contrato con el artista.';
COMMENT ON COLUMN public.item.ds_observaciones IS 'Observaciones generales sobre el ítem del proyecto.';


ALTER SEQUENCE public.item_sq OWNED BY public.item.id_item;

ALTER TABLE public.item ADD CONSTRAINT artista_item_fk
FOREIGN KEY (id_artista)
REFERENCES public.artista (id_artista)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.item ADD CONSTRAINT proveedor_item_fk
FOREIGN KEY (id_proveedor)
REFERENCES public.proveedor (id_proveedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.contacto ADD CONSTRAINT proveedor_contacto_fk
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

ALTER TABLE public.item ADD CONSTRAINT proyecto_item_fk
FOREIGN KEY (id_proyecto)
REFERENCES public.proyecto (id_proyecto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
