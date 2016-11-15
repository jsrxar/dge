SELECT 
	co.table_catalog    AS "Base",
	co.table_schema     AS "Esquema",
	co.table_name       AS "Tabla",
	co.ordinal_position AS "Posicion",
	co.column_name      AS "Columna",
	(SELECT tc.constraint_type
	 FROM information_schema.table_constraints AS tc 
	    JOIN information_schema.key_column_usage AS cu
	      ON tc.constraint_name = cu.constraint_name
	 WHERE tc.table_catalog   = co.table_catalog
	   AND tc.table_schema    = co.table_schema
	   AND tc.table_name      = co.table_name
	   AND cu.column_name     = co.column_name) AS "Constraint",
	co.column_name || ' ' || UPPER(co.data_type) ||
	COALESCE('(' || co.character_maximum_length || ')', '') ||
	COALESCE(' CHARACTER SET ' || co.character_set_name, '') ||
	COALESCE(' COLLATE ' || co.collation_name, '') ||
	COALESCE(' ' ||
		(SELECT tc.constraint_type
		 FROM information_schema.table_constraints AS tc 
		    JOIN information_schema.key_column_usage AS cu
		      ON tc.constraint_name = cu.constraint_name
		 WHERE tc.table_catalog   = co.table_catalog
		   AND tc.table_schema    = co.table_schema
		   AND tc.table_name      = co.table_name
		   AND cu.column_name     = co.column_name
		   AND tc.constraint_type = 'PRIMARY KEY'),
		CASE WHEN is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END) ||
	COALESCE(' DEFAULT ' || column_default, '') AS "Definición"
FROM information_schema.columns AS co
WHERE co.table_catalog    = 'FACTURAS'
  AND co.table_schema     = 'public'
  AND co.table_name       = 'factura'
  AND co.column_name      = 'id_factura'
ORDER BY
	co.table_catalog,
	co.table_schema,
	co.table_name,
	co.ordinal_position