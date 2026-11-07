#Accesos exitosos y fallidos

psql "postgresql://app_ventas:incorrecta@127.0.0.1/comercial" -c "SELECT 1"
psql "postgresql://usuario_inexistente:x@127.0.0.1/comercial" -c "SELECT 1"
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "SELECT count(*) FROM clientes"

SELECT linea FROM dba.bitacora WHERE linea LIKE '%client=127.0.0.1%' ORDER BY num;

##Resultado

----------------------------------------------------------------------+--------------------------------------------------------------
 2026-11-07 00:49:57.480 MST [9030] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4303
2
 2026-11-07 00:49:57.489 MST [9031] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4304
2
 2026-11-07 00:49:57.495 MST [9032] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4304
4
 2026-11-07 00:49:57.557 MST [9034] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4305
4
 2026-11-07 00:49:57.564 MST [9035] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4307
0
 2026-11-07 00:49:57.570 MST [9036] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4308
4
 2026-11-07 00:49:57.587 MST [9039] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4309
4
 2026-11-07 00:49:57.594 MST [9040] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4310
0
 2026-11-07 00:49:57.600 MST [9041] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4310
4
 2026-11-07 00:49:59.502 MST [9083] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4311
0
 2026-11-07 00:49:59.510 MST [9084] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4311
6
 2026-11-07 00:49:59.767 MST [9090] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4312
6
 2026-11-07 00:49:59.774 MST [9091] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4313
0
 2026-11-07 00:49:59.916 MST [9095] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4314
0
 2026-11-07 00:49:59.924 MST [9096] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4315
6
 2026-11-07 00:50:10.582 MST [9124] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4472
2
 2026-11-07 00:50:10.590 MST [9125] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4473
2
 2026-11-07 00:50:10.597 MST [9126] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4473
8
 2026-11-07 00:50:10.607 MST [9126] user=postgres db=comercial app=[desconocido] client=127.0.0.1 LOG:  conexión autenticada: identidad=«postgres» método=sc
ram-sha-256 (/var/lib/pgsql/data/pg_hba.conf:3)
 2026-11-07 00:50:10.607 MST [9126] user=postgres db=comercial app=[desconocido] client=127.0.0.1 LOG:  conexión autorizada: usuario=postgres base_de_datos=
comercial nombre_de_aplicación=pgAdmin 4 - DB:comercial SSL habilitado (protocolo=TLSv1.3, cifrado=TLS_AES_256_GCM_SHA384, bits=256)
 2026-11-07 00:50:10.672 MST [9128] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=4474
4
 2026-11-07 00:50:10.679 MST [9128] user=postgres db=comercial app=[desconocido] client=127.0.0.1 LOG:  conexión autenticada: identidad=«postgres» método=sc
ram-sha-256 (/var/lib/pgsql/data/pg_hba.conf:3)
 2026-11-07 00:50:10.679 MST [9128] user=postgres db=comercial app=[desconocido] client=127.0.0.1 LOG:  conexión autorizada: usuario=postgres base_de_datos=
comercial nombre_de_aplicación=pgAdmin 4 - CONN:519725 SSL habilitado (protocolo=TLSv1.3, cifrado=TLS_AES_256_GCM_SHA384, bits=256)
 2026-11-07 01:02:26.288 MST [9128] user=postgres db=comercial app=pgAdmin 4 - CONN:519725 client=127.0.0.1 LOG:  sentencia: ALTER SYSTEM SET logging_collec
tor = on;
 2026-11-07 01:02:31.243 MST [9128] user=postgres db=comercial app=pgAdmin 4 - CONN:519725 client=127.0.0.1 LOG:  sentencia: CREATE SCHEMA dba;
 2026-11-07 01:02:31.244 MST [9128] user=postgres db=comercial app=pgAdmin 4 - CONN:519725 client=127.0.0.1 ERROR:  ya existe el esquema «dba»
 2026-11-07 01:02:31.244 MST [9128] user=postgres db=comercial app=pgAdmin 4 - CONN:519725 client=127.0.0.1 SENTENCIA:  CREATE SCHEMA dba;
 2026-11-07 01:02:34.763 MST [9128] user=postgres db=comercial app=pgAdmin 4 - CONN:519725 client=127.0.0.1 LOG:  sentencia: CREATE VIEW dba.bitacora AS
 2026-11-07 01:02:34.763 MST [9128] user=postgres db=comercial app=pgAdmin 4 - CONN:519725 client=127.0.0.1 ERROR:  la relación «bitacora» ya existe
 2026-11-07 01:02:34.763 MST [9128] user=postgres db=comercial app=pgAdmin 4 - CONN:519725 client=127.0.0.1 SENTENCIA:  CREATE VIEW dba.bitacora AS
 2026-11-07 01:06:43.775 MST [12806] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=344
60
 2026-11-07 01:06:43.785 MST [12806] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 FATAL:  la autentificación password falló para el usuar
io «app_ventas»
 2026-11-07 01:06:43.785 MST [12806] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 DETALLE:  La conexión coincidió con el archivo «/var/li
b/pgsql/data/pg_hba.conf» línea 3: «host    all   all   127.0.0.1/32       scram-sha-256»
 2026-11-07 01:06:43.786 MST [12807] user=[desconocido] db=[desconocido] app=[desconocido] client=127.0.0.1 LOG:  conexión recibida: host=127.0.0.1 port=344
76
 2026-11-07 01:06:43.790 MST [12807] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 FATAL:  la autentificación password falló para el usuar
io «app_ventas»
 2026-11-07 01:06:43.790 MST [12807] user=app_ventas db=comercial app=[desconocido] client=127.0.0.1 DETALLE:  La conexión coincidió con el archivo «/var/li
b/pgsql/data/pg_hba.conf» línea 3: «host    all   all   127.0.0.1/32       scram-sha-256»
(36 filas)

## Lectura de una línea campo por campo

| Campo | Valor | Significado |
|---|---|---|
| Fecha y hora | (tu valor) | Momento del evento, con milisegundos |
| PID | (tu valor) | Proceso de la sesión; agrupa sus líneas |
| Usuario | app_ventas | Rol con el que se intentó entrar |
| Base de datos | comercial | Base a la que se intentó entrar |
| Aplicación | [unknown] | Nombre de aplicación aún no asignado |
| Cliente | 127.0.0.1 | IP desde donde llegó la conexión |
| Severidad | FATAL | La sesión terminó por error |
| Mensaje | password authentication failed | La contraseña no coincidió |
| Regla aplicada | pg_hba.conf línea (tu valor) | Regla que se usó para autenticar |

##Preguntas

La bitácora registra el usuario app_ventas en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?

No Prueba que alguien uso el nombre app_ventas con una contraseña incorrecta desde esa IP. No identifica a la persona ni a la aplicación.

¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?

Registra DETAIL Role does not exist. Se oculta al cliente para que un atacante no sepa qué usuarios existen.

¿Por qué app=[unknown] en el intento fallido, pero app=app-ventas-web en la desconexión?

Porque el nombre de la aplicacion se asigna a la sesión cuando termina la autenticacion. En el intento fallido nunca llegó a ese punto.

¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.

Muchos FATAL de contraseña en poco tiempo desde la misma IP, para uno o varios usuarios.

SELECT split_part(substring(linea from 'user=[^ ]+'), '=', 2) AS usuario, count(*) AS fallidos FROM dba.bitacora WHERE linea LIKE '%FATAL:  password authentication failed%' GROUP BY 1 ORDER BY 2 DESC;

##Interpretacion

La bitácora ya distingue accesos fallidos del acceso exitoso con su desconexión.
