## 1. Objetivo

Construir un catálogo mínimo de datos que permita identificar qué conjuntos de información existen en la organización, dónde se encuentran, quién es responsable de ellos, cuál es su clasificación y para qué se utilizan.

El catálogo integra los objetos de PostgreSQL utilizados durante los Laboratorios 01 y 03, así como las colecciones de MongoDB analizadas en el Laboratorio 02.

## 2. Inventario técnico de PostgreSQL

Primero se ejecutó `ANALYZE` para actualizar las estadísticas disponibles del servidor.

Posteriormente se consultaron los catálogos internos `pg_class` y `pg_namespace` para identificar las tablas ordinarias, sus propietarios técnicos, filas estimadas, tamaños y descripciones.

### Resultados observados

| Esquema | Tabla | Propietario técnico | Filas estimadas | Tamaño |
|---|---|---|---:|---|
| `auditoria` | `cambios_clientes` | `postgres` | 10 | 32 kB |
| `public` | `clientes` | `postgres` | 7 | 24 kB |

La tabla `public.clientes` contiene un comentario que identifica a Gerencia Comercial como propietario de los datos, al DBA como custodio y a la información como confidencial.

La tabla `auditoria.cambios_clientes` todavía no tiene un comentario general registrado.

Las filas mostradas representan estimaciones estadísticas, no conteos exactos.

La vista `dba.bitacora` tampoco apareció en el inventario porque la consulta se limitó a tablas ordinarias mediante `relkind = 'r'`.

## 3. Catálogo integrado de datos

El catálogo utiliza cinco identificadores, CAT-01 a CAT-05, para describir los conjuntos de información solicitados.

Las responsabilidades y periodos de conservación son propuestas del escenario académico y deberán formalizarse mediante las políticas de las actividades posteriores.

| ID | Conjunto de datos | Motor | Ubicación | Propietario | Custodio | Clasificación | Contiene datos personales | Finalidad | Conservación | Diccionario |
|---|---|---|---|---|---|---|---|---|---|---|
| CAT-01 | Clientes | PostgreSQL 16 | `127.0.0.1:5432 / comercial / public.clientes` | Gerencia Comercial | DBA PostgreSQL | Confidencial | Sí | Administración comercial, contacto, facturación y atención | Según POL-03, pendiente de aprobación | `diccionario-clientes.csv` |
| CAT-02 | Auditoría de clientes | PostgreSQL 16 | `127.0.0.1:5432 / comercial / auditoria.cambios_clientes` | Auditoría Interna | DBA PostgreSQL | Confidencial | Sí | Registrar y revisar modificaciones realizadas sobre clientes | Según criterio de conservación de evidencias de la Actividad 5 | Pendiente de diccionario específico |
| CAT-03 | Registro de cambios | PostgreSQL 16 | `127.0.0.1:5432 / comercial / gobierno.solicitudes_cambio` | Comité de Cambios | DBA PostgreSQL | Interno | Potencialmente, por sus datos de solicitantes y aprobadores | Registrar autorizaciones y ventanas de cambios | Según POL-03 y POL-06, pendientes de aprobación | Pendiente de creación en Actividad 7 |
| CAT-04 | Clientes (tienda) | MongoDB 7 | `127.0.0.1:27017 / comercial / clientes` | Gerencia Comercial | DBA MongoDB | Confidencial | Sí | Administración de clientes y operaciones de la aplicación de ventas | Según POL-03, pendiente de aprobación | Estructura conocida por LAB-02; diccionario formal pendiente |
| CAT-05 | Perfilado | MongoDB 7 | `127.0.0.1:27017 / comercial / system.profile` | Auditoría Interna, para la revisión de evidencias | DBA MongoDB | Confidencial | Sí, potencialmente en los filtros y comandos registrados | Diagnóstico y trazabilidad operativa | Colección limitada; exportación y conservación externa conforme a Actividad 5 | Estructura documentada en LAB-02 |

Estado de CAT-03: `gobierno.solicitudes_cambio` todavía no existe en el inventario obtenido. Se incorporó como conjunto planificado porque será creado durante la Actividad 7.

Los periodos definitivos de conservación se establecerán en la Actividad 5 y en la política POL-03. No se asignan plazos legales sin una validación normativa.

## 4. Descripción de los conjuntos de datos

### CAT-01 — Clientes de PostgreSQL

La tabla `public.clientes` almacena información utilizada en las operaciones de Comercializadora Norte.

Contiene datos personales como nombre, correo electrónico, teléfono, RFC, edad y ubicación.

Durante la Actividad 1 se identificaron problemas de calidad relacionados con correos duplicados, RFC incorrectos, correos inválidos y edades fuera de rango.

La Gerencia Comercial debe autorizar las correcciones, mientras que el DBA administra los controles técnicos y conserva la evidencia de las modificaciones.

El diccionario técnico se encuentra en `evidencias/diccionario-clientes.csv`.

### CAT-02 — Auditoría de clientes

La tabla `auditoria.cambios_clientes` fue implementada durante el Laboratorio 01.

Su finalidad es conservar información sobre las modificaciones realizadas en los registros de clientes.

Aunque se trata de información de auditoría, puede contener datos personales presentes en los valores anteriores y posteriores.

Por lo tanto, debe clasificarse como confidencial y mantenerse bajo controles de acceso y conservación independientes de las operaciones comerciales.

Se propone que Auditoría Interna sea responsable del gobierno de esta información.

### CAT-03 — Registro de solicitudes de cambio

Este conjunto se incorporará durante la Actividad 7, mediante la creación de la tabla `gobierno.solicitudes_cambio`.

Su finalidad será registrar los cambios autorizados, sus solicitantes, aprobadores y ventanas de ejecución.

Posteriormente permitirá comparar los cambios observados en la bitácora con las solicitudes aprobadas.

Hasta este momento, su incorporación constituye una planificación y no una implementación verificada.

### CAT-04 — Clientes de MongoDB

La colección `comercial.clientes` se utilizó en el Laboratorio 02 para ejecutar consultas, modificaciones y eliminaciones.

Contiene información personal de clientes, como nombre, RFC, teléfono y ciudad.

En el laboratorio se utilizó la cuenta `app_ventas` para ejecutar operaciones sobre esta colección.

La Gerencia Comercial debe conservar la responsabilidad sobre los datos, independientemente de que se utilice PostgreSQL o MongoDB.

Mantener un propietario común facilita la resolución de inconsistencias entre ambos motores.

### CAT-05 — Perfilador de MongoDB

La colección `comercial.system.profile` almacena información acerca de operaciones registradas por el perfilador.

Durante el Laboratorio 02 permitió identificar consultas, actualizaciones y eliminaciones, incluyendo información como usuario, aplicación, cliente y fecha.

Los registros pueden incluir condiciones de búsqueda o valores utilizados en las operaciones, por lo que deben tratarse como información potencialmente confidencial.

El perfilador tiene una capacidad de almacenamiento limitada y no equivale a un mecanismo completo de auditoría de seguridad.

Durante el laboratorio se exportó una copia a `system-profile.json` y se calculó su hash SHA-256 para proteger la integridad de la evidencia.

## 5. Otros activos relacionados

Aunque no aparecen como filas independientes dentro de los cinco conjuntos solicitados, se identificaron otros recursos relevantes:

Vista `dba.bitacora`: permite consultar los mensajes del archivo de bitácora activo de PostgreSQL. Durante la Actividad 3 permitió identificar once instrucciones `COMMENT`.

Bitácora de `mongod`: contiene información operativa del servidor MongoDB, incluidos eventos de autenticación y configuración.

Colección `auditoria.instantaneas_privilegios`: conserva instantáneas de los permisos de usuarios de MongoDB. Durante el Laboratorio 02 permitió identificar la incorporación temporal del rol `dbAdmin` a `app_ventas`.

Estos recursos también deben considerarse al establecer las políticas de acceso, clasificación y conservación.

## 6. Preguntas de reflexión

### 1. ¿Por qué CAT-02 y CAT-05 contienen datos personales aunque su propósito sea la auditoría?

Porque los mecanismos de auditoría y perfilado pueden registrar información procedente de las operaciones realizadas sobre datos personales.

En CAT-02, la tabla `auditoria.cambios_clientes` puede contener valores anteriores y posteriores de registros de clientes, incluyendo identificadores y datos sensibles para la operación comercial.

En CAT-05, `system.profile` puede contener filtros de consulta, condiciones de actualización y otros elementos utilizados durante las operaciones. Estos elementos pueden incluir RFC u otros datos personales.

Por lo tanto, el propósito de auditoría no elimina la sensibilidad de la información almacenada.

Ambos conjuntos deben contar con controles de acceso, clasificación y conservación adecuados para evitar que la evidencia se convierta en una nueva fuente de exposición de datos.

### 2. ¿Qué pasa si CAT-01 y CAT-04 tienen propietarios distintos y el RFC de un cliente difiere entre ambos motores?

Se produciría un conflicto de responsabilidad sobre la información.

Si PostgreSQL y MongoDB almacenan RFC diferentes para una misma persona y cada sistema tiene un propietario distinto, podría resultar difícil establecer cuál es el dato válido y quién debe autorizar su corrección.

Esta situación puede provocar inconsistencias en facturación, atención comercial y procesos de integración.

Para evitarlo, se propone que ambos conjuntos tengan el mismo propietario de negocio: Gerencia Comercial.

Además, debe establecerse qué sistema es la fuente autorizada del RFC y un procedimiento de conciliación que permita identificar diferencias, verificar los datos y aprobar las correcciones correspondientes.

El DBA no debe elegir unilateralmente qué RFC es correcto.

### 3. ¿Qué información del catálogo cambia con más frecuencia y quién debe actualizarla?

Los elementos que pueden cambiar con mayor frecuencia son la cantidad estimada de registros, el tamaño de los conjuntos de datos, la ubicación técnica, los permisos operativos y las referencias a los objetos disponibles.

Por ejemplo, `public.clientes` tenía siete filas estimadas al ejecutar el inventario, pero esa cantidad puede cambiar cuando se insertan o eliminan clientes.

El DBA debe mantener actualizada la información técnica del catálogo, como ubicación, estructura, tamaño y disponibilidad de los objetos.

Por su parte, el propietario de negocio debe validar las modificaciones de finalidad, clasificación, reglas de calidad y responsables autorizados.

La actualización del catálogo debería formar parte del procedimiento de gestión de cambios, de manera que las modificaciones relevantes se documenten oportunamente.

## 7. Conclusión

La Actividad 4 permitió construir un catálogo mínimo que integra los conjuntos de datos de PostgreSQL y MongoDB utilizados durante la Unidad III.

Se identificaron cinco conjuntos principales, incluyendo información de clientes, auditoría, registro de cambios y perfilado.

El inventario técnico permitió comprobar que PostgreSQL contiene las tablas `public.clientes` y `auditoria.cambios_clientes`, con sus respectivos propietarios técnicos, tamaños y estimaciones de registros.

También se incorporaron los conjuntos de MongoDB a partir de las evidencias del Laboratorio 02.

El catálogo permitió distinguir la propiedad técnica de un objeto de la responsabilidad de negocio sobre los datos.

Finalmente, se concluye que mantener un inventario actualizado ayuda a localizar información, asignar responsabilidades, establecer controles y detectar inconsistencias entre sistemas.

## 8. Archivo SQL relacionado

`sql/03-inventario-tablas.sql`
