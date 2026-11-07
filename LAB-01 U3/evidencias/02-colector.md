# Colector de bitácora

ALTER SYSTEM SET logging_collector = on;

SELECT pg_current_logfile();
CREATE SCHEMA dba;
REVOKE ALL ON SCHEMA dba FROM PUBLIC;
CREATE VIEW dba.bitacora AS SELECT t.n AS num, t.linea FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n') WITH ORDINALITY AS t(linea, n) WHERE t.linea <> '';

SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 10;

## Resultado

   pg_current_logfile
 log/postgresql-Sat.log
(1 fila)

----------------+--------------

 num |  linea
-----+---------------------------------------------------------------
 286 |         WHERE t.linea <> '';
 285 |              WITH ORDINALITY AS t(linea, n)
 284 |         FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
 283 |         SELECT t.n AS num, t.linea
 282 | 2026-11-07 01:03:19.378 MST [11318] user=postgres db=postgres app=psql client=[local] LOG:  sentencia: CREATE VIEW dba.bitacora AS
 281 | 2026-11-07 01:03:15.814 MST [11318] user=postgres db=postgres app=psql client=[local] LOG:  sentencia: REVOKE ALL ON SCHEMA dba FROM PUBLIC;
 280 | 2026-11-07 01:03:15.805 MST [11318] user=postgres db=postgres app=psql client=[local] LOG:  sentencia: CREATE SCHEMA dba;
 279 |         WHERE t.linea <> '';
 278 |              WITH ORDINALITY AS t(linea, n)
 277 |         FROM regexp_split_to_table(pg_read_file(pg_current_logfile()), E'\n')
(10 filas)

## Preguntas

¿Por qué logging_collector requiere reinicio y log_statement solo recarga?

El colector es un proceso que se crea cuando prende el servidor y log_statement es solo un valor que se vuelve a leer al recargar.

¿Qué ventaja tiene que la bitácora se lea con SQL y no con una herramienta del sistema operativo o del contenedor? ¿Qué riesgo introduce?

Ventaja: funciona igual en cualquier despliegue y no pide permisos del sistema. 
Riesgo: quien acceda a la vista puede leer todo el archivo, incluso datos sensibles.

¿Quién debería poder consultar dba.bitacora?

Solo el DBA o un rol de designado. Ni aplicaciones ni usuarios comunes.

## Interpretacion

La bitácora ya se puede leer y filtrar con SQL desde el propio servidor.
