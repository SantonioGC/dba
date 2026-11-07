# Incidente sin perfilado

db.getProfilingStatus()

mongosh "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XXX" } })'

db.system.profile.countDocuments()
bitacora().filter(e => JSON.stringify(e).includes("GAMA780912XXX")).length
bitacora().filter(e => JSON.stringify(e).includes("app-ventas-web")).map(e => ({ t: e.t, c: e.c, ctx: e.ctx, msg: e.msg }))

## Resultado

    { was: 0, slowms: 100, sampleRate: 1, ok: 1 }
    { acknowledged: true, insertedId: null, matchedCount: 1, modifiedCount: 1, upsertedCount: 0 }
    0
    0
    2026-11-07T05:50:51.729-07:00  NETWORK  conn18  client metadata
    2026-11-07T05:50:51.735-07:00  NETWORK  conn19  client metadata
    2026-11-07T05:50:51.857-07:00  NETWORK  conn20  client metadata
    2026-11-07T05:50:51.859-07:00  NETWORK  conn21  client metadata

## Preguntas

¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora?

No puedo demostrar qué cambió: system.profile tiene 0 documentos y la bitácora no contiene el valor GAMA780912XXX. Sí puedo ver que app_ventas se autenticó desde 127.0.0.1 con la aplicación app-ventas-web, pero no que esa conexión ejecutó el cambio.

¿Por qué mongosh abre varias conexiones (conn8, conn9, …) para una sola instrucción? ¿Cuál es la que se autentica?

mongosh abre una conexión principal y otras auxiliares Aquí son conn18 a conn21. Se autentican conn19, conn20 y conn21; conn18 no.

## Interpretación

Con el perfilador apagado la operación no deja rastro. La bitácora solo prueba que hubo conexiones de la aplicación.
