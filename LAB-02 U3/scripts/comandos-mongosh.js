// ---- scripts/bitacora.js ----
function bitacora() { return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l)) }

// ---- scripts/act01.js ----
printjson(db.version());
printjson(db.adminCommand({ buildInfo: 1 }).modules);
printjson(db.serverCmdLineOpts().parsed);

// ---- scripts/act02a.js ----
printjson(db.getProfilingStatus());

// ---- scripts/act02b.js ----
load("scripts/bitacora.js");
print(db.system.profile.countDocuments());
print(bitacora().filter(e => JSON.stringify(e).includes("GAMA780912XXX")).length);
printjson(bitacora().filter(e => JSON.stringify(e).includes("app-ventas-web")).map(e => ({ t: e.t, c: e.c, ctx: e.ctx, msg: e.msg })));

// ---- scripts/act03a.js ----
printjson(db.setProfilingLevel(2));
printjson(db.getProfilingStatus());

// ---- scripts/act03b.js ----
printjson(db.system.profile.find({ ns: "comercial.clientes" }, { op: 1, ns: 1, command: 1, user: 1, client: 1, appName: 1, ts: 1, millis: 1, nreturned: 1, docsExamined: 1, nModified: 1, ndeleted: 1 }).sort({ ts: 1 }).toArray());

// ---- scripts/act04a.js ----
db.setProfilingLevel(0);
db.system.profile.drop();
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } });
printjson(db.getProfilingStatus());

// ---- scripts/act04b.js ----
printjson(db.system.profile.find({}, { op: 1, ns: 1, user: 1, appName: 1, "command.q": 1, "command.u": 1, ts: 1 }).toArray());

// ---- scripts/act05.js ----
load("scripts/bitacora.js");
// MongoDB 6.0: los mensajes son "Authentication failed/succeeded"; el nombre de la aplicacion se toma del evento "client metadata" de la misma conexion (ctx)
const b = bitacora();
const app = ctx => b.find(x => x.ctx === ctx && x.msg === "client metadata")?.attr.doc?.application?.name;
printjson(b.filter(e => e.c === "ACCESS" && e.msg === "Authentication failed").map(e => ({ t: e.t, id: e.id, ctx: e.ctx, user: e.attr.principalName, db: e.attr.authenticationDatabase, client: e.attr.remote, error: e.attr.error, speculative: e.attr.speculative, app: app(e.ctx) })));
printjson(b.filter(e => e.msg === "Authentication succeeded" && e.attr.principalName === "app_ventas").slice(-1).map(e => ({ t: e.t, id: e.id, ctx: e.ctx, client: e.attr.remote, app: app(e.ctx) })));

// ---- scripts/act06.js ----
load("scripts/bitacora.js");
const cambios = bitacora().filter(e => e.msg === "Profiler settings changed");
const ultimo = cambios[cambios.length - 1];
printjson(ultimo);
if (ultimo) {
  printjson(bitacora().filter(e => e.ctx === ultimo.ctx && e.msg === "Authentication succeeded").map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.principalName, db: e.attr.authenticationDatabase, client: e.attr.remote })));
}

// ---- scripts/act07.js ----
load("scripts/bitacora.js");
function instantanea() {
  db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
    momento: new Date(),
    tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
    usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles }))
  });
}
instantanea();
db.setProfilingLevel(2);
db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);
print(db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } }));
print(bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length);
instantanea();
printjson(db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 }).toArray());
db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } });
printjson(db.getProfilingStatus());

// ---- scripts/act08.js ----
load("scripts/bitacora.js");
print("eventos en memoria antes del reinicio: " + bitacora().length);

