INSERT INTO sga_origen (id_origen, no_origen) VALUES
(1, 'Pliego'),
(2, 'Manual'),
(3, 'Especificación');
ALTER SEQUENCE sga_origen_sq RESTART WITH 4;

INSERT INTO sga_periodicidad (id_periodicidad, va_frecuencia, no_periodicidad) VALUES
(1, 0, 'Permanente'),
(2, 0.25, '2 veces por la mañana'),
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
(10, '1ºP'),
(20, '2ºP'),
(25, '2ºEP'),
(30, '3ºP'),
(40, '4ºP'),
(45, '4ºEP'),
(50, '5ºP'),
(60, '6ºP'),
(70, '7ºP'),
(80, '8ºP'),
(90, '9ºP'),
(-10, '1ºSS'),
(-20, '2ºSS'),
(-30, '3ºSS'),
(-40, '4ºSS');
ALTER SEQUENCE sga_planta_sq RESTART WITH 100;

INSERT INTO sga_sector (id_sector, no_sector) VALUES (0, 'No Identificado');
INSERT INTO sga_sector (no_sector) VALUES
('Industrial'),
('Noble'),
('Transición'),
('Plaza Tango');