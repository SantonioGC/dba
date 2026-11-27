## 1. Objetivo

Comparar las capacidades de trazabilidad disponibles en PostgreSQL mediante bitácoras y disparadores, MongoDB Community mediante el perfilador y la bitácora de `mongod`, y MongoDB Enterprise/Atlas mediante auditoría nativa.

El análisis se basa en las evidencias obtenidas durante los Laboratorios 01 y 02, además de la documentación oficial de MongoDB.

## 2. Tabla comparativa

| Evento auditable | PostgreSQL | MongoDB Community | MongoDB Enterprise/Atlas |
|---|---|---|---|
| Acceso exitoso | Sí la bitácora permite identificar conexiones exitosas y sus datos de sesión. | Sí `mongod` registró la autenticación exitosa de `app_ventas`, con usuario, origen y aplicación. | Documentado, no practicado. Permite auditar eventos de autenticación exitosa con la auditoría habilitada y configurada. |
| Acceso fallido | Sí se registraron intentos fallidos de autenticación. | Si se identificaron intentos con contraseña incorrecta y usuario inexistente. | Documentado puede registrar intentos fallidos de autenticación. |
| Cambio de privilegios | Sí las sentencias `GRANT` y `REVOKE` quedaron registradas mediante `log_statement = 'ddl'`. | Parcial. No se encontró evidencia directa del comando `grantRolesToUser` en los mecanismos consultados. Las instantáneas permitieron detectar la incorporación de `dbAdmin`, pero no atribuir el cambio. | Documentado la auditoría nativa contempla eventos de administración de usuarios, roles y privilegios. |
| Cambio de estructura | Sí se registraron cambios como `ALTER TABLE` mediante la bitácora. | Parcial. El perfilador puede aportar información de comandos administrativos cuando está activo, pero no se comprobó un cambio estructural específico en este laboratorio ni existe auditoría nativa en Community. | Documentado contempla eventos como creación o eliminación de colecciones e índices. |
| Modificación de datos | Sí la configuración de registro y el disparador permitieron identificar modificaciones sobre `clientes`. | Sí `system.profile` registró operaciones `update` y `remove`, incluyendo usuario, momento, cliente y aplicación. | Documentado permite auditar operaciones de escritura mediante `authCheck`, con los filtros y las opciones de auditoría correspondientes. |
| Valor anterior del dato | Sí el disparador de auditoría permitió conservar valores anteriores y posteriores mediante `OLD` y `NEW`. | No el perfilador mostró las operaciones realizadas, pero no conservó automáticamente el valor anterior del documento. | No de forma automática. La auditoría nativa registra eventos, pero no equivale a un historial de versiones con valores anteriores de cada campo. |
| Lectura de datos sensibles | No en la configuración probada. El disparador no registra `SELECT` y `log_statement = 'mod'` no capturó la lectura realizada. Puede ampliarse mediante otros mecanismos. | Parcial. El perfilador registró operaciones `query` y sus filtros cuando estuvo activo, pero no demuestra exactamente qué valores sensibles recibió el usuario. | Documentado se pueden auditar operaciones de lectura con `authCheck`; registrar lecturas exitosas requiere la configuración correspondiente. No equivale a conservar los valores devueltos. |
| Cambio de configuración del registro | Parcial. Es posible verificar parámetros y registrar operaciones de configuración si el mecanismo correspondiente está habilitado. No toda modificación queda auditada automáticamente. | Sí `mongod` registró cambios de nivel del perfilador mediante mensajes `Profiler settings changed`, correlacionados con la conexión del administrador. | Documentado, no practicado. Existen mecanismos para configurar la auditoría y eventos administrativos relacionados; su cobertura depende de la versión y configuración utilizada. |

## 3. Interpretación de resultados

### 3.1 PostgreSQL: bitácora y disparador

En el Laboratorio 01 se comprobó que PostgreSQL puede proporcionar distintos niveles de trazabilidad mediante su configuración de bitácoras y disparadores.

La bitácora permitió registrar accesos, cambios de privilegios, modificaciones de estructura y determinadas operaciones SQL.

Por su parte, el disparador permitió conservar información relacionada con los cambios en los datos, incluidos los valores anteriores y posteriores.

Sin embargo, la configuración empleada no registró las consultas `SELECT` realizadas sobre información sensible. Por tanto, contar con una bitácora y un disparador no significa que todas las operaciones estén auditadas.

### 3.2 MongoDB Community: perfilador y bitácora

En el Laboratorio 02 se comprobó que MongoDB Community proporciona dos fuentes de información complementarias.

El perfilador permitió identificar consultas y modificaciones, incluyendo datos de contexto como el usuario, la aplicación, la dirección del cliente y la fecha de la operación.

La bitácora de `mongod` permitió interpretar autenticaciones exitosas y fallidas, así como cambios en la configuración del perfilador.

No obstante, se identificaron limitaciones importantes:

- Sin perfilado activo, el cambio inicial del RFC no dejó evidencia suficiente para atribuirlo.
- Los cambios de privilegios no aparecieron en las búsquedas realizadas sobre `system.profile` y la bitácora.
- Las instantáneas detectaron diferencias entre roles, pero no identificaron al responsable del cambio.
- El perfilador no recuperó automáticamente los valores anteriores de los datos modificados.
- El nivel del perfilador volvió a `0` después del reinicio del servidor.

Por ello, estos mecanismos aportan trazabilidad parcial, pero no sustituyen una auditoría nativa de seguridad.

### 3.3 MongoDB Enterprise/Atlas: auditoría nativa

De acuerdo con la documentación oficial, MongoDB Enterprise y los despliegues de Atlas que admiten esta función pueden utilizar auditoría nativa para registrar eventos relacionados con autenticación, autorización, administración de usuarios, roles y operaciones sobre la base de datos.

También es posible auditar determinados accesos y modificaciones de datos mediante los mecanismos correspondientes.

Para registrar autorizaciones exitosas de lectura y escritura se requiere configurar apropiadamente `auditAuthorizationSuccess`, lo que puede incrementar el costo de desempeño.

Estas capacidades no se ejecutaron durante el laboratorio

La auditoría nativa tampoco debe confundirse con un historial automático de valores anteriores y posteriores de cada documento.

## 4. Análisis comparativo

La principal diferencia entre los tres escenarios se encuentra en el nivel de detalle y la finalidad de sus mecanismos.

En PostgreSQL, la combinación de bitácoras y disparadores permitió conservar evidencia técnica y registrar cambios sobre los datos, aunque se requirió configuración específica.

En MongoDB Community, el perfilador fue útil para analizar operaciones y la bitácora permitió interpretar eventos del servidor. Sin embargo, ambos mecanismos dejaron limitaciones para investigar cambios de privilegios.

MongoDB Enterprise/Atlas incorpora capacidades específicas de auditoría de seguridad que permiten mejorar la trazabilidad de esos eventos, siempre que se configure adecuadamente.

Por lo tanto, no es suficiente verificar que una tecnología genera registros. También debe evaluarse qué información registra, qué operaciones quedan fuera, cuánto tiempo se conserva y si la evidencia permite atribuir un incidente a un usuario.

## 5. Conclusión

La comparación demuestra que PostgreSQL y MongoDB Community pueden proporcionar información útil para investigar operaciones de bases de datos, pero sus mecanismos requieren configuraciones diferentes y no ofrecen exactamente la misma cobertura.

En las prácticas realizadas, PostgreSQL permitió registrar modificaciones y conservar valores anteriores mediante disparadores, mientras que MongoDB Community permitió identificar determinadas operaciones a través de `system.profile` y eventos de autenticación mediante la bitácora de `mongod`.

La diferencia más importante apareció al analizar cambios de privilegios: en MongoDB Community fue necesario utilizar instantáneas como control compensatorio, sin poder determinar de manera confiable quién realizó la modificación.

Para una organización que necesite trazabilidad formal de cambios de usuarios, roles y privilegios, sería recomendable evaluar la auditoría nativa de MongoDB Enterprise o Atlas, considerando las características, costos y requisitos de configuración del despliegue.
