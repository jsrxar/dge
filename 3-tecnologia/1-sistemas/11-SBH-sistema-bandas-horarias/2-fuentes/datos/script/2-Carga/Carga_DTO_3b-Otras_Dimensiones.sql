SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   BORRANDO DATOS VIEJOS   ----------------------------------------
DELETE FROM fac_lectura CASCADE;
DELETE FROM fac_totales CASCADE;
DELETE FROM fac_turnos CASCADE;
DELETE FROM dim_persona CASCADE;
DELETE FROM dim_empresa_area CASCADE;
DELETE FROM dim_tipo_acreditacion CASCADE;
DELETE FROM dim_origen CASCADE;
DELETE FROM dim_lugar CASCADE;

----------------------------------------   CARGANDO DIMENSIONES   ----------------------------------------
--##################
--####  Origen  ####
--##################
INSERT INTO dim_origen (id_origen, co_origen, no_origen) VALUES
(1, 'A', 'Archivo'),
(2, 'M', 'Manual'),
(3, 'C', 'Cálculo');

--#################
--####  Lugar  ####
--#################
INSERT INTO dim_lugar (co_lugar, no_lugar, ds_direccion) VALUES
('C', 'CCK',        'CCK'),
('D', 'DTO',        'CCK'),
('T', 'Tecnópolis', 'Tecnópolis'),
('R', 'CIARA',      'Cabildo'),
('M', 'MINPLAN',    'Esmeralda 255'),
('I', 'Interior',   'Interior');

--###################
--####  Persona  ####
--###################
INSERT INTO dim_persona (id_persona, co_dni_cuit, no_persona)
VALUES (0, '-1', 'Persona no identificada');

INSERT INTO dim_persona(
	id_persona,
	co_dni_cuit,
	no_persona,
	no_sector,
	no_area, 
	no_puesto
)
SELECT
	id_persona,
	co_dni_cuit,
	no_persona,
	no_sector,
	no_area,
	no_puesto
FROM ods_persona;

--##########################
--####  Empresa / Área  ####
--##########################
INSERT INTO dim_empresa_area (id_empresa_area, no_empresa_area)
VALUES (0, 'No Definido');

INSERT INTO dim_empresa_area (no_empresa_area)
SELECT DISTINCT TRIM(tx_empresa_area) FROM stg_dto_banda
WHERE TRIM(tx_empresa_area) IS NOT NULL;

--#############################
--####  Tipo Acreditación  ####
--#############################
INSERT INTO dim_tipo_acreditacion (id_tipo_acreditacion, no_tipo_acreditacion)
VALUES (0, 'No Definido');

INSERT INTO dim_tipo_acreditacion (no_tipo_acreditacion)
SELECT DISTINCT TRIM(tx_tipo_acreditac) FROM stg_dto_banda
WHERE TRIM(tx_tipo_acreditac) IS NOT NULL;