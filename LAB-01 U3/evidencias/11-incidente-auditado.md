#El incidente auditado

psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3"
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial" -c "SELECT * FROM auditoria.cambios_clientes"

SELECT id_evento, momento, usuario_sesion, usuario_efectivo, aplicacion, ip_cliente, operacion, id_cliente FROM auditoria.cambios_clientes ORDER BY id_evento;

##Resultado

a-sergio@fedora:~/dba/lab-04-hardening$ psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3"
UPDATE 1
da-sergio@fedora:~/dba/lab-04-hardening$ psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial" -c "SELECT * FROM auditoria.cambios_clientes"
ERROR:  permiso denegado al esquema auditoria

##Preguntas

Compara tu hipótesis de la Actividad 11 con este resultado.

Mi hipótesis: sin SECURITY DEFINER el disparador correría con los privilegios de app_ventas, que no puede escribir en auditoria, y el UPDATE fallaría. 
Resultado: con SECURITY DEFINER funcionó y usuario_efectivo salió postgres.
Escribe la sentencia UPDATE que restauraría el valor anterior.

UPDATE clientes SET rfc = 'GAMA780912XYZ' WHERE id = 3;

¿Qué columna conserva más valor para una investigación: aplicacion o ip_cliente? ¿Cuál puede falsificar el cliente con más facilidad?

ip_cliente tiene más valor la declara el propio cliente, así que la falsifica con facilidad.

## Interpretación

La auditoría muestra quién, cuándo, desde dónde y el valor anterior del RFC. app_ventas no puede leer la auditoría.
