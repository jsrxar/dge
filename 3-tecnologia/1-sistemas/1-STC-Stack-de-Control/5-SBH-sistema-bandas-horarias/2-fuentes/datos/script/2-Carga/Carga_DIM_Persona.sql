SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   Limpiando tabla ODS   ----------------------------------------
UPDATE ods_persona
SET co_dni_cuit = (COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(co_dni_cuit, ' ', ''), '.', ''), ',', ''), ''), '0')::BIGINT)::TEXT;

UPDATE ods_lectura le
SET id_persona = ( SELECT MAX(id_persona) FROM ods_persona WHERE co_dni_cuit = pe.co_dni_cuit )
FROM ods_persona pe
WHERE pe.id_persona = le.id_persona
  AND EXISTS (SELECT 1 FROM ods_persona WHERE co_dni_cuit = pe.co_dni_cuit AND id_persona > pe.id_persona );

DELETE FROM ods_persona pe
WHERE EXISTS (SELECT 1 FROM ods_persona WHERE co_dni_cuit = pe.co_dni_cuit AND id_persona > pe.id_persona );

----------------------------------------   Pasando ODS a DW (DIM)   ----------------------------------------
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
FROM ods_persona pe
WHERE NOT EXISTS ( SELECT 1 FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit);

----------------------------------------   Limpiando tabla DIM   ----------------------------------------
UPDATE dim_persona
SET co_dni_cuit = (COALESCE(NULLIF(REPLACE(REPLACE(REPLACE(co_dni_cuit, ' ', ''), '.', ''), ',', ''), ''), '0')::BIGINT)::TEXT;

UPDATE fac_lectura le
SET id_persona = ( SELECT MAX(id_persona) FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit )
FROM dim_persona pe
WHERE pe.id_persona = le.id_persona
  AND EXISTS (SELECT 1 FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit AND id_persona > pe.id_persona );

UPDATE fac_totales le
SET id_persona = ( SELECT MAX(id_persona) FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit )
FROM dim_persona pe
WHERE pe.id_persona = le.id_persona
  AND EXISTS (SELECT 1 FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit AND id_persona > pe.id_persona );

UPDATE fac_turnos le
SET id_persona = ( SELECT MAX(id_persona) FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit )
FROM dim_persona pe
WHERE pe.id_persona = le.id_persona
  AND EXISTS (SELECT 1 FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit AND id_persona > pe.id_persona );

DELETE FROM dim_persona pe
WHERE EXISTS (SELECT 1 FROM dim_persona WHERE co_dni_cuit = pe.co_dni_cuit AND id_persona > pe.id_persona );