#Configuración de la bitocora

ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix = '%m [%p] user=%u db=%d app=%a client=%h ';
ALTER SYSTEM SET log_statement = 'ddl';
SELECT pg_reload_conf();
SELECT name, setting, source, sourcefile FROM pg_settings WHERE name IN ('log_connections','log_line_prefix','log_statement');
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 6;

##Resultado

      name       |                 setting                 |       source       |                sourcefile
-----------------+-----------------------------------------+--------------------+------------------------------------------
 log_connections | on                                      | configuration file | /var/lib/pgsql/data/postgresql.auto.conf
 log_line_prefix | %m [%p] user=%u db=%d app=%a client=%h  | configuration file | /var/lib/pgsql/data/postgresql.auto.conf
 log_statement   | mod                                     | configuration file | /var/lib/pgsql/data/postgresql.auto.conf
(3 filas)

 num | linea
                                                                                                
-----+------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
 294 | 2026-11-07 01:06:43.790 MST [12807] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 DETALLE:  La conexión coincidió con el archivo «/
var/lib/pgsql/data/pg_hba.conf» línea 3: «host    all   all   127.0.0.1/32       scram-sha-256»
 293 | 2026-11-07 01:06:43.790 MST [12807] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 FATAL:  la autentificación password falló para el
 usuario «app_ventas»
 292 | 2026-11-07 01:06:43.786 MST [12807] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 po
rt=34476
 291 | 2026-11-07 01:06:43.785 MST [12806] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 DETALLE:  La conexión coincidió con el archivo «/
var/lib/pgsql/data/pg_hba.conf» línea 3: «host    all   all   127.0.0.1/32       scram-sha-256»
 290 | 2026-11-07 01:06:43.785 MST [12806] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 FATAL:  la autentificación password falló para el
 usuario «app_ventas»
 289 | 2026-11-07 01:06:43.775 MST [12806] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 po
rt=34460
(6 filas)

##Preguntas

¿Por qué el proceso que registra el cambio es el principal y no tu sesión?

Porque la recarga la aplica el proceso principal del servidor.

¿Qué pasaría si alguien ejecutara ALTER SYSTEM SET log_statement = 'none'? ¿Quedaría rastro?

Sí la sentencia y la línea parameter log_statement changed to none al recargar. Después ya no se registrarían sentencias.

¿Por qué no se recomienda editar postgresql.auto.conf a mano?

Porque lo administra postgresql con ALTER SYSTEM. A mano puede quedar con errores y no deja registro de la sentencia.

##Interpretacion

Los parámetros quedaron en postgresql.auto.conf y el cambio de configuración quedó registrado por el proceso principal.
