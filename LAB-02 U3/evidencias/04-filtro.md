# Filtro del perfilador

db.setProfilingLevel(0)
db.system.profile.drop()
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })
db.getProfilingStatus()

mongosh "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ _id: 1 }).toArray(); db.clientes.updateOne({ _id: 1 }, { $set: { telefono: "6670000000" } })'

db.system.profile.find({}, { op: 1, ns: 1, user: 1, appName: 1, "command.q": 1, "command.u": 1, ts: 1 })

## Resultado

    { was: 1, slowms: 100, sampleRate: 1, filter: { op: { $in: [ 'insert', 'remove', 'update' ] } }, note: 'When a filter expression is set, slowms and sampleRate are not used ...', ok: 1 }

    op: update, ns: comercial.clientes, command: { q: { _id: 1 }, u: { $set: { telefono: '6670000000' } } }, ts: 2026-11-07T12:50:54.556Z, appName: app-ventas-web, user: app_ventas@comercial

Solo aparece la operación update. La consulta find no quedó registrada.

Observación: además, mongod escribió esa misma operación en su bitácora como Slow query (05:50:54.556 MST, aplicación app-ventas-web), porque con filtro las operaciones que lo cumplen también se escriben ahí.

## Preguntas

¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?

Perdí las lecturas y los comandos. Gané menos volumen, menos riesgo de datos personales en system.profile y más tiempo antes de que la colección de 1 MB sobrescriba los registros.

¿Qué filtro usarías si solo interesaran operaciones sobre la colección clientes?

    { filter: { ns: "comercial.clientes" } }

## Interpretación

El filtro reduce el volumen a las modificaciones, a cambio de no ver las consultas.
