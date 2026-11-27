## 1. Objetivo

Proteger los datos personales y la información confidencial almacenada en PostgreSQL y MongoDB, evitando accesos innecesarios, divulgaciones no autorizadas y usos incompatibles con las finalidades aprobadas.

La política establece quién puede consultar esta información, bajo qué justificación y qué evidencias deben existir para comprobar su utilización autorizada.

## 2. Alcance

Aplica a todas las personas, cuentas de servicio y aplicaciones que accedan a información confidencial de Comercializadora Norte S.A. de C.V.

Incluye especialmente:

- Tabla `public.clientes` de PostgreSQL.
- Colección `comercial.clientes` de MongoDB.
- Tabla `auditoria.cambios_clientes`.
- Colección `comercial.system.profile`.
- Bitácoras de PostgreSQL y MongoDB.
- Exportaciones de evidencias, respaldos y archivos que contengan información personal.

De acuerdo con el diccionario de datos elaborado durante la Actividad 3, los campos de clientes que requieren protección incluyen nombre, correo, teléfono, RFC, edad y datos de ubicación.

En esta política se utiliza la expresión "datos sensibles" en el sentido operativo del laboratorio, referido a información personal y confidencial que requiere protección. La clasificación jurídica de datos personales sensibles deberá evaluarse por separado cuando corresponda.

## 3. Regla verificable

Todo acceso a información confidencial deberá tener una finalidad de negocio documentada, autorización del propietario del dato y permisos limitados a lo estrictamente necesario; los accesos excepcionales y las modificaciones deberán generar evidencia que permita identificar al usuario, el motivo y la operación realizada.

El propietario y Seguridad de la Información revisarán trimestralmente las autorizaciones y verificarán que la información no se utilice para finalidades distintas de las aprobadas.

Los accesos técnicos que no puedan atribuirse mediante los mecanismos disponibles deberán registrarse como limitaciones de auditoría.

## 4. Clasificación y finalidades

| Dato o conjunto | Clasificación operativa | Finalidad autorizada |
|---|---|---|
| Nombre | Personal, confidencial | Identificación y atención del cliente |
| Correo electrónico | Personal, confidencial | Contacto y notificaciones |
| Teléfono | Personal, confidencial | Atención y comunicación |
| RFC | Personal, confidencial | Facturación y procesos autorizados |
| Edad | Personal, confidencial | Análisis agregado y actividades autorizadas |
| Ciudad y código postal | Datos de ubicación | Atención y análisis geográfico |
| Historial de modificaciones | Confidencial | Auditoría e investigación |
| Perfilado y bitácoras | Confidencial cuando contienen identificadores o valores personales | Diagnóstico y trazabilidad |

La información solo deberá utilizarse conforme a su finalidad aprobada.

Por ejemplo, el RFC puede ser necesario para facturación, pero no debería mostrarse completo a una cuenta de soporte que únicamente necesita confirmar la identidad del cliente mediante información parcialmente enmascarada.

## 5. Responsables

| Responsable | Función |
|---|---|
| Gerencia Comercial | Aprobar las finalidades y accesos a los datos personales de clientes |
| Auditoría Interna | Autorizar y supervisar el uso de información confidencial para investigaciones |
| Seguridad de la Información | Establecer controles de acceso y revisar posibles usos indebidos |
| DBA | Implementar permisos, mecanismos de protección y controles de registro autorizados |
| Personal comercial y soporte | Utilizar solamente la información necesaria para sus funciones |
| Responsable de privacidad o área jurídica | Evaluar obligaciones relacionadas con la protección de datos personales |

El DBA no podrá otorgar acceso indiscriminado a datos personales por el solo hecho de tener privilegios administrativos.

## 6. Medidas de protección

### 6.1 Mínimo privilegio

Las cuentas de aplicación deberán disponer únicamente de los permisos necesarios para ejecutar sus funciones.

Las tareas administrativas deben realizarse mediante cuentas diferenciadas y autorizadas.

### 6.2 Enmascaramiento y vistas

Cuando un usuario no necesite conocer el valor completo de un dato, deberá utilizarse una representación limitada.

Durante la Unidad II se implementaron mecanismos de enmascaramiento de datos y se verificó que una cuenta de soporte pudiera acceder a una vista autorizada sin obtener acceso directo a toda la tabla de clientes.

### 6.3 Protección de exportaciones

Las exportaciones que contengan datos personales o información de auditoría deberán conservarse con permisos restringidos.

No podrán publicarse en repositorios públicos ni enviarse a destinatarios no autorizados.

Cuando sea posible, se usarán datos ficticios o anonimizados para pruebas y demostraciones.

### 6.4 Ambientes no productivos

Los ambientes de desarrollo y pruebas no deberán utilizar copias completas de datos reales de clientes sin controles apropiados y autorización expresa.

Se preferirán datos sintéticos, anonimizados o debidamente minimizados.

### 6.5 Trazabilidad

Las modificaciones relevantes deberán registrarse mediante los mecanismos de auditoría disponibles.

Cuando sea necesario supervisar consultas o lecturas de información sensible, deberán configurarse controles específicos. El valor `log_statement = 'mod'` de PostgreSQL no garantiza un registro completo de las consultas `SELECT`.

Del mismo modo, el perfilador de MongoDB no debe considerarse una solución permanente y exhaustiva de auditoría de acceso.

## 7. Excepciones

Podrán autorizarse accesos extraordinarios por motivos como:

- Investigación de un incidente.
- Atención de un problema técnico crítico.
- Cumplimiento de una obligación legal.
- Operación excepcional aprobada por el propietario.

Cada excepción deberá registrar:

- Usuario autorizado.
- Justificación.
- Conjunto de datos afectado.
- Alcance del acceso.
- Fecha de inicio y término.
- Responsable que autoriza.
- Evidencia generada.

Al terminar la excepción, los permisos temporales deberán revocarse y comprobarse su eliminación.

Las excepciones no permitirán publicar datos personales ni eliminar registros de auditoría.

## 8. Evidencia de cumplimiento

### 8.1 PostgreSQL — Unidad II y Laboratorio 01

Durante la Unidad II se implementaron controles de acceso y enmascaramiento de datos personales.

En el Laboratorio 01 se utilizó la tabla `auditoria.cambios_clientes`, que permite conservar información sobre modificaciones de clientes.

También se verificó la configuración `log_statement = 'mod'`, que registra determinadas sentencias de modificación y administración.

Estas evidencias demuestran la existencia de controles parciales de protección y trazabilidad.

Sin embargo, no prueban que todas las lecturas de información personal sean registradas.

### 8.2 MongoDB — Laboratorio 02

Se utilizó el usuario `app_ventas` y se revisaron sus privilegios mediante instantáneas almacenadas en:

`auditoria.instantaneas_privilegios`

También se utilizaron los registros del perfilador `system.profile` para analizar operaciones.

Durante el laboratorio se otorgó temporalmente `dbAdmin` y posteriormente se revocó ese rol.

La comparación de las instantáneas permitió identificar el cambio de permisos.

### 8.3 Diccionario de datos — Laboratorio 03

En la Actividad 3 se documentaron las columnas de `public.clientes` mediante instrucciones `COMMENT`.

La información quedó exportada en:

`evidencias/diccionario-clientes.csv`

Este archivo permite identificar qué columnas contienen información personal y cuáles son sus finalidades declaradas.

### 8.4 Evidencia pendiente

Todavía no se ha generado un registro centralizado que relacione cada lectura de información confidencial con una autorización de negocio.

Tampoco se ha demostrado una auditoría exhaustiva de todos los accesos de lectura en ambos motores.

Por ello, dichos aspectos deberán registrarse como controles pendientes y no como mecanismos completamente implementados.

## 9. Relación con otras políticas

La POL-05 se complementa con la POL-01, que establece quién autoriza y administra los accesos.

La POL-03 determina cuánto tiempo se conserva la información y las evidencias necesarias para investigar posibles usos indebidos.

Las políticas POL-02 y POL-04 establecen controles sobre respaldos y restauraciones que pueden contener información personal.

La POL-06 requiere que los cambios realizados en producción no expongan datos personales ni permitan accesos no autorizados.

## 10. Revisión

La política se revisará cada seis meses y cuando ocurra alguno de los siguientes eventos:

- Incidente relacionado con datos personales.
- Cambio en los tratamientos o finalidades autorizadas.
- Incorporación de nuevas bases o aplicaciones.
- Detección de privilegios excesivos.
- Hallazgos de auditoría.
- Cambios normativos relevantes.

La revisión corresponderá a Seguridad de la Información y Gerencia Comercial, con participación de Auditoría Interna y del área jurídica cuando sea necesario.

## 11. Criterio de cumplimiento

La política se considerará cumplida cuando los accesos revisados cuenten con una finalidad documentada, permisos apropiados y autorización verificable.

Las modificaciones relevantes y los accesos excepcionales deberán relacionarse con sus correspondientes registros de autorización.

Si no existe evidencia suficiente para atribuir una operación a una persona o cuenta, deberá documentarse esa limitación.

## 12. Conclusión

La POL-05 establece criterios para utilizar los datos personales de clientes de manera controlada y justificada.

Los laboratorios anteriores demostraron la utilidad del enmascaramiento, la separación de privilegios, el diccionario de datos y los mecanismos de trazabilidad.

También permitieron identificar limitaciones, como la ausencia de un registro completo de todas las lecturas de información sensible.

Por esta razón, la política propone controles de acceso, autorización, minimización y revisión periódica que deberán verificarse mediante evidencias concretas.

Su aplicación contribuiría a reducir la exposición de datos y a fortalecer la responsabilidad de las áreas que utilizan la información.

## 13. Documentos relacionados

- `POL-01-acceso.md`.
- `POL-02-respaldo.md`.
- `POL-03-retencion.md`.
- `POL-04-restauracion.md`.
- `evidencias/03-diccionario.md`.
- `evidencias/04-catalogo.md`.
