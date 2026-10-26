# Informe 
## Preguntas del informe
**1. ¿Cuál era la principal superficie de ataque?**
El servidor escucha en todas las interfaces `listen_addresses = '*'` y el puerto 5432 es alcanzable desde otros equipos.
**2. ¿Qué configuración representaba el mayor riesgo?**
`listen_addresses = '*'` junto con `ssl = off` cualquiera en la red puede intentar conectarse y los datos viajan sin cifrar.
**3. ¿Qué cambio produjo la mayor reducción de exposición?**
Restringir `pg_hba.conf` a una regla por base, usuario y red junto con el firewall y limitar `listen_addresses` a la interfaz necesaria.
**4. ¿Qué diferencia existe entre firewall y `pg_hba.conf`?**
El firewall decide quién llega al puerto. `pg_hba.conf` decide quién puede autenticarse una vez que llegó. Son dos capas distintas y se necesitan ambas.
**5. ¿Qué diferencia existe entre autenticación y autorización?**
Autenticación verifica quién eres. Autorización define qué puedes hacer.
**6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**
Si la aplicación se compromete, el atacante obtiene control total de la base de datos.
**7. ¿Por qué cambiar el puerto no es hardening suficiente?**
Solo reduce ruido de escaneos automáticos. No sustituye autenticación, autorización ni firewall.
**8. ¿Por qué `listen_addresses='*'` puede ser innecesario?**
Porque abre el servicio en todas las interfaces aunque solo se necesite una.
**9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**
Protege los archivos de configuración y datos. Si otro usuario del SO puede leerlos, `GRANT` y `REVOKE` no sirven de nada.
**10. ¿Qué controles deberían revisarse periódicamente?**
Roles y privilegios, `pg_hba.conf`, `listen_addresses`, firewall, extensiones, TLS, permisos del SO y versión de PostgreSQL.

## Reflexión
**¿Qué cambiarías primero en un servidor de producción que ya funciona?**
Primero revisaría y restringiría `pg_hba.conf` y el firewall para permitir solo los orígenes, usuarios y bases que de verdad se usan.

Razones:
- Es el cambio con más reducción de riesgo: corta la exposición a redes que no necesitan acceso.
- Se aplica con recarga, sin reiniciar, así que no afecta la disponibilidad.

## Respuestas a las preguntas de las actividades
**Actividad 1. ¿Por qué conocer la superficie de ataque debe preceder al hardening?**
Porque no se puede proteger ni reducir lo que no se conoce.
**Actividad 2. ¿Por qué es importante conocer la ubicación física de los archivos?**
Para poder revisar sus permisos y protegerlos, y para saber dónde están los datos, la configuración y los logs.
**Actividad 3. ¿Qué arquitectura reduce mejor la exposición?**
La segunda el servidor queda en una red privada detrás del firewall y no es alcanzable desde Internet.
**Actividad 7. Autenticación**
- Autenticación vs autorización: ver pregunta 5.
- `scram-sha-256` protege la contraseña: no viaja en claro y se guarda como hash resistente.
- Un hash no es cifrado reversible: no se puede recuperar la contraseña original a partir de él.
- Con permisos excesivos, una contraseña fuerte no ayuda: quien entre puede hacer demasiado.
**Actividad 8. ¿Por qué no usar SUPERUSER como cuenta normal de una aplicación?**
Ver pregunta 6.
**Actividad 9. ¿Qué riesgo hay si la aplicación usa una cuenta administrativa?**
Un fallo en la aplicación de ejemplo, una inyección SQL)daría control total sobre la base de datos.
**Actividad 11. ¿Por qué es un problema mantener conexiones abiertas indefinidamente?**
Ocupan cupos de `max_connections` y recursos, y pueden dejar a otros usuarios sin poder conectarse.
**Actividad 12. ¿Por qué no basta con `GRANT` y `REVOKE`?**
Porque un usuario del sistema operativo puede leer los archivos directamente sin pasar por PostgreSQL.
**Actividad 14. ¿Por qué `pg_hba.conf` y el firewall no son equivalentes?**
Ver pregunta 4.

## Caso integral
| # | Problema | Riesgo | Control propuesto |
|---|---|---|---|
| 1 | Acepta conexiones desde cualquier IPv4 | Cualquier equipo puede intentar entrar | Limitar a redes necesarias |
| 2 | La aplicación usa un usuario administrativo | Si la app se compromete, se pierde todo | Cuenta de aplicación con mínimo privilegio |
| 3 | Escucha en todas las interfaces | Más puntos de entrada | `listen_addresses` solo en la interfaz necesaria |
| 4 | Firewall permite 5432 desde cualquier origen | El puerto es alcanzable desde cualquier lugar | Permitir solo la red autorizada |
| 5 | `pg_hba.conf` permite `all/all` desde `0.0.0.0/0` | Cualquier usuario a cualquier base | Regla por base, usuario y red |
| 6 | Se confía solo en contraseñas fuertes | Fuerza bruta, filtración o robo de credenciales | Defensa en capas |
| 7 | Sin TLS | Credenciales y datos expuestos en la red | Activar TLS y `hostssl` |
| 8 | Sin monitoreo de conexiones | Accesos sospechosos pasan desapercibidos | `log_connections` y revisión de logs |
| 9 | Sin timeouts ni límites de conexión | Agotamiento de recursos | `statement_timeout` e `idle_in_transaction_session_timeout` |
| 10 | Archivos de configuración sin revisar | Lectura de configuración o credenciales | Permisos de SO solo para `postgres` |
| 11 | Sin política de actualización | Vulnerabilidades conocidas sin corregir | Política de actualización documentada |
| 12 | Sin documentación de la configuración | Configuración desconocida e irreproducible | Baseline y registro de cambios |

**¿Es suficiente tener contraseñas fuertes?**
No. La contraseña solo es autenticación tambien hace falta:
- **Autorización:** privilegios mínimos, para que una cuenta comprometida haga poco daño.
- **Red:** firewall y `listen_addresses`, para que no llegue cualquiera.
- **Configuración:** `pg_hba.conf` específico, TLS y timeouts.
- **Sistema operativo:** permisos sobre archivos sensibles.
- **Monitoreo:** logs para detectar accesos anormales.
