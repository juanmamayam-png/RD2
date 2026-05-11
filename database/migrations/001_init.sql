\set ON_ERROR_STOP on

-- -------------------------------------------------------------
-- EXTENSIONES
-- -------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -------------------------------------------------------------
-- SCHEMAS
-- -------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS catalogos;
CREATE SCHEMA IF NOT EXISTS solicitudes;

-- -------------------------------------------------------------
-- TIPOS ENUMERADOS
-- -------------------------------------------------------------
CREATE TYPE catalogos.tipo_pago AS ENUM('DINERO', 'TRUEQUE');

CREATE TYPE catalogos.tipo_estado_servicio AS ENUM(
    'PUBLICADO',
    'ACEPTADO',
    'EN_PROCESO',
    'COMPLETADO',
    'CANCELADO'
);

CREATE TYPE solicitudes.tipo_estado_aceptacion AS ENUM(
    'ACEPTADO',
    'DESISTIDO'
);

-- -------------------------------------------------------------
-- TABLA: SERVICIOS
-- -------------------------------------------------------------
CREATE TABLE solicitudes.servicios(
    pk_id_servicio UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_usuario_solicitante UUID NOT NULL,
    descripcion_servicio TEXT NOT NULL,
    direccion_origen VARCHAR(255) NOT NULL,
    direccion_destino VARCHAR(255) NOT NULL,
    estado_servicio catalogos.tipo_estado_servicio DEFAULT 'PUBLICADO' NOT NULL,
    tipo_pago catalogos.tipo_pago NOT NULL,
    valor_ofrecido VARCHAR(100) NOT NULL,
    detalles_trueque TEXT,
    fecha_publicacion TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_actualizacion TIMESTAMP,
    CONSTRAINT chk_trueque CHECK (
        tipo_pago != 'TRUEQUE' OR detalles_trueque IS NOT NULL
    )
);

-- Índices
CREATE INDEX idx_servicios_usuario ON solicitudes.servicios(id_usuario_solicitante);
CREATE INDEX idx_servicios_estado ON solicitudes.servicios(estado_servicio);
CREATE INDEX idx_servicios_fecha ON solicitudes.servicios(fecha_publicacion DESC);

-- Comentarios
COMMENT ON TABLE solicitudes.servicios IS 'Servicios publicados por usuarios para ser realizados por otros';
COMMENT ON COLUMN solicitudes.servicios.tipo_pago IS 'Forma de pago: DINERO o TRUEQUE';
COMMENT ON COLUMN solicitudes.servicios.detalles_trueque IS 'Descripción del trueque';

-- Trigger función
CREATE OR REPLACE FUNCTION solicitudes.fn_actualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_actualizar_servicio
BEFORE UPDATE ON solicitudes.servicios
FOR EACH ROW EXECUTE FUNCTION solicitudes.fn_actualizar_timestamp();

-- -------------------------------------------------------------
-- TABLA: ACEPTACIONES
-- -------------------------------------------------------------
CREATE TABLE solicitudes.aceptacion_servicios(
    pk_id_aceptacion UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_id_servicio UUID NOT NULL REFERENCES solicitudes.servicios(pk_id_servicio) ON DELETE CASCADE,
    id_usuario_realizador UUID NOT NULL,
    fecha_aceptacion TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_actualizacion TIMESTAMP,
    estado_aceptacion solicitudes.tipo_estado_aceptacion DEFAULT 'ACEPTADO' NOT NULL
);

-- Índices
CREATE INDEX idx_aceptaciones_servicio ON solicitudes.aceptacion_servicios(fk_id_servicio);
CREATE INDEX idx_aceptaciones_usuario ON solicitudes.aceptacion_servicios(id_usuario_realizador);
CREATE INDEX idx_aceptaciones_estado ON solicitudes.aceptacion_servicios(estado_aceptacion);

-- Comentarios
COMMENT ON TABLE solicitudes.aceptacion_servicios IS 'Usuarios que aceptaron servicios';
COMMENT ON COLUMN solicitudes.aceptacion_servicios.estado_aceptacion IS 'ACEPTADO o DESISTIDO';

-- Trigger
CREATE TRIGGER tr_actualizar_aceptacion
BEFORE UPDATE ON solicitudes.aceptacion_servicios
FOR EACH ROW EXECUTE FUNCTION solicitudes.fn_actualizar_timestamp();

-- -------------------------------------------------------------
-- ÍNDICE ÚNICO (CORREGIDO)
-- -------------------------------------------------------------
CREATE UNIQUE INDEX idx_una_aceptacion_activa 
ON solicitudes.aceptacion_servicios(fk_id_servicio) 
WHERE estado_aceptacion = 'ACEPTADO'::solicitudes.tipo_estado_aceptacion;

COMMENT ON INDEX solicitudes.idx_una_aceptacion_activa 
IS 'Solo una aceptación activa por servicio';

-- -------------------------------------------------------------
-- FUNCIÓN: sincronizar estado
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION solicitudes.fn_actualizar_estado_servicio()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado_aceptacion = 'ACEPTADO' THEN
        UPDATE solicitudes.servicios 
        SET estado_servicio = 'ACEPTADO'
        WHERE pk_id_servicio = NEW.fk_id_servicio;
    END IF;

    IF NEW.estado_aceptacion = 'DESISTIDO' THEN
        IF NOT EXISTS (
            SELECT 1 FROM solicitudes.aceptacion_servicios 
            WHERE fk_id_servicio = NEW.fk_id_servicio 
            AND estado_aceptacion = 'ACEPTADO'
            AND pk_id_aceptacion != NEW.pk_id_aceptacion
        ) THEN
            UPDATE solicitudes.servicios 
            SET estado_servicio = 'PUBLICADO'
            WHERE pk_id_servicio = NEW.fk_id_servicio;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_sincronizar_estado_servicio
AFTER INSERT OR UPDATE OF estado_aceptacion 
ON solicitudes.aceptacion_servicios
FOR EACH ROW 
EXECUTE FUNCTION solicitudes.fn_actualizar_estado_servicio();

-- -------------------------------------------------------------
-- VISTAS
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW solicitudes.v_servicios_completos AS
SELECT 
    s.*,
    a.pk_id_aceptacion,
    a.id_usuario_realizador,
    a.fecha_aceptacion,
    a.estado_aceptacion
FROM solicitudes.servicios s
LEFT JOIN solicitudes.aceptacion_servicios a 
    ON s.pk_id_servicio = a.fk_id_servicio 
    AND a.estado_aceptacion = 'ACEPTADO';

CREATE OR REPLACE VIEW solicitudes.v_servicios_disponibles AS
SELECT *
FROM solicitudes.servicios s
WHERE s.estado_servicio = 'PUBLICADO'
AND NOT EXISTS (
    SELECT 1 FROM solicitudes.aceptacion_servicios a
    WHERE a.fk_id_servicio = s.pk_id_servicio
    AND a.estado_aceptacion = 'ACEPTADO'
)
ORDER BY s.fecha_publicacion DESC;