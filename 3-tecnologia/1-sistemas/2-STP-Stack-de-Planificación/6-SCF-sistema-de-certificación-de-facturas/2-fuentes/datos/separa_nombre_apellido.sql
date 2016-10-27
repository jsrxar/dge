UPDATE agente SET no_nombre = NULL, no_apellido = NULL;

UPDATE agente
SET no_nombre = TRIM((string_to_array(TRIM(no_agente), ','))[2]),
  no_apellido = TRIM((string_to_array(TRIM(no_agente), ','))[1])
WHERE array_length(string_to_array(no_agente, ','), 1) = 2
  AND no_nombre IS NULL;

UPDATE agente
SET no_nombre = TRIM((string_to_array(TRIM(no_agente), '  '))[2]),
  no_apellido = TRIM((string_to_array(TRIM(no_agente), '  '))[1])
WHERE array_length(string_to_array(TRIM(no_agente), '  '), 1) = 2
  AND no_nombre IS NULL;

UPDATE agente
SET no_nombre = TRIM((string_to_array(TRIM(no_agente), '  '))[2]) || ' ' || TRIM((string_to_array(TRIM(no_agente), '  '))[3]),
  no_apellido = TRIM((string_to_array(TRIM(no_agente), '  '))[1])
WHERE array_length(string_to_array(TRIM(no_agente), '  '), 1) = 3
  AND no_nombre IS NULL;

UPDATE agente
SET no_nombre = TRIM((string_to_array(TRIM(no_agente), ' '))[2]),
  no_apellido = TRIM((string_to_array(TRIM(no_agente), ' '))[1])
WHERE array_length(string_to_array(TRIM(no_agente), ' '), 1) = 2
  AND no_nombre IS NULL;

UPDATE agente
SET no_nombre = TRIM((string_to_array(TRIM(no_agente), ' '))[2]) || ' ' || TRIM((string_to_array(TRIM(no_agente), ' '))[3]),
  no_apellido = TRIM((string_to_array(TRIM(no_agente), ' '))[1])
WHERE array_length(string_to_array(TRIM(no_agente), ' '), 1) = 3
  AND no_nombre IS NULL;

/*
SELECT COUNT(0) FROM agente WHERE no_nombre IS NULL

SELECT * FROM agente WHERE no_nombre IS NULL
*/