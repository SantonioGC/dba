# Respuesta a Dirección

## Preguntas

¿Quién cambió el RFC de María García en la Actividad 2? ¿Y en la Actividad 3?

Actividad 2: No hay evidencia con esta edición. El perfilador estaba apagado (was: 0) y la bitácora de mongod no registra operaciones de datos. Solo se ve que app_ventas se conectó a las 05:50:51 MST.
Actividad 3: app_ventas (user app_ventas@comercial), según system.profile.

¿Cuándo y desde qué aplicación?

Actividad 3: 2026-11-07 12:50:53.212 UTC (05:50:53 MST), desde la aplicación app-ventas-web, cliente 127.0.0.1.
Actividad 2: No hay evidencia con esta edición de la hora del cambio ni de la aplicación que lo hizo.

¿Qué valor tenía antes?

No hay evidencia con esta edición. system.profile guarda el comando con el valor nuevo ($set) y no el valor anterior; la bitácora de mongod no guarda datos.

¿Cambió alguien los privilegios de app_ventas?

Sí hubo un cambio: las instantáneas muestran que se agregó dbAdmin entre las 12:50:57.119 y las 12:50:57.209 UTC. Quién lo hizo y la hora exacta: No hay evidencia con esta edición, porque grantRolesToUser no aparece ni en system.profile ni en la bitácora.
Como indicio, no como prueba: la misma conexión de admin (conn65) cambió el perfilador justo antes y después de ese intervalo.

## Interpretación

Con MongoDB Community se puede atribuir una modificación de datos si el perfilador estaba activo, pero no el valor anterior ni quién cambió los privilegios.
