## 1. Objetivo

Establecer las condiciones y responsabilidades para autorizar, ejecutar y verificar una restauración de bases de datos, reduciendo los riesgos de pérdida adicional de información, recuperación incorrecta y alteración de evidencias.

La política busca garantizar que una restauración responda a una necesidad justificada y que el resultado sea validado por las áreas responsables.

## 2. Alcance

Aplica a las bases de datos PostgreSQL y MongoDB utilizadas por Comercializadora Norte S.A. de C.V.

Comprende:

- La base `comercial` de PostgreSQL.
- Los registros almacenados en `auditoria.cambios_clientes`.
- La colección `comercial.clientes` de MongoDB.
- Las instantáneas de privilegios y demás registros de auditoría persistentes.
- Los objetos, configuraciones y permisos necesarios para restablecer el servicio.
- Los ambientes de desarrollo, pruebas y producción.

La restauración de información de producción deberá realizarse bajo controles más estrictos que los aplicables a ambientes de desarrollo.

## 3. Regla verificable

Toda restauración de producción deberá contar con un incidente o solicitud documentada, autorización del propietario del sistema y validación de Seguridad de la Información antes de que el DBA la ejecute; después deberá verificarse la integridad de los datos, los permisos y la operación del servicio, dejando constancia de la aceptación del resultado.

En situaciones de emergencia se permitirá una autorización extraordinaria documentada, con revisión posterior obligatoria.

El procedimiento técnico se definirá en la Unidad V.

## 4. Condiciones para autorizar una restauración

Una restauración podrá solicitarse cuando ocurra alguna de las siguientes situaciones:

- Pérdida accidental de información.
- Corrupción de registros o estructuras.
- Falla de almacenamiento.
- Incidente de seguridad.
- Error en un cambio de producción que requiera recuperar un estado anterior.
- Prueba programada para verificar los respaldos.

Antes de autorizarla deberán conocerse, como mínimo, el sistema afectado, el motivo, el respaldo disponible y la posible pérdida de cambios posteriores a dicho respaldo.

No deberá ejecutarse una restauración únicamente porque exista una copia disponible.

### Consideración sobre evidencias

Cuando la restauración esté relacionada con un incidente, las bitácoras y los registros de auditoría pertinentes deberán preservarse antes de realizar operaciones que pudieran sobrescribirlos.

Una restauración no debe utilizarse para ocultar cambios indebidos ni eliminar evidencias de una investigación.

## 5. Responsables

| Responsable | Función |
|---|---|
| Gerencia Comercial | Autorizar la recuperación de sistemas que administran datos comerciales |
| Seguridad de la Información | Evaluar los riesgos de la restauración y participar en la autorización |
| DBA | Evaluar la viabilidad técnica, ejecutar la restauración autorizada y documentar el resultado |
| Infraestructura | Proporcionar los recursos necesarios para recuperar la disponibilidad |
| Auditoría Interna | Verificar la preservación de evidencias cuando exista un incidente |
| Usuarios responsables del sistema | Confirmar que las funciones principales operan correctamente después de la recuperación |

El DBA no podrá decidir unilateralmente qué versión de los datos de negocio debe conservarse si existen discrepancias relevantes.

## 6. Validaciones posteriores a la restauración

La restauración se considerará concluida únicamente después de realizar las verificaciones correspondientes.

| Validación | Responsable |
|---|---|
| Disponibilidad de la base de datos | DBA |
| Integridad básica de tablas y colecciones | DBA |
| Existencia de los objetos esperados | DBA |
| Permisos y roles requeridos | DBA y Seguridad |
| Funcionamiento de las operaciones comerciales | Gerencia Comercial o responsable de la aplicación |
| Conservación de evidencias relacionadas | Auditoría Interna |
| Aceptación del resultado | Propietario del sistema |

Si las verificaciones detectan diferencias importantes, deberán registrarse como incidencias y definirse las acciones correctivas correspondientes.

## 7. Excepciones

Se podrán autorizar procedimientos extraordinarios cuando exista una emergencia que afecte gravemente la disponibilidad del servicio.

Estas excepciones deberán:

- Justificarse mediante un incidente.
- Identificar al responsable que autoriza.
- Documentar el riesgo aceptado.
- Mantener el alcance estrictamente necesario.
- Registrar la ejecución y sus resultados.
- Someterse a revisión posterior.

Si no fue posible obtener una autorización formal antes de actuar, deberá documentarse la causa y solicitarse la ratificación por las áreas responsables.

La urgencia no elimina la obligación de preservar las evidencias disponibles.

## 8. Evidencia de cumplimiento

### 8.1 Evidencia existente

Durante el Laboratorio 02 se generaron exportaciones de evidencias y se verificó su integridad mediante hashes SHA-256.

Entre ellas se encuentran:

- `system-profile.json`.
- `bitacora-mongod.log`.
- `hashes.sha256`.

Estas verificaciones demuestran que se trabajó con controles de integridad sobre archivos exportados.

Sin embargo, no constituyen una prueba de restauración de una base de datos completa.

Durante el Laboratorio 03 se generó un diccionario de datos que puede apoyar la identificación de objetos esperados, pero tampoco demuestra una recuperación efectiva.

### 8.2 Evidencia pendiente

Hasta este momento no se ha realizado ni documentado una restauración completa de PostgreSQL o MongoDB dentro del presente laboratorio.

Una vez implementada esta política, cada restauración deberá producir:

- Solicitud o reporte de incidente.
- Autorización del propietario.
- Identificación del respaldo utilizado.
- Registro de inicio y finalización.
- Resultado de las verificaciones.
- Incidencias detectadas.
- Aceptación del propietario del sistema.

El procedimiento técnico se definirá en la Unidad V.

## 9. Relación con otras políticas

La POL-04 depende de la POL-02 porque no es posible garantizar una recuperación si los respaldos no se generan o no han sido probados.

También requiere cumplir con la POL-01 para limitar quién puede realizar operaciones administrativas.

La POL-03 debe asegurar que las copias necesarias se conserven durante el periodo aprobado.

La POL-05 protege los datos personales utilizados durante las pruebas de recuperación.

Finalmente, cuando una restauración forme parte de una modificación planificada en producción, deberá relacionarse con el registro de cambios establecido por la POL-06.

## 10. Revisión

La política se revisará cada seis meses y después de cualquier restauración fallida o incidente grave de pérdida de información.

La revisión estará coordinada por Seguridad de la Información, junto con el DBA, Infraestructura, Auditoría Interna y los propietarios de los sistemas.

También deberá actualizarse cuando cambien las tecnologías, los periodos de respaldo o las necesidades de recuperación.

## 11. Criterio de cumplimiento

Se considerará que una restauración cumple la política si cuenta con:

1. Una solicitud o incidente identificable.
2. Autorización verificable.
3. Ejecución por personal responsable.
4. Registro de las operaciones realizadas.
5. Validaciones de integridad y funcionamiento.
6. Aceptación del propietario del sistema.

La simple existencia de un archivo de respaldo no demuestra el cumplimiento de esta política.

## 12. Conclusión

La POL-04 establece que restaurar una base de datos debe ser una decisión controlada y documentada.

Su principal finalidad es recuperar la información y disponibilidad sin provocar daños adicionales ni comprometer las evidencias de auditoría.

La política separa las responsabilidades de autorización, ejecución técnica y validación final.

El procedimiento técnico quedará pendiente para la Unidad V, mientras que la presente política define las condiciones que deberán cumplirse antes y después de cualquier recuperación.

## 13. Documentos relacionados

- `POL-01-acceso.md`.
- `POL-02-respaldo.md`.
- `POL-03-retencion.md`.
- `POL-05-datos-sensibles.md`.
- `POL-06-cambios-produccion.md`.
