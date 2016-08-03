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

INSERT INTO espacio (id_lugar, no_espacio) VALUES
(2, '525'),
(2, 'Cartel Espacio de la Memoria'),
(2, 'Cultura - Neurociencia'),
(2, 'Dinos'),
(2, 'Espacio Araucaria'),
(2, 'Espacio Joven Interior'),
(2, 'Espacio ZEN'),
(2, 'Luz de transito'),
(2, 'Microestadio'),
(2, 'Ornamentacion'),
(2, 'Teatrino'),
(2, 'Teatro Chico 1 (Ex Industria)'),
(2, 'Teatro Chico 2 (Ex Desarrollo Social)'),
(2, 'Torre de Comunicaciones'),
(2, 'Video Juegos (Microestadio)'),
(2, 'Youtubers');

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
('Luces'),
('Sonido'),
('Video');

INSERT INTO tipo_documento (no_tipo_documento) VALUES
('Acta'),
('Requerimiento'),
('Aprobación'),
('Proyecto');

INSERT INTO organismo (no_organismo, ds_organismo, co_cuit, tx_direccion, ds_observaciones) VALUES
('UNTREF', 'Universidad Nacional de Tres de Febrero', '30-68525606-8', 'Mosconi 2736 - Saenz Peña, Buenos Aires', NULL),
('SFMyCP', NULL, NULL, NULL, NULL);

INSERT INTO convenio (id_organismo, no_convenio, va_monto, ds_descripcion) VALUES
(1, 'UNTREF', NULL, NULL),
(2, 'SFMyCP - Ampliación de OC Licitación y legítimo abono', NULL, NULL),
(2, 'SFMyCP - Legítimo abono', NULL, NULL),
(NULL, 'Rotatorio', NULL, NULL);
