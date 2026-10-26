# Cambios de configuración
La cuenta de laboratorio no es administrativa `rolsuper = f`, sin `pg_read_all_settings`, por lo que los cambios de servidor quedan como propuesta.

| # | Cambio | Estado | Justificación |
|---|---|---|---|
| 1 | Reemplazar reglas amplias de `pg_hba.conf` por reglas por BD, usuario y red ver `baseline.md`) | Propuesto | Mínimo privilegio en conexiones|
| 2 | Restringir con firewall el puerto 5432 a la red autorizada | Propuesto | Controlar el acceso a nivel de red |
| 3 | Cambiar `listen_addresses` de `*` a la interfaz necesaria | Propuesto | Reduce interfaces expuestas|
| 4 | Habilitar TLS `ssl = on` y usar `hostssl` y `verify-full` | Propuesto | Proteger datos en tránsito |
| 5 | Quitar `CREATEROLE` a las cuentas que no lo necesiten | Propuesto | Privilegio muy poderoso que va contra el mínimo privilegio |
| 6 | Separar cuentas DBA, APP y CONSULTA | Propuesto | Limitar el daño si una cuenta se compromete |
| 7 | Definir `statement_timeout` e `idle_in_transaction_session_timeout`| Propuesto | Evitar consumo indefinido de recursos |
| 8 | Documentar política de actualización de PostgreSQL | Propuesto | Corregir vulnerabilidades conocidas |
| 9 | Mantener `password_encryption = scram-sha-256` | Sin cambio, ya cumple | Almacenamiento más seguro de contraseñas |
| 10 | Mantener `log_connections` y `log_disconnections` en `on` | Sin cambio, ya cumple | Trazabilidad de accesos |
