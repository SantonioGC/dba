## 1. Objetivo

Establecer una matriz de gobierno de datos que identifique a los propietarios, custodios y usuarios autorizados de los principales conjuntos de información utilizados durante los laboratorios.

La finalidad es definir quién tiene autoridad para tomar decisiones sobre los datos, quién debe protegerlos técnicamente y quién puede utilizarlos para desarrollar funciones específicas.

## 2. Antecedentes

Durante la Unidad II se elaboró una matriz de gobierno para los datos de clientes, relacionando sus finalidades con las áreas autorizadas.

Se estableció que soporte requiere información de identificación y contacto, facturación necesita datos fiscales como el RFC y analítica utiliza preferentemente datos agregados que no permitan identificar directamente a los clientes.

En esta actividad se amplía esa matriz para incorporar los objetos de auditoría creados en PostgreSQL y los mecanismos de trazabilidad analizados en MongoDB Community.

La asignación de responsables que se presenta constituye una propuesta de gobierno para el escenario académico. Su aplicación en una organización real requeriría aprobación formal.

## 3. Diferencia entre propietario, custodio y usuario

Propietario del dato: área responsable de decidir la finalidad del dato, las personas que pueden acceder, las reglas de calidad y las correcciones permitidas.

Custodio del dato: responsable de administrar y proteger técnicamente la información conforme a las decisiones aprobadas. En nuestro escenario, esta función corresponde principalmente al DBA.

Usuario autorizado: persona, área o aplicación que utiliza información para desarrollar una función legítima y previamente autorizada.

La diferencia principal es que el propietario toma las decisiones de negocio, el custodio implementa los controles y el usuario trabaja dentro de los permisos concedidos.

## 4. Matriz de gobierno de datos

| Conjunto de datos | Propietario | Custodio | Usuarios autorizados | Quién aprueba accesos | Quién aprueba correcciones |
|---|---|---|---|---|---|
| `comercial.public.clientes` (PostgreSQL) | Gerencia Comercial | DBA de PostgreSQL | Ventas, facturación y soporte con acceso limitado según función; analítica mediante información agregada | Gerencia Comercial | Gerencia Comercial, previa verificación del dato |
| `auditoria.cambios_clientes` (PostgreSQL) | Auditoría Interna | DBA de PostgreSQL, con permisos administrativos restringidos | Auditoría Interna y personal de seguridad expresamente autorizado | Responsable de Auditoría Interna | No se permiten modificaciones ordinarias; cualquier corrección excepcional requiere autorización de Auditoría Interna |
| Bitácora de PostgreSQL | Auditoría Interna, en coordinación con Seguridad de la Información | DBA y responsable de infraestructura | Auditoría Interna y personal de seguridad autorizado; DBA para diagnóstico controlado | Auditoría Interna y Seguridad de la Información | No se deben alterar registros originales; las anotaciones o rectificaciones se documentan por separado |
| `comercial.clientes` (MongoDB) | Gerencia Comercial | DBA de MongoDB | Aplicación de ventas mediante `app_ventas`; otras áreas únicamente con acceso autorizado y limitado | Gerencia Comercial | Gerencia Comercial |
| `comercial.system.profile` (MongoDB) | Auditoría Interna, para fines de revisión de trazabilidad | DBA de MongoDB | DBA para diagnóstico y personal autorizado de Auditoría Interna | Auditoría Interna y Seguridad de la Información | No se deben modificar manualmente los registros del perfilador; cualquier incidencia debe documentarse |


## 5. Justificación de las asignaciones

### 5.1 Información de clientes en PostgreSQL

La Gerencia Comercial es propietaria de `public.clientes`, ya que los datos se utilizan para las operaciones comerciales de la empresa.

El DBA administra la tabla, sus permisos, restricciones y mecanismos de protección, pero no debe decidir unilateralmente el valor correcto del RFC, correo o teléfono de un cliente.

Las áreas operativas deben recibir únicamente la información necesaria para sus actividades.

Por ejemplo, soporte puede utilizar datos de contacto, mientras que facturación necesita información fiscal. El área de analítica puede trabajar con datos agregados sin consultar identificadores personales innecesarios.

### 5.2 Tabla de auditoría de PostgreSQL

La tabla `auditoria.cambios_clientes` registra información relacionada con modificaciones realizadas sobre los datos de clientes.

Se propone que Auditoría Interna sea responsable de su gobierno porque necesita utilizar esta evidencia para investigar operaciones y comprobar el cumplimiento de los controles.

El DBA mantiene la infraestructura y los mecanismos técnicos, pero no debería poder alterar libremente la evidencia de sus propias operaciones.

Por ello, se recomienda restringir la modificación o eliminación de registros de auditoría y conservar copias protegidas cuando corresponda.

### 5.3 Bitácora del servidor PostgreSQL

Las bitácoras contienen información útil para investigar autenticaciones, cambios de privilegios, modificaciones y errores del servidor.

Sin embargo, también pueden contener información confidencial.

Durante el Laboratorio 01 se identificó que determinadas sentencias registradas podían exponer secretos o información sensible.

Por esta razón, se propone que el acceso a las bitácoras esté restringido al personal responsable de auditoría, seguridad y administración técnica.

La finalidad de acceder a la bitácora debe estar relacionada con una necesidad de investigación, diagnóstico o supervisión autorizada.

### 5.4 Información de clientes en MongoDB

En MongoDB se utilizó la colección `comercial.clientes`, que contiene datos relacionados con clientes.

La Gerencia Comercial continúa siendo el propietario de esta información, independientemente del motor de base de datos empleado.

Durante el Laboratorio 02 se utilizó la cuenta `app_ventas`, con el rol `readWrite` sobre `comercial`.

Aunque esta cuenta puede realizar operaciones permitidas por su rol, las decisiones sobre acceso y corrección de datos deben corresponder al propietario.

Esto demuestra que tener un permiso técnico no equivale necesariamente a tener autorización de negocio para cualquier modificación.

### 5.5 Perfilador de MongoDB

`comercial.system.profile` contiene información sobre operaciones realizadas en MongoDB.

Durante el Laboratorio 02, el perfilador registró consultas, modificaciones y eliminaciones, así como información de contexto sobre el usuario, la aplicación y el cliente.

También se identificó que ciertos eventos administrativos, como el cambio temporal de privilegios, no proporcionaron evidencia directa en las búsquedas realizadas.

Por lo tanto, el perfilador debe utilizarse como una fuente técnica complementaria, no como un mecanismo completo de auditoría de seguridad.

El DBA puede administrarlo para fines de diagnóstico, mientras que Auditoría Interna debe establecer los criterios de revisión y conservación de las evidencias utilizadas en sus investigaciones.

## 6. Preguntas de reflexión

### 1. ¿Por qué el propietario de `auditoria.cambios_clientes` no debería ser el mismo que opera `clientes`?

Porque existiría un conflicto de intereses.

Si la misma área que modifica los datos también tiene autoridad para controlar o alterar las evidencias de esas modificaciones, podría ocultar errores o cambios no autorizados.

La separación de funciones busca evitar que una sola persona o área tenga control completo sobre la operación y su supervisión.

Por ejemplo, Gerencia Comercial puede autorizar una modificación del RFC, mientras que Auditoría Interna debe poder comprobar posteriormente que la operación se realizó de acuerdo con las reglas establecidas.

Por eso se propone que Auditoría Interna sea responsable de los registros de auditoría y que el DBA actúe como custodio técnico con controles que limiten la manipulación de las evidencias.

### 2. ¿Quién debería poder leer las bitácoras y la vista `dba.bitacora`? Relaciónalo con lo observado en el LAB-01 (secretos en la bitácora).

La lectura debería estar restringida al personal de Auditoría Interna, Seguridad de la Información y administradores de bases de datos expresamente autorizados.

Durante el Laboratorio 01 se comprobó que las sentencias SQL registradas pueden contener información sensible e incluso secretos utilizados durante determinadas operaciones.

Por ejemplo, si una sentencia contiene una contraseña escrita directamente, registrar su texto podría exponerla a cualquier usuario con acceso a la bitácora.

Por esta razón, no sería adecuado permitir que todos los usuarios de la base de datos consulten directamente las bitácoras o la vista `dba.bitacora`.

Se recomienda aplicar el principio de mínimo privilegio, limitar los accesos, revisar los datos sensibles registrados y proporcionar versiones filtradas de las evidencias cuando sea necesario compartirlas.

El acceso técnico del DBA a la infraestructura también debe estar sujeto a controles y supervisión, porque la administración del servidor no equivale a autorización ilimitada para consultar información confidencial.

### 3. ¿Qué ocurre con la responsabilidad sobre un dato cuando nadie la tiene asignada? Relaciónalo con el problema inicial de la unidad.

Cuando ningún área tiene asignada formalmente la responsabilidad sobre un dato, pueden surgir problemas de calidad, seguridad, conservación y cumplimiento.

Por ejemplo, si se detecta que el RFC de un cliente es incorrecto, pero no existe un propietario definido, nadie tiene claramente la autoridad para verificarlo y aprobar su corrección.

De la misma manera, cuando no existe un responsable de las bitácoras, pueden quedar sin revisar, conservarse durante un periodo insuficiente o eliminarse antes de una investigación.

El problema inicial de la unidad consistía precisamente en demostrar qué ocurrió en una base de datos y quién era responsable de cada acción y decisión.

Sin una asignación clara de responsabilidades, es posible disponer de registros técnicos y aun así carecer de un procedimiento para resolver los incidentes identificados.

Por ello, el gobierno de datos complementa la auditoría técnica mediante responsables definidos y reglas documentadas.

## 7. Conclusión

La Actividad 2 permitió ampliar la matriz de gobierno desarrollada en la Unidad II e incorporar los mecanismos de auditoría y trazabilidad utilizados durante la Unidad III.

Se estableció que Gerencia Comercial debe mantener la responsabilidad sobre los datos de clientes, mientras que el DBA actúa como custodio técnico encargado de administrar y proteger los sistemas.

También se propuso separar el gobierno de las evidencias de auditoría de las funciones operativas que modifican la información.

Esta separación reduce conflictos de intereses y permite establecer controles independientes para revisar operaciones.

Finalmente, se concluye que un gobierno de datos efectivo requiere definir propietarios, custodios, usuarios autorizados y responsables de aprobar accesos y correcciones.

Estas asignaciones son indispensables para que las evidencias técnicas puedan utilizarse de manera confiable durante una auditoría interna.
