# LAB-04 Hardening y configuracion

## Objetivo
Identificar configuraciones inseguras de un servidor PostgreSQL, reducir su superficie de ataque y documentar una línea base de seguridad.

## Entorno
| Elemento | Valor |
|---|---|
| Servidor | 192.168.200.100, puerto 5432 |
| Versión del servidor | PostgreSQL 15.19 |
| Cliente | `psql` 17.11 desde CT101 , IP 192.168.200.178 |
| Base de datos | `db_20435721_sergio_gomez` |
| Usuario | `u_20435721_sergio_gomez` sin SUPERUSER y sin `pg_read_all_settings` |
| Cliente | 172.18.0.5 |

Limitación: como la cuenta no es administrativa y CT101 es solo un cliente, algunos datos no se pudieron consultar como `pg_hba_file_rules`, `ssl_min_protocol_version` y permisos del SO.

## Superficie de ataque inicial
| Elemento | Estado actual | ¿Es necesario? | Riesgo |
|---|---|---|---|
| Puerto PostgreSQL | 5432 | Sí | Alcanzable desde CT101 `nc` lo muestra abierto |
| Interfaces de escucha | `*` todas | No, solo la interfaz autorizada | Más puntos de entrada |
| Conexiones remotas | Sí, desde 192.168.200.178 | Solo las necesarias | Sin lista de orígenes permitidos |
| Usuarios administrativos | `postgres` es el único superusuario | Sí, pero nominal | Control total si se compromete |
| SSL y TLS | `off` | No debería estar apagado | Datos y contraseñas viajan sin cifrar |
| Autenticación | `password_encryption = scram-sha-256` | Sí | Bien configurado |

## Hallazgos
1. `listen_addresses = '*'`: el servidor escucha en todas las interfaces.
2. `ssl = off`: la conexión actual no usa TLS `pg_stat_ssl` muestra `ssl = f`.
3. De 199 roles, 168 tienen `LOGIN` y 82 tienen `CREATEROLE`, sin separación de funciones.
4. `statement_timeout` e `idle_in_transaction_session_timeout` valen 0 .
5. `pg_hba.conf` no es visible con esta cuenta `permission denied for view pg_hba_file_rules`.
6. El servidor es PostgreSQL 15.19 y no hay política de actualización documentada.
7. Bien: `scram-sha-256` activo, `log_connections` y `log_disconnections` en `on`.

## Cambios realizados
No se aplicó ningún cambio en el servidor porque la cuenta no tiene permisos administrativos. Los cambios propuestos están en `configuracion/cambios.md`.

## Justificación de los cambios
Cada cambio propuesto reduce exposición o limita el daño si algo se compromete. La justificación de cada uno está en `configuracion/baseline.md` y `configuracion/cambios.md`.

## Verificación
| Verificación | Resultado | Evidencia |
|---|---|---|
| Versión, puerto, `listen_addresses`, `ssl`, `password_encryption` | Obtenido | `evidencias/01-superficie-ataque.png` |
| `listen_addresses` | `*` | `evidencias/02-listen-addresses.png` |
| `pg_hba_file_rules` | Permiso denegado | `evidencias/03-pg-hba.png` |
| Roles y privilegios | Obtenido | `evidencias/04-roles.png` |
| TLS en la conexión actual | No usa TLS | `evidencias/05-tls.png` |
| `ssl_min_protocol_version` | Permiso denegado | `evidencias/06-verificacion.png` |
| Puerto 5432 alcanzable | Sí, desde CT101 | `configuracion/baseline.md` sección 6 |

## Checklist de hardening
| # | Control | Verificado | Evidencia |
|---|---|---|---|
| 1 | Puerto documentado | 5432 | Captura 1 |
| 2 | Interfaces de escucha justificadas | `*` sin justificación | Captura 02 |
| 3 | `pg_hba.conf` revisado | sin acceso, regla propuesta | Captura 03, `baseline.md` |
| 4 | Redes autorizadas restringidas | `baseline.md` sección 2 |
| 5 | Autenticación segura `scram-sha-256`)| Captura 01 |
| 6 | Superusuarios identificados | solo `postgres` | `baseline.md` |
| 7 | Cuentas de aplicación separadas | sin separación de funciones | Captura 04 |
| 8 | Privilegios mínimos | 82 roles con `CREATEROLE` | Captura 04 |
| 9 | Extensiones revisadas | `pgcrypto`, `plpgsql` | `baseline.md` |
| 10 | TLS verificado | `ssl = off` | Captura 05 |
| 11 | Configuración protegida |sin acceso al servidor | `baseline.md` sección 6 |
| 12 | Directorio de datos protegido | sin acceso al servidor | `baseline.md` sección 6 |
| 13 | Firewall documentado | regla conceptual | `baseline.md` sección 4 |
| 14 | Actualizaciones documentadas | versión 15.19, política propuesta | `cambios.md` #8 |
| 15 | Configuración registrada | | `baseline.md`, `cambios.md` |
| 16 | Timeouts de consulta e inactividad definidos | ambos en 0 | `03-configuracion.sql` |
| 17 | Registro de conexiones activo | `01-inspeccion.sql` |
| 18 | Puerto 5432 no expuesto fuera de la red necesaria | alcanzable desde CT101 | `baseline.md` sección 6 |

## Conclusiones
El servidor tiene una autenticación correcta `scram-sha-256` pero una superficie de ataque amplia escucha en todas las interfaces, no usa TLS y tiene muchos roles con `LOGIN` y `CREATEROLE`. Los cambios de mayor impacto son restringir `pg_hba.conf` y el firewall por base, usuario y red, limitar `listen_addresses` y activar TLS. Con una cuenta sin privilegios no se pudieron aplica.
