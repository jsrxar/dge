SELECT
  TO_CHAR(fecha_inicio, 'TMDay DD de TMMonth') AS dia_inicio,
  'EVENTO ' || (row_number() over (ORDER BY fecha_inicio, hora_inicio, espacio, evento)
    + 1 - rank() over (ORDER BY fecha_inicio)) || ': ' || evento AS texto,
  espacio,
  productor,
  REPLACE(REGEXP_REPLACE(hora_inicio, '^0', ''), ':00', '') || ' a ' ||
    REPLACE(REGEXP_REPLACE(hora_fin,  '^0', ''), ':00', '') || ' hs' ||
    (CASE WHEN fecha_fin != fecha_inicio 
     THEN ' (' || TO_CHAR(fecha_fin, 'DD/MM') || ')' ELSE '' END) AS horario,
  req_esp_fis,
  req_ope_mnt,
  req_ser_gen
FROM (
  SELECT
    subject      AS evento,
    (SELECT name FROM enumerations WHERE type IN ('IssuePriority') AND id = ss.priority_id ) AS prioridad,
    created_on   AS fecha_creado,
    updated_on   AS fecha_actualizado,
    (SELECT cv.value FROM custom_fields cf INNER JOIN custom_values cv ON cv.custom_field_id = cf.id
     WHERE cf.type = 'IssueCustomField' AND cf.name = 'Espacio' AND cv.customized_id = ss.id) AS espacio,
    start_date   AS fecha_inicio,
    (SELECT cv.value FROM custom_fields cf INNER JOIN custom_values cv ON cv.custom_field_id = cf.id
     WHERE cf.type = 'IssueCustomField' AND cf.name = 'Hora Inicio' AND cv.customized_id = ss.id) AS hora_inicio,
    due_date     AS fecha_fin,
    (SELECT cv.value FROM custom_fields cf INNER JOIN custom_values cv ON cv.custom_field_id = cf.id
     WHERE cf.type = 'IssueCustomField' AND cf.name = 'Hora Fin' AND cv.customized_id = ss.id) AS hora_fin,
    (SELECT cv.value FROM custom_fields cf INNER JOIN custom_values cv ON cv.custom_field_id = cf.id
     WHERE cf.type = 'IssueCustomField' AND cf.name = 'Productor' AND cv.customized_id = ss.id) AS productor,
    (SELECT cv.value FROM custom_fields cf INNER JOIN custom_values cv ON cv.custom_field_id = cf.id
     WHERE cf.type = 'IssueCustomField' AND cf.name = 'Req. Espacios Físicos' AND cv.customized_id = ss.id) AS req_esp_fis,
    (SELECT cv.value FROM custom_fields cf INNER JOIN custom_values cv ON cv.custom_field_id = cf.id
     WHERE cf.type = 'IssueCustomField' AND cf.name = 'Req. Operativa / Mantenimiento' AND cv.customized_id = ss.id) AS req_ope_mnt,
    (SELECT cv.value FROM custom_fields cf INNER JOIN custom_values cv ON cv.custom_field_id = cf.id
     WHERE cf.type = 'IssueCustomField' AND cf.name = 'Req. Servicios Generales' AND cv.customized_id = ss.id) AS req_ser_gen,
    closed_on    AS fecha_cierre,
    (SELECT login FROM users WHERE id = ss.author_id) AS autor,
    (SELECT login FROM users WHERE id = ss.assigned_to_id) AS asignado,
    description  AS descripcion
  FROM issues ss
  WHERE project_id = (SELECT id FROM projects WHERE identifier = 'agenda')
    AND tracker_id = (SELECT id FROM trackers WHERE name = 'EVENTO')
    AND status_id  = (SELECT id FROM issue_statuses WHERE name = 'Agendado')
    AND start_date BETWEEN now() - interval '7 days' AND now() + interval '7 days') a
ORDER BY
  fecha_inicio,
  hora_inicio,
  espacio,
  evento