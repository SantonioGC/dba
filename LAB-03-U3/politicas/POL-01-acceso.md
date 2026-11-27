## 1. Objetivo

Reducir el riesgo de accesos no autorizados, exposición de información confidencial y asignación excesiva de privilegios en las bases de datos de la organización.

La política establece las responsabilidades y condiciones para solicitar, aprobar, otorgar, modificar, revisar y revocar permisos de acceso.

## 2. Alcance

Aplica a las bases de datos PostgreSQL y MongoDB utilizadas por Comercializadora Norte S.A. de C.V., especialmente:

- `comercial.public.clientes`, en PostgreSQL.
- `comercial.auditoria.cambios_clientes`, en PostgreSQL.
- `comercial.clientes`, en MongoDB.
- `comercial.system.profile`, en MongoDB.
- Las bitácoras y los objetos utilizados para conservar evidencias de auditoría.

La política comprende los ambientes de desarrollo, pruebas y producción, así como las cuentas de usuarios, aplicaciones, administradores y servicios que accedan a estas bases de datos.

## 3. Regla

Todo acceso a datos o modificación de privilegios deberá contar con una solicitud documentada y aprobación del propietario de los datos antes de que el DBA otorgue los permisos, aplicando el principio de mínimo privilegio.

El DBA revisará mensualmente los cambios de permisos registrados y los conciliará con las solicitudes aprobadas; adicionalmente, los propietarios revisarán trimestralmente los accesos vigentes y solicitarán la revocación de aquellos que ya no sean necesarios.

Las cuentas administrativas deberán utilizarse únicamente para funciones autorizadas y no para las operaciones habituales de las aplicaciones.

## 4. Responsables

| Responsable | Función |
|---|---|
| Gerencia Comercial | Autorizar los accesos a los datos de clientes y verificar que correspondan a una finalidad legítima |
| Auditoría Interna | Autorizar o validar, junto con Seguridad de la Información, los accesos a evidencias de auditoría |
| DBA | Implementar y revocar permisos conforme a las autorizaciones; conservar evidencia técnica |
| Seguridad de la Información | Supervisar privilegios elevados, investigar accesos sospechosos y revisar excepciones |
| Usuarios y responsables de aplicaciones | Solicitar únicamente los permisos necesarios y utilizar la información para la finalidad autorizada |

El DBA actúa como custodio técnico de la información, pero no sustituye al propietario en las decisiones de autorización.

## 5. Excepciones

Solo podrán autorizarse accesos excepcionales cuando exista una necesidad operativa justificada, como la atención de un incidente crítico.

La excepción deberá contar con autorización documentada de Seguridad de la Información y del propietario correspondiente, definir un alcance específico y establecer una vigencia limitada.

En situaciones de emergencia que impidan obtener autorización previa, el acceso deberá documentarse inmediatamente y someterse a revisión posterior.

La excepción no autoriza la eliminación ni alteración de evidencias de auditoría.

## 6. Evidencia de cumplimiento

Para comprobar el cumplimiento de esta política se utilizarán los siguientes registros:

### 6.1 PostgreSQL — Laboratorio 01

En el Laboratorio 01 se configuró `log_statement = 'mod'` y se utilizaron las bitácoras del servidor para identificar operaciones administrativas.

La vista `dba.bitacora` permite consultar las sentencias registradas, incluyendo operaciones de modificación de privilegios como `GRANT` y `REVOKE`, cuando se encuentran disponibles en el archivo activo.

También se verificaron controles de acceso y restricciones para usuarios con permisos limitados.

Evidencia: bitácoras y archivos del Laboratorio 01 correspondientes a cambios de privilegios y pruebas de acceso.

### 6.2 MongoDB — Laboratorio 02

Durante el Laboratorio 02 se utilizó el usuario `app_ventas` con el rol `readWrite` sobre `comercial`.

Posteriormente se agregó temporalmente `dbAdmin` y se compararon dos instantáneas de privilegios almacenadas en:

`auditoria.instantaneas_privilegios`

Las instantáneas identificaron el cambio de permisos, aunque no permitieron atribuir por sí solas quién lo realizó.

Al finalizar, se revocó `dbAdmin` y se verificó que `app_ventas` conservara únicamente `readWrite`.

Evidencia: `evidencias/07-privilegios-control-compensatorio.md` del Laboratorio 02 y la colección de instantáneas.

### 6.3 Solicitudes de autorización

Para relacionar cada cambio de privilegios con su aprobación, las solicitudes deberán registrarse antes de la ejecución.

El registro de solicitudes se implementará en la Actividad 7 mediante la tabla:

`gobierno.solicitudes_cambio`

Estado: el registro todavía está pendiente de creación. Por tanto, no se afirma que las solicitudes de los laboratorios anteriores contaran con una aprobación formal almacenada en esa tabla.

### 6.4 Verificación periódica

La revisión mensual deberá producir un reporte que incluya los cambios de permisos identificados, sus solicitudes correspondientes, las diferencias detectadas y la persona responsable de revisarlas.

La revisión trimestral de accesos vigentes deberá conservar la aprobación del propietario y las solicitudes de revocación que correspondan.

Estos reportes constituyen controles propuestos; todavía no se han generado como parte de la práctica.

## 7. Revisión de la política

La política se revisará cada seis meses, o antes si ocurre alguno de los siguientes eventos:

- Un incidente de seguridad relacionado con accesos.
- Una modificación importante en los roles o responsabilidades.
- La incorporación de nuevos sistemas o bases de datos.
- Un cambio normativo que afecte la protección de información.
- La detección de privilegios excesivos durante una auditoría.

La revisión será coordinada por Seguridad de la Información y requerirá la participación de Gerencia Comercial, Auditoría Interna y el DBA.

## 8. Criterio de verificación

Se considerará que la política se cumple cuando los accesos y cambios de privilegios revisados cuenten con autorización verificable, correspondan a las funciones del usuario y no excedan los permisos aprobados.

Cuando un cambio aparezca en la bitácora o en una instantánea, pero no tenga una autorización correspondiente, se registrará como hallazgo para investigación.

La ausencia de evidencia suficiente deberá documentarse expresamente; no se interpretará automáticamente como demostración de cumplimiento.

## 9. Conclusión

La POL-01 establece una separación entre la autorización de accesos, que corresponde al propietario de los datos, y su implementación técnica, que corresponde al DBA.

La política también define revisiones periódicas para identificar privilegios excesivos, cuentas innecesarias y modificaciones no autorizadas.

Las experiencias de PostgreSQL y MongoDB demostraron que disponer de permisos técnicos no equivale a contar con autorización de negocio y que los cambios deben poder relacionarse con solicitudes aprobadas.

La aplicación de esta política contribuiría a mejorar el control de accesos y la trazabilidad de los permisos en la organización.
