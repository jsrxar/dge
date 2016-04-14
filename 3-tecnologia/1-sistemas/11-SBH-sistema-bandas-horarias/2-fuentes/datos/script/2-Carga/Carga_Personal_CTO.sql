SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE DTO   ----------------------------------------
UPDATE stg_dto_personal
SET
	no_archivo = '...',
	co_lugar = 'C',
	fe_carga = now(),
	co_estado_proceso = 'C',
	tx_dni = TRIM(tx_dni),
	tx_nombre = TRIM(tx_nombre),
	tx_sector = TRIM(tx_sector),
	tx_area = TRIM(tx_area),
	tx_puesto = TRIM(tx_puesto)
WHERE fe_carga IS NULL;

UPDATE ods_persona pe
SET
	no_persona = tx_nombre,
	no_sector  = tx_sector,
	no_area    = tx_area,
	no_tarea   = tx_puesto
FROM stg_dto_personal st
WHERE pe.co_dni_cuit = st.tx_dni
  AND st.co_estado_proceso = 'C';

INSERT INTO ods_persona(
	co_dni_cuit,
	no_persona,
	no_sector,
	no_area,
	no_tarea
)
SELECT
	tx_dni         co_dni_cuit,
	MAX(tx_nombre) no_persona,
	MAX(tx_sector) no_sector,
	MAX(tx_area)   no_area,
	MAX(tx_puesto) no_tarea
FROM stg_dto_personal
WHERE co_estado_proceso = 'C'
  AND tx_dni IS NOT NULL
  AND tx_dni NOT IN ( SELECT co_dni_cuit FROM ods_persona )
GROUP BY tx_dni;

UPDATE stg_dto_personal
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C';

UPDATE dim_persona pe
SET
	no_persona     = od.no_persona,
	no_direccion   = od.no_direccion,
	no_dependencia = od.no_dependencia,
	no_sector      = od.no_sector,
	no_area        = od.no_area,
	no_puesto      = od.no_puesto,
	no_tarea       = od.no_tarea
FROM ods_persona od
WHERE pe.id_persona = od.id_persona;

INSERT INTO dim_persona(
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	no_sector,
	no_area,
	no_puesto,
	no_tarea
)
SELECT
	co_dni_cuit,
	no_persona,
	no_direccion,
	no_dependencia,
	no_sector,
	no_area,
	no_puesto,
	no_tarea
FROM ods_persona
WHERE co_dni_cuit NOT IN ( SELECT co_dni_cuit FROM dim_persona );
