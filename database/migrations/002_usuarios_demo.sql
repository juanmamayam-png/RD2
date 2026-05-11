-- =====================================================================
-- SEED DE DATOS DE PRUEBA - MÓDULO RAPICAMPO
-- =====================================================================
-- Ejecutar después de crear las tablas con el DDL principal

-- ---------------------------------------------------------------------
-- USUARIOS FICTICIOS (UUIDs que simularían existir en la app global)
-- ---------------------------------------------------------------------
-- Estos UUIDs representan usuarios que existen en la base de datos global
-- Usuario 1: Carlos Pérez (solicitante activo)
-- Usuario 2: María Gómez (solicitante y realizadora)
-- Usuario 3: Juan Martínez (realizador)
-- Usuario 4: Ana López (solicitante)
-- Usuario 5: Pedro Rodríguez (realizador)

-- ---------------------------------------------------------------------
-- SERVICIOS DE PRUEBA
-- ---------------------------------------------------------------------

-- Servicio 1: Transporte de cosecha (DINERO) - PUBLICADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',
    '11111111-1111-1111-1111-111111111111', -- Carlos Pérez
    'Necesito transportar 10 bultos de café desde mi finca hasta el centro de acopio en Neiva. Aproximadamente 500 kg.',
    'Vereda La Vega, Palermo, Huila',
    'Calle 7 #5-24, Centro, Neiva',
    'PUBLICADO',
    'DINERO',
    '$80,000 COP',
    NULL,
    NOW() - INTERVAL '2 hours'
);

-- Servicio 2: Ayuda en siembra (TRUEQUE) - ACEPTADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e',
    '22222222-2222-2222-2222-222222222222', -- María Gómez
    'Requiero ayuda para sembrar 1 hectárea de maíz. Trabajo de un día completo.',
    'Finca El Porvenir, Baraya, Huila',
    'Finca El Porvenir, Baraya, Huila',
    'ACEPTADO',
    'TRUEQUE',
    'Jornada de trabajo',
    'Ofrezco 2 gallinas ponedoras o 20 kg de yuca',
    NOW() - INTERVAL '1 day'
);

-- Servicio 3: Transporte de ganado (DINERO) - EN_PROCESO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'c3d4e5f6-a7b8-4c9d-0e1f-2a3b4c5d6e7f',
    '11111111-1111-1111-1111-111111111111', -- Carlos Pérez
    'Transportar 5 reses desde mi finca hasta la feria ganadera. Necesito camión con rampa.',
    'Vereda El Cedral, Tello, Huila',
    'Feria Ganadera, Carrera 9 #25-30, Neiva',
    'EN_PROCESO',
    'DINERO',
    '$250,000 COP',
    NULL,
    NOW() - INTERVAL '3 days'
);

-- Servicio 4: Reparación de cerca (TRUEQUE) - PUBLICADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'd4e5f6a7-b8c9-4d0e-1f2a-3b4c5d6e7f8a',
    '44444444-4444-4444-4444-444444444444', -- Ana López
    'Necesito reparar 200 metros de cerca alambre de púas. Tengo los materiales.',
    'Finca La Esperanza, Campoalegre, Huila',
    'Finca La Esperanza, Campoalegre, Huila',
    'PUBLICADO',
    'TRUEQUE',
    'Día de trabajo',
    'Ofrezco 50 kg de plátano o 30 kg de arroz',
    NOW() - INTERVAL '5 hours'
);

-- Servicio 5: Compra de insumos (DINERO) - COMPLETADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'e5f6a7b8-c9d0-4e1f-2a3b-4c5d6e7f8a9b',
    '22222222-2222-2222-2222-222222222222', -- María Gómez
    'Comprar y traer 5 bultos de fertilizante desde la cooperativa hasta mi finca.',
    'Cooperativa Agrícola, Calle 12 #8-45, Neiva',
    'Vereda Los Cauchos, Rivera, Huila',
    'COMPLETADO',
    'DINERO',
    '$40,000 COP',
    NULL,
    NOW() - INTERVAL '5 days'
);

-- Servicio 6: Fumigación de cultivo (DINERO) - PUBLICADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c',
    '11111111-1111-1111-1111-111111111111', -- Carlos Pérez
    'Fumigar 2 hectáreas de cacao contra plagas. Tengo la bomba fumigadora.',
    'Finca San José, Aipe, Huila',
    'Finca San José, Aipe, Huila',
    'PUBLICADO',
    'DINERO',
    '$120,000 COP',
    NULL,
    NOW() - INTERVAL '8 hours'
);

-- Servicio 7: Cosecha de arroz (TRUEQUE) - PUBLICADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'a7b8c9d0-e1f2-4a3b-4c5d-6e7f8a9b0c1d',
    '44444444-4444-4444-4444-444444444444', -- Ana López
    'Necesito 3 personas para cosechar arroz manualmente. Jornada de 2 días.',
    'Hacienda El Arroz, Villavieja, Huila',
    'Hacienda El Arroz, Villavieja, Huila',
    'PUBLICADO',
    'TRUEQUE',
    'Dos días de trabajo',
    'Ofrezco 100 kg de arroz paddy por persona',
    NOW() - INTERVAL '1 hour'
);

-- Servicio 8: Arreglo de motor (DINERO) - CANCELADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'b8c9d0e1-f2a3-4b4c-5d6e-7f8a9b0c1d2e',
    '22222222-2222-2222-2222-222222222222', -- María Gómez
    'Reparación de motor de motoguadaña STIHL. Ya conseguí quien lo arregle.',
    'Vereda La Mesa, Yaguará, Huila',
    'Vereda La Mesa, Yaguará, Huila',
    'CANCELADO',
    'DINERO',
    '$60,000 COP',
    NULL,
    NOW() - INTERVAL '4 days'
);

-- Servicio 9: Transporte de pasajeros (DINERO) - PUBLICADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'c9d0e1f2-a3b4-4c5d-6e7f-8a9b0c1d2e3f',
    '11111111-1111-1111-1111-111111111111', -- Carlos Pérez
    'Llevar 4 personas desde Neiva hasta la vereda El Paraíso mañana a las 6am.',
    'Terminal de Transportes, Neiva',
    'Vereda El Paraíso, Gigante, Huila',
    'PUBLICADO',
    'DINERO',
    '$100,000 COP',
    NULL,
    NOW() - INTERVAL '30 minutes'
);

-- Servicio 10: Préstamo de herramienta (TRUEQUE) - PUBLICADO
INSERT INTO solicitudes.servicios (
    pk_id_servicio,
    id_usuario_solicitante,
    descripcion_servicio,
    direccion_origen,
    direccion_destino,
    estado_servicio,
    tipo_pago,
    valor_ofrecido,
    detalles_trueque,
    fecha_publicacion
) VALUES (
    'd0e1f2a3-b4c5-4d6e-7f8a-9b0c1d2e3f4a',
    '44444444-4444-4444-4444-444444444444', -- Ana López
    'Necesito alquilar una motosierra por 2 días para cortar árboles.',
    'Barrio El Caguán, Neiva',
    'Barrio El Caguán, Neiva',
    'PUBLICADO',
    'TRUEQUE',
    'Alquiler de herramienta',
    'Ofrezco prestarte mi guadañadora por el mismo tiempo',
    NOW() - INTERVAL '3 hours'
);

-- ---------------------------------------------------------------------
-- ACEPTACIONES DE SERVICIOS
-- ---------------------------------------------------------------------

-- Aceptación 1: Juan acepta el servicio de siembra (Servicio 2) - ACEPTADO
INSERT INTO solicitudes.aceptacion_servicios (
    pk_id_aceptacion,
    fk_id_servicio,
    id_usuario_realizador,
    fecha_aceptacion,
    estado_aceptacion
) VALUES (
    'f1a2b3c4-d5e6-4f7a-8b9c-0d1e2f3a4b5c',
    'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e',
    '33333333-3333-3333-3333-333333333333', -- Juan Martínez
    NOW() - INTERVAL '20 hours',
    'ACEPTADO'
);

-- Aceptación 2: Pedro acepta el transporte de ganado (Servicio 3) - ACEPTADO
INSERT INTO solicitudes.aceptacion_servicios (
    pk_id_aceptacion,
    fk_id_servicio,
    id_usuario_realizador,
    fecha_aceptacion,
    estado_aceptacion
) VALUES (
    'a2b3c4d5-e6f7-4a8b-9c0d-1e2f3a4b5c6d',
    'c3d4e5f6-a7b8-4c9d-0e1f-2a3b4c5d6e7f',
    '55555555-5555-5555-5555-555555555555', -- Pedro Rodríguez
    NOW() - INTERVAL '2 days',
    'ACEPTADO'
);

-- Aceptación 3: María acepta compra de insumos (Servicio 5) - ya COMPLETADO
INSERT INTO solicitudes.aceptacion_servicios (
    pk_id_aceptacion,
    fk_id_servicio,
    id_usuario_realizador,
    fecha_aceptacion,
    estado_aceptacion
) VALUES (
    'b3c4d5e6-f7a8-4b9c-0d1e-2f3a4b5c6d7e',
    'e5f6a7b8-c9d0-4e1f-2a3b-4c5d6e7f8a9b',
    '22222222-2222-2222-2222-222222222222', -- María Gómez
    NOW() - INTERVAL '4 days',
    'ACEPTADO'
);

-- Aceptación 4: Pedro intenta el servicio de arreglo pero desiste (Servicio 8)
INSERT INTO solicitudes.aceptacion_servicios (
    pk_id_aceptacion,
    fk_id_servicio,
    id_usuario_realizador,
    fecha_aceptacion,
    fecha_actualizacion,
    estado_aceptacion
) VALUES (
    'c4d5e6f7-a8b9-4c0d-1e2f-3a4b5c6d7e8f',
    'b8c9d0e1-f2a3-4b4c-5d6e-7f8a9b0c1d2e',
    '55555555-5555-5555-5555-555555555555', -- Pedro Rodríguez
    NOW() - INTERVAL '4 days',
    NOW() - INTERVAL '3 days',
    'DESISTIDO'
);

-- Aceptación 5: Juan acepta fumigación pero luego desiste (Servicio 6)
INSERT INTO solicitudes.aceptacion_servicios (
    pk_id_aceptacion,
    fk_id_servicio,
    id_usuario_realizador,
    fecha_aceptacion,
    fecha_actualizacion,
    estado_aceptacion
) VALUES (
    'd5e6f7a8-b9c0-4d1e-2f3a-4b5c6d7e8f9a',
    'f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c',
    '33333333-3333-3333-3333-333333333333', -- Juan Martínez
    NOW() - INTERVAL '6 hours',
    NOW() - INTERVAL '2 hours',
    'DESISTIDO'
);

-- ---------------------------------------------------------------------
-- VERIFICACIÓN DE DATOS
-- ---------------------------------------------------------------------
SELECT 'Seed completado exitosamente!' AS mensaje;

SELECT 
    'Servicios creados: ' || COUNT(*) AS resumen 
FROM solicitudes.servicios;

SELECT 
    'Aceptaciones creadas: ' || COUNT(*) AS resumen 
FROM solicitudes.aceptacion_servicios;

-- Mostrar resumen por estado
SELECT 
    estado_servicio,
    COUNT(*) as cantidad
FROM solicitudes.servicios
GROUP BY estado_servicio
ORDER BY cantidad DESC;