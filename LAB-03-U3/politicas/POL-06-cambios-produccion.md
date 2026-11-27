## 1. Objetivo

Reducir los riesgos de interrupciones, pérdida de datos, modificaciones no autorizadas y errores operativos derivados de cambios realizados en bases de datos de producción.

La política establece las condiciones que deben cumplirse antes, durante y después de una modificación, permitiendo relacionar los cambios ejecutados con solicitudes previamente autorizadas.

## 2. Alcance

Aplica a los cambios realizados sobre los sistemas de PostgreSQL y MongoDB de Comercializadora Norte S.A. de C.V.

Incluye:

- Creación, modificación o eliminación de tablas y colecciones.
- Cambios en usuarios, roles y privilegios.
- Modificaciones de estructuras y restricciones.
- Actualizaciones de configuración del servidor.
- Cambios relevantes en mecanismos de auditoría.
- Modificaciones masivas de datos.
- Operaciones administrativas que puedan afectar la disponibilidad, integridad o confidencialidad.

Comprende los ambientes de desarrollo, pruebas y producción, con especial atención a las operaciones que afecten a los usuarios reales.

## 3. Definición de ambientes

De acuerdo con la Unidad I de la materia, un ambiente es un conjunto independiente de infraestructura, configuración y datos destinado a un propósito específico dentro del ciclo de vida del software.

Se distinguen tres ambientes:

| Ambiente | Propósito | Responsabilidad principal |
|---|---|---|
| Desarrollo | Construir y probar cambios nuevos | Equipo de desarrollo |
| Pruebas | Validar el funcionamiento de los cambios antes de liberarlos | Personal de validación y responsables técnicos |
| Producción | Atender las operaciones y usuarios reales | DBA o proceso de despliegue formalmente autorizado |

La separación de ambientes comprende infraestructura, configuraciones, credenciales, permisos y datos.

Las pruebas deberán realizarse en un entorno que no ponga en riesgo las operaciones reales.

En el presente laboratorio, el ambiente local sirve para simular decisiones y controles de producción. Las pruebas académicas no representan por sí mismas cambios en una empresa real.

## 4. Regla verificable

Todo cambio en producción deberá contar con un folio, una descripción, pruebas previas, aprobación del responsable correspondiente y una ventana de ejecución autorizada; el DBA registrará su ejecución y verificará el resultado, y Auditoría Interna conciliará mensualmente los eventos de bitácora con las solicitudes aprobadas.

Cualquier cambio detectado sin autorización o fuera de su ventana será documentado como hallazgo.

Los cambios urgentes deberán contar con una justificación y una autorización extraordinaria verificable.

## 5. Actividades obligatorias antes, durante y después del cambio

### 5.1 Antes del cambio

El solicitante deberá registrar:

1. Identificador o folio de la solicitud.
2. Descripción del cambio.
3. Motivo de negocio o necesidad técnica.
4. Sistema y ambiente afectados.
5. Responsable solicitante.
6. Evaluación de impacto y riesgos.
7. Resultado de las pruebas previas.
8. Plan de reversión o recuperación aplicable.
9. Persona o comité que aprueba.
10. Ventana autorizada de ejecución.

Si existe riesgo significativo de pérdida de datos, deberá verificarse previamente la disponibilidad de un respaldo recuperable, conforme a la POL-02.

Un cambio sin aprobación no deberá ejecutarse como cambio ordinario de producción.

### 5.2 Durante el cambio

El DBA o responsable técnico autorizado deberá:

- Confirmar que el cambio corresponde a la solicitud aprobada.
- Verificar que se encuentra dentro de la ventana autorizada.
- Ejecutar únicamente las operaciones previstas.
- Conservar la evidencia disponible en las bitácoras.
- Registrar los errores y desviaciones.
- Detener la ejecución si aparece un riesgo no contemplado que requiera una nueva decisión.

La cuenta empleada deberá contar con los privilegios necesarios y no exceder los permisos autorizados.

### 5.3 Después del cambio

Deberán verificarse:

- Resultado técnico de la ejecución.
- Integridad y disponibilidad de los datos afectados.
- Funcionamiento de las operaciones principales.
- Permisos y controles de seguridad.
- Existencia de registros de auditoría.
- Correspondencia entre el cambio ejecutado y la autorización.
- Cierre de la solicitud y aceptación del responsable.

Si el cambio no produce el resultado esperado, deberá evaluarse la aplicación del plan de reversión autorizado.

Los resultados se documentarán incluso cuando el cambio falle.

## 6. Responsables

| Responsable | Función |
|---|---|
| Gerencia Comercial | Solicitar y justificar cambios relacionados con los datos de clientes |
| Comité de Cambios | Revisar el impacto y autorizar modificaciones relevantes de producción |
| DBA | Ejecutar los cambios autorizados y conservar evidencia técnica |
| Equipo de desarrollo | Preparar y probar las modificaciones antes de solicitar su aplicación |
| Seguridad de la Información | Revisar riesgos de seguridad, permisos y posibles excepciones |
| Auditoría Interna | Conciliar los cambios ejecutados con sus solicitudes y registrar hallazgos |
| Responsable de la aplicación | Verificar que el sistema funciona después del cambio |

El DBA no podrá aprobar unilateralmente una modificación que afecte decisiones de negocio únicamente porque tenga permisos para ejecutarla.

## 7. Excepciones

Podrán autorizarse cambios urgentes cuando exista un incidente que afecte significativamente la operación o la seguridad.

La excepción deberá documentar:

- Folio de incidente o cambio urgente.
- Justificación.
- Riesgo de no intervenir.
- Responsable que autoriza.
- Alcance autorizado.
- Hora de inicio y finalización.
- Resultado de la intervención.
- Revisión posterior.

Cuando no sea viable seguir el procedimiento ordinario, la autorización extraordinaria deberá quedar registrada y posteriormente revisarse por el Comité de Cambios.

La urgencia no elimina la obligación de conservar evidencia técnica ni de investigar desviaciones.

## 8. Evidencia de cumplimiento

### 8.1 Evidencia de PostgreSQL — Laboratorio 01

La configuración `log_statement = 'mod'` permite registrar determinadas sentencias de modificación de datos y objetos.

La vista `dba.bitacora` permite consultar el archivo de bitácora activo e identificar información sobre el usuario, fecha y sentencia ejecutada.

Estos registros pueden utilizarse para reconocer operaciones como `CREATE`, `ALTER`, `DROP`, `GRANT` y `REVOKE`, cuando estén presentes en el archivo consultado.

La existencia de una sentencia en la bitácora demuestra que fue registrada, pero no demuestra por sí misma que estuviera autorizada.

### 8.2 Evidencia de MongoDB — Laboratorio 02

Las instantáneas de privilegios permitieron detectar cambios en los roles asignados a `app_ventas`.

La comparación mostró que se había incorporado temporalmente `dbAdmin`.

Posteriormente se revocó ese rol.

Estas instantáneas permiten identificar diferencias entre estados de permisos, pero no constituyen por sí solas un registro de aprobación del cambio.

### 8.3 Evidencia de PostgreSQL — Laboratorio 03, Actividad 3

Durante la documentación de `public.clientes` se registraron once sentencias `COMMENT` en la bitácora.

Los registros incluyeron el usuario `postgres`, la aplicación `psql` y las marcas de tiempo.

Esta evidencia demuestra que se pueden identificar modificaciones documentales realizadas en el motor.

Sin embargo, los cambios de esa actividad no estuvieron vinculados a un folio formal de autorización de producción.

### 8.4 Evidencia prevista — Actividad 7

Durante la Actividad 7 se implementará la tabla:

`gobierno.solicitudes_cambio`

La estructura permitirá registrar:

- `folio`.
- `descripcion`.
- `solicitado_por`.
- `aprobado_por`.
- `ambiente`.
- `fecha_aprobacion`.
- `ventana_inicio`.
- `ventana_fin`.

Se utilizará la solicitud de ejemplo:

`CAM-2026-014`

Su finalidad será documentar un cambio para agregar la columna `canal_alta` a `public.clientes`.

Después se consultarán los eventos de la bitácora para verificar su correspondencia con las solicitudes autorizadas.

Estado: esta actividad todavía no se ha ejecutado. La creación de la tabla, el registro del cambio y su conciliación permanecen pendientes.

### 8.5 Evidencia de conciliación

La conciliación deberá identificar:

| Elemento | Comprobación |
|---|---|
| Cambio ejecutado | Existencia de una sentencia registrada |
| Solicitud | Folio que corresponde al cambio |
| Aprobación | Responsable y fecha de autorización |
| Ambiente | Coincidencia con el ambiente autorizado |
| Ventana | Ejecución dentro del periodo aprobado |
| Resultado | Verificación técnica y aceptación |
| Hallazgo | Diferencia, ausencia de autorización o falta de evidencia |

Cuando no exista una solicitud correspondiente, se registrará la discrepancia como hallazgo de auditoría.

La ausencia de evidencia de autorización no se interpretará automáticamente como prueba definitiva de una actuación maliciosa, pero sí requerirá investigación.

## 9. Relación con otras políticas

La POL-06 está relacionada con:

POL-01: los cambios deberán ejecutarse con permisos adecuados y autorizados.
POL-02: antes de cambios riesgosos deberá comprobarse la disponibilidad de medidas de recuperación.
POL-03: las bitácoras y autorizaciones deberán conservarse el tiempo necesario para su revisión.
POL-04: los cambios fallidos deberán contar con condiciones apropiadas de recuperación.
POL-05: los cambios no deberán exponer información confidencial ni facilitar accesos indebidos.

El registro de cambios también deberá conservarse durante un periodo suficiente para permitir la conciliación mensual y las investigaciones posteriores.

## 10. Revisión

La política se revisará cada seis meses y después de:

- Un cambio fallido con impacto significativo.
- Una modificación no autorizada.
- Un incidente de seguridad.
- Un cambio importante en la infraestructura.
- Una auditoría con hallazgos relevantes.
- Una modificación del proceso de aprobación.

Auditoría Interna y Seguridad de la Información coordinarán la revisión, con la participación del DBA y del Comité de Cambios.

## 11. Criterio de cumplimiento

Se considerará que la política se cumple cuando los cambios de producción revisados cuenten con una solicitud aprobada, registro técnico de ejecución, comprobación de la ventana autorizada y evidencia del resultado.

Los eventos administrativos identificados en las bitácoras deberán poder relacionarse con solicitudes de cambio.

Las diferencias deberán investigarse y documentarse.

No bastará con demostrar que un cambio se ejecutó correctamente; será necesario comprobar que estaba autorizado.

## 12. Conclusión

La POL-06 establece controles para administrar modificaciones de producción mediante solicitudes, autorizaciones, ventanas de ejecución y verificaciones posteriores.

Los laboratorios anteriores demostraron que las bitácoras permiten observar cambios, pero que dichos registros no explican por sí mismos si las operaciones estaban permitidas.

La incorporación del registro `gobierno.solicitudes_cambio` permitirá relacionar los eventos ejecutados con las autorizaciones correspondientes.

Esta política también retoma la separación de ambientes estudiada en la Unidad I, evitando que las modificaciones experimentales se apliquen directamente a sistemas que atienden usuarios reales.

La conciliación periódica entre bitácoras y solicitudes será fundamental para demostrar el cumplimiento y detectar cambios que requieran investigación.

## 13. Documentos relacionados

- `POL-01-acceso.md`.
- `POL-02-respaldo.md`.
- `POL-03-retencion.md`.
- `POL-04-restauracion.md`.
- `POL-05-datos-sensibles.md`.
- `evidencias/05-conservacion.md`.
- `evidencias/06-conciliacion.md`.
- `sql/04-registro-cambios.sql`.
