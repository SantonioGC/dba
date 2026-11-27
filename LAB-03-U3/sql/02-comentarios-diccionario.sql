
-- Comentario general de la tabla
COMMENT ON TABLE public.clientes IS
'Clientes de Comercializadora Norte. Propietario: Gerencia Comercial. Custodio: DBA. Clasificación: confidencial (contiene datos personales).';


--Identificador interno
COMMENT ON COLUMN public.clientes.id IS
'Identificador interno del cliente. Generado por el sistema.';


--Nombre del cliente
COMMENT ON COLUMN public.clientes.nombre IS
'Nombre completo. Dato personal identificador directo.';


--Correo electrónico
COMMENT ON COLUMN public.clientes.correo IS
'Correo de contacto. Dato personal. Uso: notificaciones al cliente.';


--Telefono
COMMENT ON COLUMN public.clientes.telefono IS
'Número telefónico del cliente. Dato personal. Uso: contacto y atención por parte de personal autorizado.';


--RFC
COMMENT ON COLUMN public.clientes.rfc IS
'RFC del cliente. Dato personal. Uso: facturación. Cambios auditados en auditoria.cambios_clientes.';


--Edad
COMMENT ON COLUMN public.clientes.edad IS
'Edad en años cumplidos. Dato personal. Uso: analítica agregada.';


--Ciudad
COMMENT ON COLUMN public.clientes.ciudad IS
'Ciudad de residencia del cliente. Dato de ubicación. Uso: atención comercial y análisis geográfico agregado.';


--Codigo postal
COMMENT ON COLUMN public.clientes.codigo_postal IS
'Código postal de residencia del cliente. Dato de ubicación. Uso: segmentación geográfica y análisis comercial.';


--Fecha de alta
COMMENT ON COLUMN public.clientes.fecha_alta IS
'Fecha de registro del cliente en el sistema. Uso: seguimiento de antiguedad y gestion comercial.';


--Segmento comercial
COMMENT ON COLUMN public.clientes.segmento IS
'Segmento comercial asignado al cliente. Uso: clasificacion de clientes y analisis comercial agregado.';


--verificacion de diccionario
SELECT
    c.ordinal_position AS pos,
    c.column_name AS columna,
    c.data_type AS tipo,
    c.character_maximum_length AS longitud,
    c.is_nullable AS acepta_nulos,
    c.column_default AS valor_por_defecto,
    col_description(
        'public.clientes'::regclass,
        c.ordinal_position
    ) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
ORDER BY c.ordinal_position;
