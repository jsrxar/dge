SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE DTO   ----------------------------------------
UPDATE stg_dto_banda
SET
	no_archivo = '...',
	co_lugar = 'D',
	fe_carga = now(),
	co_estado_proceso = 'C',
	tx_fecha = TRIM(tx_fecha),
	tx_nombre = TRIM(tx_nombre),
	tx_entrada = TRIM(tx_entrada),
	tx_salida = TRIM(tx_salida),
	tx_horas = TRIM(tx_horas),
	tx_dni = TRIM(tx_dni),
	tx_empresa_area = TRIM(tx_empresa_area),
	tx_tipo_acreditac = TRIM(tx_tipo_acreditac)
WHERE fe_carga IS NULL;

UPDATE stg_dto_banda ba
SET tx_dni = (SELECT DISTINCT tx_dni FROM stg_dto_banda WHERE tx_nombre = ba.tx_nombre AND tx_dni IS NOT NULL)
WHERE tx_dni IS NULL;

UPDATE stg_dto_banda ba
SET tx_tipo_acreditac = (SELECT MAX(tx_tipo_acreditac) FROM stg_dto_banda WHERE tx_dni = ba.tx_dni AND tx_tipo_acreditac IS NOT NULL)
WHERE tx_tipo_acreditac IS NULL;
