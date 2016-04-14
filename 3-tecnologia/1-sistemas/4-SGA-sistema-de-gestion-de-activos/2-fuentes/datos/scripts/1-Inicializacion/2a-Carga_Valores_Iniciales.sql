INSERT INTO sga_origen (id_origen, no_origen) VALUES
(1, 'Pliego'),
(2, 'Manual'),
(3, 'Especificaci�n');
ALTER SEQUENCE sga_origen_sq RESTART WITH 4;

INSERT INTO sga_periodicidad (id_periodicidad, va_frecuencia, no_periodicidad) VALUES
(1, 0, 'Permanente'),
(2, 0.25, '2 veces por la ma�ana'),
(3, 0.25, '2 veces por la tarde'),
(4, 0.5, '2 veces dia'),
(5, 1, 'Diaria'),
(6, 7, 'Semanal'),
(7, 15, 'Quincenal'),
(8, 30, 'Mensual'),
(9, 60, 'Bimestral'),
(10, 90, 'Trimestral'),
(11, 180, 'Semestral'),
(12, 365, 'Anual');
ALTER SEQUENCE sga_periodicidad_sq RESTART WITH 13;

INSERT INTO sga_planta (id_planta, no_planta) VALUES
(0, 'PB'),
(10, '1�P'),
(20, '2�P'),
(25, '2�EP'),
(30, '3�P'),
(40, '4�P'),
(45, '4�EP'),
(50, '5�P'),
(60, '6�P'),
(70, '7�P'),
(80, '8�P'),
(90, '9�P'),
(-10, '1�SS'),
(-20, '2�SS'),
(-30, '3�SS'),
(-40, '4�SS');
ALTER SEQUENCE sga_planta_sq RESTART WITH 100;

INSERT INTO sga_sector (id_sector, no_sector) VALUES (0, 'No Identificado');
INSERT INTO sga_sector (no_sector) VALUES
('Industrial'),
('Noble'),
('Transici�n'),
('Plaza Tango');