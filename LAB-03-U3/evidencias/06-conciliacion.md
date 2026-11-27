## 1. Objetivo

Relacionar las operaciones administrativas registradas en las bitácoras de PostgreSQL con las solicitudes de cambio autorizadas, identificando modificaciones justificadas, intentos rechazados, operaciones de preparación y posibles hallazgos de auditoría.

Esta actividad busca demostrar que registrar una operación no equivale a demostrar que estaba autorizada y que una conciliación requiere comparar tanto la evidencia técnica como la documentación de aprobación.

## 2. Registro de solicitudes de cambio

Se creó el esquema `gobierno` y se restringieron los privilegios generales de acceso mediante:

```sql
CREATE SCHEMA gobierno;
REVOKE ALL ON SCHEMA gobierno FROM PUBLIC;
```

Posteriormente se creó la tabla `gobierno.solicitudes_cambio` con los siguientes campos:

- `folio`
- `descripcion`
- `solicitado_por`
- `aprobado_por`
- `ambiente`
- `fecha_aprobacion`
- `ventana_inicio`
- `ventana_fin`

La tabla fue documentada mediante `COMMENT ON TABLE`, identificando al Comité de Cambios como propietario y al DBA como custodio.

## 3. Solicitud registrada

Se insertó la solicitud académica `CAM-2026-014`, correspondiente a la incorporación de una nueva columna en `public.clientes`.

| Campo | Valor registrado |
|---|---|
| Folio | `CAM-2026-014` |
| Descripción | Agregar columna `canal_alta` a clientes |
| Solicitante | Gerencia Comercial |
| Aprobador del escenario | Comite de cambios |
| Ambiente | `produccion` |
| Fecha de aprobación | Generada como un día antes del registro |
| Inicio de ventana | 16/11/2026, 09:07:33 CST |
| Fin de ventana | 16/11/2026, 10:12:33 CST |

La aprobación representa una simulación académica y no una autorización empresarial real.

Antes de aplicar el cambio se comprobó que el campo `dentro_de_ventana` devolvía `t`, es decir, verdadero.

## 4. Cambio implementado

Se ejecutó correctamente:

```sql
ALTER TABLE public.clientes
ADD COLUMN canal_alta VARCHAR(20);
```

PostgreSQL devolvió:

`ALTER TABLE`

Posteriormente se documentó la columna mediante:

```sql
COMMENT ON COLUMN public.clientes.canal_alta IS
'Canal por el que se registro el cliente. Cambio CAM-2026-014.';
```

PostgreSQL devolvió:

`COMMENT`

La comprobación del diccionario de datos confirmó los siguientes resultados:

| Propiedad | Resultado |
|---|---|
| Columna | `canal_alta` |
| Tipo | `character varying` |
| Longitud | 20 |
| Permite valores nulos | `YES` |
| Descripción | `Canal por el que se registro el cliente. Cambio CAM-2026-014.` |

Esto permite demostrar que el cambio se aplicó y que el diccionario conserva su referencia al folio académico.

## 5. Revisión de la bitácora vigente

Se utilizó la vista `dba.bitacora` para identificar sentencias de creación, modificación y cambios de privilegios.

Debido a que PostgreSQL registraba los mensajes en español, se adaptó el filtro para reconocer `sentencia:` en lugar de utilizar únicamente `statement:`.

La consulta devolvió cuatro eventos administrativos:

| Línea de bitácora | Fecha y hora (CST) | Usuario | Operación |
|---|---|---|---|
| 35 | 16/11/2026, 09:09:49 | `postgres` | `CREATE SCHEMA gobierno` |
| 36 | 16/11/2026, 09:10:36 | `postgres` | `REVOKE ALL ON SCHEMA gobierno FROM PUBLIC` |
| 37 | 16/11/2026, 09:11:20 | `postgres` | `CREATE TABLE gobierno.solicitudes_cambio` |
| 42 | 16/11/2026, 09:13:50 | `postgres` | `ALTER TABLE public.clientes ADD COLUMN canal_alta VARCHAR(20)` |

La línea 42 corresponde al cambio documentado mediante `CAM-2026-014`.

La hora de ejecución fue posterior al inicio de la ventana y anterior a su finalización.

Por tanto, el evento coincide con la descripción y la ventana de la solicitud simulada.

Los tres eventos restantes corresponden a la preparación de la estructura de gobierno y no están cubiertos expresamente por el alcance del folio `CAM-2026-014`.

## 6. Revisión de la bitácora histórica

La consulta `pg_ls_logdir()` permitió identificar ocho archivos de bitácora de PostgreSQL.

Se examinó específicamente el archivo:

`postgresql-2026-10-28_000000.log`

En él se encontraron registros asociados con los cambios de privilegios y las pruebas del disparador de auditoría realizadas durante el Laboratorio 01.

### 6.1 Intento de desactivación por `app_ventas`

Se identificaron las líneas:

| Línea | Evento |
|---|---|
| 553 | `app_ventas` envió `ALTER TABLE public.clientes DISABLE TRIGGER trg_auditoria_clientes` |
| 554 | PostgreSQL devolvió un error de propiedad de tabla |
| 555 | El servidor mostró nuevamente la sentencia fallida |

Mensaje de error observado:

```text
ERROR: debe ser dueño de la tabla clientes
```

Interpretación: la cuenta `app_ventas` intentó desactivar el disparador, pero la operación fue rechazada por PostgreSQL.

Por tanto, esta evidencia no demuestra una desactivación efectiva, sino un intento de realizar una operación administrativa sin los permisos necesarios.

El evento es relevante porque permite comprobar la actuación de un control de permisos.

### 6.2 Instrucciones registradas en la sesión de `postgres`

Se identificaron las siguientes líneas:

| Línea | Instrucción |
|---|---|
| 164 | `GRANT UPDATE` sobre `public.clientes` para `app_ventas` |
| 589 | `DISABLE TRIGGER trg_auditoria_clientes` |
| 602 | `ENABLE TRIGGER trg_auditoria_clientes` |

Se revisaron los encabezados de las sentencias y se confirmó que las instrucciones estaban asociadas con sesiones del usuario `postgres`.

La instrucción de concesión de permisos apareció dentro de una sentencia iniciada en la línea 143.

Las instrucciones relacionadas con el disparador aparecieron dentro de una sentencia multilínea iniciada en la línea 557, correspondiente a una sesión de `postgres` desde pgAdmin.

Limitación: las líneas revisadas confirman que las instrucciones fueron enviadas y registradas, pero no proporcionan por sí solas el resultado independiente de cada operación.

Tampoco se identificó un folio formal asociado con estas operaciones históricas.

### 6.3 Estado actual del disparador

Para verificar el estado del mecanismo se consultó `pg_trigger`.

El resultado fue:

| Disparador | Estado |
|---|---|
| `trg_auditoria_clientes` | `HABILITADO` |

Esto confirma que el disparador está habilitado actualmente.

No obstante, el estado actual no permite reconstruir por sí solo cuánto tiempo pudo haber permanecido deshabilitado en el pasado.

## 7. Tabla de conciliación de cambios

La siguiente tabla relaciona las operaciones identificadas con la documentación de autorización disponible.

| Momento | Usuario | Sentencia u operación | Folio que lo autoriza | ¿Autorizado? | Hallazgo |
|---|---|---|---|---|---|
| 16/11/2026, 09:09:49 | `postgres` | `CREATE SCHEMA gobierno` | Sin folio específico | No documentado formalmente | Preparación del laboratorio |
| 16/11/2026, 09:10:36 | `postgres` | `REVOKE ALL ON SCHEMA gobierno FROM PUBLIC` | Sin folio específico | No documentado formalmente | Preparación de seguridad del laboratorio |
| 16/11/2026, 09:11:20 | `postgres` | `CREATE TABLE gobierno.solicitudes_cambio` | Sin folio específico | No documentado formalmente | Preparación del laboratorio |
| 16/11/2026, 09:13:50 | `postgres` | `ALTER TABLE public.clientes ADD COLUMN canal_alta VARCHAR(20)` | `CAM-2026-014` | Sí, en el escenario académico | Sin discrepancia respecto de la solicitud simulada |
| 28/10/2026, 02:01:36 | `app_ventas` | Intento de `DISABLE TRIGGER` | No identificado | No autorizado por permisos técnicos; ejecución rechazada | Intento administrativo fallido |
| 28/10/2026, 02:03:07, sesión iniciada | `postgres` | `DISABLE TRIGGER trg_auditoria_clientes` | No identificado | Sin autorización formal acreditada | Hallazgo potencial de severidad alta |
| 28/10/2026, misma sesión | `postgres` | `ENABLE TRIGGER trg_auditoria_clientes` | No identificado | Sin autorización formal acreditada | Reactivación registrada; requiere conciliación |
| 28/10/2026, hora exacta no recuperada en esta consulta | `postgres` | `GRANT UPDATE ON public.clientes TO app_ventas` | No identificado | Sin autorización formal acreditada | Cambio de privilegios pendiente de conciliación |

Criterio de clasificación: la ausencia de un folio en la evidencia disponible no demuestra automáticamente que una operación fuera maliciosa o indebidamente autorizada. Significa que su autorización no pudo acreditarse mediante el registro revisado.

En una auditoría real, las operaciones históricas deberían compararse con solicitudes, órdenes de trabajo y aprobaciones existentes antes de determinar su condición definitiva.

## 8. Hallazgos identificados

### H-01 — Preparación administrativa sin folio específico

Severidad propuesta: Baja en el escenario académico.

Se identificaron operaciones de creación de esquema, creación de tabla y restricción de permisos ejecutadas como parte de la preparación del laboratorio.

No existe un folio específico que las autorice.

Estas operaciones son explicables en el contexto de la práctica, pero en producción deberían contar con una autorización que documente su finalidad y ventana de ejecución.

Acción recomendada: registrar también los cambios preparatorios que afecten la estructura de producción.

### H-02 — Intento de desactivación del disparador por una cuenta de aplicación

Severidad propuesta: Media; requiere investigación del motivo.

El usuario `app_ventas` intentó ejecutar `DISABLE TRIGGER`, una operación que no corresponde a las funciones habituales de una cuenta comercial.

PostgreSQL rechazó la instrucción porque dicha cuenta no era propietaria de la tabla.

Impacto observado: no se demostró una desactivación efectiva.

Acción recomendada: revisar la causa del intento, validar que la cuenta tenga solo los privilegios necesarios y registrar cualquier desviación.

### H-03 — Desactivación administrativa del mecanismo de auditoría sin autorización identificada

Severidad potencial: Alta.

Se registró una instrucción `DISABLE TRIGGER` asociada con la sesión administrativa `postgres`.

La desactivación efectiva de un disparador de auditoría puede generar un periodo sin seguimiento de cambios sobre los datos.

Aunque también se registró una instrucción `ENABLE TRIGGER` y el disparador está habilitado actualmente, no se dispone en esta revisión de una autorización formal ni de una prueba completa que establezca el resultado y la duración de una posible desactivación.

Acción recomendada: investigar el motivo del cambio, verificar el resultado histórico de ambas operaciones, documentar la autorización y determinar si existió un intervalo sin cobertura de auditoría.

### H-04 — Cambio de privilegios sin folio identificado

Severidad propuesta: Media, pendiente de evaluación.

La bitácora histórica contiene una instrucción `GRANT UPDATE` ejecutada desde una sesión de `postgres`, destinada a conceder permisos sobre `public.clientes` a `app_ventas`.

No se identificó una solicitud formal asociada.

Acción recomendada: revisar la matriz de roles de la Unidad II, comprobar la necesidad del privilegio y localizar la aprobación correspondiente.

### H-05 — Limitación histórica de cobertura de bitácora

Severidad propuesta: Media.

La guía del laboratorio indica que algunos objetos fueron creados cuando `log_statement` estaba en `none`, por lo que determinadas operaciones iniciales no quedaron registradas.

La existencia posterior de una bitácora no permite reconstruir automáticamente los eventos que no fueron capturados.

Acción recomendada: documentar los periodos sin registro y establecer controles para verificar la configuración de auditoría desde el inicio de los ambientes.

## 9. Preguntas de reflexión

### 1. ¿Qué cambios de la bitácora no tienen folio? Clasifícalos: ¿son de preparación del laboratorio o representan hallazgos?

Los cambios del 16 de noviembre relacionados con `CREATE SCHEMA gobierno`, `REVOKE ALL ON SCHEMA gobierno FROM PUBLIC` y `CREATE TABLE gobierno.solicitudes_cambio` no tienen un folio específico.

Estos eventos corresponden a la preparación del laboratorio. Su finalidad está documentada en el procedimiento académico, pero no deben presentarse como operaciones formalmente autorizadas mediante `CAM-2026-014`.

Por otro lado, en la bitácora histórica del 28 de octubre aparecen instrucciones `GRANT UPDATE`, `DISABLE TRIGGER` y `ENABLE TRIGGER` que no cuentan con un folio identificado en las evidencias revisadas.

Estas operaciones requieren investigación porque afectan los permisos o el mecanismo de auditoría de la base de datos.

La instrucción `DISABLE TRIGGER` es especialmente relevante, ya que puede impedir que determinadas modificaciones de datos queden registradas.

También se identificó el intento fallido de `app_ventas`, que debe documentarse como un evento relevante de seguridad, aunque PostgreSQL rechazó su ejecución.

En conclusión, los cambios sin folio deben diferenciarse según su contexto, impacto y evidencia disponible. No todos representan necesariamente una infracción, pero deben poder justificarse.

### 2. La desactivación del disparador del LAB-01 (Actividad 14), ¿qué tan grave es como hallazgo? ¿Por qué? ¿Qué distingue la línea 163 de la 169?

La desactivación efectiva de un disparador de auditoría puede constituir un hallazgo de severidad alta, porque elimina temporalmente un mecanismo diseñado para registrar modificaciones de información.

Si se modifican datos mientras el disparador está deshabilitado, esos cambios podrían no quedar registrados en la tabla de auditoría correspondiente.

Esto limita la capacidad de reconstruir los hechos, detectar modificaciones indebidas e identificar responsabilidades.

La guía utiliza las líneas 163 y 169 de un ejemplo de bitácora para distinguir dos situaciones.

En nuestra instalación, los eventos correspondientes aparecen en líneas diferentes:

- Línea 553: `app_ventas` intentó desactivar el disparador.
- Línea 554: PostgreSQL rechazó el intento porque la cuenta no era propietaria de la tabla.
- Línea 589: la instrucción de desactivación apareció dentro de una sesión de `postgres`.
- Línea 602: en esa misma sesión se registró la instrucción de reactivación.

La principal diferencia es que `app_ventas` no tenía privilegios suficientes, mientras que `postgres` era la cuenta administrativa utilizada para ejecutar las instrucciones.

Se comprobó que el disparador está habilitado actualmente, pero las líneas revisadas no bastan para certificar el resultado de cada instrucción administrativa ni el tiempo durante el cual pudo haber estado deshabilitado.

### 3. ¿Qué limitación tiene esta conciliación si `log_statement` estuvo en `none` durante algún periodo?

Si `log_statement` estuvo configurado en `none`, PostgreSQL no registró mediante ese parámetro las sentencias SQL ejecutadas durante dicho periodo.

Esto genera un vacío de evidencia.

Aunque posteriormente se active `log_statement = 'mod'`, el cambio de configuración no recupera las operaciones que anteriormente no quedaron registradas.

Por lo tanto, la conciliación no puede considerarse completa para esos intervalos únicamente a partir de la bitácora de sentencias.

Sería necesario buscar información adicional en mecanismos de auditoría, registros de aplicaciones, sistemas de despliegue, solicitudes de cambio u otras fuentes disponibles.

El informe deberá declarar expresamente esa limitación, en lugar de afirmar que no ocurrieron modificaciones.

### 4. ¿Quién debería realizar la conciliación: el DBA que hizo los cambios u otra persona?

La conciliación debería ser realizada o supervisada por una persona independiente de quien ejecutó los cambios, preferentemente Auditoría Interna o Seguridad de la Información.

El DBA tiene la responsabilidad de administrar las bases de datos, ejecutar las modificaciones autorizadas y proporcionar las evidencias técnicas.

Sin embargo, si el mismo DBA es la única persona que revisa y aprueba sus propias operaciones, existe un conflicto de funciones.

Una revisión independiente permite detectar cambios sin autorización, privilegios excesivos y diferencias entre las solicitudes aprobadas y las operaciones registradas.

Por esta razón, se propone que el DBA proporcione las bitácoras y los registros necesarios, mientras que Auditoría Interna realice la conciliación y documente los hallazgos.

Los propietarios de los datos deben participar cuando sea necesario validar la legitimidad o finalidad de un cambio.

## 10. Limitaciones de la conciliación

Se identificaron las siguientes limitaciones:

1. La vista `dba.bitacora` consulta el archivo activo y no incluye automáticamente todas las bitácoras históricas.
2. Algunas sentencias se registran en varias líneas y requieren reconstruir el encabezado para identificar al usuario.
3. El registro de una sentencia no demuestra por sí solo que se ejecutó correctamente.
4. La existencia de una autorización simulada no equivale a una aprobación empresarial real.
5. Las operaciones históricas no disponen de folios identificados en los registros revisados.
6. Los periodos con configuración de registro insuficiente pueden contener operaciones que no fueron capturadas.
7. La cuenta `postgres` identifica la sesión administrativa, pero no necesariamente permite atribuir la operación a una persona física concreta sin evidencia adicional.
8. Los registros completos pueden contener contraseñas o datos personales y deben revisarse antes de exportarlos o compartirlos.

Estas limitaciones deberán incorporarse al expediente final de auditoría interna.

## 11. Conclusión

La Actividad 7 permitió implementar un registro mínimo de cambios y relacionarlo con las bitácoras de PostgreSQL.

Se registró la solicitud académica `CAM-2026-014`, se comprobó su ventana y se agregó correctamente la columna `canal_alta` a `public.clientes`.

La consulta de la bitácora confirmó que la modificación quedó registrada mediante una sentencia `ALTER TABLE` ejecutada por `postgres` dentro de la ventana documentada.

Además, se revisaron registros históricos del Laboratorio 01, donde se identificó un intento rechazado de desactivación del disparador por `app_ventas` y operaciones administrativas asociadas con `postgres`.

Se comprobó que el disparador está habilitado actualmente, aunque persisten limitaciones para establecer el resultado histórico completo de todas las instrucciones y sus autorizaciones.

Finalmente, se concluye que una conciliación efectiva no consiste solamente en revisar comandos SQL. También debe confirmar la existencia de una autorización verificable, identificar las diferencias y asignar la investigación de los hallazgos a una persona independiente.

## 12. Archivos relacionados

- `sql/04-registro-cambios.sql`
- `evidencias/06-conciliacion.md`
- `politicas/POL-01-acceso.md`
- `politicas/POL-06-cambios-produccion.md`
- `evidencias/05-conservacion.md`
- `evidencias/04-catalogo.md`
