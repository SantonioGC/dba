# Incidente sin bitácora

psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912XXX' WHERE id = 3"
SELECT linea FROM dba.bitacora WHERE linea ILIKE '%update%' OR linea LIKE '%app_ventas%';

## Resultado

postgres=# SELECT linea FROM dba.bitacora WHERE linea ILIKE '%update%' OR linea LIKE '%app_ventas%';
linea 
---+---
(0 filas)

## Preguntas

¿Puedes demostrar quién modificó el RFC?

No hay ninguna línea en la bitácora.

¿Puedes demostrar que el cambio no lo hizo soporte_ana?

No no se puede demostrar que no fue ella ni otro usuario, porque no hay registro de sesiones

Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?

No lo impidieron y no debían app_ventas tiene permiso de UPDATE. Los privilegios dicen quién puede, no quién lo hizo.

¿Qué tendría que haber estado configurado antes del incidente?

El colector, log_connections, un log_line_prefix con usuario, base, aplicación e IP, log_statement en mod y la auditoría con disparador.

## Interpretacion

La auditoría no puede configurarse después para eventos que ya ocurrieron.
