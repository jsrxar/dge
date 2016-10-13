SET CLIENT_ENCODING TO 'LATIN1';

----------------------------------------   PROCESO DE DTO   ----------------------------------------
COPY stg_dto_personal (tx_sector, tx_area, tx_puesto, tx_nombre, tx_dni)
FROM 'C:/archivos/dto/personal/DTO_Personal.csv' USING DELIMITERS ';' WITH NULL AS '';

UPDATE stg_dto_personal
SET
	no_archivo = 'DTO nuevo.xlsx',
	co_lugar = 'D',
	fe_carga = now(),
	co_estado_proceso = 'C',
	tx_dni = TRIM(tx_dni),
	tx_nombre = TRIM(tx_nombre),
	tx_sector = TRIM(tx_sector),
	tx_area = TRIM(tx_area),
	tx_puesto = TRIM(tx_puesto)
WHERE fe_carga IS NULL;
