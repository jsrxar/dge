
CREATE SEQUENCE public.cont_oc_sq;

CREATE TABLE public.cont_oc (
                id_cont_oc INTEGER NOT NULL DEFAULT nextval('public.cont_oc_sq'),
                no_cont_oc VARCHAR(100) NOT NULL,
                CONSTRAINT cont_oc_pk PRIMARY KEY (id_cont_oc)
);
COMMENT ON TABLE public.cont_oc IS 'CONT / OC del expediente.';
COMMENT ON COLUMN public.cont_oc.id_cont_oc IS 'Identificador único del CONT / OC.';
COMMENT ON COLUMN public.cont_oc.no_cont_oc IS 'CONT/OC del proyecto.';


ALTER SEQUENCE public.cont_oc_sq OWNED BY public.cont_oc.id_cont_oc;

CREATE SEQUENCE public.finalizado_sq;

CREATE TABLE public.finalizado (
                id_finalizado INTEGER NOT NULL DEFAULT nextval('public.finalizado_sq'),
                no_finalizado VARCHAR(100) NOT NULL,
                CONSTRAINT finalizado_pk PRIMARY KEY (id_finalizado)
);
COMMENT ON TABLE public.finalizado IS 'Estado finalizado del expediente.';
COMMENT ON COLUMN public.finalizado.id_finalizado IS 'Identificador único del estado de finalización del expediente.';
COMMENT ON COLUMN public.finalizado.no_finalizado IS 'Nombre del estado de finalización del expediente.';


ALTER SEQUENCE public.finalizado_sq OWNED BY public.finalizado.id_finalizado;

CREATE SEQUENCE public.ubicacion_interna_sq;

CREATE TABLE public.ubicacion_interna (
                id_ubicacion_interna INTEGER NOT NULL DEFAULT nextval('public.ubicacion_interna_sq'),
                no_ubicacion_interna VARCHAR(100) NOT NULL,
                CONSTRAINT ubicacion_interna_pk PRIMARY KEY (id_ubicacion_interna)
);
COMMENT ON TABLE public.ubicacion_interna IS 'Ubicación interna del expediente.';
COMMENT ON COLUMN public.ubicacion_interna.id_ubicacion_interna IS 'Identificador único de la ubicación interna del expediente.';
COMMENT ON COLUMN public.ubicacion_interna.no_ubicacion_interna IS 'Nombre de la ubicación interna del expediente.';


ALTER SEQUENCE public.ubicacion_interna_sq OWNED BY public.ubicacion_interna.id_ubicacion_interna;

CREATE SEQUENCE public.estado_sq;

CREATE TABLE public.estado (
                id_estado INTEGER NOT NULL DEFAULT nextval('public.estado_sq'),
                no_estado VARCHAR(100) NOT NULL,
                CONSTRAINT estado_pk PRIMARY KEY (id_estado)
);
COMMENT ON TABLE public.estado IS 'Estado del expediente.';
COMMENT ON COLUMN public.estado.id_estado IS 'Identificador único del estado del expediente.';
COMMENT ON COLUMN public.estado.no_estado IS 'Nombre del estado del expediente.';


ALTER SEQUENCE public.estado_sq OWNED BY public.estado.id_estado;

CREATE SEQUENCE public.destino_sq;

CREATE TABLE public.sector_destino (
                id_sector_destino INTEGER NOT NULL DEFAULT nextval('public.destino_sq'),
                no_sector_destino VARCHAR(100) NOT NULL,
                CONSTRAINT sector_destino_pk PRIMARY KEY (id_sector_destino)
);
COMMENT ON TABLE public.sector_destino IS 'Sector de destino del envío del expediente.';
COMMENT ON COLUMN public.sector_destino.id_sector_destino IS 'Identificador único del sector de destino.';
COMMENT ON COLUMN public.sector_destino.no_sector_destino IS 'Nombre del sector de destino del expediente.';


ALTER SEQUENCE public.destino_sq OWNED BY public.sector_destino.id_sector_destino;

CREATE SEQUENCE public.reparticion_sq;

CREATE TABLE public.reparticion (
                id_reparticion INTEGER NOT NULL DEFAULT nextval('public.reparticion_sq'),
                no_reparticion VARCHAR(100) NOT NULL,
                CONSTRAINT reparticion_pk PRIMARY KEY (id_reparticion)
);
COMMENT ON TABLE public.reparticion IS 'Nombre de la repartición.';
COMMENT ON COLUMN public.reparticion.id_reparticion IS 'Identificador único de la repartición.';
COMMENT ON COLUMN public.reparticion.no_reparticion IS 'Nombre de la repartición.';


ALTER SEQUENCE public.reparticion_sq OWNED BY public.reparticion.id_reparticion;

CREATE SEQUENCE public.contratacion_sq;

CREATE TABLE public.tipo_contratacion (
                id_tipo_contratacion INTEGER NOT NULL DEFAULT nextval('public.contratacion_sq'),
                no_tipo_contratacion VARCHAR(100) NOT NULL,
                CONSTRAINT tipo_contratacion_pk PRIMARY KEY (id_tipo_contratacion)
);
COMMENT ON TABLE public.tipo_contratacion IS 'Tipo de contratación del expediente.';
COMMENT ON COLUMN public.tipo_contratacion.id_tipo_contratacion IS 'Identificador único del tipo de contratación.';
COMMENT ON COLUMN public.tipo_contratacion.no_tipo_contratacion IS 'Nombre del tipo de contratación del expediente.';


ALTER SEQUENCE public.contratacion_sq OWNED BY public.tipo_contratacion.id_tipo_contratacion;

CREATE SEQUENCE public.tipo_bien_servicio_sq;

CREATE TABLE public.tipo_bien_servicio (
                id_tipo_bien_servicio INTEGER NOT NULL DEFAULT nextval('public.tipo_bien_servicio_sq'),
                no_tipo_bien_servicio VARCHAR(100) NOT NULL,
                CONSTRAINT tipo_bien_servicio_pk PRIMARY KEY (id_tipo_bien_servicio)
);
COMMENT ON TABLE public.tipo_bien_servicio IS 'Tipo de bien o servicio del expediente.';
COMMENT ON COLUMN public.tipo_bien_servicio.id_tipo_bien_servicio IS 'Identificador único del tipo de bien o servicio.';
COMMENT ON COLUMN public.tipo_bien_servicio.no_tipo_bien_servicio IS 'Nombre del tipo de bien o servicio.';


ALTER SEQUENCE public.tipo_bien_servicio_sq OWNED BY public.tipo_bien_servicio.id_tipo_bien_servicio;

CREATE SEQUENCE public.proveedor_sq;

CREATE TABLE public.proveedor (
                id_proveedor INTEGER NOT NULL DEFAULT nextval('public.proveedor_sq'),
                no_proveedor VARCHAR(200) NOT NULL,
                CONSTRAINT proveedor_pk PRIMARY KEY (id_proveedor)
);
COMMENT ON TABLE public.proveedor IS 'Proveedor asociado al expediente.';
COMMENT ON COLUMN public.proveedor.id_proveedor IS 'Identificador único del proveedor.';
COMMENT ON COLUMN public.proveedor.no_proveedor IS 'Nombre del proveedor.';


ALTER SEQUENCE public.proveedor_sq OWNED BY public.proveedor.id_proveedor;

CREATE SEQUENCE public.expediente_sq;

CREATE TABLE public.expediente (
                id_expediente INTEGER NOT NULL DEFAULT nextval('public.expediente_sq'),
                co_expediente VARCHAR(50),
                nu_expediente INTEGER,
                nu_anio_expediente INTEGER,
                no_caratula VARCHAR(100) NOT NULL,
                fe_origen DATE,
                id_proveedor INTEGER,
                ds_emp_sugeridas VARCHAR(200),
                va_monto REAL,
                va_monto_pagado REAL,
                id_tipo_bien_servicio INTEGER,
                id_tipo_contratacion INTEGER,
                id_reparticion_solicitante INTEGER,
                id_reparticion_destino INTEGER,
                fe_responsable DATE,
                fe_compras_ingreso DATE,
                fe_compras_salida DATE,
                id_sector_destino INTEGER,
                id_estado INTEGER,
                ds_estado VARCHAR(1000),
                id_ubicacion_interna INTEGER,
                co_cuit VARCHAR(100),
                ds_beneficiario VARCHAR(100),
                ds_facturas VARCHAR(200),
                ds_orden_pago VARCHAR(100),
                ds_observaciones VARCHAR(1000),
                id_finalizado INTEGER,
                id_cont_oc INTEGER,
                CONSTRAINT expediente_pk PRIMARY KEY (id_expediente)
);
COMMENT ON TABLE public.expediente IS 'Expediente.';
COMMENT ON COLUMN public.expediente.id_expediente IS 'Identificador único del expediente.';
COMMENT ON COLUMN public.expediente.co_expediente IS 'Código del expediente.';
COMMENT ON COLUMN public.expediente.nu_expediente IS 'Número del expediente.';
COMMENT ON COLUMN public.expediente.nu_anio_expediente IS 'Año del expediente.';
COMMENT ON COLUMN public.expediente.no_caratula IS 'Carátula del expediente.';
COMMENT ON COLUMN public.expediente.fe_origen IS 'Origen Fecha.';
COMMENT ON COLUMN public.expediente.id_proveedor IS 'Proveedor del expediente.';
COMMENT ON COLUMN public.expediente.ds_emp_sugeridas IS 'Empresas sugeridas como proveedor.';
COMMENT ON COLUMN public.expediente.va_monto IS 'Monto total del expediente.';
COMMENT ON COLUMN public.expediente.va_monto_pagado IS 'Monto pagado del expediente.';
COMMENT ON COLUMN public.expediente.id_tipo_bien_servicio IS 'Tipo de bien o servicio.';
COMMENT ON COLUMN public.expediente.id_tipo_contratacion IS 'Tipo de contratación.';
COMMENT ON COLUMN public.expediente.id_reparticion_solicitante IS 'Repartición solicitante.';
COMMENT ON COLUMN public.expediente.id_reparticion_destino IS 'Repartición destino del expediente.';
COMMENT ON COLUMN public.expediente.fe_responsable IS 'Fecha Responsable.';
COMMENT ON COLUMN public.expediente.fe_compras_ingreso IS 'Fecha de ingreso a compras del expediente.';
COMMENT ON COLUMN public.expediente.fe_compras_salida IS 'Fecha de salida de compras del expediente.';
COMMENT ON COLUMN public.expediente.id_sector_destino IS 'Sector de destino del expediente.';
COMMENT ON COLUMN public.expediente.id_estado IS 'Estado del expediente.';
COMMENT ON COLUMN public.expediente.ds_estado IS 'Detalle del estado del expediente.';
COMMENT ON COLUMN public.expediente.id_ubicacion_interna IS 'Ubicación interna del expediente.';
COMMENT ON COLUMN public.expediente.co_cuit IS 'CUIT relacionado con el expediente.';
COMMENT ON COLUMN public.expediente.ds_beneficiario IS 'Descripción del Número de Beneficiario.';
COMMENT ON COLUMN public.expediente.ds_facturas IS 'Facturas relacionadas con el expediente.';
COMMENT ON COLUMN public.expediente.ds_orden_pago IS 'Orden de pago del expediente.';
COMMENT ON COLUMN public.expediente.ds_observaciones IS 'Observaciones del expediente.';
COMMENT ON COLUMN public.expediente.id_finalizado IS 'Estado de finalización del expediente.';
COMMENT ON COLUMN public.expediente.id_cont_oc IS 'CONT / OC';


ALTER SEQUENCE public.expediente_sq OWNED BY public.expediente.id_expediente;

CREATE INDEX expediente_uk
 ON public.expediente
 ( co_expediente ASC );

CREATE TABLE public.stg_expedientes (
                ds_expediente VARCHAR(100),
                ds_origen_fecha VARCHAR(100),
                ds_caratula VARCHAR(100),
                ds_proveedor VARCHAR(200),
                ds_monto VARCHAR(100),
                ds_tipo_bien_servicio VARCHAR(100),
                ds_tipo_contratacion VARCHAR(100),
                ds_reparticion_solicitante VARCHAR(100),
                ds_reparticion_destino VARCHAR(100),
                ds_responsable VARCHAR(100),
                ds_fecha_ingreso_compras VARCHAR(100),
                ds_fecha_salida_compras VARCHAR(100),
                ds_envio_a VARCHAR(100),
                ds_estado_1 VARCHAR(1000),
                ds_observaciones_1 VARCHAR(1000),
                ds_ubicacion_interna VARCHAR(100),
                ds_cuit VARCHAR(100),
                ds_nro_beneficiario VARCHAR(100),
                ds_nro_facturas VARCHAR(200),
                ds_orden_pago VARCHAR(100),
                ds_monto_pagado VARCHAR(100),
                ds_estado_2 VARCHAR(100),
                ds_observaciones_2 VARCHAR(1000),
                ds_finalizado VARCHAR(100),
                ds_cont_oc VARCHAR(100)
);
COMMENT ON TABLE public.stg_expedientes IS 'Base de datos de expedientes de compras.';


ALTER TABLE public.expediente ADD CONSTRAINT cont_oc_expediente_fk
FOREIGN KEY (id_cont_oc)
REFERENCES public.cont_oc (id_cont_oc)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT finalizado_expediente_fk
FOREIGN KEY (id_finalizado)
REFERENCES public.finalizado (id_finalizado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT ubicacion_interna_expediente_fk
FOREIGN KEY (id_ubicacion_interna)
REFERENCES public.ubicacion_interna (id_ubicacion_interna)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT estado_expediente_fk
FOREIGN KEY (id_estado)
REFERENCES public.estado (id_estado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT sector_destino_expediente_fk
FOREIGN KEY (id_sector_destino)
REFERENCES public.sector_destino (id_sector_destino)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT reparticion_expediente_fk
FOREIGN KEY (id_reparticion_solicitante)
REFERENCES public.reparticion (id_reparticion)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT reparticion_expediente_fk1
FOREIGN KEY (id_reparticion_destino)
REFERENCES public.reparticion (id_reparticion)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT tipo_contratacion_expediente_fk
FOREIGN KEY (id_tipo_contratacion)
REFERENCES public.tipo_contratacion (id_tipo_contratacion)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT tipo_bien_servicio_expediente_fk
FOREIGN KEY (id_tipo_bien_servicio)
REFERENCES public.tipo_bien_servicio (id_tipo_bien_servicio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.expediente ADD CONSTRAINT proveedor_expediente_fk
FOREIGN KEY (id_proveedor)
REFERENCES public.proveedor (id_proveedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
