insert into custom_values (customized_type, customized_id, custom_field_id, value, user_id)
SELECT customized_type, customized_id, 45, value, user_id
FROM custom_values
where custom_field_id = 27
and customized_id != 519
and length(value)>1

alter table projects add default_assignee_id int;
