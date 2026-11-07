# Trazabilidad en MongoDB Community

## Despliegue

- MongoDB Community instalado de forma nativa en Fedora, con paquetes de la distribución.
- Versión: 6.0.27 (la guía indica MongoDB 7; los nombres de algunos mensajes de la bitácora cambian y se adaptaron los filtros).
- Cliente: mongosh 2.8.3.
- Servicio: sudo systemctl restart mongod
- Configuración: /etc/mongod.conf, con security.authorization: enabled.
- Bitácora: archivo /var/log/mongodb/mongod.log (systemLog.destination: file).
- Sesión del DBA: usuario admin (root). Sesión de la aplicación: usuario app_ventas (readWrite en comercial).

## Contenido

- evidencias/: 01 a 10, system-profile.json, bitacora-mongod.log, mongod-archivo.log y hashes.sha256
- scripts/comandos-mongosh.js: todos los comandos de mongosh usados
- informe.md

## Notas

- Las contraseñas aparecen como <REDACTED> en las evidencias.
- system-profile.json, bitacora-mongod.log y mongod-archivo.log se exportaron antes del reinicio del servicio y no contienen contraseñas.
- El perfilador se configuró con db.setProfilingLevel; no se aplicó operationProfiling.mode en /etc/mongod.conf.
- Las Actividades 5 y 6 se interpretaron sobre bitacora-mongod.log, porque la memoria de getLog se vació al reiniciar.
