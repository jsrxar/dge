SELECT
  evento,
  prioridad,
  fecha_creado,
  fecha_actualizado,
  espacio,
  TO_CHAR(fecha_inicio, 'TMDay DD/MM') AS dia_inicio,
  fecha_inicio,
  hora_inicio,
  fecha_fin,
  hora_fin,
  fecha_cierre,
  autor,
  productor,
  descripcion
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
    closed_on    AS fecha_cierre,
    (SELECT login FROM users WHERE id = ss.author_id) AS autor,
    (SELECT login FROM users WHERE id = ss.assigned_to_id) AS productor,
    description  AS descripcion
  FROM issues ss
  WHERE project_id = (SELECT id FROM projects WHERE identifier = 'agenda')
    AND tracker_id = (SELECT id FROM trackers WHERE name = 'EVENTO')
    AND status_id  = (SELECT id FROM issue_statuses WHERE name = 'Agendado')
    AND start_date BETWEEN DATE '2016-06-08' AND DATE '2016-06-08' + INTERVAL '6 days') a
ORDER BY
  fecha_inicio,
  espacio,
  hora_inicio,
  evento