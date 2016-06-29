CREATE OR REPLACE FUNCTION fn_Carga_Lista (
	destino_campo VARCHAR,
	origen_tabla  VARCHAR,
	origen_id     VARCHAR,
	origen_valor  VARCHAR,
	origen_corto  VARCHAR DEFAULT NULL,
	conexion      VARCHAR DEFAULT 'dbname=RCDTO user=rcdto password=rcdto',
	servidor      VARCHAR DEFAULT 'port=5432 host=127.0.0.1'
) RETURNS INTEGER AS
$BODY$
DECLARE
    id_field INTEGER;
BEGIN
	-- Buscando ID del campo
	SELECT id INTO id_field
	FROM custom_fields
	WHERE field_format = 'enumeration'
	  AND name = destino_campo;

	-- Cargando tabla temporal
	DELETE FROM custom_field_enumerations_aux
	WHERE custom_field_id = id_field;
	INSERT INTO custom_field_enumerations_aux (
		custom_field_id,
		id_ori,
		name,
		view_name,
		position
	)
	SELECT
		id_field  AS custom_field_id,
		id_origen AS id_ori,
		no_origen AS name,
		CASE WHEN NOT origen_corto IS NULL THEN no_corto END AS view_name,
		row_number()OVER()-1 AS position
	FROM dblink (servidor ||' '|| conexion,
	'SELECT '|| origen_id ||', '|| origen_valor ||', '|| COALESCE(origen_corto, origen_valor) ||
	' FROM '|| origen_tabla ||' ORDER BY '|| origen_valor) AS P (
	  id_origen BIGINT,
	  no_origen VARCHAR,
	  no_corto  VARCHAR
	);
	
	-- Pasando de temporal a fisica
	DELETE FROM custom_field_enumerations
	WHERE custom_field_id = id_field
	  AND id_ori NOT IN ( SELECT id_ori FROM custom_field_enumerations_aux WHERE custom_field_id = id_field );

	UPDATE custom_field_enumerations a
	SET 
		name      = b.name,
		view_name = b.view_name,
		position  = b.position,
		active    = TRUE
	FROM custom_field_enumerations_aux b
	WHERE a.custom_field_id = b.custom_field_id
	  AND a.id_ori          = b.id_ori
	  AND a.custom_field_id = id_field;

	INSERT INTO custom_field_enumerations (
		custom_field_id,
		id_ori,
		name,
		view_name,
		active,
		position
	)
	SELECT
		custom_field_id,
		id_ori,
		name,
		view_name,
		TRUE AS active,
		position
	FROM custom_field_enumerations_aux
	WHERE custom_field_id = id_field
	  AND id_ori NOT IN ( SELECT id_ori FROM custom_field_enumerations WHERE custom_field_id = id_field );

	-- Actualizando numeración del campo
	/*
	UPDATE custom_fields
	SET position = (SELECT COUNT(0) FROM custom_field_enumerations WHERE custom_field_id = id_field)
	WHERE id = id_field;
	*/

	RETURN 1;
END
$BODY$
LANGUAGE 'plpgsql';

--SELECT fn_Carga_Lista('Espacio Físico', 'public.sga_espacio', 'id_espacio', 'ds_referencia', 'co_espacio')
