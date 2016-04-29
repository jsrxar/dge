ALTER TABLE custom_field_enumerations ADD COLUMN id_ori INTEGER;

CREATE TABLE custom_field_enumerations_aux (
  id_ori integer,
  custom_field_id integer NOT NULL,
  name character varying NOT NULL,
  "position" integer NOT NULL DEFAULT 1
);
ALTER TABLE custom_field_enumerations OWNER TO redmine;
