CREATE OR REPLACE FUNCTION fn_Carga_Lista(
	destino_campo VARCHAR,
	origen_tabla  VARCHAR,
	origen_id     VARCHAR,
	origen_nombre VARCHAR
) RETURNS INTEGER AS
$BODY$
DECLARE
    id_field INTEGER;
BEGIN
	SELECT id INTO id_field
	FROM custom_fields
	WHERE field_format = 'enumeration'
	  AND name = destino_campo;

	DELETE FROM custom_field_enumerations
	WHERE custom_field_id = id_field;

	INSERT INTO custom_field_enumerations (
		id,
		custom_field_id,
		name,
		active,
		position
	)
	SELECT
		id_origen AS id,
		id_field  AS custom_field_id,
		no_origen AS name,
		TRUE      AS active,
		row_number()OVER()-1 AS position
	FROM dblink ('dbname=RCDTO port=5432 host=127.0.0.1 user=rcdto password=rcdto',
	'SELECT '|| origen_id ||', '|| origen_nombre ||' FROM '|| origen_tabla ||' ORDER BY '|| origen_nombre) AS P (
	  id_origen BIGINT,
	  no_origen VARCHAR(400)
	);

	UPDATE custom_fields
	SET position = (SELECT COUNT(0) FROM custom_field_enumerations WHERE custom_field_id = id_field)
	WHERE id = id_field;

	RETURN 1;
END
$BODY$
LANGUAGE 'plpgsql';
