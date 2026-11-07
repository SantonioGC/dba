# Accesos en la bitácora de mongod

mongosh "mongodb://app_ventas:incorrecta@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"
mongosh "mongodb://usuario_inexistente:x@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"

DBA (adaptado a MongoDB 6.0.27):

const b = bitacora()
const app = ctx => b.find(x => x.ctx === ctx && x.msg === "client metadata")?.attr.doc?.application?.name
b.filter(e => e.c === "ACCESS" && e.msg === "Authentication failed").map(e => ({ t: e.t, id: e.id, ctx: e.ctx, user: e.attr.principalName, db: e.attr.authenticationDatabase, client: e.attr.remote, error: e.attr.error, speculative: e.attr.speculative, app: app(e.ctx) }))
b.filter(e => e.msg === "Authentication succeeded" && e.attr.principalName === "app_ventas").slice(-1).map(e => ({ t: e.t, id: e.id, ctx: e.ctx, client: e.attr.remote, app: app(e.ctx) }))

## Resultado

MongoServerError: Authentication failed.
MongoServerError: Authentication failed.

Accesos fallidos:

t: 2026-11-07T05:50:55.333-07:00, id: 20249, ctx: conn51, user: app_ventas, db: comercial, client: 127.0.0.1:38642, speculative: true, error: AuthenticationFailed: SCRAM authentication failed, storedKey mismatch, app: mongosh 2.8.3
t: 2026-11-07T05:50:55.660-07:00, id: 20249, ctx: conn53, user: usuario_inexistente, db: comercial, client: 127.0.0.1:38654, speculative: true, error: UserNotFound: Could not find user "usuario_inexistente" for db "comercial", app: mongosh 2.8.3
t: 2026-11-07T05:50:55.662-07:00, id: 20249, ctx: conn53, user: usuario_inexistente, db: comercial, client: 127.0.0.1:38654, speculative: false, error: UserNotFound: Could not find user "usuario_inexistente" for db "comercial", app: mongosh 2.8.3

Último acceso exitoso de la aplicación:

t: 2026-11-07T05:50:54.552-07:00, id: 20250, ctx: conn45, client: 127.0.0.1:38598, app: app-ventas-web

El usuario inexistente produjo dos líneas por un mismo intento. Se cuentan intentos, no líneas: fueron 2 intentos fallidos.

## Preguntas

¿Qué campo distingue un acceso fallido de uno exitoso?

El mensaje: Authentication failed frente a Authentication succeeded. El fallido además trae el campo error.

¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos?

Contraseña incorrecta: AuthenticationFailed. Usuario inexistente: UserNotFound. El cliente recibe siempre Authentication failed para no revelar qué usuarios existen.

¿Por qué el nombre de la aplicación del intento fallido es mongosh 2.10.0 y no app-ventas-web?

En mi caso es mongosh 2.8.3. Los intentos fallidos se hicieron sin appName en la cadena de conexión, así que mongosh se identifica con su propio nombre y versión.

## Interpretación

La bitácora distingue un acceso fallido de uno exitoso, con usuario, base y dirección de origen. Para saber la aplicación hay que correlacionar con client metadata por ctx.
