#Cronología

SELECT num, linea FROM dba.bitacora WHERE linea ~ '(parameter ".*" changed|FATAL|connection authorized|statement:|ERROR)' ORDER BY num;
SELECT id_evento, momento, usuario_sesion, aplicacion, ip_cliente, operacion, id_cliente, valores_antes ->> 'rfc' AS rfc_antes, valores_despues ->> 'rfc' AS rfc_despues, valores_antes ->> 'telefono' AS tel_antes, valores_despues ->> 'telefono' AS tel_despues FROM auditoria.cambios_clientes ORDER BY id_evento;

##Cronología

| # | Fecha y hora | Usuario | Cliente | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente |
|---|---|---|---|---|---|---|---|
| 1 | 01:39:24 | proceso principal | | Configuración | log_line_prefix y log_statement = ddl | Sí | Fri línea 313-314 |
| 2 | 01:39:49 | app_ventas | 127.0.0.1 | Acceso | Contraseña incorrecta | No | Fri 316, 319 |
| 3 | 01:39:49 | usuario_inexistente | 127.0.0.1 | Acceso | Rol inexistente | No | Fri 322, 326 |
| 4 | 01:39:49 | app_ventas | 127.0.0.1 | Acceso | Conexión exitosa (app-ventas-web) | Sí | Fri 331 |
| 5 | 01:48:49 | postgres | 127.0.0.1 | Privilegio | REVOKE UPDATE a soporte_ana y GRANT UPDATE a app_ventas | Sí | Fri 353-354 |
| 6 | 01:48:54 | postgres | 127.0.0.1 | Estructura | ALTER TABLE clientes ADD COLUMN segmento | Sí | Fri 355 |
| 7 | 01:48:56 | postgres | 127.0.0.1 | Privilegio | CREATE ROLE y DROP ROLE rol_temporal (contraseña visible en la bitácora) | Sí | Fri 356-357 |
| 8 | 01:49:34 y 01:50:43 | app_ventas | 127.0.0.1 | Acceso | Conexiones exitosas; el UPDATE del RFC no quedó registrado (ddl) | Sí | Fri 360, 364 |
| 9 | 01:51:06 | postgres | 127.0.0.1 | Configuración | log_statement = mod (vigente a las 01:51:11) | Sí | Fri 372, 375 |
| 10 | 01:51:23 | app_ventas | 127.0.0.1 | Datos | UPDATE del teléfono del cliente 3 | Sí | Fri 379 |
| 11 | 01:52:10 | soporte_ana | 127.0.0.1 | Error | DELETE del cliente 5 rechazado (se repitió a las 01:52:26) | No | Fri 384-385 |
| 12 | 01:52:44 | postgres | 127.0.0.1 | Error | DROP ROLE soporte_ana rechazado por dependencias | No | Fri 395-396 |
| 13 | 01:59:17 a 02:02:01 | postgres | 127.0.0.1 | Estructura | Esquema auditoria, tabla, función y disparador | Sí | Fri 414-454 |
| 14 | 02:03:22 | app_ventas | 127.0.0.1 | Datos | UPDATE del RFC del cliente 3 (XYZ a ZZZ) | Sí | Fri 460; id_evento 1 |
| 15 | 02:03:27 | app_ventas | 127.0.0.1 | Error | SELECT en auditoria rechazado | No | Fri 465 |
| 16 | 02:04:19 y 02:04:23 | postgres | 127.0.0.1 | Datos | INSERT y DELETE del cliente Pedro Ruiz | Sí | Fri 468, 470; id_evento 2 y 3 |
| 17 | 02:04:43 | app_ventas | 127.0.0.1 | Error | DELETE en auditoria y DISABLE TRIGGER rechazados | No | Fri 475-479 |
| 18 | 02:06:09 a 02:06:13 | postgres | 127.0.0.1 | Datos | DISABLE TRIGGER, UPDATE del RFC (ZZZ a GHI) y ENABLE TRIGGER, sin fila de auditoría | Sí | Fri 483-486 |
| 19 | 02:06:42 | postgres | 127.0.0.1 | Datos | UPDATE de segmento en los 5 clientes | Sí | Fri 491; id_evento 4 a 8 |

##Preguntas

¿Quién cambió el RFC la primera vez (Actividad 3)? ¿Y en las Actividades 7, 12 y 14?

Actividad 3: No hay evidencia, el cambio ocurrió sin bitácora ni auditoría. 
Actividad 7: No hay evidencia de la sentencia solo se ve la conexión de app_ventas. 
Actividad 12: app_ventas. 
Actividad 14: postgres, según la bitácora la auditoría no lo registró.

¿Quién cambió el teléfono?

app_ventas, según la bitácora log_statement = mod. No hay evidencia en la tabla de auditoría porque el disparador se creó después.

¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?

Sí app_ventas y usuario_inexistente, ambos desde 127.0.0.1.

¿Qué valor tenía el RFC antes de cada cambio?

Actividad 3: No hay evidencia. Actividad 7: No hay evidencia. Actividad 12: GAMA780912XYZ. Actividad 14: No hay evidencia directa, la auditoría no lo registró.

##Interpretacion

Lo que no se registró se declara como hueco, no se estima.
