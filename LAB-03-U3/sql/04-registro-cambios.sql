CREATE SCHEMA gobierno;

REVOKE ALL ON SCHEMA gobierno FROM PUBLIC;

CREATE TABLE gobierno.solicitudes_cambio (
    folio TEXT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    solicitado_por TEXT NOT NULL,
    aprobado_por TEXT,
    ambiente TEXT NOT NULL
        CHECK (ambiente IN ('desarrollo', 'pruebas', 'produccion')),
    fecha_aprobacion TIMESTAMPTZ,
    ventana_inicio TIMESTAMPTZ,
    ventana_fin TIMESTAMPTZ
);

COMMENT ON TABLE gobierno.solicitudes_cambio IS
'Registro de solicitudes de cambio en la base comercial. Propietario: Comité de cambios. Custodio: DBA. Evidencia de POL-06.';

--Solicitud academica simulada CAM-2026-014
--No representa una autorizacion empresarial real
INSERT INTO gobierno.solicitudes_cambio VALUES (
    'CAM-2026-014',
    'Agregar columna canal_alta a clientes',
    'Gerencia Comercial',
    'Comite de cambios',
    'produccion',
    now() - interval '1 day',
    now() - interval '5 minutes',
    now() + interval '1 hour'
);

--Se verifico la ventana antes de modificar la tabla.
SELECT
    folio,
    aprobado_por,
    ventana_inicio,
    ventana_fin,
    ventana_inicio <= now()
        AND now() <= ventana_fin AS dentro_de_ventana
FROM gobierno.solicitudes_cambio
WHERE folio = 'CAM-2026-014';

--El resultado fue 't' al momento de la comprobacion.
ALTER TABLE public.clientes
ADD COLUMN canal_alta VARCHAR(20);

COMMENT ON COLUMN public.clientes.canal_alta IS
'Canal por el que se registro el cliente. Cambio CAM-2026-014.';

--Comprobar la solicitud registrada.
SELECT *
FROM gobierno.solicitudes_cambio
WHERE folio = 'CAM-2026-014';

--Verificar la columna incorporada.
SELECT
    c.column_name AS columna,
    c.data_type AS tipo,
    c.character_maximum_length AS longitud,
    c.is_nullable AS acepta_nulos,
    col_description(
        'public.clientes'::regclass,
        c.ordinal_position
    ) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
  AND c.column_name = 'canal_alta';

--Verificar que el disparador este habilitado.
SELECT
    tgname AS disparador,
    CASE tgenabled
        WHEN 'O' THEN 'HABILITADO'
        WHEN 'D' THEN 'DESHABILITADO'
        WHEN 'R' THEN 'SOLO REPLICA'
        WHEN 'A' THEN 'SIEMPRE'
    END AS estado
FROM pg_trigger
WHERE tgrelid = 'public.clientes'::regclass
  AND tgname = 'trg_auditoria_clientes';

SELECT
    num,
    left(linea, 23) AS momento,
    substring(linea FROM 'user=([^ ]*)') AS usuario,
    CASE
        WHEN linea ~* '(PASSWORD|IDENTIFIED BY)'
            THEN '[REDACTADO: posible credencial]'
        ELSE split_part(linea, 'sentencia: ', 2)
    END AS sentencia
FROM dba.bitacora
WHERE linea ~
    '(sentencia|statement): (CREATE|ALTER|DROP|GRANT|REVOKE)'
ORDER BY num;

