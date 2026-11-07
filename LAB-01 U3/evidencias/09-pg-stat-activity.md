#Sesiones activas con pg_stat_activity

psql "postgresql://soporte_ana:<REDACTED>@127.0.0.1/comercial?application_name=reporte-mensual" -c "SELECT pg_sleep(90)"

SELECT pid, usename, application_name, client_addr, backend_start, state, left(query, 30) AS query FROM pg_stat_activity WHERE backend_type = 'client backend';
SELECT linea FROM dba.bitacora WHERE linea LIKE '%[PID]%' ORDER BY num;

##Resultado

 11486 | postgres | psql                     |             | 2026-11-07 04:41:54.599275-07 | active | SELECT pid, usename, applicati
 11059 | postgres | pgAdmin 4 - CONN:7203912 | 127.0.0.1   | 2026-11-07 04:39:46.979017-07 | idle   | SELECT oid, pg_catalog.format_
 11057 | postgres | pgAdmin 4 - DB:comercial | 127.0.0.1   | 2026-11-07 04:39:46.891466-07 | idle   | SELECT CASE 
(3 filas)

linea
2026-11-07 04:51:17.161 MST [13386] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=568
88
2026-11-07 04:51:17.170 MST [13386] user=soporte_ana db=comercial app=[desconocido] client=127.0.0.1 LOG:  conexión autenticada: identidad=«soporte_ana» mé
todo=scram-sha-256 (/var/lib/pgsql/data/pg_hba.conf:3)
2026-11-07 04:51:17.171 MST [13386] user=soporte_ana db=comercial app=[desconocido] client=127.0.0.1 LOG:  conexión autorizada: usuario=soporte_ana base_de
_datos=comercial nombre_de_aplicación=reporte-mensual SSL habilitado (protocolo=TLSv1.3, cifrado=TLS_AES_256_GCM_SHA384, bits=256)
(3 filas)


##Preguntas

¿Qué columna permite relacionar una sesión con sus líneas de bitácora?

El pid en la bitácora aparece entre corchetes.

Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?

La bitácora pg_stat_activity ya no muestra la sesion.

¿Por qué client_addr aparece vacío en la sesión del administrador?

Porque esa sesión usa el socket local, sin IP. Si pgAdmin se conecta por TCP, aparecerá 127.0.0.1.

##Interpretacion

pg_stat_activity es una fotografía del momento. La bitácora es la historia.
