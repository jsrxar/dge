
CREATE SEQUENCE public.dim_turno_sq;

CREATE TABLE public.dim_turno (
                id_turno SMALLINT NOT NULL DEFAULT nextval('public.dim_turno_sq'),
                no_turno VARCHAR(50),
                tx_banda_horaria VARCHAR(20) NOT NULL,
                CONSTRAINT dim_turno_pk PRIMARY KEY (id_turno)
);
COMMENT ON TABLE public.dim_turno IS 'Turno de trabajo.';
COMMENT ON COLUMN public.dim_turno.id_turno IS 'Identificador único del turno.';
COMMENT ON COLUMN public.dim_turno.no_turno IS 'Turno del horario de recambio.';
COMMENT ON COLUMN public.dim_turno.tx_banda_horaria IS 'Banda Horaria del turno.';


ALTER SEQUENCE public.dim_turno_sq OWNED BY public.dim_turno.id_turno;

CREATE SEQUENCE public.dim_tipo_hora_sq;

CREATE TABLE public.dim_tipo_hora (
                id_tipo_hora SMALLINT NOT NULL DEFAULT nextval('public.dim_tipo_hora_sq'),
                no_tipo_hora VARCHAR(100) NOT NULL,
                no_turno_hora VARCHAR(50),
                CONSTRAINT dim_tipo_hora_pk PRIMARY KEY (id_tipo_hora)
);
COMMENT ON TABLE public.dim_tipo_hora IS 'Tipo de horario de la fichada.';
COMMENT ON COLUMN public.dim_tipo_hora.id_tipo_hora IS 'Identificador único del tipo de hora.';
COMMENT ON COLUMN public.dim_tipo_hora.no_tipo_hora IS 'Nombre del tipo de hora.';
COMMENT ON COLUMN public.dim_tipo_hora.no_turno_hora IS 'Turno del horario de recambio.';


ALTER SEQUENCE public.dim_tipo_hora_sq OWNED BY public.dim_tipo_hora.id_tipo_hora;

CREATE TABLE public.dim_hora (
                id_hora BIGINT NOT NULL,
                no_hora_12 VARCHAR(8) NOT NULL,
                fe_hora TIME NOT NULL,
                no_hora_24 VARCHAR(5) NOT NULL,
                nu_hora_12 SMALLINT NOT NULL,
                nu_hora_24 SMALLINT NOT NULL,
                tx_am_pm CHAR(2) NOT NULL,
                nu_minuto SMALLINT NOT NULL,
                nu_minuto_dia INTEGER NOT NULL,
                tx_cuartos_hora VARCHAR(20) NOT NULL,
                id_turno8 SMALLINT DEFAULT 0 NOT NULL,
                id_turno8_tipo_hora SMALLINT DEFAULT 0 NOT NULL,
                CONSTRAINT dim_hora_pk PRIMARY KEY (id_hora)
);
COMMENT ON TABLE public.dim_hora IS 'Dimensión de representación de Horas y Minutos.';
COMMENT ON COLUMN public.dim_hora.id_hora IS 'Identificador único de la hora.';
COMMENT ON COLUMN public.dim_hora.no_hora_12 IS 'Hora y minutos en formato de 12 horas más AM / PM (12:00 AM a 11:59 PM).';
COMMENT ON COLUMN public.dim_hora.fe_hora IS 'Hora en formato de hora.';
COMMENT ON COLUMN public.dim_hora.no_hora_24 IS 'Hora en formato de 24 horas (00:00 a 23:59).';
COMMENT ON COLUMN public.dim_hora.nu_hora_12 IS 'Número de hora en formato de 12 horas.';
COMMENT ON COLUMN public.dim_hora.nu_hora_24 IS 'Número de hora en formato de 24 horas.';
COMMENT ON COLUMN public.dim_hora.tx_am_pm IS 'Identifica si la hora es AM o PM.';
COMMENT ON COLUMN public.dim_hora.nu_minuto IS 'Número de minuto dentro de la hora.';
COMMENT ON COLUMN public.dim_hora.nu_minuto_dia IS 'Número de minuto en el día.';
COMMENT ON COLUMN public.dim_hora.tx_cuartos_hora IS 'Cuarto de hora dentro de la hora.';
COMMENT ON COLUMN public.dim_hora.id_turno8 IS 'Identificador único del turno de 8 horas.';
COMMENT ON COLUMN public.dim_hora.id_turno8_tipo_hora IS 'Identificador único del tipo de hora en un turno de 8 horas.';


CREATE TABLE public.dim_origen (
                id_origen INTEGER NOT NULL,
                co_origen CHAR(1) NOT NULL,
                no_origen VARCHAR(100) NOT NULL,
                CONSTRAINT dim_origen_pk PRIMARY KEY (id_origen)
);
COMMENT ON TABLE public.dim_origen IS 'Dimensión de origen de las lecturas.';
COMMENT ON COLUMN public.dim_origen.id_origen IS 'Identificador único del origen de lectura.';
COMMENT ON COLUMN public.dim_origen.co_origen IS 'Código del origen de la lectura.';
COMMENT ON COLUMN public.dim_origen.no_origen IS 'Nombre del origen de la lectura.';


CREATE UNIQUE INDEX dim_origen_uk
 ON public.dim_origen
 ( co_origen );

CREATE SEQUENCE public.dim_empresa_area_sq;

CREATE TABLE public.dim_empresa_area (
                id_empresa_area INTEGER NOT NULL DEFAULT nextval('public.dim_empresa_area_sq'),
                no_empresa_area VARCHAR(100) NOT NULL,
                CONSTRAINT dim_empresa_area_pk PRIMARY KEY (id_empresa_area)
);
COMMENT ON TABLE public.dim_empresa_area IS 'Dimensión de Empresas / Áreas.';
COMMENT ON COLUMN public.dim_empresa_area.id_empresa_area IS 'Identificador único de Empresa o Área.';
COMMENT ON COLUMN public.dim_empresa_area.no_empresa_area IS 'Nombre de la Empresa o Área.';


ALTER SEQUENCE public.dim_empresa_area_sq OWNED BY public.dim_empresa_area.id_empresa_area;

CREATE UNIQUE INDEX dim_empresa_area_uk
 ON public.dim_empresa_area
 ( no_empresa_area );

CREATE SEQUENCE public.fac_totales_sq;

CREATE TABLE public.fac_totales (
                id_lectura BIGINT NOT NULL DEFAULT nextval('public.fac_totales_sq'),
                id_lugar INTEGER NOT NULL,
                id_persona INTEGER NOT NULL,
                id_fecha BIGINT NOT NULL,
                id_tipo_acreditacion INTEGER NOT NULL,
                id_empresa_area INTEGER,
                nu_lecturas INTEGER DEFAULT 1 NOT NULL,
                nu_persona_dias INTEGER NOT NULL,
                fe_hora_min TIMESTAMP,
                fe_hora_max TIMESTAMP,
                va_hora_min REAL,
                va_hora_max REAL,
                va_horas_total REAL NOT NULL,
                va_horas_media REAL,
                ds_observaciones VARCHAR(400) DEFAULT NULL::character varying,
                CONSTRAINT fac_totales_pk PRIMARY KEY (id_lectura)
);
COMMENT ON TABLE public.fac_totales IS 'Tabla de hecho de totales de horas de las lecturas.';
COMMENT ON COLUMN public.fac_totales.id_lectura IS 'Identificador único de la lectura.';
COMMENT ON COLUMN public.fac_totales.id_lugar IS 'Identificador único de lugar de lectura.';
COMMENT ON COLUMN public.fac_totales.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.fac_totales.id_fecha IS 'Identificador único de la fecha.';
COMMENT ON COLUMN public.fac_totales.id_tipo_acreditacion IS 'Identificador único del tipo de acreditación de la persona.';
COMMENT ON COLUMN public.fac_totales.id_empresa_area IS 'Identificador único de Empresa o Área.';
COMMENT ON COLUMN public.fac_totales.nu_lecturas IS 'Cantidad de lecturas.';
COMMENT ON COLUMN public.fac_totales.nu_persona_dias IS 'Cantidad de personas/días de las lecturas.';
COMMENT ON COLUMN public.fac_totales.fe_hora_min IS 'Fecha y Hora de la primera lectura.';
COMMENT ON COLUMN public.fac_totales.fe_hora_max IS 'Fecha y Hora de la última lectura.';
COMMENT ON COLUMN public.fac_totales.va_hora_min IS 'Fecha y Hora de la primera lectura.';
COMMENT ON COLUMN public.fac_totales.va_hora_max IS 'Fecha y Hora de la última lectura.';
COMMENT ON COLUMN public.fac_totales.va_horas_total IS 'Total de horas trabajadas en el día (Maximo - Mínimo).';
COMMENT ON COLUMN public.fac_totales.va_horas_media IS 'Promedio de horas trabajadas en el día.';
COMMENT ON COLUMN public.fac_totales.ds_observaciones IS 'Observaciones de la lectura.';


ALTER SEQUENCE public.fac_totales_sq OWNED BY public.fac_totales.id_lectura;

CREATE TABLE public.dim_fecha (
                id_fecha BIGINT NOT NULL,
                fe_fecha DATE NOT NULL,
                tx_fecha VARCHAR(10) NOT NULL,
                no_fecha VARCHAR(50) NOT NULL,
                nu_anio INTEGER NOT NULL,
                nu_mes INTEGER NOT NULL,
                no_mes VARCHAR(20) NOT NULL,
                nu_dia INTEGER NOT NULL,
                nu_dia_semana INTEGER NOT NULL,
                no_dia_semana VARCHAR(20) NOT NULL,
                nu_semana_anio INTEGER NOT NULL,
                nu_dia_ano INTEGER NOT NULL,
                nu_cuatrimestre INTEGER NOT NULL,
                fl_fin_semana VARCHAR(2) DEFAULT 'No' NOT NULL,
                fl_feriado VARCHAR(2) DEFAULT 'No' NOT NULL,
                no_estacion VARCHAR(20) NOT NULL,
                CONSTRAINT dim_fecha_pk PRIMARY KEY (id_fecha)
);
COMMENT ON TABLE public.dim_fecha IS 'Fecha de la lectura.';
COMMENT ON COLUMN public.dim_fecha.id_fecha IS 'Identificador único de la fecha.';
COMMENT ON COLUMN public.dim_fecha.fe_fecha IS 'Fecha real en formato de fecha.';
COMMENT ON COLUMN public.dim_fecha.tx_fecha IS 'Fecha real en formato de texto.';
COMMENT ON COLUMN public.dim_fecha.no_fecha IS 'Nombre completo de la fecha.';
COMMENT ON COLUMN public.dim_fecha.nu_anio IS 'Año de la fecha.';
COMMENT ON COLUMN public.dim_fecha.nu_mes IS 'Mes de la fecha.';
COMMENT ON COLUMN public.dim_fecha.no_mes IS 'Nombre del mes de la fecha.';
COMMENT ON COLUMN public.dim_fecha.nu_dia IS 'Número del día en el mes.';
COMMENT ON COLUMN public.dim_fecha.nu_dia_semana IS 'Número del día de la semana.';
COMMENT ON COLUMN public.dim_fecha.no_dia_semana IS 'Nombre del día de la semana.';
COMMENT ON COLUMN public.dim_fecha.nu_semana_anio IS 'Número de semana en el año.';
COMMENT ON COLUMN public.dim_fecha.nu_dia_ano IS 'Número de día en el año.';
COMMENT ON COLUMN public.dim_fecha.nu_cuatrimestre IS 'Número de cuatrimestre.';
COMMENT ON COLUMN public.dim_fecha.fl_fin_semana IS 'Flag indicativo de fin de semana.';
COMMENT ON COLUMN public.dim_fecha.fl_feriado IS 'Flag indicativo de feriado.';
COMMENT ON COLUMN public.dim_fecha.no_estacion IS 'Estación del año.';


CREATE SEQUENCE public.dim_lugar_sq;

CREATE TABLE public.dim_lugar (
                id_lugar INTEGER NOT NULL DEFAULT nextval('public.dim_lugar_sq'),
                co_lugar CHAR(1) NOT NULL,
                no_lugar VARCHAR(100) NOT NULL,
                ds_direccion VARCHAR(100),
                CONSTRAINT dim_lugar_pk PRIMARY KEY (id_lugar)
);
COMMENT ON TABLE public.dim_lugar IS 'Dimensión de lugares de lectura.';
COMMENT ON COLUMN public.dim_lugar.id_lugar IS 'Identificador único de lugar de lectura.';
COMMENT ON COLUMN public.dim_lugar.co_lugar IS 'Código de ifentificación única del lugar.';
COMMENT ON COLUMN public.dim_lugar.no_lugar IS 'Nombre del lugar de lectura.';
COMMENT ON COLUMN public.dim_lugar.ds_direccion IS 'Dirección del lugar.';


ALTER SEQUENCE public.dim_lugar_sq OWNED BY public.dim_lugar.id_lugar;

CREATE UNIQUE INDEX dim_lugar_uk
 ON public.dim_lugar
 ( co_lugar );

CREATE SEQUENCE public.dim_tipo_acreditacion_sq;

CREATE TABLE public.dim_tipo_acreditacion (
                id_tipo_acreditacion INTEGER NOT NULL DEFAULT nextval('public.dim_tipo_acreditacion_sq'),
                no_tipo_acreditacion VARCHAR(100) NOT NULL,
                CONSTRAINT dim_tipo_acreditacion_pk PRIMARY KEY (id_tipo_acreditacion)
);
COMMENT ON TABLE public.dim_tipo_acreditacion IS 'Dimensión de tipo de acreditación de las personas.';
COMMENT ON COLUMN public.dim_tipo_acreditacion.id_tipo_acreditacion IS 'Identificador único del tipo de acreditación de la persona.';
COMMENT ON COLUMN public.dim_tipo_acreditacion.no_tipo_acreditacion IS 'Nombre del tipo de acreditación.';


ALTER SEQUENCE public.dim_tipo_acreditacion_sq OWNED BY public.dim_tipo_acreditacion.id_tipo_acreditacion;

CREATE UNIQUE INDEX dim_tipo_persona_uk
 ON public.dim_tipo_acreditacion
 ( no_tipo_acreditacion );

CREATE SEQUENCE public.dim_persona_sq;

CREATE TABLE public.dim_persona (
                id_persona INTEGER NOT NULL DEFAULT nextval('public.dim_persona_sq'),
                co_dni_cuit VARCHAR(20) NOT NULL,
                co_legajo VARCHAR(20),
                no_persona VARCHAR(100) NOT NULL,
                no_direccion VARCHAR(100),
                no_dependencia VARCHAR(100),
                no_sector VARCHAR(100),
                no_area VARCHAR(100),
                no_puesto VARCHAR(100),
                no_tarea VARCHAR(100),
                CONSTRAINT dim_persona_pk PRIMARY KEY (id_persona)
);
COMMENT ON TABLE public.dim_persona IS 'Dimensión de personas.';
COMMENT ON COLUMN public.dim_persona.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.dim_persona.co_dni_cuit IS 'Número de DNI o CUIT de la persona.';
COMMENT ON COLUMN public.dim_persona.co_legajo IS 'Legajo de la persona.';
COMMENT ON COLUMN public.dim_persona.no_persona IS 'Nombre de la persona.';
COMMENT ON COLUMN public.dim_persona.no_direccion IS 'Dirección a la que pertenece la persona.';
COMMENT ON COLUMN public.dim_persona.no_dependencia IS 'Dependencia a la que pertenece la persona.';
COMMENT ON COLUMN public.dim_persona.no_sector IS 'Sector en que trabaja la persona.';
COMMENT ON COLUMN public.dim_persona.no_area IS 'Área dentro del sector.';
COMMENT ON COLUMN public.dim_persona.no_puesto IS 'Puesto dentro del área.';
COMMENT ON COLUMN public.dim_persona.no_tarea IS 'Tarea realizada dentro del área.';


ALTER SEQUENCE public.dim_persona_sq OWNED BY public.dim_persona.id_persona;

CREATE INDEX dim_persona_ix
 ON public.dim_persona
 ( co_dni_cuit, co_legajo );

CREATE UNIQUE INDEX dim_persona_uk
 ON public.dim_persona
 ( co_dni_cuit, co_legajo );

CREATE TABLE public.fac_turnos (
                id_persona INTEGER NOT NULL,
                fe_hora_inicio TIMESTAMP NOT NULL,
                id_fecha_inicio BIGINT NOT NULL,
                id_origen_inicio INTEGER DEFAULT 2 NOT NULL,
                id_fecha_fin BIGINT,
                id_origen_fin INTEGER DEFAULT 2 NOT NULL,
                id_turno SMALLINT NOT NULL,
                id_turno_inicio SMALLINT,
                id_tipo_hora SMALLINT NOT NULL,
                fe_hora_fin TIMESTAMP,
                id_empresa_area INTEGER NOT NULL,
                nu_lecturas INTEGER DEFAULT 1 NOT NULL,
                va_horas_total REAL NOT NULL,
                va_horas_media REAL,
                CONSTRAINT fac_turnos_pk PRIMARY KEY (id_persona, fe_hora_inicio)
);
COMMENT ON TABLE public.fac_turnos IS 'Tabla de hecho de turnos.';
COMMENT ON COLUMN public.fac_turnos.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.fac_turnos.fe_hora_inicio IS 'Hora de la lectura de início del turno.';
COMMENT ON COLUMN public.fac_turnos.id_fecha_inicio IS 'Identificador único de la fecha de início del turno.';
COMMENT ON COLUMN public.fac_turnos.id_origen_inicio IS 'Identificador único del origen de lectura de início.';
COMMENT ON COLUMN public.fac_turnos.id_fecha_fin IS 'Identificador único de la fecha de fin del turno.';
COMMENT ON COLUMN public.fac_turnos.id_origen_fin IS 'Identificador único del origen de lectura de fin.';
COMMENT ON COLUMN public.fac_turnos.id_turno IS 'Identificador único del turno.';
COMMENT ON COLUMN public.fac_turnos.id_turno_inicio IS 'Identificador único del turno de início.';
COMMENT ON COLUMN public.fac_turnos.id_tipo_hora IS 'Identificador único del tipo de hora.';
COMMENT ON COLUMN public.fac_turnos.fe_hora_fin IS 'Hora de la lectura del fin del turno.';
COMMENT ON COLUMN public.fac_turnos.id_empresa_area IS 'Identificador único de Empresa o Área.';
COMMENT ON COLUMN public.fac_turnos.nu_lecturas IS 'Cantidad de lecturas.';
COMMENT ON COLUMN public.fac_turnos.va_horas_total IS 'Total de horas trabajadas en el día (Maximo - Mínimo).';
COMMENT ON COLUMN public.fac_turnos.va_horas_media IS 'Promedio de horas trabajadas en el día.';


CREATE SEQUENCE public.fac_lectura_sq;

CREATE TABLE public.fac_lectura (
                id_lectura BIGINT NOT NULL DEFAULT nextval('public.fac_lectura_sq'),
                id_persona INTEGER NOT NULL,
                id_fecha BIGINT NOT NULL,
                id_hora BIGINT NOT NULL,
                id_lugar INTEGER NOT NULL,
                id_origen INTEGER DEFAULT 2 NOT NULL,
                id_tipo_acreditacion INTEGER NOT NULL,
                id_tipo_hora SMALLINT DEFAULT 1 NOT NULL,
                id_empresa_area INTEGER NOT NULL,
                nu_lecturas INTEGER DEFAULT 1 NOT NULL,
                fe_hora TIMESTAMP NOT NULL,
                ds_hora VARCHAR(10) NOT NULL,
                no_usuario VARCHAR(10),
                ds_usuario VARCHAR(50),
                co_lector INTEGER,
                ds_observaciones VARCHAR(400) DEFAULT NULL::character varying,
                fl_procesado BOOLEAN DEFAULT false NOT NULL,
                CONSTRAINT fac_lectura_pk PRIMARY KEY (id_lectura)
);
COMMENT ON TABLE public.fac_lectura IS 'Tabla de hecho de lecturas.';
COMMENT ON COLUMN public.fac_lectura.id_lectura IS 'Identificador único de la lectura.';
COMMENT ON COLUMN public.fac_lectura.id_persona IS 'Identificador único de la persona.';
COMMENT ON COLUMN public.fac_lectura.id_fecha IS 'Identificador único de la fecha.';
COMMENT ON COLUMN public.fac_lectura.id_hora IS 'Identificador único de la hora.';
COMMENT ON COLUMN public.fac_lectura.id_lugar IS 'Identificador único de lugar de lectura.';
COMMENT ON COLUMN public.fac_lectura.id_origen IS 'Identificador único del origen de lectura.';
COMMENT ON COLUMN public.fac_lectura.id_tipo_acreditacion IS 'Identificador único del tipo de acreditación de la persona.';
COMMENT ON COLUMN public.fac_lectura.id_tipo_hora IS 'Identificador único del tipo de hora.';
COMMENT ON COLUMN public.fac_lectura.id_empresa_area IS 'Identificador único de Empresa o Área.';
COMMENT ON COLUMN public.fac_lectura.nu_lecturas IS 'Cantidad de lecturas.';
COMMENT ON COLUMN public.fac_lectura.fe_hora IS 'Fecha y Hora de la lectura.';
COMMENT ON COLUMN public.fac_lectura.ds_hora IS 'Hora de la lectura en formato texto.';
COMMENT ON COLUMN public.fac_lectura.no_usuario IS 'Usuário de la lectura.';
COMMENT ON COLUMN public.fac_lectura.ds_usuario IS 'Descripción de usuário de la lectura.';
COMMENT ON COLUMN public.fac_lectura.co_lector IS 'Código de lector.';
COMMENT ON COLUMN public.fac_lectura.ds_observaciones IS 'Observaciones de la lectura.';
COMMENT ON COLUMN public.fac_lectura.fl_procesado IS 'Si el registro ya fue usado para cálculo de turnos.';


ALTER SEQUENCE public.fac_lectura_sq OWNED BY public.fac_lectura.id_lectura;

CREATE UNIQUE INDEX fac_lectura_uk
 ON public.fac_lectura
 ( id_persona, id_fecha, fe_hora );

CREATE INDEX fac_lectura_ix
 ON public.fac_lectura
 ( id_persona, id_fecha, fe_hora );

ALTER TABLE public.fac_turnos ADD CONSTRAINT fac_turno_turnos_fk
FOREIGN KEY (id_turno)
REFERENCES public.dim_turno (id_turno)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.dim_hora ADD CONSTRAINT dim_turno_hora_fk
FOREIGN KEY (id_turno8)
REFERENCES public.dim_turno (id_turno)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_turnos ADD CONSTRAINT fac_turno_turno_inicio_fk
FOREIGN KEY (id_turno_inicio)
REFERENCES public.dim_turno (id_turno)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT fac_tipo_hora_lectura_fk
FOREIGN KEY (id_tipo_hora)
REFERENCES public.dim_tipo_hora (id_tipo_hora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.dim_hora ADD CONSTRAINT dim_tipo_hora_hora_fk
FOREIGN KEY (id_turno8_tipo_hora)
REFERENCES public.dim_tipo_hora (id_tipo_hora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_turnos ADD CONSTRAINT fac_tipo_hora_turnos_fk
FOREIGN KEY (id_tipo_hora)
REFERENCES public.dim_tipo_hora (id_tipo_hora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT hora_fac_lectura_fk
FOREIGN KEY (id_hora)
REFERENCES public.dim_hora (id_hora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT fac_origen_lectura_fk
FOREIGN KEY (id_origen)
REFERENCES public.dim_origen (id_origen)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT fac_empresa_area_lectura_fk
FOREIGN KEY (id_empresa_area)
REFERENCES public.dim_empresa_area (id_empresa_area)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_turnos ADD CONSTRAINT fac_empresa_area_turnos_fk
FOREIGN KEY (id_empresa_area)
REFERENCES public.dim_empresa_area (id_empresa_area)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT fac_fecha_lectura_fk
FOREIGN KEY (id_fecha)
REFERENCES public.dim_fecha (id_fecha)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_turnos ADD CONSTRAINT fac_fecha_inicio_turnos_fk
FOREIGN KEY (id_fecha_inicio)
REFERENCES public.dim_fecha (id_fecha)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_turnos ADD CONSTRAINT fac_fecha_fin_turnos_fk
FOREIGN KEY (id_fecha_fin)
REFERENCES public.dim_fecha (id_fecha)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT fac_lugar_lectura_fk
FOREIGN KEY (id_lugar)
REFERENCES public.dim_lugar (id_lugar)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT fac_tipo_acreditacion_lectura_fk
FOREIGN KEY (id_tipo_acreditacion)
REFERENCES public.dim_tipo_acreditacion (id_tipo_acreditacion)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_lectura ADD CONSTRAINT fac_persona_lectura_fk
FOREIGN KEY (id_persona)
REFERENCES public.dim_persona (id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.fac_turnos ADD CONSTRAINT fac_persona_turnos_fk
FOREIGN KEY (id_persona)
REFERENCES public.dim_persona (id_persona)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
