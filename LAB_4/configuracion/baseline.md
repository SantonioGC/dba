# Línea base de seguridad
## 1. Antes y despues
| Control | Antes | Despues | Justificación |
|---|---|---|---|
| listen_addresses | `*` | IP privada del servidor o `localhost` | Escuchar solo donde hace falta |
| pg_hba.conf | No accesible: `permission denied for view pg_hba_file_rules` | Una regla por BD + usuario + red + método | Mínimo privilegio en conexiones |
| Método de autenticación | `password_encryption = scram-sha-256` | `scram-sha-256` en `pg_hba.conf` también | Más seguro que md5 |
| Usuarios administrativos | `postgres` es el único superusuario y mi cuenta no es superusuario | Solo cuentas DBA nominales | Reducir cuentas con control total |
| Cuentas de aplicación | De 199 roles, 168 tienen `LOGIN` y 82 tienen `CREATEROLE`, sin separación de funciones | Cuenta propia por aplicación, sin `CREATEROLE` ni `CREATEDB` | Limitar el daño si se compromete |
| Puerto | 5432 | 5432, documentado y protegido por firewall | Cambiar el puerto no es hardening |
| TLS | `off` | `on`, TLS 1.2 o superior, clientes con `verify-full` | Proteger el tránsito |
| Permisos SO | Sin acceso al servidor: `/etc/postgresql/` y `/var/lib/postgresql/` no existen en CT101 | Dueño `postgres`, sin lectura para otros | Proteger archivos sensibles |
| Extensiones | `pgcrypto` 1.3, `plpgsql` 1.0 | Mantener `plpgsql`; `pgcrypto` solo si se necesita | Menos funcionalidad expuesta |
| Conexiones | `max_connections = 200`, reservadas 3, `statement_timeout = 0`, `idle_in_transaction_session_timeout = 0` | Timeouts definidos | Evitar consumo indefinido de recursos |
| Registro de conexiones | `log_connections = on`, `log_disconnections = on` | Se mantiene | Trazabilidad de accesos |

## 2. Regla permisiva y regla propuesta
| Campo | Valor |
|---|---|
| Regla actual | No visible con mi cuenta `host all all 0.0.0.0/0 scram-sha-256` |
| Problema | Cualquier usuario, a cualquier BD, desde cualquier IPv4 |
| Origen que necesita acceso | 192.168.200.178 `psql` y 172.18.0.5 |
| Base de datos | `db_20435721_sergio_gomez` |
| Usuario | `u_20435721_sergio_gomez` |
| Regla propuesta | `host db_20435721_sergio_gomez u_20435721_sergio_gomez 192.168.200.178/32 scram-sha-256` |
| Segunda regla | `host db_20435721_sergio_gomez u_20435721_sergio_gomez 172.18.0.5/32 scram-sha-256` |
| Con TLS activo | Cambiar `host` por `hostssl` para exigir TLS |

## 3. Cuentas
| Cuenta | Propósito | LOGIN | Privilegios |
|---|---|---|---|
| DBA | Administración | Sí | Administrativos |
| APP | Aplicación | Sí | Mínimos |
| CONSULTA | Consulta | Sí | Solo lectura |

## 4. Firewall conceptual
| Origen | Destino | Puerto | Acción |
|---|---|---|---|
| 10.10.10.0/24 | 10.10.10.20 | 5432 | Permitir |
| Cualquier otro origen | PostgreSQL | 5432 | Denegar |

| Origen | Destino | Puerto | Acción |
|---|---|---|---|
| 192.168.200.0/24 | 192.168.200.100 | 5432 | Permitir |
| Cualquier otro origen | PostgreSQL | 5432 | Denegar |

## 5. Propuesta de baseline
**Red**
- Escuchar solo en la interfaz autorizada, puerto 5432.
- Firewall que permita solo las redes necesarias.

**Autenticación**
- `scram-sha-256`; contraseñas largas y únicas.
- Cuentas administrativas nominales y separadas de las de aplicación.

**Autorización**
- Roles con mínimo privilegio; ninguna aplicación con SUPERUSER ni `CREATEROLE`.

**Configuración**
- Extensiones solo las necesarias.
- `statement_timeout` e `idle_in_transaction_session_timeout` distintos de 0; `log_connections` y `log_disconnections` activos.

**Sistema operativo**
- Archivos de configuración y directorio de datos propiedad de `postgres`, sin acceso para otros usuarios.

**Cifrado**
- TLS activo y clientes con `verify-full`.
- Contraseñas con hash; datos sensibles cifrados; claves fuera del repositorio.

**Mantenimiento**
- Política de actualización documentada, revisión periódica de roles, `pg_hba.conf` y extensiones, y configuración registrada.

## 6. Permisos del SO y exposición de red
**Actividad 12 permisos de archivos.** Desde CT101:
```
ls -l /etc/postgresql/ /var/lib/postgresql/
ls: /etc/postgresql/: No such file or directory
ls: /var/lib/postgresql/: No such file or directory
```
CT101 es un equipo cliente, sin acceso al servidor, así que no se pudieron revisar propietario ni permisos. En el servidor se esperaría que `postgresql.conf`, `pg_hba.conf` y el directorio de datos sean propiedad de `postgres` y no se puedan leer por otros usuarios.

**Actividad 13 exposición de red.** `ss -lnt` solo mostraría los puertos de CT101, no los del servidor. Desde CT101:
```
nc -zv 192.168.200.100 5432
192.168.200.100 192.168.200.100:5432 open
```

| Campo | Valor |
|---|---|
| Dirección de escucha | `*` según `listen_addresses`; no verificable con `ss` |
| Puerto | 5432 |
| ¿Expuesto fuera de la interfaz necesaria? | escucha en todas las interfaces y el puerto es alcanzable desde CT101 |

## 7. Consultas sin permiso
`SHOW ssl_min_protocol_version` falló con `must be superuser or have privileges of pg_read_all_settings`, así que no se pudo conocer la versión mínima de TLS. `pg_stat_ssl` sí respondió: la conexión actual no usa TLS `ssl = f`.

`SHOW config_file`, `hba_file`, `ident_file`, `data_directory` y `log_directory` también fallaron por falta de privilegios, así que no se pudieron documentar las rutas de datos, configuración, autenticación y logs. `log_connections` y `log_disconnections` sí respondieron.

## 8. Extensiones

| Extensión | Versión | ¿Necesaria? | ¿Instalada para prácticas? | ¿Innecesaria en otro entorno? |
|---|---|---|---|---|
| `plpgsql` | 1.0 | viene por defecto y permite funciones y procedimientos | No | No |
| `pgcrypto` | 1.3 | Solo si se usan funciones de hash o cifrado | Probablemente, por las prácticas de laboratorio | Sí, si la aplicación no la usa |


## 9. Parámetros de conexión

| Parámetro | Valor | Función |
|---|---|---|
| `max_connections` | 200 | Máximo de conexiones simultáneas |
| `superuser_reserved_connections` | 3 | Cupos reservados a superusuarios para poder entrar aunque el servidor esté lleno |
| `statement_timeout` | 0 | Tiempo máximo de una consulta|
| `idle_in_transaction_session_timeout` | 0 | Tiempo máximo con una transacción abierta e inactiva|
