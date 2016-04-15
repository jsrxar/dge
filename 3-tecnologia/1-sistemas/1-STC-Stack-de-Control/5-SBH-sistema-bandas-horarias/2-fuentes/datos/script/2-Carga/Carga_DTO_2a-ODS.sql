SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   BORRANDO DATOS VIEJOS   ----------------------------------------
--DELETE FROM ods_persona CASCADE;

----------------------------------------   CARGANDO ODS   ----------------------------------------
--###################
--####  Persona  ####
--###################
INSERT INTO ods_persona(
	co_dni_cuit,
	no_persona,
	no_sector,
	no_area, 
	no_puesto
)
SELECT DISTINCT
	tx_dni         co_dni_cuit,
	tx_nombre      no_persona,
	MAX(tx_sector) no_sector,
	MAX(tx_area)   no_area,
	MAX(tx_puesto) no_puesto
FROM stg_dto_personal
WHERE tx_dni IS NOT NULL
GROUP BY
	tx_dni,
	tx_nombre;

INSERT INTO ods_persona(
	co_dni_cuit,
	no_persona,
	no_sector,
	no_area, 
	no_puesto
)
SELECT DISTINCT
	tx_dni            co_dni_cuit,
	tx_nombre         no_persona,
	COALESCE((SELECT MAX(no_sector) FROM ods_persona WHERE no_area = pe.tx_sector_area),
		tx_sector_area)    no_sector,
	COALESCE((SELECT MAX(no_area) FROM ods_persona WHERE no_area = pe.tx_sector_area),
		'NO IDENTIFICADO') no_area,
	'NO IDENTIFICADO' no_puesto
FROM (
	SELECT DISTINCT
		tx_dni         tx_dni,
		MAX(tx_nombre) tx_nombre,
		UPPER(REPLACE(MAX(tx_empresa_area), 'CTO - ', '')) tx_sector_area
	FROM stg_dto_banda
	WHERE COALESCE(tx_dni, '0') > '0'
	  AND tx_dni NOT IN (SELECT co_dni_cuit FROM ods_persona)
	GROUP BY
		tx_dni ) pe;

--###################
--####  Lectura  ####
--###################
INSERT INTO ods_lectura (
	id_persona,
	fe_fecha_lectura,
	co_lugar,
	co_origen,
	no_tipo_acreditacion,
	no_empresa_area,
	ds_observaciones,
	id_carga )
SELECT
	( SELECT MAX(id_persona)
	  FROM ods_persona
	  WHERE co_dni_cuit = tx_dni ) id_persona,
	TO_TIMESTAMP(tx_fecha || ' ' || LPAD(tx_entrada, 5, '0'), 'DD/MM/YYYY HH24:MI') fe_fecha_lectura,
	co_lugar,
	'A' co_origen,
	TRIM(tx_tipo_acreditac) no_tipo_acreditacion,
	TRIM(tx_empresa_area) no_empresa_area,
	'Total: ' || tx_horas ds_observaciones,
	id_carga
FROM stg_dto_banda fi
WHERE co_estado_proceso = 'C';

INSERT INTO ods_lectura (
	id_persona,
	fe_fecha_lectura,
	co_lugar,
	co_origen,
	no_tipo_acreditacion,
	no_empresa_area,
	ds_observaciones,
	id_carga )
SELECT
	( SELECT MAX(id_persona)
	  FROM ods_persona
	  WHERE co_dni_cuit = tx_dni ) id_persona,
	TO_TIMESTAMP(tx_fecha || ' ' || LPAD(tx_salida, 5, '0'), 'DD/MM/YYYY HH24:MI') fe_fecha_lectura,
	co_lugar,
	'A' co_origen,
	TRIM(tx_tipo_acreditac) no_tipo_acreditacion,
	TRIM(tx_empresa_area) no_empresa_area,
	'Total: ' || tx_horas ds_observaciones,
	id_carga
FROM stg_dto_banda fi
WHERE co_estado_proceso = 'C'
  AND tx_salida != '--:--';

UPDATE stg_dto_banda
SET co_estado_proceso = 'P'
WHERE co_estado_proceso = 'C';