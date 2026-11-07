# Conservación

bitacora().length
mongosh "mongodb://admin:<REDACTED>@127.0.0.1:27017/comercial?authSource=admin" --quiet --eval 'EJSON.stringify(db.system.profile.find({}, { op: 1, ns: 1, user: 1, client: 1, appName: 1, ts: 1, "command.q": 1, "command.u": 1 }).toArray(), null, 2)' > evidencias/system-profile.json
mongosh "mongodb://admin:<REDACTED>@127.0.0.1:27017/comercial?authSource=admin" --quiet --eval 'db.adminCommand({ getLog: "global" }).log.join("\n")' > evidencias/bitacora-mongod.log
sudo cp /var/log/mongodb/mongod.log evidencias/mongod-archivo.log
sha256sum evidencias/system-profile.json evidencias/bitacora-mongod.log evidencias/mongod-archivo.log > evidencias/hashes.sha256
sudo systemctl restart mongod
db.getProfilingStatus()
db.system.profile.countDocuments()
bitacora().length

## Resultado

Antes del reinicio: 318 eventos en memoria.

Hashes SHA-256 (hashes.sha256):

    beb8362ec181304caebe4b4f57784bc06a4ccaaee573a80a3593ab7f481bd94d  evidencias/system-profile.json
    19b059fda6b01052261f5a5038763ce89cd1b5103bae7dd76e14564185c1b280  evidencias/bitacora-mongod.log
    2066fe6a6d132533684833802c70bf65deeaa8cd18b5e0014e3c9593c6953a29  evidencias/mongod-archivo.log

Se comprobó que los tres archivos no contienen contraseñas (grep dio 0).

Después del reinicio:

    { was: 0, slowms: 100, sampleRate: 1, ok: 1 }
    2
    51

El nivel volvió a 0, system.profile conserva 2 documentos y la memoria de getLog bajó de 318 a 51 eventos.

## Preguntas

Menciona tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin que nadie la borre deliberadamente.

1. system.profile es una colección limitada: al llenarse sobrescribe los documentos más antiguos.
2. Al reiniciar, la memoria de getLog se vacía y el perfilador vuelve al nivel 0.
3. El archivo de bitácora puede rotarse o perderse si el servidor se reinstala o falla el disco.

¿Por qué el tamaño de 1 MB de system.profile es un problema de conservación y no solo de espacio?

Porque con mucha actividad se llena rápido y el registro del incidente puede sobrescribirse antes de que alguien lo descubra. Limita cuánto tiempo hacia atrás se puede investigar.

¿Por qué getLog sirve para interpretar pero no para conservar?

Porque solo guarda los 1024 eventos más recientes en memoria y se vacía al reiniciar. No es el archivo completo.

## Interpretación

Hay que exportar system.profile y la bitácora, con su hash, antes de reiniciar o de que se sobrescriban.
