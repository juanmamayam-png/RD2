-- ═══════════════════════════════════════════════════════════
--  Migration 001 — Esquema inicial PostgreSQL 17
-- ═══════════════════════════════════════════════════════════
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE rol_usuario      AS ENUM ('ciudadano','conductor');
CREATE TYPE tipo_servicio     AS ENUM ('llevar','traer');
CREATE TYPE estado_solicitud  AS ENUM ('pendiente','aceptada','en_camino','recogido','entregado','cancelado');

CREATE TABLE usuarios (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nombre     VARCHAR(100) NOT NULL,
  telefono   VARCHAR(20)  UNIQUE NOT NULL,
  email      VARCHAR(150),
  password   VARCHAR(255) NOT NULL,
  rol        rol_usuario  NOT NULL,
  rating     NUMERIC(2,1) DEFAULT 5.0,
  activo     BOOLEAN      DEFAULT TRUE,
  creado_en  TIMESTAMPTZ  DEFAULT NOW()
);

CREATE TABLE conductores (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id       UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  vehiculo         VARCHAR(100),
  placa            VARCHAR(20),
  disponible       BOOLEAN     DEFAULT FALSE,
  lat_actual       NUMERIC(10,8),
  lng_actual       NUMERIC(11,8),
  ultima_ubicacion TIMESTAMPTZ
);

CREATE TABLE solicitudes (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ciudadano_id  UUID NOT NULL REFERENCES usuarios(id),
  conductor_id  UUID          REFERENCES usuarios(id),
  tipo          tipo_servicio NOT NULL,
  descripcion   TEXT          NOT NULL,
  peso_aprox    VARCHAR(50),
  origen_dir    VARCHAR(255)  NOT NULL,
  origen_lat    NUMERIC(10,8),
  origen_lng    NUMERIC(11,8),
  destino_dir   VARCHAR(255)  NOT NULL,
  destino_lat   NUMERIC(10,8),
  destino_lng   NUMERIC(11,8),
  pago_ofrecido NUMERIC(12,0),
  estado        estado_solicitud DEFAULT 'pendiente',
  eta_minutos   INT,
  distancia_km  NUMERIC(6,2),
  creado_en     TIMESTAMPTZ  DEFAULT NOW(),
  aceptado_en   TIMESTAMPTZ,
  entregado_en  TIMESTAMPTZ
);

CREATE TABLE calificaciones (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  solicitud_id UUID NOT NULL REFERENCES solicitudes(id),
  de_usuario   UUID NOT NULL REFERENCES usuarios(id),
  para_usuario UUID NOT NULL REFERENCES usuarios(id),
  estrellas    SMALLINT NOT NULL CHECK (estrellas BETWEEN 1 AND 5),
  comentario   TEXT,
  creado_en    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_solicitudes_estado     ON solicitudes(estado);
CREATE INDEX idx_solicitudes_ciudadano  ON solicitudes(ciudadano_id);
CREATE INDEX idx_conductores_disponible ON conductores(disponible);
