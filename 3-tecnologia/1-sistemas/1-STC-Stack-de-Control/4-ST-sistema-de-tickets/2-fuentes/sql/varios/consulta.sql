SELECT
	(SELECT name FROM projects  WHERE id = ss.project_id) project_name,
	(SELECT tr.name
	 FROM trackers tr INNER JOIN projects_trackers pt ON tr.id = pt.tracker_id
	 WHERE pt.project_id = ss.project_id AND tr.id = ss.tracker_id) tracker_name,
	subject,
	(SELECT name FROM enumerations WHERE type IN ('IssuePriority') AND id = ss.priority_id ) priority_name,
	(SELECT name FROM issue_statuses WHERE id = ss.status_id) status_name,
	done_ratio,
	estimated_hours,
	created_on,
	updated_on,
	start_date,
	due_date,
	closed_on,
	(SELECT login FROM users WHERE id = ss.author_id) author,
	(SELECT login FROM users WHERE id = ss.assigned_to_id) assigned_to,
	description
FROM issues ss
-- ORDER BY date(closed_on)
;
SELECT * FROM issue_statuses
;
SELECT
--	(SELECT name FROM projects  WHERE id = p.parent_id) parent_name,
	p.name project_name,
-- 	(SELECT login FROM users WHERE id = i.assigned_to_id) assigned_to,
	MIN(i.start_date) start_date,
	MAX(i.closed_on) closed_on,
-- 	SUM(i.done_ratio * i.estimated_hours / 100) estimated_hours,
-- 	SUM(CASE i.status_id WHEN 1 THEN 0 WHEN 6 THEN 0 WHEN 5 THEN 100 WHEN 15 THEN 100
-- 		ELSE done_ratio END * i.estimated_hours / 100) estimated_hours_real,
	SUM((i.done_ratio + CASE i.status_id WHEN 1 THEN 0 WHEN 6 THEN 0 WHEN 5 THEN 100 WHEN 15 THEN 100
		ELSE done_ratio END) * i.estimated_hours / 200) estimated_hours_media
FROM issues i LEFT JOIN projects p ON p.id = i.project_id
GROUP BY i.project_id, p.name -- , a.assigned_to_id
order by 1, 2
;
-- Para tickets de Mesa de Ayuda
SELECT
	created_on AS creado,
	(SELECT login FROM users WHERE id = ss.author_id) autor,
	(SELECT tr.name
	 FROM trackers tr INNER JOIN projects_trackers pt ON tr.id = pt.tracker_id
	 WHERE pt.project_id = ss.project_id AND tr.id = ss.tracker_id) tipo,
	subject AS asunto,
	(SELECT name FROM enumerations WHERE type IN ('IssuePriority') AND id = ss.priority_id ) prioridad,
	(SELECT name FROM issue_statuses WHERE id = ss.status_id) estado,
	(SELECT value FROM custom_values
	 WHERE customized_type = 'Issue' AND customized_id = ss.id AND custom_field_id = 42) area_origen,
	(SELECT value FROM custom_values
	 WHERE customized_type = 'Issue' AND customized_id = ss.id AND custom_field_id = 36) persona_solicitante
FROM issues ss
WHERE ss.project_id = 3 -- Mesa de Ayuda

