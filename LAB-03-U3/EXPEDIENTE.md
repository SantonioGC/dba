#expediente de auditoria interna

## 1. Alcance

-El presente expediente tiene como finalidad documentar y evaluar los mecanismos de auditoría, trazabilidad, control de acceso y gobierno de datos implementados sobre la base de datos `comercial`
-La revisión comprende principalmente las actividades efectuadas entre el 28 de octubre y el 16 de noviembre de 2026, así como los antecedentes técnicos disponibles de los laboratorios anteriores

### Sistemas revisados

| Sistema | Versión | Entorno | Alcance |
|---|---|---|---|
| PostgreSQL | 16.15 | Servidor local en Windows, puerto 5432 | Configuración, privilegios, bitácoras, disparadores y gobierno de datos |
| MongoDB Community | 7 | Entorno académico del LAB-02 | Perfilador, registros técnicos e instantáneas de privilegios |

El expediente contempla las siguientes solicitudes de auditoría:

A1: Identificar los conjuntos de datos y sus responsables
A2: Documentar la estructura, significado y sensibilidad de los datos
A3: Verificar los mecanismos de registro y conservación de eventos
A4: Definir políticas prácticas y verificables
A5: Conciliar los cambios observados con los registros de autorización
A6: Documentar las limitaciones técnicas y los riesgos pendientes de aceptación

Alcance de la conclusión: este expediente demuestra determinados controles y eventos mediante evidencias disponibles.

## 2. Configuracion de auditoria

### 2.1 PostgreSQL

En el LAB-01 se implementaron mecanismos de registro de eventos y auditoría de modificaciones.
La configuración comprobada incluye:

- Registro mediante el colector de PostgreSQL.
- Configuración de `log_statement` con valor `mod`.
- Consulta de eventos mediante la vista `dba.bitacora`.
- Tabla `auditoria.cambios_clientes`.
- Disparador `trg_auditoria_clientes`, asociado a `public.clientes`.

La evidencia E1 conserva los parámetros actuales de registro. La evidencia E3 confirma que el disparador se encuentra habilitado, identificado mediante el estado `O`
La evidencia E4 contiene una muestra de diez registros de auditoría, mientras que E5 contiene la bitácora exportada y su manifiesto de integridad SHA-256
Los registros de auditoría permiten analizar operaciones de inserción, actualización y eliminación

**Evidencias:** `evidencias/E1-configuracion-registro.txt`, `evidencias/E3-disparadores.txt`, `evidencias/E4-muestra-auditoria.txt` y `evidencias/E5-bitacora-postgresql.log`.

### 2.2 MongoDB Community

-En el LAB-02 se trabajó con mecanismos de trazabilidad disponibles en MongoDB Community, principalmente registros de operaciones, información del perfilador e instantáneas de privilegios
-Las evidencias recuperadas incluyen `system-profile.json`, `bitacora-mongod.log`, el manifiesto de hashes y la comparación técnica del laboratorio
-La edición Community no ofrece el mismo mecanismo de auditoría nativa disponible en ediciones empresariales. Por ello, debe distinguirse el alcance de los mecanismos implementados de las capacidades que solamente se estudiaron conceptualmente

**Evidencias:** `evidencias/E6-mongodb/system-profile.json`, `evidencias/E6-mongodb/bitacora-mongod.log`, `evidencias/E6-mongodb/hashes.sha256` y `evidencias/E6-mongodb/09-comparacion.md`.

## 3. Bitacora interpretada

-Se seleccionaron tres eventos registrados en `auditoria.cambios_clientes`
-Las fechas siguientes conservan el desplazamiento UTC−06 mostrado por PostgreSQL

### Evento 1 — Modificación del RFC del cliente 3

| Campo | Información registrada |
|---|---|
| ID de evento | 1 |
| Fecha | 28 de octubre de 2026, 01:47:10 |
| Usuario de sesión | `app_ventas` |
| Usuario efectivo | `postgres` |
| Aplicación | `app-ventas-web` |
| Dirección de origen | `127.0.0.1` |
| Operación | `UPDATE` |
| Identificador afectado | 3 |
| ¿Cambió el RFC? | Sí |
| ¿Se conservaron valores anterior y posterior? | Sí |

Interpretación: se registró una actualización del cliente 3, correspondiente al caso de María García. La comparación entre los valores anterior y posterior del campo `rfc` confirmó que fueron diferentes.

El usuario de sesión fue `app_ventas`, mientras que el usuario efectivo registrado fue `postgres`. Esta diferencia debe conservarse como parte del contexto de ejecución y no permite, por sí sola, atribuir el cambio a una persona administradora.

La dirección `127.0.0.1` indica una conexión local al servidor
Tipo de evento: modificación de datos con repercusión en la integridad de información identificativa
Qué demuestra: el disparador conservó información suficiente para identificar la operación y comprobar el cambio de RFC, sin necesidad de exponer sus valores completos
Limitación: el registro demuestra la modificación, pero no acredita una autorización de negocio ni la causa que la originó
Evidencia: consulta de verificación sobre `auditoria.cambios_clientes`; muestra general en `evidencias/E4-muestra-auditoria.txt`.

### Inserción de un registro

| Campo | Información registrada |
|---|---|
| ID de evento | 2 |
| Fecha | 28 de octubre de 2026, 01:55:15 |
| Usuario de sesión | `postgres` |
| Usuario efectivo | `postgres` |
| Aplicación | `pgAdmin 4 - CONN:2914679` |
| Dirección de origen | `127.0.0.1` |
| Operación | `INSERT` |
| Identificador afectado | 6 |

Interpretación: se registró la creación de un cliente con identificador 6, ejecutada mediante una sesión administrativa de pgAdmin
Tipo de evento: inserción de datos
Qué demuestra: el mecanismo de auditoría registra la incorporación de registros a la tabla
Limitación: se desconoce, a partir de este evento aislado, si la inserción tenía una solicitud de autorización asociada o una finalidad de prueba formalmente registrada
Evidencia: evento 2 de `auditoria.cambios_clientes`

### Eliminación de un registro

| Campo | Información registrada |
|---|---|
| ID de evento | 3 |
| Fecha | 28 de octubre de 2026, 01:55:49 |
| Usuario de sesión | `postgres` |
| Usuario efectivo | `postgres` |
| Aplicación | `pgAdmin 4 - CONN:2914679` |
| Dirección de origen | `127.0.0.1` |
| Operación | `DELETE` |
| Identificador afectado | 6 |

Interpretación: aproximadamente 34 segundos después de la inserción, se registró la eliminación del cliente 6 mediante la misma aplicación administrativa.
Tipo de evento: eliminación de datos
Qué demuestra: el mecanismo de auditoría puede conservar evidencia de una eliminación incluso cuando el registro ya no permanece en la tabla operativa
Limitación: la proximidad temporal sugiere una secuencia relacionada, pero no demuestra por sí sola que se tratara de una prueba autorizada
Evidencia: `auditoria.cambios_clientes`

### Conclusión de la interpretación

Los tres eventos evidencian el funcionamiento de la auditoría para operaciones `UPDATE`, `INSERT` y `DELETE`
No obstante, la presencia de una bitácora no sustituye los procedimientos de autorización. Para determinar si una acción fue adecuada deben relacionarse los registros técnicos con las reglas de negocio y las solicitudes aprobadas

## 4. Elementos de gobierno

### 4.1 Responsables de los datos

Se establecio una matriz de responsabilidades para distinguir:

| Figura | Responsabilidad |
|---|---|
| Gerencia Comercial | Propietaria de los datos de clientes; decide finalidades, acceso y correcciones |
| DBA | Custodio técnico; administra protección, disponibilidad y mecanismos de registro |
| Aplicación de ventas | Usuario funcional para operaciones autorizadas |
| Área de soporte | Usuario con acceso limitado a información necesaria |
| Seguridad de la Información | Revisión de accesos, controles y riesgos |
| Comité de Cambios | Autorización de modificaciones controladas en el entorno |

El DBA no debe decidir unilateralmente cuál es el RFC correcto de un cliente; esa decisión requiere validación del propietario del dato.

Evidencia: `evidencias/02-responsables.md`.

### 4.2 Catálogo mínimo de datos

Se elaboró un inventario de conjuntos de datos para identificar su ubicación, finalidad, responsable y clasificación.

Entre los objetos relevantes de PostgreSQL se encuentran:

- `public.clientes`.
- `auditoria.cambios_clientes`.
- `gobierno.solicitudes_cambio`.

-La documentación también incorpora conjuntos de datos del escenario de MongoDB y sus mecanismos de trazabilidad
-El listado completo y las clasificaciones correspondientes se conservan en el catálogo

Evidencia: `evidencias/04-catalogo.md` y `sql/03-inventario-tablas.sql`

### 4.3 Diccionario de datos

Se utilizaron instrucciones `COMMENT` para documentar el significado de la tabla `clientes` y sus columnas
Posteriormente, se exportó la información a un archivo CSV para integrar la descripción operativa de los campos
Durante la Actividad 7 se incorporó la columna `canal_alta`, cuya finalidad fue documentada como parte del cambio `CAM-2026-014`
Entre los atributos que requieren atención especial se encuentran el RFC, correo electrónico, teléfono y otros identificadores personales

Evidencias: `sql/02-comentarios-diccionario.sql`, `evidencias/03-diccionario.md` y `evidencias/diccionario-clientes.csv`.

### 4.4 Calidad de datos

Las verificaciones realizadas identificaron situaciones que requieren revisión por el propietario del dato:

- Posible duplicidad de correo electrónico.
- Valores de RFC que no cumplen la validación esperada.
- Formato de correo electrónico incorrecto.
- Edad negativa.
- Ausencia de RFC en un registro.

La existencia de estos problemas no autoriza al DBA a sustituir valores arbitrariamente.

Evidencias: `sql/01-verificaciones-calidad.sql` y `evidencias/01-calidad.md`.

## 5. Conservación

Se documentó un criterio de conservación que distingue distintos tipos de registros y sus necesidades de consulta, protección, integridad y disponibilidad
La conservación debe responder a tres preguntas:

1. ¿Durante cuánto tiempo se necesita el registro?
2. ¿Quién puede consultarlo?
3. ¿Cómo se demuestra que no fue alterado?

La política distingue entre bitácoras de acceso, errores, modificaciones, auditoría del dato, eventos de privilegios y fuentes de trazabilidad de los motores utilizados
Los plazos y responsables específicos corresponden al documento de conservación aprobado o propuesto en la Actividad 5
Se verificó el uso de SHA-256 para detectar alteraciones en archivos de evidencia exportados
Las copias de trabajo redactadas cuentan con manifiestos independientes de los originales

Evidencias: `evidencias/05-conservacion.md`, `evidencias/E5-bitacora-postgresql.sha256` y `evidencias/E6-mongodb/hashes.sha256`.

## 6. Políticas

| Política | Propósito | Evidencia relacionada |
|---|---|---|
| POL-01 — Acceso | Regular solicitudes, aprobación y revisión de privilegios | E2 y matriz de responsables |
| POL-02 — Respaldo | Definir responsabilidades y frecuencia de protección de información | Política documentada; pruebas operativas futuras |
| POL-03 — Retención | Establecer conservación, acceso y disposición de registros | Criterio de conservación y hashes |
| POL-04 — Restauración | Definir autorización, verificación y criterios de recuperación | Política documentada; procedimiento operativo pendiente |
| POL-05 — Datos sensibles | Minimizar exposición y registrar usos autorizados | Diccionario, E4 y versiones redactadas |
| POL-06 — Cambios en producción | Exigir solicitudes, ventanas de ejecución y conciliación | Registro de cambios y bitácora |

La existencia de las políticas no equivale automáticamente a demostrar su cumplimiento continuo. Los controles requieren evidencia periódica y revisión
Los procedimientos técnicos detallados de respaldo y restauración corresponden a actividades posteriores

Documentos: `politicas/POL-01-acceso.md`, `POL-02-respaldo.md`, `POL-03-retencion.md`, `POL-04-restauracion.md`, `POL-05-datos-sensibles.md` y `POL-06-cambios-produccion.md`.

## 7. Conciliación de cambios

-Durante la Actividad 7 se creó el esquema `gobierno` y la tabla `gobierno.solicitudes_cambio`
-El registro permite relacionar una modificación con un folio, solicitante, aprobador, ambiente y ventana de ejecución

### 7.1 Cambio autorizado

-Se registró el folio `CAM-2026-014` para agregar la columna `canal_alta` a `public.clientes`
-El escenario académico registró como aprobador al Comité de Cambios, con una ventana de ejecución para el 16 de noviembre de 2026
-La modificación se ejecutó durante dicha ventana

Resultado: coincidencia entre el cambio técnico realizado y el folio registrado. La aprobación forma parte de la simulación académica; no constituye una autorización externa independiente.

### 7.2 Cambios históricos

La revisión de las bitácoras anteriores identificó operaciones administrativas, entre ellas:

- Intento de `app_ventas` de deshabilitar el disparador de auditoría, rechazado por falta de permisos.
- Instrucciones administrativas para deshabilitar y rehabilitar el disparador.
- Modificaciones de privilegios mediante `GRANT`.
- Cambios de estructura y comentarios de objetos.

-No todos estos eventos históricos cuentan con un folio formal de autorización en el registro creado posteriormente.
-Por lo tanto, deben clasificarse según su contexto: preparación de laboratorio, cambio autorizado documentado o evento que requiere conciliación adicional.
-Una sentencia registrada no acredita por sí sola que el cambio se completara correctamente.

### 7.3 Resultado de la conciliación

| Cambio | Folio | Resultado |
|---|---|---|
| Incorporación de `canal_alta` | `CAM-2026-014` | Conciliado en el escenario académico |
| Intento de desactivar el disparador por `app_ventas` | Sin folio identificado | Intento rechazado; revisar privilegios |
| Desactivación y rehabilitación administrativa del disparador | Sin folio identificado | Riesgo de interrupción de trazabilidad; revisión requerida |
| Modificaciones históricas de permisos | Sin folio identificado en el registro actual | Contexto académico; formalización pendiente |

Evidencias: `sql/04-registro-cambios.sql`, `evidencias/06-conciliacion.md`, `evidencias/E3-disparadores.txt` y bitácoras históricas de LAB-01.

## 8. Hallazgos

| ID | Hallazgo | Fuente | Severidad | Impacto | Recomendación | Decisión requerida de |
|---|---|---|---|---|---|---|
| H-01 | Inconsistencias de calidad en `clientes`: correos duplicados, formatos incorrectos, RFC y edad inválidos | Actividad 1 | Media | Decisiones comerciales incorrectas y dificultades de identificación | Validar registros, definir reglas y aprobar correcciones | Gerencia Comercial |
| H-02 | Posibilidad de deshabilitar el disparador utilizando privilegios administrativos | LAB-01 y Actividad 7 | Alta | Pérdida potencial de trazabilidad de modificaciones | Restringir operaciones, supervisar cambios y exigir autorización | Seguridad de la Información y Comité de Cambios |
| H-03 | Cambios históricos sin folio de autorización identificable | Actividad 7 | Media | Dificultad para demostrar autorización formal | Conciliar registros y clasificar prácticas académicas | Comité de Cambios |
| H-04 | Periodos históricos sin registro completo de sentencias | LAB-01 y E1 | Alta | Imposibilidad de reconstruir todas las operaciones del periodo | Mantener registro continuo, conservar configuraciones históricas y declarar brechas | Seguridad de la Información |
| H-05 | Limitaciones de auditoría en MongoDB Community | LAB-02 y E6 | Media | Cobertura parcial de determinadas operaciones | Evaluar mecanismos complementarios o auditoría avanzada | Seguridad de la Información |
| H-06 | Potencial exposición de datos sensibles en bitácoras exportadas | Actividad 8 | Media | Divulgación de identificadores y datos internos | Minimizar, redactar y restringir acceso a los originales | DBA y Seguridad de la Información |
| H-07 | Diferencia entre usuario de sesión y usuario efectivo en el evento 1 | Auditoría del dato | Media | Dificultad para interpretar correctamente la identidad de ejecución | Revisar el contexto y la función de auditoría; conservar ambos identificadores | DBA y Seguridad de la Información |

### Tratamiento

-Los hallazgos deben asignarse a responsables, recibir una decisión documentada y contar con seguimiento.
-No se considera que un hallazgo esté resuelto únicamente porque el control esté habilitado actualmente o porque se haya registrado en este expediente.

## 9. Limitaciones conocidas y riesgos aceptados

### 9.1 Cobertura temporal de PostgreSQL

El parámetro `log_statement` estuvo en `none` durante parte del trabajo previo.

Consecuentemente, la configuración actual no permite demostrar que todas las operaciones anteriores quedaron registradas.

Estado: limitación identificada. 
Aceptación formal: pendiente de Seguridad de la Información y del responsable del sistema.

### 9.2 Auditoría deshabilitable por un administrador

Un usuario con privilegios administrativos suficientes puede modificar la configuración de auditoría o deshabilitar mecanismos de registro.

El estado actual habilitado del disparador no demuestra que siempre permaneciera activo.

Estado: riesgo técnico identificado. 
Aceptación formal: pendiente del Comité de Cambios y Seguridad de la Información.

### 9.3 Cobertura de MongoDB Community

El perfilador y los registros técnicos no equivalen a una auditoría nativa integral.

La comparación de mecanismos avanzados de auditoría corresponde al análisis técnico, no a una implementación verificada en este entorno.

Estado: limitación documentada. 
Aceptación formal: pendiente del propietario del sistema y Seguridad de la Información.

### 9.4 Cambios anteriores al registro formal

El registro `gobierno.solicitudes_cambio` se incorporó después de varias operaciones históricas.

Por ello, no existe correspondencia automática entre todos los eventos previos y un folio aprobado.

Estado: trazabilidad de autorización parcialmente documentada. 
Aceptación formal: pendiente del Comité de Cambios.

### 9.5 Integridad y confidencialidad de evidencias

Los hashes SHA-256 permiten detectar diferencias entre archivos y valores almacenados, pero por sí solos no acreditan autoría, fecha original de generación ni ausencia de información confidencial.

Las versiones redactadas reducen la exposición de determinados datos, aunque requieren revisión antes de publicarse.

Estado: controles de integridad verificados; revisión de publicación pendiente. 
Aceptación formal: pendiente del custodio de evidencias y Seguridad de la Información.

Conclusión sobre aceptación de riesgos: este ejercicio identifica responsables propuestos, pero no simula firmas, autorizaciones externas o aceptaciones formales que no se hayan obtenido.

## 10. Índice de evidencias

### 10.1 Gobierno y documentación

| Archivo | Contenido |
|---|---|
| `evidencias/01-calidad.md` | Diagnóstico de calidad |
| `evidencias/02-responsables.md` | Matriz de responsabilidades |
| `evidencias/03-diccionario.md` | Documentación del diccionario |
| `evidencias/04-catalogo.md` | Inventario de datos |
| `evidencias/05-conservacion.md` | Criterios de conservación |
| `evidencias/06-conciliacion.md` | Análisis de cambios |
| `evidencias/07-reflexion-evidencias.md` | Respuestas de la Actividad 8 |
| `evidencias/diccionario-clientes.csv` | Diccionario exportado |

### 10.2 Evidencias técnicas

| Identificador | Archivo | Integridad |
|---|---|---|
| E1 | `evidencias/E1-configuracion-registro.txt` | Exportación técnica |
| E2 | `evidencias/E2-privilegios.txt` | Exportación técnica |
| E3 | `evidencias/E3-disparadores.txt` | Exportación técnica |
| E4 | `evidencias/E4-muestra-auditoria.txt` | Muestra sin valores personales completos |
| E5 | `evidencias/E5-bitacora-postgresql.log` | SHA-256 verificado |
| E5 | `evidencias/E5-bitacora-postgresql.sha256` | Manifiesto original |
| E6 | `evidencias/E6-mongodb/system-profile.json` | Hash original verificado |
| E6 | `evidencias/E6-mongodb/bitacora-mongod.log` | Hash original verificado |
| E6 | `evidencias/E6-mongodb/hashes.sha256` | Manifiesto de MongoDB |
| E6 | `evidencias/E6-mongodb/09-comparacion.md` | Comparación de mecanismos |

### 10.3 Copias redactadas

Se prepararon versiones independientes en:

`evidencias/versiones-redactadas/publicacion/`

Estas incluyen:

- `E5-bitacora-postgresql.log`.
- `bitacora-mongod.log`.
- `system-profile.json`.
- `hashes-publicacion.sha256`.

La verificación de los tres hashes devolvió `True`.

Los originales y las versiones redactadas no deben confundirse, porque tienen contenidos y huellas criptográficas diferentes.

### 10.4 Scripts y políticas

Scripts SQL:

- `sql/01-verificaciones-calidad.sql`.
- `sql/02-comentarios-diccionario.sql`.
- `sql/03-inventario-tablas.sql`.
- `sql/04-registro-cambios.sql`.

Políticas:

- `politicas/POL-01-acceso.md`.
- `politicas/POL-02-respaldo.md`.
- `politicas/POL-03-retencion.md`.
- `politicas/POL-04-restauracion.md`.
- `politicas/POL-05-datos-sensibles.md`.
- `politicas/POL-06-cambios-produccion.md`.

---

## Conclusión general

-El desarrollo del Laboratorio 03 permitió integrar los mecanismos técnicos construidos en PostgreSQL y MongoDB con elementos de gobierno práctico de datos
-Se documentaron responsabilidades, calidad de información, estructura de los datos, criterios de conservación, políticas y un registro de cambios
-La interpretación de los eventos de auditoría demostró que es posible identificar operaciones sobre la tabla `clientes` y relacionarlas con cuentas, aplicaciones y momentos específicos

