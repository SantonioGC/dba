# Modificaciones: ddl frente a mod

psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912XYZ' WHERE id = 3"

SELECT linea FROM dba.bitacora WHERE linea LIKE '%user=app_ventas%' ORDER BY num DESC LIMIT 3;
ALTER SYSTEM SET log_statement = 'mod';
SELECT pg_reload_conf();

psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET telefono = '6679990000' WHERE id = 3" -c "SELECT nombre, rfc FROM clientes WHERE id = 3"

SELECT linea FROM dba.bitacora WHERE linea LIKE '%log_statement%' OR linea LIKE '%user=app_ventas%statement:%' ORDER BY num;

 pg_reload_conf 
--------+-------
 t
(1 fila)

 2026-11-07 04:42:04.906 MST [11486] user=postgres db=postgres app=psql client=[local] LOG:  sentencia: ALTER SYSTEM SET log_statement = 'mod';
(1 fila)

## Preguntas

¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?

El nivel all registraría todas las consultas de todas las tablas esto hace mucho volumen, almacenamiento y riesgo de guardar datos sensibles.

¿Qué le falta a esta bitácora para revertir el cambio con certeza?

El valor anterior del dato.

## Interpretacion

Con ddl no aparece el UPDATE. Con mod sí aparece quién, cuándo, desde dónde y qué sentencia, pero no el valor anterior ni las lecturas.
