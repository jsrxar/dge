CREATE or REPLACE FUNCTION two(varchar) RETURNS integer AS $$
    SELECT 1 AS result;
$$ LANGUAGE SQL;

SELECT  two('');