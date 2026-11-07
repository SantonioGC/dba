#Edición y limitación

db.version()
db.adminCommand({ buildInfo: 1 }).modules
db.serverCmdLineOpts().parsed

## Resultado

6.0.27
[]
{ config: '/etc/mongod.conf', net: { bindIp: '127.0.0.1', port: 27017 }, security: { authorization: 'enabled' }, storage: { dbPath: '/var/lib/mongo' }, systemLog: { destination: 'file', logAppend: true, path: '/var/log/mongodb/mongod.log' } }

## Preguntas

¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra?

Community, versión 6.0.27. modules aparece vacío; en Enterprise incluiría "enterprise".

¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes?

A un archivo: /var/log/mongodb/mongod.log. Lo sé por systemLog en serverCmdLineOpts().parsed (destination: file y path).

Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa?

Cambios de esquema (DDL); eventos de conjuntos de réplicas y clústeres fragmentados; autenticación y autorización; operaciones CRUD.

¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?

El costo de la licencia o del plan, el esfuerzo de migración, qué eventos necesita realmente auditar, el impacto en desempeño y almacenamiento, y si un control compensatorio cubre el riesgo mientras tanto.

## Interpretación

Mi servidor es Community, así que no tiene auditoría nativa. Solo dispone del perfilador y de la bitácora de mongod.
