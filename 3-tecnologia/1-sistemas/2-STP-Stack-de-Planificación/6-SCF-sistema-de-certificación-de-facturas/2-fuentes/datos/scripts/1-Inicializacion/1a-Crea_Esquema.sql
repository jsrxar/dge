DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
ALTER SCHEMA public OWNER TO facturas;
COMMENT ON SCHEMA audit IS 'Esquema general del sistema de certificación de facturas';

DROP SCHEMA audit CASCADE;
CREATE SCHEMA audit;
ALTER SCHEMA audit OWNER TO facturas;
REVOKE ALL ON SCHEMA audit FROM public;
