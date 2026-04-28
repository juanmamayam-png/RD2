-- Datos de prueba para desarrollo
-- Contraseña de todos: demo1234 (hash bcrypt real — regenerar en producción)
INSERT INTO usuarios (nombre, telefono, email, password, rol) VALUES
  ('Carlos Martínez', '3120000001', 'carlos@demo.co', '$2b$10$REEMPLAZAR_CON_HASH_REAL', 'conductor'),
  ('Ana Ríos',        '3120000002', 'ana@demo.co',    '$2b$10$REEMPLAZAR_CON_HASH_REAL', 'conductor'),
  ('María López',     '3120000003', 'maria@demo.co',  '$2b$10$REEMPLAZAR_CON_HASH_REAL', 'ciudadano'),
  ('José Torres',     '3120000004', 'jose@demo.co',   '$2b$10$REEMPLAZAR_CON_HASH_REAL', 'ciudadano')
ON CONFLICT DO NOTHING;

INSERT INTO conductores (usuario_id, vehiculo, placa, disponible, lat_actual, lng_actual)
SELECT id, 'Moto Honda CB125', 'ABC123', TRUE, 2.9320, -75.2780 FROM usuarios WHERE telefono='3120000001';
INSERT INTO conductores (usuario_id, vehiculo, placa, disponible, lat_actual, lng_actual)
SELECT id, 'Moto Yamaha YBR',  'XYZ456', TRUE, 2.9250, -75.2850 FROM usuarios WHERE telefono='3120000002';
