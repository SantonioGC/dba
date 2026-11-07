# Correlación de un cambio de configuración con su autor

const cambios = bitacora().filter(e => e.msg === "Profiler settings changed")
cambios[cambios.length - 1]
bitacora().filter(e => e.ctx === "conn41" && e.msg === "Authentication succeeded").map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.principalName, db: e.attr.authenticationDatabase, client: e.attr.remote }))

## Resultado

Cambios del perfilador en la bitácora:

    05:50:52.766  conn27  nivel 0 a 2
    05:50:54.103  conn39  nivel 2 a 0
    05:50:54.123  conn41  nivel 0 a 1 con filtro { op: { $in: [ insert, remove, update ] } }
    05:50:57.195  conn65  nivel 1 a 2
    05:50:57.219  conn65  nivel 2 a 1

Último cambio de la Actividad 4 (conn41):

    t: 2026-11-07T05:50:54.123-07:00, ctx: conn41, msg: Profiler settings changed
    from: { level: 0, slowms: 100, sampleRate: 1 }
    to: { level: 1, slowms: 100, sampleRate: 1, filter: { op: { $in: [ 'insert', 'remove', 'update' ] } } }

Autenticación de esa conexión:

    t: 2026-11-07T05:50:54.075-07:00, ctx: conn41, user: admin, db: admin, client: 127.0.0.1:38564

## Preguntas

¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?

El usuario admin. Lo demuestran Profiler settings changed en conn41 (05:50:54.123) y Authentication succeeded de admin en conn41 (05:50:54.075).

¿Qué condición debe cumplirse para que esta correlación sea válida? (Piensa en qué pasa si el servidor se reinicia y los números de conexión vuelven a empezar.)

Que ambos eventos pertenezcan al mismo arranque del servidor. Si se reinicia, los números de conexión empiezan de nuevo y conn41 podría ser otra persona.

¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?

Porque quien apaga o cambia el registro puede ocultar sus actos. Si el cambio queda registrado, se puede detectar la manipulación.

## Interpretación

El evento de configuración no trae el usuario, pero se atribuye a admin correlacionando el ctx con su autenticación.
