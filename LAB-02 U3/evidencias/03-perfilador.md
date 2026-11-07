# Perfilador

db.setProfilingLevel(2)
db.getProfilingStatus()

mongosh "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ ciudad: "Culiacán" }, { nombre: 1, ciudad: 1 }).toArray(); db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XYZ" } }); db.clientes.deleteOne({ _id: 2 });'

db.system.profile.find({ ns: "comercial.clientes" }, { op: 1, ns: 1, command: 1, user: 1, client: 1, appName: 1, ts: 1, millis: 1, nreturned: 1, docsExamined: 1, nModified: 1, ndeleted: 1 }).sort({ ts: 1 })

## Resultado

    { was: 0, slowms: 100, sampleRate: 1, ok: 1 }
    { was: 2, slowms: 100, sampleRate: 1, ok: 1 }

    op: query, ns: comercial.clientes, command: { find: 'clientes', filter: { ciudad: 'Culiacán' }, projection: { nombre: 1, ciudad: 1 } }, docsExamined: 5, nreturned: 3, millis: 0, ts: 2026-11-07T12:50:53.207Z, client: 127.0.0.1, appName: app-ventas-web, user: app_ventas@comercial
    op: update, ns: comercial.clientes, command: { q: { _id: 3 }, u: { $set: { rfc: 'GAMA780912XYZ' } }, multi: false, upsert: false }, docsExamined: 1, nModified: 1, millis: 0, ts: 2026-11-07T12:50:53.212Z, client: 127.0.0.1, appName: app-ventas-web, user: app_ventas@comercial
    op: remove, ns: comercial.clientes, command: { q: { _id: 2 }, limit: 1 }, docsExamined: 1, ndeleted: 1, millis: 0, ts: 2026-11-07T12:50:53.217Z, client: 127.0.0.1, appName: app-ventas-web, user: app_ventas@comercial

## Interpretación de los documentos

| # | op | Usuario | Cliente | Aplicación | Momento | Qué hizo | Documentos afectados |
|---|---|---|---|---|---|---|---|
| 1 | query | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-07 12:50:53.207 UTC | Consultó clientes de Culiacán (nombre y ciudad) | 5 examinados, 3 devueltos |
| 2 | update | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-07 12:50:53.212 UTC | Cambió el rfc del _id 3 a GAMA780912XYZ | 1 examinado, 1 modificado |
| 3 | remove | app_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-07 12:50:53.217 UTC | Eliminó el _id 2 | 1 examinado, 1 eliminado |

La hora de mongod en la bitácora está en MST (UTC-7): 12:50:53 UTC es 05:50:53 MST.

## Preguntas

¿Puedes saber cuál era el RFC antes del cambio con la información de system.profile?

No el comando solo trae el valor nuevo en $set.

¿Puedes saber qué datos tenía el documento eliminado?

No solo trae el filtro q: { _id: 2 }, no el contenido del documento.

A diferencia de log_statement = 'mod' en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?

Ventaja: se puede saber quién consultó qué y cuándo. Riesgo: guarda filtros y valores en texto en system.profile, y cuesta desempeño y espacio.

¿Por qué el campo user incluye @comercial?

Porque el usuario se define dentro de una base de datos. user@base identifica la base donde se creó y distingue usuarios con el mismo nombre en bases distintas.

## Interpretación

El perfilador en nivel 2 permite atribuir la operación, pero no conserva el valor anterior ni el contenido eliminado.
