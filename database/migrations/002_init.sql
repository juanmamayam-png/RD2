--LIMPIEZA DEL SCHEMA 001_init.sql DEFINIDO ANTERIORMENTE
DROP TABLE IF EXISTS calificaciones CASCADE;

DROP TABLE IF EXISTS solicitudes CASCADE;

DROP TABLE IF EXISTS conductores CASCADE;

DROP TABLE IF EXISTS usuarios CASCADE;

DROP TYPE IF EXISTS rol_usuario CASCADE;

DROP TYPE IF EXISTS tipo_servicio CASCADE;

DROP TYPE IF EXISTS estado_solicitud CASCADE;

--EXTENSIÓN DE POSTIGS PARA GEOREFERENCIACIÓN
CREATE EXTENSION IF NOT EXISTS postgis;

--CREACIÓN DE SCHEMAS 

CREATE SCHEMA usuarios;

CREATE SCHEMA catalogos;

CREATE SCHEMA solicitudes;

--CREACIÓN DE TIPOS ENUMERADOS 
CREATE TYPE usuarios.tipo_usuario AS ENUM ('CIUDADANO', 'CONDUCTOR');

CREATE TYPE solicitudes.tipo_servicio AS ENUM ('llevar', 'traer');

CREATE TYPE solicitudes.tipo_estado_solicitud_servicio AS ENUM (
    'pendiente',
    'aceptado',
    'en_camino',
    'recogido',
    'entregado',
    'cancelado'
);

CREATE TYPE catalogos.tipo_sigla AS ENUM ('cc', 'ti');

CREATE SEQUENCE usuarios.sec_ref_ciudadanos
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE usuarios.sec_ref_conductores
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE solicitudes.sec_ref_servicios
    START WITH 1
    INCREMENT BY 1;


--DDL TABLAS EN EL SCHEMA catalogos

CREATE TABLE
    catalogos.tipos_documento_identificacion (
        pk_id_tipo_doc INT,
        tipo_documento VARCHAR(50) NOT NULL,
        sigla_documento catalogos.tipo_sigla NOT NULL,
        created_at TIMESTAMP DEFAULT NOW () NOT NULL,
        updated_at TIMESTAMP NULL
    );

ALTER TABLE catalogos.tipos_documento_identificacion ADD CONSTRAINT pk_tipo_doc PRIMARY KEY (pk_id_tipo_doc);

ALTER TABLE catalogos.tipos_documento_identificacion ADD CONSTRAINT uq_tipo_documento UNIQUE (tipo_documento);

ALTER TABLE catalogos.tipos_documento_identificacion ADD CONSTRAINT uq_sigla_documento UNIQUE (sigla_documento);

CREATE SEQUENCE catalogos.sec_tipos_doc_id
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION catalogos.fn_asignar_id_tipo_doc_id()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.pk_id_tipo_doc := nextval('catalogos.sec_tipos_doc_id');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_id_tipos_doc
BEFORE INSERT ON catalogos.tipos_documento_identificacion
FOR EACH ROW EXECUTE FUNCTION catalogos.fn_asignar_id_tipo_doc_id();

CREATE TABLE
    catalogos.tipos_vehiculo (
        pk_id_tipo_vehiculo INT,
        tipo_vehiculo VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT NOW () NOT NULL,
        updated_at TIMESTAMP
    );

ALTER TABLE catalogos.tipos_vehiculo ADD CONSTRAINT pk_tipo_vehilo PRIMARY KEY (pk_id_tipo_vehiculo);

ALTER TABLE catalogos.tipos_vehiculo ADD CONSTRAINT uq_tipo_vehiculo UNIQUE (tipo_vehiculo);

CREATE SEQUENCE catalogos.sec_id_tipos_vehiculo
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION catalogos.fn_asignar_id_tipos_vehiculo()
RETURNS TRIGGER AS
$$
BEGIN 
        NEW.pk_id_tipo_vehiculo := nextval('catalogos.sec_id_tipos_vehiculo');
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_id_tipos_vehiculo
BEFORE INSERT ON catalogos.tipos_vehiculo
FOR EACH ROW EXECUTE FUNCTION catalogos.fn_asignar_id_tipos_vehiculo();

--usuarios.usuarios

CREATE TABLE
    catalogos.tipos_servicio (
        pk_id_tipo_servicio INT,
        servicio solicitudes.tipo_servicio NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW (),
        updated_at TIMESTAMP
    );

ALTER TABLE catalogos.tipos_servicio ADD CONSTRAINT pk_tipo_servicio PRIMARY KEY (pk_id_tipo_servicio);

ALTER TABLE catalogos.tipos_servicio ADD CONSTRAINT uq_tipo_servicio UNIQUE (servicio);

CREATE SEQUENCE catalogos.sec_id_tipos_servicio
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION catalogos.fn_asignar_pk_tipos_servicio()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.pk_id_tipo_servicio := nextval('catalogos.sec_id_tipos_servicio');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_pk_tipos_servicio
BEFORE INSERT ON catalogos.tipos_servicio
FOR EACH ROW EXECUTE FUNCTION catalogos.fn_asignar_pk_tipos_servicio();

CREATE TABLE
    usuarios.usuarios (
        pk_id_usuario INT,
        id_usuario_externo INT NOT NULL,
        primer_nombre VARCHAR(50) NOT NULL,
        segundo_nombre VARCHAR(50) NULL,
        primer_apellido VARCHAR(50) NOT NULL,
        segundo_apellido VARCHAR(50) NULL,
        fk_id_tipo_documento INT NOT NULL,
        numero_doc_identificacion VARCHAR(20) NOT NULL,
        tipo_usuario usuarios.tipo_usuario NOT NULL,
        estado BOOLEAN NOT NULL DEFAULT TRUE,
        created_at TIMESTAMP NOT NULL DEFAULT NOW (),
        updated_at TIMESTAMP NULL
    );

ALTER TABLE usuarios.usuarios ADD CONSTRAINT pk_usuario PRIMARY KEY (pk_id_usuario);

ALTER TABLE usuarios.usuarios ADD CONSTRAINT uq_usuario_externo UNIQUE (id_usuario_externo);

ALTER TABLE usuarios.usuarios ADD CONSTRAINT uq_documento_id UNIQUE (numero_doc_identificacion);

ALTER TABLE usuarios.usuarios ADD CONSTRAINT fk_tipo_documento_usuario FOREIGN KEY (fk_id_tipo_documento) REFERENCES catalogos.tipos_documento_identificacion (pk_id_tipo_doc);

CREATE SEQUENCE usuarios.sec_id_usuarios
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION usuarios.fn_asignar_id_usuarios()
RETURNS TRIGGER AS
$$ 
BEGIN
        NEW.pk_id_usuario := nextval('usuarios.sec_id_usuarios');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_id_usuarios
BEFORE INSERT ON usuarios.usuarios
FOR EACH ROW EXECUTE FUNCTION usuarios.fn_asignar_id_usuarios();

--usuarios.conductores

CREATE TABLE
    usuarios.conductores (
        pk_id_conductor INT,
        fk_id_usuario INT NOT NULL,
        referencia VARCHAR(10),
        created_at TIMESTAMP NOT NULL DEFAULT NOW (),
        updated_at TIMESTAMP NULL
    );

ALTER TABLE usuarios.conductores ADD CONSTRAINT pk_conductor PRIMARY KEY (pk_id_conductor);

ALTER TABLE usuarios.conductores ADD CONSTRAINT fk_conductor_usuario FOREIGN KEY (fk_id_usuario) REFERENCES usuarios.usuarios (pk_id_usuario) ON DELETE CASCADE;

ALTER TABLE usuarios.conductores ADD CONSTRAINT uq_ref_conductor UNIQUE(referencia);

CREATE SEQUENCE usuarios.sec_id_conductores
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION usuarios.fn_asignar_pk_conductores()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.pk_id_conductor := nextval('usuarios.sec_id_conductores');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_pk_conductores
BEFORE INSERT ON usuarios.conductores
FOR EACH ROW EXECUTE FUNCTION usuarios.fn_asignar_pk_conductores();

--usuarios.ciudadanos

CREATE TABLE
    usuarios.ciudadanos (
        pk_id_ciudadano INT,
        fk_id_usuario INT NOT NULL,
        referencia VARCHAR(10) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW (),
        updated_at TIMESTAMP NULL
    );

ALTER TABLE usuarios.ciudadanos ADD CONSTRAINT pk_ciudadano PRIMARY KEY (pk_id_ciudadano);

ALTER TABLE usuarios.ciudadanos ADD CONSTRAINT fk_ciudadano_usuairo FOREIGN KEY (fk_id_usuario) REFERENCES usuarios.usuarios (pk_id_usuario) ON DELETE CASCADE;

ALTER TABLE usuarios.ciudadanos ADD CONSTRAINT uq_ref_ciudadano UNIQUE(referencia);

CREATE SEQUENCE usuarios.sec_id_ciudadanos
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION usuarios.fn_asignar_pk_ciudadanos()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.pk_id_ciudadano := nextval('usuarios.sec_id_ciudadanos');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_asignar_pk_ciudadanos
BEFORE INSERT ON usuarios.ciudadanos
FOR EACH ROW EXECUTE FUNCTION usuarios.fn_asignar_pk_ciudadanos();

CREATE OR REPLACE FUNCTION usuarios.fn_generar_ref_ciudadano()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.referencia := 'CD-' || LPAD(
        nextval('usuarios.sec_ref_ciudadanos')::TEXT, 
        3, 
        '0'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_generar_ref_ciudadano
BEFORE INSERT ON usuarios.ciudadanos
FOR EACH ROW EXECUTE FUNCTION usuarios.fn_generar_ref_ciudadano();


--solicitudes.vehiculos

CREATE TABLE
    solicitudes.vehiculos (
        pk_id_vehiculo INT,
        placa VARCHAR(6) NOT NULL,
        referencia VARCHAR(15) NOT NULL,
        estado VARCHAR(50) NOT NULL,
        ubicacion_actual GEOGRAPHY (POINT, 4326),
        ultima_ubicacion GEOGRAPHY (POINT, 4326),
        fk_conductor INT NOT NULL,
        fk_tipo_vehiculo INT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW (),
        updated_at TIMESTAMP NULL
    );

ALTER TABLE solicitudes.vehiculos ADD CONSTRAINT pk_vehiculo PRIMARY KEY (pk_id_vehiculo);

ALTER TABLE solicitudes.vehiculos ADD CONSTRAINT uq_placa UNIQUE (placa);

ALTER TABLE solicitudes.vehiculos ADD CONSTRAINT fk_vehiculo_conductor FOREIGN KEY (fk_conductor) REFERENCES usuarios.conductores (pk_id_conductor);

ALTER TABLE solicitudes.vehiculos ADD CONSTRAINT fk_vehiculo_tipo_vehiculo FOREIGN KEY (fk_tipo_vehiculo) REFERENCES catalogos.tipos_vehiculo (pk_id_tipo_vehiculo);

ALTER TABLE solicitudes.vehiculos ADD CONSTRAINT uq_ref_vehiculo UNIQUE(referencia);


CREATE SEQUENCE solicitudes.sec_id_vehiculos
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION solicitudes.fn_asignar_pk_vehiculos()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.pk_id_vehiculo := nextval('solicitudes.sec_id_vehiculos');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_pk_vehiculos
BEFORE INSERT ON solicitudes.vehiculos
FOR EACH ROW EXECUTE FUNCTION solicitudes.fn_asignar_pk_vehiculos();

CREATE OR REPLACE FUNCTION solicitudes.fn_generar_ref_vehiculo()
RETURNS TRIGGER AS
$$
BEGIN
    -- Toma la placa completa en mayúsculas: VH-ABC123
    NEW.referencia := 'VH-' || UPPER(TRIM(NEW.placa));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_generar_ref_vehiculo
BEFORE INSERT ON solicitudes.vehiculos
FOR EACH ROW EXECUTE FUNCTION solicitudes.fn_generar_ref_vehiculo();

--solicitudes.servicios

CREATE TABLE
    solicitudes.servicios (
        pk_id_servicio INT,
        referencia VARCHAR(10) NOT NULL,
        direccion_origen VARCHAR(100) NOT NULL,
        ubicacion_origen GEOGRAPHY (POINT, 4326) NOT NULL,
        estado solicitudes.tipo_estado_solicitud_servicio NOT NULL,
        direccion_destino VARCHAR(100) NOT NULL,
        ubicacion_destino GEOGRAPHY (POINT, 4326) NOT NULL,
        fk_id_tipo_servicio INT NOT NULL,
        pago_ofrecido NUMERIC(10,2) NOT NULL,
        fecha_solicitud TIMESTAMP NOT NULL DEFAULT NOW (),
        fk_id_ciudadano INT NOT NULL,
        fk_id_conductor INT NULL,
        fecha_asiganacion TIMESTAMP NULL,
        fecha_finalizacion TIMESTAMP
    );

ALTER TABLE solicitudes.servicios ADD CONSTRAINT pk_servicio PRIMARY KEY (pk_id_servicio);

ALTER TABLE solicitudes.servicios ADD CONSTRAINT fk_servicio_tipo FOREIGN KEY (fk_id_tipo_servicio) REFERENCES catalogos.tipos_servicio (pk_id_tipo_servicio);

ALTER TABLE solicitudes.servicios ADD CONSTRAINT fk_ciudadano FOREIGN KEY (fk_id_ciudadano) REFERENCES usuarios.ciudadanos (pk_id_ciudadano);

ALTER TABLE solicitudes.servicios ADD CONSTRAINT fk_conductor FOREIGN KEY (fk_id_conductor) REFERENCES usuarios.conductores (pk_id_conductor);

ALTER TABLE solicitudes.servicios ADD CONSTRAINT uq_ref_servicio UNIQUE(referencia);  

CREATE SEQUENCE solicitudes.sec_id_servicios
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION solicitudes.fn_asignar_pk_servicios()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.pk_id_servicio := nextval('solicitudes.sec_id_servicios');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_pk_servicios
BEFORE INSERT ON solicitudes.servicios
FOR EACH ROW EXECUTE FUNCTION solicitudes.fn_asignar_pk_servicios();

CREATE OR REPLACE FUNCTION usuarios.fn_generar_ref_conductor()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.referencia := 'CN-' || LPAD(
        nextval('usuarios.sec_ref_conductores')::TEXT, 
        3, 
        '0'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_generar_ref_conductor
BEFORE INSERT ON usuarios.conductores
FOR EACH ROW EXECUTE FUNCTION usuarios.fn_generar_ref_conductor();

CREATE OR REPLACE FUNCTION solicitudes.fn_generar_ref_servicio()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.referencia := 'SV-' || LPAD(
        nextval('solicitudes.sec_ref_servicios')::TEXT, 
        5, 
        '0'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_generar_ref_servicio
BEFORE INSERT ON solicitudes.servicios
FOR EACH ROW EXECUTE FUNCTION solicitudes.fn_generar_ref_servicio();


--solicitudes.calificaciones

CREATE TABLE
    solicitudes.calificaciones (
        pk_id_calificacion INT,
        num_estrellas INT NOT NULL CHECK (num_estrellas BETWEEN 1 AND 5),
        fk_id_servicio INT,
        created_at TIMESTAMP NOT NULL DEFAULT NOW (),
        updated_at TIMESTAMP
    );

ALTER TABLE solicitudes.calificaciones ADD CONSTRAINT pk_calificacion PRIMARY KEY (pk_id_calificacion);

ALTER TABLE solicitudes.calificaciones ADD CONSTRAINT fk_calificacion_servicio FOREIGN KEY (fk_id_servicio) REFERENCES solicitudes.servicios (pk_id_servicio);

CREATE SEQUENCE solicitudes.sec_id_calificaciones
START WITH 1
INCREMENT BY 1;

CREATE FUNCTION solicitudes.fn_asignar_pk_calificaciones()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.pk_id_calificacion := nextval('solicitudes.sec_id_calificaciones');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_pk_calificaciones
BEFORE INSERT ON solicitudes.calificaciones
FOR EACH ROW EXECUTE FUNCTION solicitudes.fn_asignar_pk_calificaciones();

CREATE INDEX idx_conductores_fk_usuario ON usuarios.conductores(fk_id_usuario);

CREATE INDEX idx_servicios_fk_ciudadano ON solicitudes.servicios(fk_id_ciudadano);

CREATE INDEX idx_ciudadanos_fk_usuario   ON usuarios.ciudadanos(fk_id_usuario);

CREATE INDEX idx_vehiculos_fk_conductor  ON solicitudes.vehiculos(fk_conductor);

CREATE INDEX idx_servicios_fk_conductor  ON solicitudes.servicios(fk_id_conductor);

CREATE INDEX idx_calificaciones_fk_serv  ON solicitudes.calificaciones(fk_id_servicio);