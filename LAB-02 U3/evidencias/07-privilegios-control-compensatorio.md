# Privilegios y control compensatorio

db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({ momento: new Date(), tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers, usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles })) })
db.setProfilingLevel(2)
db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])
db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } })
bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length
(segunda instantánea, el mismo insertOne)
db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 })
db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })

## Resultado

    0
    0

No hay evidencia en ninguna de las dos fuentes (system.profile y bitácora).

Instantáneas:

    momento: 2026-11-07T12:50:57.119Z, tomada_por: admin@admin, app_ventas@comercial roles: readWrite@comercial
    momento: 2026-11-07T12:50:57.209Z, tomada_por: admin@admin, app_ventas@comercial roles: dbAdmin@comercial, readWrite@comercial

| Pregunta | ¿La instantánea responde? |
|---|---|
| ¿Cambiaron los privilegios de app_ventas? | Sí |
| ¿Qué rol se agregó? | Sí (dbAdmin en comercial) |
| ¿Quién lo agregó? | No |
| ¿Cuándo exactamente? | No, solo que ocurrió entre las 12:50:57.119 y las 12:50:57.209 UTC |

Después se revocó el rol y se restableció el filtro de la Actividad 4.

## Preguntas

¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?

Porque cambia quién puede hacer qué. Un privilegio de más abre accesos y cambios que antes no eran posibles y puede ser el primer paso de un abuso.

¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?

Al menos una vez al día, y cada hora en bases críticas. Influyen la frecuencia con que cambian los privilegios, la sensibilidad de los datos, el costo de cada instantánea y cuánto tiempo sin evidencia se tolera.

¿Quién debería poder escribir en auditoria.instantaneas_privilegios?

Solo una cuenta de auditoría o el proceso programado, nunca las aplicaciones ni los administradores que cambian privilegios, y nadie con permiso de borrar.

Redacta en tres líneas cómo comunicarías esta limitación a Dirección.

MongoDB Community no registra quién cambia los privilegios ni cuándo.
Con instantáneas periódicas sabemos que cambiaron y qué rol se agregó, solo dentro de un intervalo de tiempo.
Para atribuir el cambio a una persona se necesita la auditoría nativa de Enterprise o Atlas.

## Interpretación

La instantánea es un control compensatorio: detecta el cambio, pero no equivale a auditoría porque no atribuye ni da la hora exacta.
