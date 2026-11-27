## 1. Objetivo

Proponer criterios de conservación para las bitácoras y registros de auditoría utilizados en PostgreSQL y MongoDB, considerando su finalidad, sensibilidad, riesgo de pérdida, integridad y acceso autorizado.

El propósito es establecer cuánto tiempo deben conservarse las evidencias, dónde deben almacenarse y qué procedimiento debe seguirse cuando termine su periodo de conservación.

## 2. Antecedentes

Durante el Laboratorio 01 se configuraron las bitácoras de PostgreSQL y se implementó la tabla `auditoria.cambios_clientes`.

Se comprobó que la bitácora permite registrar accesos, sentencias de modificación y cambios administrativos. También se identificó que determinados comandos pueden incluir contraseñas o datos personales.

Durante el Laboratorio 02 se utilizaron el perfilador `system.profile`, la bitácora de `mongod` y las instantáneas de privilegios.

Se observó que el perfilador utiliza almacenamiento limitado, mientras que el historial disponible mediante `getLog` se reinicia con el servidor.

Antes de reiniciar MongoDB se exportaron archivos de evidencia y se calcularon sus hashes SHA-256.

Estos antecedentes demuestran la necesidad de definir criterios de conservación que eviten perder información relevante para una investigación.

## 3. Tabla de criterios de conservación

Los siguientes periodos son propuestas académicas de conservación, no plazos legales obligatorios. Su aplicación requiere aprobación de Auditoría Interna, Seguridad de la Información y, cuando corresponda, del área jurídica.

| Registro | Ubicación actual | Riesgo de pérdida observado | Sensibilidad | Periodo propuesto | Justificación | Dónde se conserva | Quién puede leerlo | Acción al vencer |
|---|---|---|---|---|---|---|---|---|
| Accesos de PostgreSQL | Archivo del colector, identificado mediante `pg_current_logfile()` | Rotación, eliminación de archivos, reinstalación o recreación del servidor | Alta: contiene usuarios, direcciones y eventos de acceso | 90 días | Permite investigar intentos de acceso y fallos de autenticación recientes | Repositorio centralizado de bitácoras con acceso restringido | DBA, Seguridad de la Información y Auditoría Interna autorizados | Verificar si existe una investigación pendiente; después eliminar de forma controlada |
| Cambios de privilegios y estructura | Archivo del colector de PostgreSQL | Rotación, pérdida del archivo o configuración de registro insuficiente | Alta: contiene operaciones administrativas y posibles secretos | 365 días | Los cambios administrativos pueden afectar la seguridad durante periodos prolongados | Almacenamiento centralizado, protegido contra alteraciones y con verificación de integridad | Auditoría Interna y Seguridad; DBA con acceso técnico autorizado | Revisar obligaciones pendientes y autorización de eliminación |
| Modificaciones de datos (`log_statement = 'mod'`) | Archivo del colector de PostgreSQL | Rotación y pérdida de registros; exposición de información sensible en sentencias | Alta: puede contener datos personales o contraseñas | 180 días | Permite investigar modificaciones recientes y relacionarlas con solicitudes autorizadas | Repositorio de evidencias con permisos restringidos | Auditoría Interna, Seguridad y DBA autorizado | Depurar conforme a la política de retención, preservando únicamente evidencias sujetas a investigación |
| `auditoria.cambios_clientes` | Tabla de PostgreSQL en la base `comercial` | Eliminación de registros, modificación no autorizada, corrupción o pérdida del servidor | Confidencial: contiene datos personales y valores anteriores y posteriores | 365 días | Permite investigar modificaciones y verificar el historial de cambios de clientes | Tabla protegida y copias de evidencia con controles de integridad | Auditoría Interna y personal expresamente autorizado | Evaluar minimización, anonimización o eliminación controlada según la finalidad y las obligaciones aplicables |
| Bitácora de `mongod` | Salida del contenedor Docker y mensajes de `getLog`; en otros despliegues, `systemLog.path` | Historial temporal de `getLog` perdido tras reinicio; rotación o pérdida de registros del contenedor | Alta: contiene usuarios, direcciones y eventos de autenticación | 180 días | Permite investigar accesos, autenticaciones fallidas y cambios de configuración | Exportaciones periódicas a un repositorio de evidencias protegido | Seguridad de la Información, Auditoría Interna y DBA autorizado | Verificar investigaciones pendientes y eliminar la copia conforme al procedimiento aprobado |
| `system.profile` | Colección limitada de MongoDB, con tamaño predeterminado aproximado de 1 MB | Los registros antiguos son reemplazados cuando se alcanza su capacidad | Alta: puede incluir filtros, identificadores y valores personales | 90 días para exportaciones seleccionadas | Su contenido puede apoyar investigaciones operativas, pero no está diseñado como auditoría permanente | Exportaciones JSON protegidas, con integridad verificable | DBA autorizado y Auditoría Interna cuando corresponda | Eliminar exportaciones vencidas, salvo las sujetas a una investigación o conservación autorizada |
| Instantáneas de privilegios de MongoDB | Colección `auditoria.instantaneas_privilegios` | Modificación o eliminación no autorizada; cambios temporales no detectados entre instantáneas | Alta: documenta capacidades administrativas y cuentas existentes | 365 días | Permite detectar diferencias de privilegios entre periodos | Colección restringida y exportaciones protegidas fuera del servidor | Seguridad de la Información y Auditoría Interna; DBA con acceso controlado | Evaluar la conservación necesaria y eliminar mediante procedimiento autorizado |

## 4. Justificación de los periodos propuestos

### 4.1 Accesos de PostgreSQL — 90 días

Se propone conservar los registros de acceso durante 90 días porque permiten identificar intentos fallidos, accesos sospechosos y conexiones relevantes para investigaciones recientes.

Estos eventos deben revisarse periódicamente y almacenarse fuera del archivo activo del servidor, para evitar que la rotación elimine evidencia todavía necesaria.

### 4.2 Cambios de privilegios y estructura — 365 días

Se propone un periodo de 365 días debido a su importancia para la seguridad.

Una modificación de permisos o estructura puede permanecer activa durante varios meses antes de descubrirse.

Durante el Laboratorio 01 se comprobó que PostgreSQL podía registrar sentencias administrativas como `GRANT`, `REVOKE` y `ALTER TABLE`.

Conservarlas durante un periodo mayor facilita las revisiones y permite investigar modificaciones históricas.

### 4.3 Modificaciones de datos — 180 días

Las sentencias de modificación permiten investigar quién ejecutó operaciones relevantes en la base de datos.

Se propone conservarlas durante 180 días, considerando su utilidad para auditorías periódicas.

Sin embargo, la bitácora puede contener información personal y secretos escritos directamente en sentencias SQL. Por ello se requieren controles estrictos de acceso y una evaluación de su sensibilidad antes de exportarla.

### 4.4 Auditoría de clientes — 365 días

La tabla `auditoria.cambios_clientes` permite conservar información sobre modificaciones realizadas en los registros de clientes.

Se propone un periodo inicial de 365 días, sujeto a revisión jurídica y de privacidad.

Este periodo debe ser coherente con la finalidad de auditoría y con los derechos aplicables a los titulares de los datos.

No se recomienda conservar indefinidamente los valores anteriores y posteriores si ya no existe una finalidad legítima para hacerlo.

### 4.5 Bitácora de MongoDB — 180 días

En el Laboratorio 02 se comprobó que `getLog` mantiene un historial temporal que se reinicia cuando lo hace el servidor.

Por lo tanto, se propone conservar exportaciones del registro durante 180 días, fuera del almacenamiento temporal del contenedor.

La exportación realizada antes del reinicio demuestra la importancia de generar copias oportunamente.

### 4.6 Perfilador de MongoDB — 90 días

Se propone conservar durante 90 días las exportaciones del perfilador que sean necesarias para diagnósticos o investigaciones justificadas.

La colección `system.profile` tiene una capacidad limitada, por lo que los documentos antiguos pueden sobrescribirse automáticamente.

Durante una investigación, las exportaciones deben realizarse con suficiente frecuencia para evitar perder eventos. No puede garantizarse la conservación completa utilizando únicamente la colección circular.

### 4.7 Instantáneas de privilegios — 365 días

Las instantáneas permiten detectar diferencias entre los roles de los usuarios.

Durante el Laboratorio 02 se identificó que `app_ventas` recibió temporalmente el rol `dbAdmin`.

Aunque las instantáneas no permiten determinar por sí solas quién realizó el cambio, pueden apoyar revisiones periódicas.

Se propone conservarlas durante 365 días y protegerlas contra modificaciones o eliminaciones no autorizadas.

## 5. Control de integridad y acceso

Se propone aplicar los siguientes controles:

1. Exportar las evidencias antes de que sean eliminadas por rotación o sobrescritura.
2. Generar un hash SHA-256 de cada archivo exportado.
3. Conservar un manifiesto de hashes en una ubicación protegida.
4. Restringir el acceso a las evidencias conforme a las funciones autorizadas.
5. Registrar quién genera, consulta, transfiere o elimina cada evidencia.
6. Mantener copias protegidas fuera del servidor principal.
7. Verificar periódicamente que los archivos conservados coincidan con los hashes registrados.

El Laboratorio 02 proporcionó evidencia práctica de este control mediante los archivos `system-profile.json`, `bitacora-mongod.log` y `hashes.sha256`.

Un hash permite detectar alteraciones respecto a un valor previamente conservado, pero por sí solo no demuestra quién generó el archivo ni impide que una persona sustituya tanto el archivo como su hash.

Por ello, el manifiesto también debe protegerse.

## 6. Conflicto entre auditoría y retención de datos personales

Existe un conflicto importante entre conservar evidencia de auditoría y eliminar los datos personales cuando termina su finalidad de tratamiento.

Por ejemplo, si un cliente solicita la eliminación de sus datos, la organización debe evaluar qué información puede eliminar y qué registros deben conservarse por motivos legalmente aplicables.

La tabla `auditoria.cambios_clientes` podría contener valores anteriores de RFC, correos electrónicos u otros datos personales.

Por esta razón, no sería adecuado conservar indefinidamente todos los cambios únicamente por tratarse de una tabla de auditoría.

Se propone que Gerencia Comercial, Auditoría Interna y el área jurídica determinen qué información requiere conservación, durante cuánto tiempo y bajo qué controles.

Cuando sea procedente, podrían utilizarse mecanismos de minimización, anonimización o eliminación controlada, evitando destruir evidencias necesarias para una investigación o una obligación vigente.

Los periodos legales aplicables deben confirmarse con el área jurídica antes de aprobar la política.

## 7. Preguntas de reflexión

### 1. ¿Por qué la bitácora de cambios de privilegios merece más tiempo de conservación que la de consultas rutinarias?

Porque los cambios de privilegios pueden tener consecuencias de seguridad durante periodos prolongados.

Una consulta rutinaria puede formar parte de la operación normal de una aplicación, mientras que un cambio de privilegios puede conceder acceso a información confidencial o permitir operaciones administrativas.

Por ejemplo, durante el Laboratorio 02 se otorgó temporalmente el rol `dbAdmin` al usuario `app_ventas`, lo cual incrementó sus capacidades dentro de MongoDB.

Si una modificación semejante se realizara sin autorización y no se detectara inmediatamente, los registros históricos serían fundamentales para investigarla.

Por ello, se propone conservar los eventos administrativos durante 365 días, frente a periodos menores para los registros operativos rutinarios.

### 2. ¿Qué control de integridad aplicarás a las bitácoras exportadas?

Se utilizarán hashes criptográficos SHA-256 para verificar la integridad de los archivos exportados.

El procedimiento consiste en generar el hash cuando se crea la evidencia, registrar su valor en un manifiesto protegido y comparar posteriormente el hash almacenado con el calculado nuevamente.

Durante el Laboratorio 02 se aplicó este mecanismo a `bitacora-mongod.log` y `system-profile.json`.

Los hashes permitieron comprobar que las evidencias conservadas no habían cambiado respecto a los valores registrados.

Además, se propone almacenar las copias y sus manifiestos con permisos restringidos para evitar alteraciones.

### 3. ¿Qué diferencia hay entre conservar una bitácora y respaldar una base de datos?

Conservar una bitácora significa mantener registros que permitan investigar eventos, identificar operaciones y reconstruir determinadas acciones realizadas en el sistema.

Por otro lado, respaldar una base de datos significa conservar una copia de su información y estructura para poder recuperarla si ocurre una pérdida, corrupción o falla.

La bitácora responde principalmente qué ocurrió, mientras que el respaldo permite recuperar información y restablecer el servicio.

Ambos mecanismos son complementarios, pero no sustituyen sus funciones.

Una copia de seguridad puede recuperar una base de datos sin proporcionar suficiente evidencia de quién realizó una modificación. De manera similar, conservar una bitácora no garantiza que se puedan recuperar todos los registros perdidos.

El procedimiento técnico de respaldo y restauración se desarrollará en la Unidad V.

## 8. Conclusión

La Actividad 5 permitió establecer una propuesta de conservación para siete tipos de registros utilizados en PostgreSQL y MongoDB.

Se consideraron los riesgos observados durante los laboratorios anteriores, especialmente la rotación de bitácoras, el almacenamiento limitado de `system.profile` y la pérdida del historial temporal de `getLog` después de reiniciar MongoDB.

Se propusieron periodos diferenciados de conservación según la criticidad y la sensibilidad de cada tipo de evidencia.

También se identificó la importancia de utilizar hashes SHA-256, permisos restringidos y almacenamiento independiente para proteger las exportaciones.

Finalmente, se concluye que la conservación de evidencias debe equilibrar las necesidades de auditoría con la protección de datos personales y las obligaciones normativas aplicables.

Los periodos establecidos constituyen propuestas que deberán ser revisadas y autorizadas por las áreas responsables antes de implementarse como política institucional.
