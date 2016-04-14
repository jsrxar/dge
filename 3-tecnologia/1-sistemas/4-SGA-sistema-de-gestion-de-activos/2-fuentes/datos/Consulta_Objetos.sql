SELECT
    tc.table_name, 
    tc.constraint_name,
    constraint_type,
    kcu.column_name, 
    case CONSTRAINT_TYPE when 'FOREIGN KEY' then ccu.table_name end AS foreign_table_name,
    case CONSTRAINT_TYPE when 'FOREIGN KEY' then ccu.column_name end AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
UNION ALL
SELECT 
    (idx.indrelid::regclass)::varchar,
    i.relname as indname,
    'INDEX',
    REPLACE(REPLACE(
    ARRAY(SELECT pg_get_indexdef(idx.indexrelid, k + 1, true)
          FROM generate_subscripts(idx.indkey, 1) as k
          ORDER BY k)::varchar, '{', ''), '}', '') as indkey_names,
    NULL, NULL
FROM
    pg_index as idx
    JOIN pg_class as i
      ON i.oid = idx.indexrelid
    JOIN pg_am as am
      ON i.relam = am.oid
WHERE (idx.indrelid::regclass)::varchar LIKE 'ods_%'
ORDER BY
    table_name,
    constraint_type,
    constraint_name
