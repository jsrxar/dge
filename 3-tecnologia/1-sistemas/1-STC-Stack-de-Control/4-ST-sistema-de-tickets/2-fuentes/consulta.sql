select
	(SELECT name FROM projects  WHERE id = a.project_id) project_name,
	(SELECT trackers.name FROM trackers INNER JOIN projects_trackers ON trackers.id = projects_trackers.tracker_id
	 WHERE projects_trackers.project_id = a.project_id
	   AND trackers.id = a.tracker_id) tracker_name,
	subject,
	(SELECT name FROM enumerations WHERE type IN ('IssuePriority') AND id = a.priority_id ) priority_name,
	(SELECT name FROM issue_statuses WHERE id = a.status_id) status_name,
	done_ratio,
	estimated_hours,
	created_on,
	updated_on,
	start_date,
	due_date,
	closed_on,
	(SELECT login FROM users WHERE id = a.author_id) author,
	(SELECT login FROM users WHERE id = a.assigned_to_id) assigned_to,
	description
from issues a
-- order by date(closed_on)
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


