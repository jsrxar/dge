CREATE SEQUENCE public.stg_carga_sq;

CREATE TABLE public.stg_periodicidad (
                id_carga BIGINT NOT NULL DEFAULT nextval('public.stg_carga_sq'),
                no_archivo VARCHAR(100),
                fe_carga TIMESTAMP,
                co_estado_proceso CHAR(1),
                tx_accion VARCHAR(50),
                tx_bien VARCHAR(100),
                tx_espacio VARCHAR(100),
                tx_cat_bien VARCHAR(100),
                tx_cat_espacio VARCHAR(100),
                tx_tipo_accion VARCHAR(100),
                tx_metodologia VARCHAR(400),
                tx_frecuencia VARCHAR(50),
                tx_frecuencia_req VARCHAR(50),
                tx_duracion VARCHAR(50),
                tx_qt_recursos VARCHAR(50),
                CONSTRAINT stg_fichadas_pk PRIMARY KEY (id_carga)
);

ALTER SEQUENCE public.stg_carga_sq OWNED BY public.stg_periodicidad.id_carga;
