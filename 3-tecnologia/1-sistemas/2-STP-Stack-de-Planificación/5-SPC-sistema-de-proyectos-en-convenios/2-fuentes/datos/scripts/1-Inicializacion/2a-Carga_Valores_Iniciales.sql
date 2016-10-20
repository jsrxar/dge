INSERT INTO area_requirente (no_area_requirente) VALUES
('CAVAS'),
('CUEVAS'),
('LUCAS/CAMPOS'),
('LUCAS/CUEVAS'),
('MARTIN LUCAS'),
('URTIAGA');

INSERT INTO lugar (no_lugar) VALUES
('CCK'),
('TECNOPOLIS'),
('FEDERAL'),
('EXTERIOR');

INSERT INTO tipo_proyecto (no_tipo_proyecto) VALUES
('AUDIOVISUAL'),
('FEDERAL/LA RIOJA'),
('FEDERAL/USUAHIA'),
('MUESTRA'),
('MUESTRA ARTES VISUALES'),
('MUESTRA GENERAL'),
('MUESTRA INTERNACIONAL'),
('OBRA'),
('PRODUCCION AUDIOVISUAL'),
('PUESTA EN VALOR'),
('SERVICIOS GENERALES'),
('STAND/MUESTRA'),
('STAND/MUESTRA PAKA PAKA');

INSERT INTO tipo_item (no_tipo_item) VALUES
('Art�stica'),
('Log�stica'),
('T�cnica - General'),
('T�cnica - Luces'),
('T�cnica - Sonido'),
('T�cnica - Video');

INSERT INTO organismo (no_organismo, ds_organismo, co_cuit, tx_direccion, ds_observaciones) VALUES
('UNTREF', 'Universidad Nacional de Tres de Febrero', '30-68525606-8', 'Mosconi 2736 - Saenz Pe�a, Buenos Aires', NULL),
('SFMyCP', NULL, NULL, NULL, NULL);

INSERT INTO convenio (id_organismo, no_convenio, va_monto, ds_descripcion) VALUES
(1, 'UNTREF', NULL, NULL),
(2, 'SFMyCP - Ampliaci�n de OC Licitaci�n y leg�timo abono', NULL, NULL),
(2, 'SFMyCP - Leg�timo abono', NULL, NULL),
(NULL, 'Rotatorio', NULL, NULL);
