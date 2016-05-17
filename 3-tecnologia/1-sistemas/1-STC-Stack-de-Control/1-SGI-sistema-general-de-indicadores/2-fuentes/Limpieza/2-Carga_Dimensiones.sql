INSERT INTO dim_estado_limpieza (id_estado_limpieza, no_estado_limpieza, no_estado_insumos) VALUES
  (0, 'Sin datos',          'Sin datos'),
  (1, 'Muy sucio',          'Sin insumos'),
  (2, 'Limpieza regular',   'Insumos insuficientes'),
  (3, 'Limpieza buena',     'Faltante de insumos'),
  (4, 'Limpieza muy buena', 'Insumos suficientes'),
  (5, 'Limpieza Impecable', 'Insumos completos');

INSERT INTO dim_espacio_limpieza(id_espacio_limpieza, no_espacio_limpieza) VALUES
  (0, 'No Informado');

INSERT INTO dim_supervisor (id_supervisor, no_supervisor) VALUES
  (0, 'No Informado');
