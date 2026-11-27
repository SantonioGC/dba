## 1. Objetivo

Reducir el riesgo de pérdida permanente de información, interrupción de operaciones y falta de disponibilidad de los datos ante fallas técnicas, errores humanos, corrupción, incidentes de seguridad o daños en la infraestructura.

La política establece qué información debe respaldarse, la frecuencia mínima propuesta y quién es responsable de verificar que las copias puedan utilizarse para recuperar los sistemas.

## 2. Alcance

Esta política aplica a los ambientes de desarrollo, pruebas y producción de las bases de datos de Comercializadora Norte S.A. de C.V., priorizando los sistemas de producción que contienen información operativa y confidencial.

Incluye los siguientes conjuntos de datos:

| Sistema | Información que debe respaldarse |
|---|---|
| PostgreSQL — `comercial` | Tablas de clientes, información de negocio, esquemas, estructura, restricciones y demás objetos necesarios para recuperar la base |
| PostgreSQL — `auditoria` | Tabla `auditoria.cambios_clientes` y los registros de auditoría almacenados |
| PostgreSQL — `dba` | Objetos técnicos necesarios para consultar y administrar registros |
| MongoDB — `comercial` | Colección `clientes`, usuarios, roles y configuraciones necesarias para restablecer el servicio |
| MongoDB — `auditoria` | Instantáneas de privilegios y otros registros persistentes utilizados para revisiones de seguridad |
| Configuraciones y documentación | Parámetros de seguridad, configuraciones, diccionarios, catálogos y documentación necesaria para reconstruir el entorno |

Las bitácoras y exportaciones de auditoría también requieren conservación independiente, conforme a la POL-03 — Retención.

No se considera suficiente conservar una copia en el mismo equipo o servidor donde se encuentra la base de datos original.

## 3. Regla verificable

Todas las bases de datos de producción deberán contar con un respaldo completo diario y una copia protegida adicional fuera del servidor principal; el DBA verificará diariamente la ejecución e integridad de los respaldos y realizará, al menos una vez al mes, una prueba de restauración en un ambiente aislado, documentando su resultado.

Los respaldos que contengan información confidencial deberán protegerse mediante cifrado, controles de acceso y mecanismos de verificación de integridad.

## 4. Responsables

| Responsable | Función |
|---|---|
| Gerencia Comercial | Identificar la información de negocio crítica y aprobar sus necesidades de recuperación |
| DBA de PostgreSQL | Coordinar y verificar los respaldos correspondientes a PostgreSQL |
| DBA de MongoDB | Coordinar y verificar los respaldos correspondientes a MongoDB |
| Seguridad de la Información | Supervisar la protección de las copias, sus accesos y mecanismos de cifrado |
| Auditoría Interna | Revisar las evidencias de ejecución y los resultados de las pruebas de restauración |
| Responsable de infraestructura | Garantizar la disponibilidad del almacenamiento destinado a respaldos y copias independientes |

El DBA es responsable de ejecutar y verificar los controles técnicos, pero los propietarios de los datos deben participar en la definición de las necesidades de recuperación.

## 5. Frecuencia y verificación

Se proponen los siguientes criterios operativos:

| Actividad | Frecuencia propuesta | Responsable |
|---|---|---|
| Respaldo completo de las bases de producción | Diario | DBA correspondiente |
| Copia protegida fuera del servidor principal | Diario, después del respaldo | DBA e Infraestructura |
| Verificación del resultado de ejecución | Diaria | DBA |
| Verificación de integridad de los archivos | Diaria | DBA |
| Prueba de restauración en ambiente aislado | Mensual | DBA, con supervisión de Seguridad |
| Revisión de reportes de respaldo | Mensual | Auditoría Interna |
| Revisión de la política | Semestral | Seguridad, DBA y propietarios de datos |

Estas frecuencias son propuestas para el escenario académico y deberán ajustarse a la criticidad del servicio y a las necesidades aprobadas de recuperación.

Una ejecución que termine sin errores no demuestra por sí sola que el respaldo sea recuperable. Por ello, se requieren pruebas periódicas de restauración.

## 6. Protección de los respaldos

Los archivos de respaldo pueden contener información personal, credenciales protegidas, estructuras internas y datos de auditoría.

Por esta razón, deberán aplicarse las siguientes condiciones:

1. Almacenar los respaldos en ubicaciones con acceso restringido.
2. Utilizar cifrado adecuado para proteger las copias.
3. Evitar incluir contraseñas escritas directamente en scripts o repositorios públicos.
4. Mantener al menos una copia independiente del servidor principal.
5. Impedir que las cuentas operativas de las aplicaciones puedan modificar o eliminar respaldos.
6. Registrar las personas o cuentas que accedan a los archivos.
7. Verificar periódicamente la integridad y capacidad de recuperación de las copias.

Los criterios de conservación y eliminación se establecerán mediante la POL-03, evitando mantener información personal durante periodos injustificados.

## 7. Excepciones

Podrán autorizarse excepciones cuando exista una imposibilidad técnica temporal, una ventana de mantenimiento o una situación extraordinaria debidamente justificada.

La excepción deberá ser aprobada por Seguridad de la Información y por el propietario del sistema afectado.

Toda excepción deberá documentar:

- Motivo de la excepción.
- Sistema y datos afectados.
- Riesgo asociado.
- Responsable que autoriza.
- Periodo de vigencia.
- Medida compensatoria.
- Fecha prevista para restablecer el control.

Por ejemplo, si un respaldo diario falla por falta de almacenamiento, el DBA deberá reportarlo y gestionar una medida correctiva. La ausencia del respaldo no podrá considerarse cumplimiento de la política.

No se permitirá omitir indefinidamente los respaldos de sistemas críticos sin una decisión formal de aceptación del riesgo.

## 8. Evidencia de cumplimiento

La evidencia deberá permitir comprobar que los respaldos se ejecutaron, se conservaron y pudieron utilizarse en una restauración.

### 8.1 Evidencia técnica existente

Durante los laboratorios anteriores se generaron evidencias relacionadas con la conservación e integridad de información.

Laboratorio 02 — MongoDB Community

Se conservaron los siguientes archivos:

- `evidencias/system-profile.json`
- `evidencias/bitacora-mongod.log`
- `evidencias/hashes.sha256`

Los hashes SHA-256 permitieron verificar que las evidencias exportadas no habían cambiado.

Sin embargo, estos archivos corresponden a exportaciones de evidencia de auditoría.

Laboratorio 03 — Diccionario de datos

Se generó el archivo:

`evidencias/diccionario-clientes.csv`

Este archivo conserva metadatos de la tabla `public.clientes`, pero tampoco constituye un respaldo completo de PostgreSQL.

### 8.2 Evidencia que todavía no existe

Hasta este momento no se ha demostrado mediante las prácticas que exista:

- Un respaldo completo y periódico de la base `comercial` de PostgreSQL.
- Un respaldo completo y periódico de MongoDB.
- Un reporte automatizado de ejecución diaria.
- Un resultado documentado de restauración mensual.
- Una aprobación formal de la política.

Por tanto, el cumplimiento de la POL-02 todavía no está verificado.

El procedimiento técnico se definirá en la Unidad V.

### 8.3 Registros necesarios para demostrar cumplimiento

Una vez implementado el procedimiento, deberán conservarse los siguientes documentos:

| Evidencia | Información requerida |
|---|---|
| Registro de respaldo | Sistema, fecha, hora, responsable y resultado |
| Inventario de copias | Identificador, ubicación, tamaño y periodo de conservación |
| Verificación de integridad | Hash o resultado de la comprobación correspondiente |
| Reporte de restauración | Fecha, ambiente, responsable y resultado de la prueba |
| Registro de incidentes | Respaldos fallidos, causa y medidas correctivas |
| Autorización de excepciones | Responsable, justificación y vigencia |

La existencia de estos documentos permitirá comprobar que la política se aplica efectivamente y no solamente que se encuentra escrita.

## 9. Relación con las demás políticas

La POL-02 debe aplicarse de forma coordinada con otras reglas del gobierno de datos.

POL-01 Acceso: determina quién puede consultar, administrar o recuperar los respaldos.

POL-03 Retención: establece durante cuánto tiempo se conservan las copias y cómo deben eliminarse al vencer el periodo autorizado.

POL-04 Restauración: determina quién puede autorizar una recuperación y bajo qué condiciones debe ejecutarse.

POL-05 Uso de datos sensibles: exige proteger la información personal y confidencial que pueda encontrarse dentro de los respaldos.

POL-06 Cambios en producción: establece los controles que deben verificarse antes de realizar cambios importantes, incluida la disponibilidad de un respaldo recuperable cuando corresponda.

Estas políticas deben ser consistentes para evitar que un respaldo sea eliminado antes de una investigación o conservado sin una finalidad válida.

## 10. Revisión de la política

La POL-02 se revisará cada seis meses y también cuando ocurra alguna de las siguientes situaciones:

- Pérdida de información o falla grave de una base de datos.
- Resultado fallido de una prueba de restauración.
- Incorporación de un nuevo sistema.
- Cambios en la infraestructura de almacenamiento.
- Modificación de las necesidades de disponibilidad.
- Hallazgos relevantes de una auditoría.
- Cambios normativos que afecten el tratamiento de los datos.

La revisión estará a cargo de Seguridad de la Información, con participación del DBA, Auditoría Interna y los propietarios de los sistemas afectados.

## 11. Criterio de cumplimiento

La política se considerará cumplida cuando exista evidencia de que cada base de producción cuenta con respaldos conforme a la frecuencia aprobada, copias protegidas e independientes, verificaciones de integridad y pruebas de restauración satisfactorias.

Los respaldos fallidos deberán contar con un registro de incidencia y una medida correctiva documentada.

La ausencia de reportes o pruebas de restauración se registrará como una limitación de evidencia, sin asumir que los respaldos funcionan correctamente.

## 12. Conclusión

La POL-02 establece reglas de decisión para proteger la información almacenada en PostgreSQL y MongoDB frente a pérdidas, fallas o incidentes.

Se propone realizar respaldos completos diarios, conservar copias protegidas fuera del servidor principal y efectuar verificaciones de integridad y pruebas mensuales de restauración.

Los laboratorios anteriores proporcionaron experiencia en exportación y conservación de evidencias, pero todavía no demostraron la existencia de respaldos completos ni pruebas de recuperación de las bases.

Por ello, la implementación y validación técnica quedan pendientes para la Unidad V.

El principal propósito de la política es garantizar que la organización no dependa únicamente de la existencia de archivos de respaldo, sino que pueda demostrar que estos se generan, protegen y permiten recuperar la información cuando sea necesario.
